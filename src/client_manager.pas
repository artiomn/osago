unit client_manager;

//
// Менеджер клиентов.
//

{$I settings.inc}

interface

uses
  SysUtils, Classes, Variants, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, DBCtrls, Grids, DBGrids, Buttons, strings_l10n,
  common_functions, common_consts, LResources, LCLType, EditBtn, ExtDlgs, FileUtil,
  data_unit, waiter_unit, abstract_manager, orm_abstract,
  orm_client, orm_user, orm_group, phone_input, update_dispatcher, logger;

type

  { TfrmClientManager }

  TfrmClientManager = class(TAbstractManager)
    cbBonusMalus: TComboBox;
    cbClientType: TComboBox;
    cbRegion: TComboBox;
    cbCountry: TComboBox;
    cbCity: TComboBox;
    cbSocialState: TComboBox;
    cbFamilyState: TComboBox;
    cbDocType: TComboBox;
    cbSDocType: TComboBox;
    cbSClientTypeGroup: TComboBox;
    cboxViolations: TCheckBox;
    dtedtStage: TDateEdit;
    dtedBirthDate: TDateEdit;
    dbgridSearch: TDBGrid;
    edbPhoneCell: TEditButton;
    edbPhoneHome: TEditButton;
    edbPhoneBusiness: TEditButton;
    edSCorpus: TEdit;
    edSFlat: TEdit;
    edSHome: TEdit;
    edSStreet: TEdit;
    edSurname: TEdit;
    edTown: TEdit;
    edStreet: TEdit;
    edHome: TEdit;
    edCorpus: TEdit;
    edFlat: TEdit;
    edSDocSer: TEdit;
    edSDocNum: TEdit;
    edName: TEdit;
    edSLicenseSer: TEdit;
    edSLicenseNum: TEdit;
    edSName: TEdit;
    edSSurname: TEdit;
    edSPathronimyc: TEdit;
    edPathronimyc: TEdit;
    edLicenseNum: TEdit;
    edLicenseSer: TEdit;
    edDocSer: TEdit;
    edDocNum: TEdit;
    edIndex: TEdit;
    edSTown: TEdit;
    gbAddress1: TGroupBox;
    gbClientData: TGroupBox;
    gbDoc: TGroupBox;
    gbAddress: TGroupBox;
    gbSDoc: TGroupBox;
    gbSClientData: TGroupBox;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    labelName: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    labelSurname: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    labelSSurname: TLabel;
    labelPathronimyc: TLabel;
    labelSName: TLabel;
    labelSPathronimyc: TLabel;
    Label32: TLabel;
    labelBirthDate: TLabel;
    labelSocialState: TLabel;
    labelFamilyState: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    memoComments: TMemo;
    pgctlMain: TPageControl;
    pnHead: TPanel;
    rgSearchType: TRadioGroup;
    sbarMain: TStatusBar;
    pnBottom: TPanel;
    sbtnApply: TSpeedButton;
    sbtnCancel: TSpeedButton;
    sbtnClear: TSpeedButton;
    sbtnOk: TSpeedButton;
    sbtnNew: TSpeedButton;
    sbtnSearch: TSpeedButton;
    ttsMain_ClientEditor: TTabSheet;
    ttsMain_ClientList: TTabSheet;
    procedure cbClientTypeChange(Sender: TObject);
    procedure cbCountryChange(Sender: TObject);
    procedure cbRegionChange(Sender: TObject);
    procedure cbSClientTypeGroupChange(Sender: TObject);
    procedure dbgridSearchDblClick(Sender: TObject);
    procedure dbgridSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edbPhonesButtonClick(Sender: TObject);
    procedure edsSearchKeyPress(Sender: TObject; var Key: char);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pgctlMainPageChanged(Sender: TObject);
    procedure sbtnPanelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbtnFindClick(Sender: TObject);
  public
    // Метод вызывается, при обновлении клиента.
    procedure EntityWasUpdated(const record_id: TTableRecordID;
      const update_type: TUpdateType; const user_updater: string); override;
  private
    procedure SetControlsState(cenabled: boolean); override;
    procedure ListData(); override;
    procedure LoadDataInEntity(); override;
    procedure SetParamsDuringCreation(); override;
    procedure SavingErrorMsg(); override;
    function CheckEntityFields(): boolean; override;
    function MakeNewEntity(): boolean; override;
  private
    // Проверят занесены ли в БД телефоны.
    function CheckContactPhones(): boolean;
  end;

var
  frmClientManager: TfrmClientManager;

implementation
//---------------------------------------------------------------------------
procedure TfrmClientManager.SetParamsDuringCreation();
begin
  ClientsCollection := TEntityesCollection.Create(TClientEntity);
  SetCreationParameters(ClientsCollection, pnHead, pgctlMain,
    cln_mgr_ClientView, cln_mgr_ClientChange, cln_mgr_ClientSearch,
    cln_mgr_ClientNew,
    dmData.datasrcClient, dmData.datasrcSearchClient);
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.SavingErrorMsg();
begin
  raise Exception.Create(SysToUTF8(cln_mgr_msg_db_chg_err));
end;
//---------------------------------------------------------------------------
function TfrmClientManager.CheckEntityFields(): boolean;
begin
  Result := false;
  if (CheckContactPhones() = false) then
  begin
    edbPhoneHome.SetFocus();
    exit;
  end;
  if (edSurname.Text = EmptyStr) then
    begin
      HighligthControl(edSurname);
      exit;
    end;
  if (dtedBirthDate.Text = EmptyStr) then
    begin
      HighligthControl(dtedBirthDate);
      exit;
    end;
  Result := true;
end;
//---------------------------------------------------------------------------
function TfrmClientManager.MakeNewEntity(): boolean;
begin
  Result := true;
  if (inherited MakeNewEntity()) then
    begin
      try
        ChangesBlocked          := true;

        cbClientType.ItemIndex  := 0;
        cbSocialState.ItemIndex := 0;
        cbFamilyState.ItemIndex := 0;
        cbBonusMalus.ItemIndex  := 5;
        cbDocType.ItemIndex     := 0;
        cbCountry.ItemIndex     := 0;
        cbCountry.OnChange(cbCountry);
        SetIndexFromObject(cbRegion, VarToStr(def_rgn_id));
        cbRegion.OnChange(cbRegion);
        cbCity.ItemIndex        := 0;
        Result                  := true;
      finally
        ChangesBlocked := false;
      end;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.sbtnPanelClick(Sender: TObject);
begin
  if (Sender = sbtnApply) then
    begin
      case (DlgChangesCommit()) of
        mrYes:
          begin
            //DBUpdateDispatcher.Refresh();
            DoApply();
          end;
        mrNo: ;
        mrCancel, mrRetry:
          exit;
      end;
    end
  else if (Sender = sbtnOk) then
    begin
      case (DlgChangesCommit()) of
        mrYes:
          begin
            DBUpdateDispatcher.Refresh();
            ModalResult := mrOk;
          end;
        mrNo:
          ModalResult := mrCancel;
        mrCancel, mrRetry:
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
      if (not MakeNewEntity()) then exit;
      // ClearEdits(ttsMain_ClientEditor);
      dtedBirthDate.Date := Now();
      dtedtStage.Date    := Now();
      edPathronimyc.Text := EmptyStr;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.pgctlMainPageChanged(Sender: TObject);
begin
  SetHeadText();
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.cbSClientTypeGroupChange(Sender: TObject);
begin
  with cbSClientTypeGroup do
  ListClientTypeGroup(StrToInt(GetCBoxStr(cbSClientTypeGroup, ItemIndex)),
    labelSSurname, labelSName, labelSPathronimyc, edSPathronimyc);
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.dbgridSearchDblClick(Sender: TObject);
begin
  if (dbgridSearch.SelectedIndex < 0) then exit;
  ShowSearchResults();
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.dbgridSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    begin
      dbgridSearch.OnDblClick(Sender);
      Key := 0;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.edbPhonesButtonClick(Sender: TObject);
begin
  with (Sender as TEditButton) do
    begin
      frmInputPhone.PopupThis(ControlToScreen(Point(0, Height)),
        Sender as TEditButton);
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.cbClientTypeChange(Sender: TObject);
var group: variant;
begin
  with cbClientType do
    group := dmData.myClientTypes.Lookup('ID_CLIENT_TYPE',
      GetCBoxStr(cbClientType, ItemIndex),
      'ID_CLIENT_TYPE_GROUP');
  if (group = Null) then group := 0;
  ListClientTypeGroup(group, labelSurname, labelName, labelPathronimyc,
    edPathronimyc);
  if (group = ind_person) then
    begin
      labelSocialState.Visible  := true;
      cbSocialState.Visible     := true;
      labelFamilyState.Visible  := true;
      cbFamilyState.Visible     := true;
      labelBirthDate.Caption    := SysToUTF8(cln_mgr_BirthDate);
    end
  else
    begin
      labelSocialState.Visible  := false;
      cbSocialState.Visible     := false;
      labelFamilyState.Visible  := false;
      cbFamilyState.Visible     := false;
      labelBirthDate.Caption    := SysToUTF8(cln_mgr_RegDate);
    end;
  DataWasChanged(Sender);
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.cbCountryChange(Sender: TObject);
begin
  try
    with dmData.myRegion, cbCountry do
      begin
        Close();
        ParamByName('id_country').AsString :=
          (Items.Objects[ItemIndex] as TStringObject).StringValue;
        Open();
      end;
    //DBListFiler.ClearCb(cbRegion);
    DBListFiler.FillListFromDB('ID_REGION', 'NAME',
      dmData.myRegion, [cbRegion]);
    cbRegion.OnChange(cbRegion);
    //DataWasChanged(Sender);
  except
    on E: Exception do LogException(E);
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.cbRegionChange(Sender: TObject);
begin
  try
    with dmData.myCity do
      begin
        with cbCountry do
          if ((Items.Count <= 0) or (ItemIndex < 0)) then exit;
        with cbRegion do
          if ((Items.Count <= 0) or (ItemIndex < 0)) then exit;
        Close();
        with cbCountry do
          if (Items.Objects[ItemIndex] <> nil) then
            begin
              ParamByName('id_country').AsString :=
                (Items.Objects[ItemIndex] as TStringObject).StringValue;
            end;
        with cbRegion do
          if (Items.Objects[ItemIndex] <> nil) then
            begin
              ParamByName('id_region').AsString :=
                (Items.Objects[ItemIndex] as TStringObject).StringValue;
            end;
        Open();
      end;
    //DBListFiler.ClearCb(cbCity);
    DBListFiler.FillListFromDB('ID_CITY', 'NAME',
      dmData.myCity, [frmClientManager.cbCity]);
    DataWasChanged(Sender);
  except
    on E: Exception do LogException(E);
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.edsSearchKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = #13) then
    begin
      Key := #0;
      sbtnSearch.Click();
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.FormShow(Sender: TObject);
begin

end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.FormCreate(Sender: TObject);
begin
//  pnHead.Caption := SysToUTF8(cln_mgr_ClientSearch);
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ClientsCollection);
  DBListFiler.ClearCb(cbSClientTypeGroup);
  DBListFiler.ClearCb(cbSDocType);
  DBListFiler.ClearCb(cbClientType);
  DBListFiler.ClearCb(cbSocialState);
  DBListFiler.ClearCb(cbFamilyState);
  DBListFiler.ClearCb(cbDocType);
  DBListFiler.ClearCb(cbCountry);
  DBListFiler.ClearCb(cbRegion);
  DBListFiler.ClearCb(cbCity);
  DBListFiler.ClearCb(cbBonusMalus);
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.sbtnFindClick(Sender: TObject);
begin
  if (Sender = sbtnSearch) then
    begin
      ShowWaiter();
      dmData.FindClient(edSSurname.Text, edSName.Text, edSPathronimyc.Text,
        edSDocSer.Text, edSDocNum.Text, edSLicenseSer.Text, edSLicenseNum.Text,
        GetCBoxStr(cbSClientTypeGroup, cbSClientTypeGroup.ItemIndex),
        GetCBoxStr(cbSDocType, cbSDocType.ItemIndex),
        edSTown.Text, edSStreet.Text, edSHome.Text, edSCorpus.Text,
        edSFlat.Text,
        rgSearchType.ItemIndex = 1);
      HideWaiter();
    end
  else
    begin
      ClearEdits(ttsMain_ClientList);
    end;
end;
//---------------------------------------------------------------------------
function TfrmClientManager.CheckContactPhones(): boolean;
begin
  Result := not ((edbPhoneHome.Text = EmptyStr) and
    (edbPhoneBusiness.Text = EmptyStr) and
    (edbPhoneCell.Text = EmptyStr));

  if (not Result) then
    begin
      Result := QuestionDlg(SysToUTF8(cls_warning),
        SysToUTF8(cln_mgr_msg_no_phone + cls_sure_q), mtWarning,
        [mrYes, SysToUTF8(cls_yes), mrNo, SysToUTF8(cls_no)], 0) = mrYes;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.SetControlsState(cenabled: boolean);
var eflag: boolean;
begin
  with CurrentUser.UserGroup do
    begin
      eflag := ((ManagerState in [msEntityView, msEntityEdit]) and
        Privileges[Priv_cln_chg]);
      eflag := eflag or (ManagerState = msEntityCreation);
      eflag := eflag and cenabled;
      SwitchControls(ttsMain_ClientEditor, eflag);
      sbtnNew.Enabled := Privileges[Priv_cln_add];
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.ListData();
var group: variant;
//    idx: integer;
begin
  with (Target as TClientEntity) do
    begin
      SetIndexFromObject(cbClientType, VarToStr(IDClientType));
      cbClientType.OnChange(cbClientType);
      with cbClientType do
        group := dmData.myClientTypes.Lookup('ID_CLIENT_TYPE',
          GetCBoxStr(cbClientType, ItemIndex), 'ID_CLIENT_TYPE_GROUP');

      if (IDDocType <> Null) then
        SetIndexFromObject(cbDocType, VarToStr(IDDocType));
      if (IDCountry <> Null) then
        begin
          //idx := cbCountry.ItemIndex;
          SetIndexFromObject(cbCountry, VarToStr(IDCountry));
          //if (idx <> cbCountry.ItemIndex) then
          cbCountry.OnChange(cbCountry);
        end
      else cbCountry.ItemIndex := -1;

      if (IDRegion <> Null) then
        begin
          // idx := cbRegion.ItemIndex;
          SetIndexFromObject(cbRegion, VarToStr(IDRegion));
          // if (idx <> cbRegion.ItemIndex) then cbRegion.OnChange(cbRegion);
          cbRegion.OnChange(cbRegion);
        end
      else cbRegion.ItemIndex := -1;

      if (IDCity <> Null) then
        SetIndexFromObject(cbCity, VarToStr(IDCity))
      else cbCity.ItemIndex := -1;

      if (IDInsuranceClass <> Null) then
        SetIndexFromObject(cbBonusMalus, VarToStr(IDInsuranceClass));

      if (group <> ind_person) then edName.Text := VarToStr(INN)
      else
        begin
          edName.Text         := VarToStr(ClientName);
          edPathronimyc.Text  := VarToStr(ClientPathronimyc);
          SetIndexFromObject(cbSocialState, VarToStr(IDSocialState));
          SetIndexFromObject(cbFamilyState, VarToStr(IDFamilyState));
        end;
      edSurname.Text          := VarToStr(ClientSurname);
      edbPhoneHome.Text       := VarToStr(PhoneHome);
      edbPhoneBusiness.Text       := VarToStr(CellPhone);
      edbPhoneCell.Text   := VarToStr(BusinessPhone);
      edDocSer.Text           := VarToStr(DocSer);
      edDocNum.Text           := VarToStr(DocNum);
      edLicenseSer.Text       := VarToStr(LicenseSer);
      edLicenseNum.Text       := VarToStr(LicenseNum);
      edIndex.Text            := VarToStr(Postindex);
      //edRegion.Text      := FieldByName('REGION').AsString;
      edTown.Text             := VarToStr(Town);
      edStreet.Text           := VarToStr(Street);
      edHome.Text             := VarToStr(Home);
      edCorpus.Text           := VarToStr(Corpus);
      edFlat.Text             := VarToStr(FlatNum);
      dtedBirthDate.Text      := VarToStr(Birthday);
      dtedtStage.Text         := VarToStr(StartDrivingDate);
      cboxViolations.Checked  := VarToBool(GrossViolations);
      memoComments.Lines.Assign(Comments);
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.LoadDataInEntity();
begin
  with (Target as TClientEntity) do
    begin
      with cbClientType do
        if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
          IDClientType := (Items.Objects[ItemIndex] as TStringObject).StringValue;
      with cbDocType do
        if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
          IDDocType := (Items.Objects[ItemIndex] as TStringObject).StringValue;
      with cbCountry do
        if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
          IDCountry := (Items.Objects[ItemIndex] as TStringObject).StringValue;
      with cbRegion do
        if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
          IDRegion := (Items.Objects[ItemIndex] as TStringObject).StringValue;
      with cbCity do
        if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
          IDCity := (Items.Objects[ItemIndex] as TStringObject).StringValue;
      with cbBonusMalus do
        if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
          IDInsuranceClass := (Items.Objects[ItemIndex] as TStringObject).StringValue;

      with cbClientType do
        if (dmData.myClientTypes.Lookup('ID_CLIENT_TYPE',
          GetCBoxStr(cbClientType, ItemIndex), 'ID_CLIENT_TYPE_GROUP')
          <> ind_person) then INN := edName.Text
        else
          begin
            ClientName        := edName.Text;
            ClientPathronimyc := edPathronimyc.Text;
            with cbSocialState do
              if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
                IDSocialState :=
                  (Items.Objects[ItemIndex] as TStringObject).StringValue;
            with cbFamilyState do
              if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
                IDFamilyState :=
                  (Items.Objects[ItemIndex] as TStringObject).StringValue;
          end;
      ClientSurname           := edSurname.Text;
      PhoneHome               := edbPhoneHome.Text;
      CellPhone               := edbPhoneBusiness.Text;
      BusinessPhone           := edbPhoneCell.Text;
      DocSer                  := edDocSer.Text;
      DocNum                  := edDocNum.Text;
      LicenseSer              := edLicenseSer.Text;
      LicenseNum              := edLicenseNum.Text;
      Postindex               := edIndex.Text;
      Town                    := edTown.Text;
      Street                  := edStreet.Text;
      Home                    := edHome.Text;
      Corpus                  := edCorpus.Text;
      FlatNum                 := edFlat.Text;
      Birthday                := dtedBirthDate.Date;
      StartDrivingDate        := dtedtStage.Date;
      GrossViolations         := cboxViolations.Checked;
      Comments.Assign(memoComments.Lines);
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmClientManager.EntityWasUpdated(const record_id: TTableRecordID;
  const update_type: TUpdateType; const user_updater: string);
begin
  // Выполняю действия только, если менеджер видим.
  if (Visible and (Target <> nil)) then
    begin
      // Проверка на отображение сущности менеджером.
      if (not Target.CheckID(record_id)) then exit;
    end
  else exit;

  if (user_updater = CurrentUser.User) then exit;
  // Делаю какие-либо действия, только если это выбранное ТС.
  case update_type of
    utInsert: ;
    utUpdate:
      begin
        Target.DataSource := dmData.GetClientByID(VarToStr(record_id[0]));
        Target.DB_Load(ltNew);
        try
          ChangesBlocked := true;
          ListData();
        finally
          ChangesBlocked := false;
        end;
      end;
    utDelete:
      begin
        Target.Assign(nil);
        try
          ChangesBlocked := true;
          ListData();
          ReinitManager();
        finally
          ChangesBlocked := false;
        end;
      end;
    utAction: ;
  end;
end;
//---------------------------------------------------------------------------
initialization
  {$i client_manager.lrs}

end.
