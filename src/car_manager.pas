unit car_manager;

//
// Менеджер ТС.
//

{$I settings.inc}

interface

uses
  SysUtils, Classes, Variants, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DBCtrls, Grids, DBGrids, FileUtil,
  Buttons, Math, strings_l10n, common_consts, common_functions, LResources,
  LCLType, EditBtn, abstract_manager, client_manager, data_unit, waiter_unit,
  update_dispatcher,
  orm_abstract, orm_car, orm_client, orm_user, orm_group, logger;

type

  { TfrmCarManager }

  TfrmCarManager = class(TAbstractManager)
    cbCarModel: TComboBox;
    cboxRent: TCheckBox;
    cbCarType: TComboBox;
    cbCarMark: TComboBox;
    cboxForeing: TCheckBox;
    cbPurposeType: TComboBox;
    cbSClientTypeGroup: TComboBox;
    cboxPowerAutoConvert: TCheckBox;
    dtedPTSDate: TDateEdit;
    dtedSPTSDate: TDateEdit;
    edPowerHP: TEdit;
    edMaxMass: TEdit;
    edPassengersCount: TEdit;
    edSChassiNum: TEdit;
    edSVIN: TEdit;
    edSKusovNum: TEdit;
    edSPTSSer: TEdit;
    edSPTSNum: TEdit;
    edSName: TEdit;
    edSSurname: TEdit;
    edVIN: TEdit;
    edSRegNum: TEdit;
    edSPathronimyc: TEdit;
    edSLicenceSer: TEdit;
    edSLicenceNum: TEdit;
    edPowerKWT: TEdit;
    edChassiNum: TEdit;
    edKusovNum: TEdit;
    edPTSSer: TEdit;
    edPTSNum: TEdit;
    edRegNum: TEdit;
    edProductionYear: TEdit;
    gbCarInfo: TGroupBox;
    gbNumbers: TGroupBox;
    gbOwner: TGroupBox;
    gbTechData: TGroupBox;
    gbPTS: TGroupBox;
    gbSNumbers: TGroupBox;
    gbSPTS: TGroupBox;
    gbSClientData: TGroupBox;
    Label1: TLabel;
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
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label29: TLabel;
    Label52: TLabel;
    labelOwnerAddress: TLabel;
    labelOwnerINN: TLabel;
    labelOwnerPassport: TLabel;
    labelOwnerName: TLabel;
    labelSName: TLabel;
    labelSSurname: TLabel;
    labelSPathronimyc: TLabel;
    Label28: TLabel;
    Label3: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    memoComments: TMemo;
    pnHead: TPanel;
    rgSearchType: TRadioGroup;
    sbarMain: TStatusBar;
    pnBottom: TPanel;
    sbtnCancel: TSpeedButton;
    sbtnOk: TSpeedButton;
    pgctlMain: TPageControl;
    sbtnApply: TSpeedButton;
    sbtnOwner: TSpeedButton;
    ttsMain_CarList: TTabSheet;
    ttsMain_CarEditor: TTabSheet;
    sbtnNew: TSpeedButton;
    dbgridSearch: TDBGrid;
    sbtnSearch: TSpeedButton;
    sbtnClear: TSpeedButton;
    procedure cbCarMarkChange(Sender: TObject);
    procedure cboxPowerAutoConvertChange(Sender: TObject);
    procedure cbSClientTypeGroupChange(Sender: TObject);
    procedure dbgridSearchDblClick(Sender: TObject);
    procedure dbgridSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edPowerChange(Sender: TObject);
    procedure edDigitalEdKeyPress(Sender: TObject; var Key: char);
    procedure edSearchKeyPress(Sender: TObject; var Key: char);
    procedure edVINKeyPress(Sender: TObject; var Key: char);
    procedure FormDestroy(Sender: TObject);
    procedure pgctlMainPageChanged(Sender: TObject);
    procedure sbtnOwnerClick(Sender: TObject);
    procedure sbtnPanelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbtnFindClick(Sender: TObject);
  public
    // Метод вызывается, при обновлении ТС.
    procedure EntityWasUpdated(const record_id: TTableRecordID;
      const update_type: TUpdateType; const user_updater: string); override;
  private
    procedure ClearClientLabels();
    procedure ListClientParams();
  private
    procedure ListData(); override;
    procedure SetControlsState(cenabled: boolean); override;
    procedure LoadDataInEntity(); override;
    procedure SetParamsDuringCreation(); override;
    procedure SavingErrorMsg(); override;
    function CheckEntityFields(): boolean; override;
    function MakeNewEntity(): boolean; override;
  end;

var
  frmCarManager: TfrmCarManager;

implementation
//---------------------------------------------------------------------------
procedure TfrmCarManager.SetParamsDuringCreation();
begin
  CarsCollection := TEntityesCollection.Create(TCarEntity);
  SetCreationParameters(CarsCollection, pnHead, pgctlMain,
    car_mgr_CarView, car_mgr_CarChange, car_mgr_CarSearch, car_mgr_CarNew,
    dmData.datasrcCar, dmData.datasrcSearchCar);
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.SavingErrorMsg();
begin
  raise Exception.Create(SysToUTF8(car_mgr_msg_db_chg_err));
end;
//---------------------------------------------------------------------------
function TfrmCarManager.CheckEntityFields(): boolean;
begin
  Result := false;
  if (TCarEntity(Target).CarOwner.IDClient = Null) then
    raise Exception.Create(SysToUTF8(car_mgr_no_owner_err));
  Result := true;
end;
//---------------------------------------------------------------------------
function TfrmCarManager.MakeNewEntity(): boolean;
begin
  // Так надо.
  Result := true;
  if (inherited MakeNewEntity()) then
    begin
      try
        ChangesBlocked          := true;

        cbCarType.ItemIndex     := 0;
        cbPurposeType.ItemIndex := 0;
        cbCarMark.ItemIndex     := 0;
        cbCarMark.OnChange(cbCarMark);
        Result                  := true;
      finally
        ChangesBlocked := false;
      end;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.sbtnPanelClick(Sender: TObject);
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
      // ClearEdits(ttsMain_CarEditor);
      // ClearClientLabels();
      // cboxRent.Checked    := false;
      // cboxForeing.Checked := false;
      dtedPTSDate.Date    := Now();
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.pgctlMainPageChanged(Sender: TObject);
begin
  SetHeadText();
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.sbtnOwnerClick(Sender: TObject);
var new_owner: TClientEntity;
    ms: TManagerState;
begin
  with (TCarEntity(Target)) do
  try
    CarOwner.DataSource := DataSource;
    if ((ManagerState = msEntityCreation) and
        ((CarOwner.IDClient = Null) or (CarOwner.IDClient = EmptyStr)))
          then ms := msEntitySearch
          else ms := msEntityView;
    new_owner := TClientEntity(frmClientManager.ShowManager(CarOwner, ms));
    if (frmClientManager.ModalResult = mrOK) then
      begin
        CarOwner := new_owner;
        ListClientParams();
        DataWasChanged(Sender);
      end;
  except
    on E: Exception do LogException(E);
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.cbSClientTypeGroupChange(Sender: TObject);
begin
  with cbSClientTypeGroup do
  ListClientTypeGroup(StrToInt(GetCBoxStr(cbSClientTypeGroup, ItemIndex)),
    labelSSurname, labelSName, labelSPathronimyc, edSPathronimyc);
  DataWasChanged(Sender);
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.cboxPowerAutoConvertChange(Sender: TObject);
begin
  if (edPowerKWT.Text = EmptyStr) then edPowerChange(edPowerHP)
  else if (edPowerHP.Text = EmptyStr) then edPowerChange(edPowerKWT);
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.cbCarMarkChange(Sender: TObject);
begin
  try
    with dmData.myGetCarModels, cbCarMark do
      begin
        Close();
        ParamByName('id_carmark').AsString :=
          (Items.Objects[ItemIndex] as TStringObject).StringValue;
        Open();
      end;
    DBListFiler.FillListFromDB('ID_CAR_MODEL', 'MODEL',
      dmData.myGetCarModels, [cbCarModel]);
    DataWasChanged(Sender);
  except
    on E: Exception do LogException(E);
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.dbgridSearchDblClick(Sender: TObject);
begin
  if (dbgridSearch.SelectedIndex < 0) then exit;
  ShowSearchResults();
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.dbgridSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    begin
      dbgridSearch.OnDblClick(Sender);
      Key := 0;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.edPowerChange(Sender: TObject);
var power: double;
begin
  if (ChangesBlocked) then exit;
  DataWasChanged(Sender);
  if (not cboxPowerAutoConvert.Checked) then exit;
  power := StrToFloatDef((Sender as TEdit).Text, 0);
  if (Sender = edPowerKWT) then
    begin
    // Рассчёт мощности в Л.С.
      power                 := SimpleRoundTo(ct_hp2kwt * power, -2);
      edPowerHP.OnChange    := nil;
      edPowerHP.Text        := FloatToStr(power);
      edPowerHP.OnChange    := @edPowerChange;
    end
  else
    begin
    // Рассчёт мощности в киловаттах
      power                 := SimpleRoundTo(ct_kwt2hp * power, -2);
      edPowerKWT.OnChange   := nil;
      edPowerKWT.Text       := FloatToStr(power);
      edPowerKWT.OnChange   := @edPowerChange;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.edDigitalEdKeyPress(Sender: TObject; var Key: char);
begin
  CheckDigitalInput(Sender, Key);
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.edVINKeyPress(Sender: TObject; var Key: char);
var ss: TShiftState;
begin
  ss := GetKeyShiftState();
  if ((ss = [ssAlt]) or (ss = [ssCtrl])) then exit;
  if ((Key in ['A'..'Z']) or (Key in ['0'..'9']) or (Key = #8)) then exit;
  if (Key in ['a'..'z']) then
    begin
      Key := upcase(Key);
      exit;
    end;
  Key := #0;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.edSearchKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = #13) then
    begin
      Key := #0;
      sbtnSearch.Click();
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.FormCreate(Sender: TObject);
begin
//  pnHead.Caption := SysToUTF8(car_mgr_CarSearch);
  // ClearClientLabels();
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.FormDestroy(Sender: TObject);
begin
  FreeAndNil(CarsCollection);
  DBListFiler.ClearCb(cbSClientTypeGroup);
  DBListFiler.ClearCb(cbCarType);
  DBListFiler.ClearCb(cbPurposeType);
  DBListFiler.ClearCb(cbCarMark);
  DBListFiler.ClearCb(cbCarModel);
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.sbtnFindClick(Sender: TObject);
begin
  if (Sender = sbtnSearch) then
    begin
      ShowWaiter();
      with cbSClientTypeGroup do
        dmData.FindCar(edSSurname.Text, edSName.Text, edSPathronimyc.Text,
          edSLicenceSer.Text, edSLicenceNum.Text,
          GetCBoxStr(cbSClientTypeGroup, ItemIndex),
          edSVIN.Text, edSChassiNum.Text, edSKusovNum.Text, edSRegNum.Text,
          edSPTSSer.Text, edSPTSNum.Text, dtedSPTSDate.Text,
          '',
          rgSearchType.ItemIndex = 1
        );
      HideWaiter();
    end
  else
    begin
      ClearEdits(ttsMain_CarList);
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.ClearClientLabels();
begin
  labelOwnerName.Caption      := EmptyStr;
  labelOwnerPassport.Caption  := EmptyStr;
  labelOwnerINN.Caption       := EmptyStr;
  labelOwnerAddress.Caption   := EmptyStr;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.ListClientParams();
begin
  ClearClientLabels();
  with (Target as TCarEntity) do
    begin
      labelOwnerName.Caption      := VarToStr(CarOwner.FullName);
      labelOwnerPassport.Caption  := VarToStr(CarOwner.FullDoc);
      labelOwnerINN.Caption       := VarToStr(CarOwner.INN);
      labelOwnerAddress.Caption   := VarToStr(CarOwner.FullAddress);
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.SetControlsState(cenabled: boolean);
var eflag: boolean;
begin
  with CurrentUser.UserGroup do
    begin
      eflag := ((ManagerState in [msEntityView, msEntityEdit]) and
        Privileges[Priv_car_chg]);
      eflag := eflag or (ManagerState = msEntityCreation);
      eflag := eflag and cenabled;
      SwitchControls(ttsMain_CarEditor, eflag);
      sbtnNew.Enabled := Privileges[Priv_car_add];
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.ListData();
begin
  with (Target as TCarEntity) do
    begin
      SetIndexFromObject(cbCarType, VarToStr(IDCarType));
      SetIndexFromObject(cbPurposeType, VarToStr(IDPurposeUse));
      SetIndexFromObject(cbCarMark, VarToStr(IDCarMark));
      with cbCarMark do
      if (ItemIndex = -1) then
        begin
          // Автор предыдущего клиента заносил в это поле не ID,
          // а название марки. Я хочу работать и с тем, и с тем.
          ItemIndex := Items.IndexOf(VarToStr(CarMarkName));
        end;
      cbCarMark.OnChange(cbCarMark);
      cbCarModel.Text         := VarToStr(CarModel);
      edPTSSer.Text           := VarToStr(PtsSer);
      edPTSNum.Text           := VarToStr(PtsNum);
      dtedPTSDate.Text        := VarToStr(PtsDate);
      edVIN.Text              := VarToStr(VIN);
      edChassiNum.Text        := VarToStr(ShassiNum);
      edKusovNum.Text         := VarToStr(KusovNum);
      edRegNum.Text           := VarToStr(GosNum);
      edProductionYear.Text   := VarToStr(YearIssue);
      edPowerKWT.Text         := VarToStr(PowerKWT);
      edPowerHP.Text          := VarToStr(PowerHP);
      edMaxMass.Text          := VarToStr(MaxMass);
      edPassengersCount.Text  := VarToStr(NumPlaces);
      cboxRent.Checked        := VarToBool(InRent);
      cboxForeing.Checked     := VarToBool(Foreign);
      memoComments.Lines.Assign(Comments);
    end;
  ListClientParams();
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.LoadDataInEntity();
begin
  with (Target as TCarEntity) do
    begin
      with cbCarType do
        if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
          IDCarType := (Items.Objects[ItemIndex] as TStringObject).StringValue;
      with cbPurposeType do
        if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
          IDPurposeUse := (Items.Objects[ItemIndex] as TStringObject).StringValue;
      with cbCarMark do
        if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
          begin
            IDCarMark := (Items.Objects[ItemIndex] as TStringObject).StringValue;
            OnChange(cbCarMark);
          end;
      CarModel                := cbCarModel.Text;
      PtsSer                  := edPTSSer.Text;
      PtsNum                  := edPTSNum.Text;
      PtsDate                 := dtedPTSDate.Date;
      VIN                     := edVIN.Text;
      ShassiNum               := edChassiNum.Text;
      KusovNum                := edKusovNum.Text;
      GosNum                  := edRegNum.Text;
      YearIssue               := StrToVar(edProductionYear.Text);
      PowerKWT                := StrToVar(edPowerKWT.Text);
      PowerHP                 := StrToVar(edPowerHP.Text);
      MaxMass                 := StrToVar(edMaxMass.Text);
      NumPlaces               := StrToVar(edPassengersCount.Text);
      InRent                  := cboxRent.Checked;
      Foreign                 := cboxForeing.Checked;
      Comments.Assign(memoComments.Lines);
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmCarManager.EntityWasUpdated(const record_id: TTableRecordID;
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
        Target.DataSource := dmData.GetCarByID(VarToStr(record_id[0]));
        Target.DB_Load(ltNew);
        try
          ChangesBlocked := true;
          ListData();
          ReinitManager();
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
        finally
          ChangesBlocked := false;
        end;
      end;
    utAction: ;
  end;
end;
//---------------------------------------------------------------------------
initialization
  {$i car_manager.lrs}

end.
