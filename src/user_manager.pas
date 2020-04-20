unit user_manager;

//
// Редактор пользователей и групп.
//

{$I settings.inc}

// Есть некоторое дублирование кода из TAbstractManager.
// Но, в целях упрощения, пока что UserManager не является его потомком,
// т.к. он не реализует функционал, который требуется от менеджера
// (поиск, например). Чтобы не модифицировать базовый класс и не обходить...
// Да и времени нет.

{
    user_mgr_msg_db_chg_err
}

interface

uses
  SysUtils, Classes, Variants, Graphics, Controls, Forms, Dialogs, FileUtil,
  StdCtrls, ExtCtrls, ComCtrls, DBCtrls, Grids, DBGrids, Buttons, strings_l10n,
  common_functions,
  LResources, EditBtn, abstract_manager, data_unit, phone_input,
  orm_abstract, orm_user, orm_group, update_dispatcher;

type

  { TfrmUserManager }

  TfrmUserManager = class(TForm)
    chkgrpGroupPrivs: TCheckGroup;
    cbUserGroups: TComboBox;
    cbGroup: TComboBox;
    dbgridUsers: TDBGrid;
    edbPhoneCell: TEditButton;
    edbPhoneHome: TEditButton;
    edName: TEdit;
    edPathronimyc: TEdit;
    edAddress: TEdit;
    edSurname: TEdit;
    edLogin: TEdit;
    edHost: TEdit;
    edPassword: TEdit;
    edPasswordConfirm: TEdit;
    edGroupName: TEdit;
    gbSelUser: TGroupBox;
    gbUserData: TGroupBox;
    gbGroupParams: TGroupBox;
    labelName: TLabel;
    labelPathronimyc: TLabel;
    labelPathronimyc1: TLabel;
    labelPathronimyc2: TLabel;
    labelPathronimyc4: TLabel;
    labelPathronimyc5: TLabel;
    labelPathronimyc6: TLabel;
    labelPathronimyc7: TLabel;
    labelSurname: TLabel;
    labelSurname1: TLabel;
    labelSurname2: TLabel;
    labelSurname3: TLabel;
    labelSurname4: TLabel;
    labelSurname5: TLabel;
    labelSurname6: TLabel;
    memoUserComments: TMemo;
    memoGroupDescr: TMemo;
    pgctlMain: TPageControl;
    pnHead: TPanel;
    sbarMain: TStatusBar;
    pnBottom: TPanel;
    sbtnApply: TSpeedButton;
    sbtnCancel: TSpeedButton;
    sbtnDel: TSpeedButton;
    sbtnOk: TSpeedButton;
    sbtnNew: TSpeedButton;
    pnMain: TPanel;
    ttsMain_Users: TTabSheet;
    ttsMain_Groups: TTabSheet;
    procedure cbGroupChange(Sender: TObject);
    procedure ControlChange(Sender: TObject);
    procedure dbgridUsersDblClick(Sender: TObject);
    procedure edbPhonesButtonClick(Sender: TObject);
    procedure EditsKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pgctlMainChanging(Sender: TObject; var AllowChange: Boolean);
    procedure sbtnPanelClick(Sender: TObject);
  private
    FChangesLocked:   boolean;
    FUserEntity:      TUserEntity;
    FManagerState:    TManagerState;
  private
    function DlgDataLoss(): boolean;
    function DoApply(): TModalResult;
    procedure SetUMState(const ms: TManagerState);
    procedure SetHeadText();
  private
    procedure FillGroupLists();
    procedure ListGroupParams();
    procedure ListUserData();
    procedure LoadUserDataInEntity();
  public
    // Метод вызывается, при обновлении клиента.
    procedure EntityWasUpdated(const record_id: TTableRecordID;
      const update_type: TUpdateType; const user_updater: string);
  end;

var
  frmUserManager: TfrmUserManager;

implementation
//---------------------------------------------------------------------------
function TfrmUserManager.DoApply(): TModalResult;
begin
  Result := mrYes;
  if (FManagerState in [msEntityCreation, msEntityEdit]) then
    begin
      if (edLogin.Text = EmptyStr) then
        begin
          HighligthControl(edLogin);
          Result := mrRetry;
          exit;
        end;
      if ((edPassword.Text = EmptyStr) and
          (edPasswordConfirm.Text = EmptyStr)) then
        begin
          HighligthControl(edPassword);
          Result := mrRetry;
          exit;
        end;
      if (edPassword.Text <> edPasswordConfirm.Text) then
        begin
          MessageDlg(SysToUTF8(cls_error), SysToUTF8(user_mgr_msg_it_psw_err),
            mtError, [mbOk], 0);
          edPassword.SetFocus;
          Result := mrRetry;
          exit;
        end;

      Result := QuestionDlg(SysToUTF8(cls_warning),
        SysToUTF8(cls_data_commit_q + cls_sure_q), mtWarning,
        [mrYes, SysToUTF8(cls_yes), mrNo, SysToUTF8(cls_no)], 0);

      if (Result = mrYes) then
        begin
          LoadUserDataInEntity();
          if (FUserEntity.DB_Save() = false) then
            begin
              MessageDlg(SysToUTF8(cls_error),
                SysToUTF8(user_mgr_msg_db_chg_err), mtError, [mbOK], '');
              Result := mrRetry;
            end
          else
            begin
              if (FUserEntity.CheckID([CurrentUser.Host, CurrentUser.User])) then
                begin
                  CurrentUser.Assign(FUserEntity);
                  with (dmData) do
                    begin
                      myconnMain.Password         := CurrentUser.Password;
                      myconnAddContract.Password  := CurrentUser.Password;
                    end;
                end;
              DBUpdateDispatcher.Refresh();
              FManagerState := msEntitySearch;
              SetUMState(msEntityView);
            end;
        end
      else if (Result = mrNo) then
        begin
          //FManagerState := msEntitySearch;
          //SetUMState(msEntityView);
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.SetUMState(const ms: TManagerState);
begin
  if (FManagerState = ms) then exit;
  if ((FManagerState = msEntityCreation) and (ms = msEntityEdit)) then exit;
  // Из поиска возможен только просмотр или создание новой записи.
  // Изменение невозможно.
  if ((FManagerState = msEntitySearch) and (ms = msEntityEdit)) then exit;
  if (not DlgDataLoss()) then exit;
  FManagerState := ms;
  if (FManagerState = msEntitySearch) then
    begin
      SwitchControls(gbUserData, false);
      sbtnDel.Enabled := false;
    end
  else
    begin
      SwitchControls(gbUserData, true);
      sbtnDel.Enabled := FManagerState in [msEntityEdit, msEntityView];
    end;
  SetHeadText();
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.SetHeadText();
begin
  case FManagerState of
    msEntityView, msEntitySearch:
      pnHead.Caption := SysToUTF8(user_mgr_UserView);
    msEntityEdit:
      pnHead.Caption := SysToUTF8(user_mgr_UserChange);
    msEntityCreation:
      pnHead.Caption := SysToUTF8(user_mgr_UserNew);
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.sbtnPanelClick(Sender: TObject);
begin
  if (Sender = sbtnApply) then
    begin
      DoApply();
    end
  else if (Sender = sbtnOk) then
    begin
      case (DoApply()) of
        mrYes:
          ModalResult := mrOk;
        mrNo, mrRetry:
          exit;
      end;
    end
  else if (Sender = sbtnCancel) then
    begin
      if (not DlgDataLoss()) then exit;
      ModalResult := mrCancel;
    end
  else if (Sender = sbtnNew) then
    begin
      SetUMState(msEntityCreation);
      if (FManagerState <> msEntityCreation) then exit;
      FUserEntity.Assign(nil);
      ListUserData();
      FChangesLocked        := true;
      edHost.Text           := '%';
      FChangesLocked        := false;
      pgctlMain.ActivePage  := ttsMain_Users;
      with cbUserGroups do ItemIndex := Items.Count - 1;
    end
  else if (Sender = sbtnDel) then
    begin
      if (QuestionDlg(SysToUTF8(cls_warning),
        Format(SysToUTF8(user_mgr_del_confirm + cls_sure_q),
          [VarToStr(FUserEntity.User)]),
        mtWarning, [mrYes, SysToUTF8(cls_yes), mrNo, SysToUTF8(cls_no)], 0)
        = mrNo) then exit;
      if (FUserEntity.DB_Delete()) then
        begin
          FUserEntity.Assign(nil);
          ListUserData();
          FChangesLocked  := true;
          edHost.Text     := '%';
          FChangesLocked  := false;
          FManagerState   := msEntitySearch;
          SetHeadText();
          DBUpdateDispatcher.Refresh();
        end
      else
        MessageDlg(SysToUTF8(cls_error),
          SysToUTF8(user_mgr_del_err), mtError, [mbOK], '');
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.pgctlMainChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  sbtnDel.Enabled := (not (pgctlMain.ActivePage = ttsMain_Users))
    and (FManagerState in [msEntityEdit, msEntityView]);
  sbtnNew.Enabled := not (pgctlMain.ActivePage = ttsMain_Users);
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.FillGroupLists();
var i: integer;
    grp: TGroupEntity;
begin
  cbGroup.Items.BeginUpdate;
  cbUserGroups.Items.BeginUpdate;
  try
    cbGroup.Items.Clear;
    cbUserGroups.Items.Clear;
    for i := 0 to GroupsCollection.Count - 1 do
      begin
        grp := GroupsCollection[i] as TGroupEntity;
        cbGroup.Items.AddObject(VarToStr(grp.GroupName), grp);
        cbUserGroups.Items.AddObject(VarToStr(grp.GroupName), grp);
      end;
  finally
    cbGroup.Items.EndUpdate;
    cbUserGroups.Items.EndUpdate;
    cbGroup.ItemIndex := cbGroup.Items.Count - 1;
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.ListGroupParams();
var i: TGroupPrivs;
    grp: TGroupEntity;
begin
  if (cbGroup.ItemIndex < 0) then exit;
  grp := cbGroup.Items.Objects[cbGroup.ItemIndex] as TGroupEntity;
  if (grp = nil) then exit;
  edGroupName.Text  := VarToStr(grp.GroupName);
  memoGroupDescr.Lines.Assign(grp.GroupDescr);
  for i := Low(TGroupPrivs) to High(TGroupPrivs)
    do chkgrpGroupPrivs.Checked[integer(i)] := grp.Privileges[i];
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.ListUserData();
begin
  FChangesLocked          := true;
  edLogin.Text            := VarToStr(FUserEntity.User);
  edHost.Text             := VarToStr(FUserEntity.Host);
  edPassword.Text         := VarToStr(FUserEntity.Password);
  edPasswordConfirm.Text  := VarToStr(FUserEntity.Password);
  edSurname.Text          := VarToStr(FUserEntity.UserSurname);
  edName.Text             := VarToStr(FUserEntity.UserName);
  edPathronimyc.Text      := VarToStr(FUserEntity.UserPathronimyc);
  edbPhoneHome.Text       := VarToStr(FUserEntity.PhoneHome);
  edbPhoneCell.Text       := VarToStr(FUserEntity.CellPhone);
  edAddress.Text          := VarToStr(FUserEntity.Address);
  memoUserComments.Lines.Assign(FUserEntity.Comments);
  with cbUserGroups do ItemIndex := Items.IndexOfObject(FUserEntity.UserGroup);
  FChangesLocked          := false;
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.LoadUserDataInEntity();
begin
  FUserEntity.User            := edLogin.Text;
  FUserEntity.Host            := edHost.Text;
  if (edPassword.Text = EmptyStr) then FUserEntity.Password := Null
  else FUserEntity.Password := edPassword.Text;
  FUserEntity.UserSurname     := edSurname.Text;
  FUserEntity.UserName        := edName.Text;
  FUserEntity.UserPathronimyc := edPathronimyc.Text;
  FUserEntity.PhoneHome       := edbPhoneHome.Text;
  FUserEntity.CellPhone       := edbPhoneCell.Text;
  FUserEntity.Address         := edAddress.Text;
  FUserEntity.Comments.Assign(memoUserComments.Lines);

  with cbUserGroups do
  if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
    FUserEntity.IDGroup := (Items.Objects[ItemIndex] as TGroupEntity).IDGroup;
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.FormCreate(Sender: TObject);
begin
  FUserEntity             := TUserEntity.Create(nil);
  FUserEntity.DataSource  := dbgridUsers.DataSource;
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.FormDestroy(Sender: TObject);
begin
  FUserEntity.Free;
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.FormShow(Sender: TObject);
begin
  FillGroupLists();
  ListGroupParams();
  dbgridUsers.DataSource  := dmData.GetAllUsers();
  FManagerState           := msEntitySearch;
  if (dbgridUsers.DataSource.DataSet.RecordCount > 0) then
    begin
      dbgridUsers.OnDblClick(dbgridUsers);
    end
  else
    begin
      SwitchControls(gbUserData, false);
      sbtnDel.Enabled := false;
    end;
  SetHeadText();
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.cbGroupChange(Sender: TObject);
begin
  ListGroupParams();
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.ControlChange(Sender: TObject);
begin
  if (FChangesLocked) then exit;
  SetUMState(msEntityEdit);
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.EditsKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = #13) then
    begin
      Key := #0;
      sbtnApply.Click();
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.dbgridUsersDblClick(Sender: TObject);
begin
  if (dbgridUsers.DataSource.DataSet.RecordCount <= 0) then exit;
  SetUMState(msEntityView);
  if (FManagerState <> msEntityView) then exit;
  FUserEntity.DataSource := dbgridUsers.DataSource;
  FUserEntity.DB_Load(ltNew);
  ListUserData();
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.edbPhonesButtonClick(Sender: TObject);
begin
  with (Sender as TEditButton) do
    begin
      frmInputPhone.PopupThis(ControlToScreen(Point(0, Height)),
        Sender as TEditButton);
    end;
end;
//---------------------------------------------------------------------------
function TfrmUserManager.DlgDataLoss(): boolean;
begin
  Result := true;
  if (FManagerState in [msEntityCreation, msEntityEdit]) then
  Result := QuestionDlg(SysToUTF8(cls_warning),
    SysToUTF8(cls_lossdata_q + cls_sure_q), mtWarning,
    [mrYes, SysToUTF8(cls_yes), mrNo, SysToUTF8(cls_no)], 0) = mrYes;
end;
//---------------------------------------------------------------------------
procedure TfrmUserManager.EntityWasUpdated(const record_id: TTableRecordID;
  const update_type: TUpdateType;
  const user_updater: string);
begin
  if (not Visible) then exit;

  with dbgridUsers.DataSource.DataSet do
    begin
      Close();
      Open();
    end;

  if (user_updater = CurrentUser.User) then exit;

  if (not FUserEntity.CheckID(record_id)) then exit;
  // Делаю какие-либо действия, только если это выбранный пользователь.
  case update_type of
    utInsert: ;
    utUpdate:
      begin
        FUserEntity.DB_Load(ltSaved);
        try
          FChangesLocked := true;
          ListUserData();
        finally
          FChangesLocked := false;
        end;
      end;
    utDelete:
      begin
        FUserEntity.Assign(nil);
        try
          FChangesLocked := true;
          ListUserData();
          FManagerState := msEntitySearch;
        finally
          FChangesLocked := false;
        end;
      end;
    utAction: ;
  end;
end;
//---------------------------------------------------------------------------
initialization
  {$i user_manager.lrs}

end.
