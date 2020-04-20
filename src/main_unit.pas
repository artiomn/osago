unit main_unit;

{$I settings.inc}

//
// Главный модуль программы. Содержит основную форму.
//

interface

//
// Ну вот исчезла дрожь в руках...
// Теперь - наверх.
// Ну вот сорвался в пропасть страх... Навек, навек.
//

uses
  SysUtils, Classes, dateutils, Variants, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, ComCtrls, Menus, Buttons,
  LResources, LCLType, PopupNotifier, ExtDlgs, DbCtrls, EditBtn,
  about_unit, car_manager, client_manager, user_manager, info_manager,
  contract_history, db, strings_l10n, waiter_unit, SQLTool, LCLProc,
  ZVDateTimePicker, DBAccess, LR_Class, LR_Desgn, LR_Const, FileUtil,
  data_unit, data_coefs, blank_contracts,
  common_consts, abstract_manager, contracts_input, common_functions,
  reports_unit, orm_abstract, orm_contract, orm_client, orm_car,
  orm_infos_inscompany, orm_user, orm_group, m_in_word, ins_prem_calc,
  update_dispatcher, logger;

type

  TEdSubstate = (esNone, esProlong, esReplace);

  { TfrmMain }

  TfrmMain = class(TAbstractManager)
    apppropMain: TApplicationProperties;
    bevelSeparator2: TBevel;
    bevelSeparator3: TBevel;
    calcedAward: TCalcEdit;
    cbBonusMalus: TComboBox;
    cbInsCompany: TComboBox;
    cboxAddPeriod: TCheckBox;
    cboxAddPeriod2: TCheckBox;
    cboxTransit: TCheckBox;
    cboxUnlimDrvs: TCheckBox;
    cbSClientTypeGroup: TComboBox;
    cbSDocType: TComboBox;
    dbgridReminder: TDBGrid;
    dbgridSearch: TDBGrid;
    dtedAddPeriod2End: TDateEdit;
    dtedAddPeriod2Start: TDateEdit;
    dtedAddPeriodEnd: TDateEdit;
    dtedAddPeriodStart: TDateEdit;
    dtedBeginDate: TDateEdit;
    dtedEndDate: TDateEdit;
    dtedPeriodEnd: TDateEdit;
    dtedPeriodStart: TDateEdit;
    dtedSigningDate: TDateEdit;
    dtedStartDate: TDateEdit;
    dtedTicketDate: TDateEdit;
    edAgentName: TEdit;
    edInsAwdBS: TEdit;
    edInsAwdKBM: TEdit;
    edInsAwdKM: TEdit;
    edInsAwdKN: TEdit;
    edInsAwdKO: TEdit;
    edInsAwdKP: TEdit;
    edInsAwdKS: TEdit;
    edInsAwdKT: TEdit;
    edInsAwdKVS: TEdit;
    edInsSum: TEdit;
    edPolisNum: TEdit;
    edPolisSer: TEdit;
    edSChassiNum: TEdit;
    edSDocNum: TEdit;
    edSDocSer: TEdit;
    edSKusovNum: TEdit;
    edSLicenceNum: TEdit;
    edSLicenceSer: TEdit;
    edSName: TEdit;
    edSPathronimyc: TEdit;
    edSpecialSignNum: TEdit;
    edSpecialSignSer: TEdit;
    edSPolisNum: TEdit;
    edSPolisSer: TEdit;
    edSRegNum: TEdit;
    edSSurname: TEdit;
    edSVIN: TEdit;
    edTicketNum: TEdit;
    edTicketSer: TEdit;
    gbAgent: TGroupBox;
    gbCar: TGroupBox;
    gbDrivers: TGroupBox;
    gbInsCalculator: TGroupBox;
    gbOwner: TGroupBox;
    gbPeriods: TGroupBox;
    gbPolicyholder: TGroupBox;
    gbPolis: TGroupBox;
    gbReceipt: TGroupBox;
    gbSCar: TGroupBox;
    gbSpecialNotes: TGroupBox;
    gbSPolicyholder: TGroupBox;
    gbSPolicyholderDoc: TGroupBox;
    gbSPolis: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
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
    Label28: TLabel;
    Label3: TLabel;
    Label32: TLabel;
    Label4: TLabel;
    Label40: TLabel;
    Label44: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label5: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label6: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label7: TLabel;
    Label70: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    labelAddPeriod2Delim: TLabel;
    labelAddPeriodDelim: TLabel;
    labelAgent: TLabel;
    labelCarMark: TLabel;
    labelCarType: TLabel;
    labelGosNum: TLabel;
    labelKusov: TLabel;
    labelOwnerAddress: TLabel;
    labelOwnerData: TLabel;
    labelOwnerINN: TLabel;
    labelOwnerPassport: TLabel;
    labelPhAddress: TLabel;
    labelPhINN: TLabel;
    labelPhPassport: TLabel;
    labelPolisNum: TLabel;
    labelPolisSer: TLabel;
    labelPTSNum: TLabel;
    labelPTSSer: TLabel;
    labelShassi: TLabel;
    labelSName: TLabel;
    labelSPathronimyc: TLabel;
    labelSSCaption: TLabel;
    LabelSSNum: TLabel;
    LabelSSSer: TLabel;
    labelSSurname: TLabel;
    labelVIN: TLabel;
    memoSpecialNotes: TMemo;
    mnRemindButton_RPerm: TMenuItem;
    mnRemindButton_RTemp: TMenuItem;
    mmnMain_Help_Sep0: TMenuItem;
    mmnMain_Help_Manual: TMenuItem;
    mnTree_Sep0: TMenuItem;
    mmnMain_Admin_Sep0: TMenuItem;
    mnTree_TicketEdit: TMenuItem;
    mmnMain_Admin_Reports_RepGeneral: TMenuItem;
    mmnMain_Admin_Reports_RepbyDate: TMenuItem;
    mmnMain_Admin_Reports: TMenuItem;
    mmnMain_Admin_ReportsForm_RepGeneral: TMenuItem;
    mmnMain_Admin_ReportsForm_Repbydate: TMenuItem;
    mnTree_BlankDamage: TMenuItem;
    mnTree_BlankUnreserve: TMenuItem;
    mnTree_BlankReserve: TMenuItem;
    mnReminder_Open: TMenuItem;
    mnReminder_Remind: TMenuItem;
    mnPopupReminder: TPopupMenu;
    mnTray_MinInTray: TMenuItem;
    mnTray_Minimize: TMenuItem;
    mnDrivers_Add: TMenuItem;
    mnDrivers_Chg: TMenuItem;
    mnDrivers_Del: TMenuItem;
    mnPopupDrivers: TPopupMenu;
    mnTray_CloseApp: TMenuItem;
    mnTray_Sep0: TMenuItem;
    mnTray_ShowApp: TMenuItem;
    mmnMain_Admin_ReportsForm_Receipt: TMenuItem;
    mmnMain_Admin_ReportsForm_Polis: TMenuItem;
    mmnMain_Admin_InputBlanks: TMenuItem;
    mmnMain_Admin_ReportsForm: TMenuItem;
    mnTree_CompanyInfo: TMenuItem;
    mmnMain_Help_About: TMenuItem;
    mmnMain_Help: TMenuItem;
    mmnMain_Admin_SQLTool: TMenuItem;
    mmnMain_Admin: TMenuItem;
    pgctlMain: TPageControl;
    pnDriversBottom: TPanel;
    pnHead: TPanel;
    pnotifierTree: TPopupNotifier;
    mnPopupTree: TPopupMenu;
    mnPopupTray: TPopupMenu;
    mnPopup_RemindButton: TPopupMenu;
    rgPrint: TRadioGroup;
    rgSearchType: TRadioGroup;
    sbtnCalcInsAward: TSpeedButton;
    sbtnCar: TSpeedButton;
    sbtnClear: TSpeedButton;
    sbtnContractSave: TSpeedButton;
    sbtnContractProlong: TSpeedButton;
    sbtnContractReplace: TSpeedButton;
    sbtnContractRollBack: TSpeedButton;
    sbtnDriverAdd: TSpeedButton;
    sbtnDriverDel: TSpeedButton;
    sbtnDriverEdit: TSpeedButton;
    sbtnGetActualCoefs: TSpeedButton;
    sbtnGetCurrCoefs: TSpeedButton;
    sbtnNow: TSpeedButton;
    sbtnPolicyholder: TSpeedButton;
    sbtnPolisSelect: TSpeedButton;
    sbtnPrint: TSpeedButton;
    sbtnRemind: TSpeedButton;
    sbtnSearch: TSpeedButton;
    sbtnSetInsClass: TSpeedButton;
    splitterHoriz: TSplitter;
    strGridDrivers: TStringGrid;
    stxtFormula: TStaticText;
    tmTray: TTimer;
    trayicMain: TTrayIcon;
    trvLeft: TTreeView;
    mmnMain: TMainMenu;
    sbarMain: TStatusBar;
    splitterLeft: TSplitter;
    pnData: TPanel;
    mmnMain_File: TMenuItem;
    pnToolbar: TPanel;
    sbtnContractAdd: TSpeedButton;
    sbtnContractClose: TSpeedButton;
    sbtnCarManager: TSpeedButton;
    sbtnClientManager: TSpeedButton;
    bevelSeparator: TBevel;
    bevelSeparator1: TBevel;
    sbtnUserManager: TSpeedButton;
    sbtnInfoManager: TSpeedButton;
    sbtnContractHistory: TSpeedButton;
    imglstTree: TImageList;
    mmnMain_File_Close: TMenuItem;
    ttsMain_AddInfo: TTabSheet;
    ttsMain_Search: TTabSheet;
    ttsMain_Statement: TTabSheet;
    zvdtpStartTime: TZVDateTimePicker;
    procedure apppropMainShowHint(var HintStr: string; var CanShow: Boolean;
      var HintInfo: THintInfo);
    procedure dbgridReminderDblClick(Sender: TObject);
    procedure dbgridSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dtedPeriodsUseChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MainMenuClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnPopup_RemindButtonItemsClick(Sender: TObject);
    procedure mnPopupReminderPopup(Sender: TObject);
    procedure mnPopupTreePopup(Sender: TObject);
    procedure mnReminderItemsClick(Sender: TObject);
    procedure mnTrayItemsClick(Sender: TObject);
    procedure mnTreeItemsClick(Sender: TObject);
    procedure sbtnNowClick(Sender: TObject);
    procedure splitterLeftCanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure sbtnPanelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure strGridDriversKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tmTrayTimer(Sender: TObject);
    procedure trayicMainDblClick(Sender: TObject);
    procedure trayicMainMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure trvLeftChange(Sender: TObject; Node: TTreeNode);
    procedure trvLeftDblClick(Sender: TObject);
    procedure trvLeftDeletion(Sender: TObject; Node: TTreeNode);
    procedure cbClientChange(Sender: TObject);
    procedure cboxAddPeriodChange(Sender: TObject);
    procedure cboxUnlimDrvsChange(Sender: TObject);
    procedure cbSClientTypeGroupChange(Sender: TObject);
    procedure dbgridSearchDblClick(Sender: TObject);
    procedure edInsAwdCoefsKeyPress(Sender: TObject; var Key: char);
    procedure edNumberKeyPress(Sender: TObject; var Key: char);
    procedure edSearchKeyPress(Sender: TObject; var Key: char);
    procedure sbtnDriversClick(Sender: TObject);
    procedure sbtnPrnClick(Sender: TObject);
    procedure sbtnsStatementClick(Sender: TObject);
    procedure sbtnFindClick(Sender: TObject);
    procedure strGridDriversColRowDeleted(Sender: TObject; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure strGridDriversColRowInserted(Sender: TObject; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure mnDriversItemsClick(Sender: TObject);
    procedure mnPopupDriversPopup(Sender: TObject);
    procedure strGridDriversDblClick(Sender: TObject);
    procedure sbtnInsCoefsClick(Sender: TObject);
    procedure edInsAwdCoefsChange(Sender: TObject);
  published
    procedure DataWasChanged(Sender: TObject); override;
  public
    // Менеджер договоров вызывает этот метод, при обновлении договора.
    procedure EntityWasUpdated(const record_id: TTableRecordID;
      const update_type: TUpdateType; const user_updater: string); override;
  private
    // Договор для отката.
    FBackupContract: TContractEntity;
    // Пердыдущий (исторически) договор. Требуется при печати заявления.
    FPrevContract: TContractEntity;
    // Дополнительное состояние, при редактировании (замена/пролонгация).
    FEdSubstate: TEdSubstate;
    // Преобразователь числа в строку.
    FNumConvertor: TInWord;
    // В этой точке было показано контекстное меню дерева.
    FMnTreePopupPoint: TPoint;
    // Метод, создающий окно с информацией о страховой компании.
    procedure CreateICNotifier();
    // Процедура, вызываемая при деактивации окна информации о компании.
    procedure NotifierDeactivated(Sender: TObject);
    // Устанавливает страховую компанию в списке из компании,
    // выбранной в дереве.
    procedure SetCompanyFromTree(const Node: TTreeNode);
  private
    procedure HistoryGridsClick(ds: TDataSource);
  private
    // Дизайнер заявления. Обработка клика на кнопке сохранения.
    // FDumbReport: TfrDumbReport;
    // FTicketDesign: boolean;
    procedure DesignerOnSaveClick(Sender: TObject);
  private
    // Рассчёт страховой премии.
    procedure CalcInsAward();
    procedure ClearContractLabels();
  private
    // Устанавливает индекс в списке вероятных страхователей.
    //procedure SetPHIndex(const value: variant);
    // Получает индекс данного страхователя.
    //function GetPHIndex(p_holder: TClientEntity): integer;
    //procedure SetClientInList(const cln: TClientEntity;
    //  const add: boolean = true);
    procedure ListCarParams();
    procedure ListClientParams();
    function ClientInDriversIndex(const cln: TClientEntity): integer;
    procedure AddDriverToGrid(const row_num: integer;
      const de: TDriverEntity);
    // Обновляет водителя в списке, если de входит в список.
    procedure UpdateDrivers(const de: TDriverEntity);
    procedure ListDrivers();
    // Загружает коэффициенты из договора.
    procedure ListContractCoefs();
    // Загружает корректные коэффициенты из справочников.
    procedure ListActualCoefs();
    procedure ListAgent();
    procedure FillClientsLists();
    // Устанавливает коррекный класс страхования.
    procedure SetRigthInsClass();
    // Проверяет класс страхования.
    procedure CheckInsClass();
    // Создаёт особые отметки из страховых премий.
    procedure MakeSpecialNotes();
    // Резервирует бланк.
    procedure DoReserveBlank(const blank: TBlankEntity);
  private
    procedure SetControlsState(cenabled: boolean); override;
    procedure ListData(); override;
    procedure LoadDataInEntity(); override;
    procedure SetParamsDuringCreation(); override;
    procedure SavingErrorMsg(); override;
    function CheckEntityFields(): boolean; override;
  private
    procedure SetHeadText(); override;
    function ShowSearchResults(): boolean; override;
  private
    // Настройки пользователя.
    procedure ApplyCurUserSettings();
    procedure SaveCurUserSettings();
  private
    // Получение данных, для печати бланков.
    procedure ReceiptGetValue(const ParName: String; var ParValue: Variant);
    procedure PolisGetValue(const ParName: String; var ParValue: Variant);
  private
    function AddCompanyToTreeAndList(const ins_company: TInfInsCompany): TTreeNode;
    function AddBlankToTree(const parent_node: TTreeNode;
      const blank: TBlankEntity; const first: boolean): TTreeNode;
    procedure MakeCompaniesLists();
    procedure ClearCompaniesLists();
  private
    // События обновления.
    procedure OnBlanksUpdate(const entity_id: TTableRecordID;
      const update_type: TUpdateType; const user_updater: string);
    procedure OnCarUpdate(const entity_id: TTableRecordID;
      const update_type: TUpdateType; const user_updater: string);
    procedure OnClientUpdate(const entity_id: TTableRecordID;
      const update_type: TUpdateType; const user_updater: string);
    procedure OnContractUpdate(const entity_id: TTableRecordID;
      const update_type: TUpdateType; const user_updater: string);
    procedure OnInsCompsUpdate(const entity_id: TTableRecordID;
      const update_type: TUpdateType; const user_updater: string);
    procedure OnUserUpdate(const entity_id: TTableRecordID;
      const update_type: TUpdateType; const user_updater: string);
    procedure OnVisInfosUpdate(const table_name: string;
      const user_updater: string);
    procedure OnInvisInfosUpdate(const table_name: string;
      const user_updater: string);
  private
    // Ошибка БД.
    procedure DBError(Sender: TObject; E: EDAError;
      var Fail: boolean);
  end;

var
  frmMain: TfrmMain;

implementation
//---------------------------------------------------------------------------
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FEdSubstate         := esNone;
  FBackupContract     := TContractEntity.Create(nil);
  FPrevContract       := TContractEntity.Create(nil);
  FNumConvertor       := TInWord.Create(Self);
  CompaniesCollection := TEntityesCollection.Create(TInfInsCompany);
  GroupsCollection    := TEntityesCollection.Create(TGroupEntity);
  LoadGroups();
  CreateICNotifier();
  trayicMain.BalloonTitle := Caption;
  trayicMain.BalloonHint  := Application.Title;
  pnHead.Caption := SysToUTF8(contract_mgr_ConSearch);
  // Модули данных создаются первыми, поэтому, в данном случае, работает.
  dmReports.OnPolisGetValue   := @PolisGetValue;
  dmReports.OnReceiptGetValue := @ReceiptGetValue;
  // Одинаковый обработчик для квитанции и заявления.
  dmReports.OnTicketGetValue  := @ReceiptGetValue;

  strGridDrivers.DoubleBuffered := true;
  dbgridSearch.DoubleBuffered   := true;

  ClearContractLabels();

  ApplyCurUserSettings();

  dmData.OnDBError                          := @DBError;

  // Произвожу предварительное обновление. Без событий.
  DBUpdateDispatcher.Active                 := true;
  DBUpdateDispatcher.Active                 := false;

  DBUpdateDispatcher.OnBlanksUpdate         := @OnBlanksUpdate;
  DBUpdateDispatcher.OnCarUpdate            := @OnCarUpdate;
  DBUpdateDispatcher.OnClientUpdate         := @OnClientUpdate;
  DBUpdateDispatcher.OnContractUpdate       := @OnContractUpdate;
  DBUpdateDispatcher.OnInsCompsUpdate       := @OnInsCompsUpdate;
  DBUpdateDispatcher.OnInfosInvisibleUpdate := @OnInvisInfosUpdate;
  DBUpdateDispatcher.OnInfosVisibleUpdate   := @OnVisInfosUpdate;
  DBUpdateDispatcher.OnUserUpdate           := @OnUserUpdate;

  DBUpdateDispatcher.Active                 := true;

end;
//---------------------------------------------------------------------------
procedure TfrmMain.SetParamsDuringCreation();
begin
  ContractsCollection := TEntityesCollection.Create(TContractEntity);
  SetCreationParameters(ContractsCollection, pnHead, pgctlMain,
    contract_mgr_ConView, contract_mgr_ConChange, contract_mgr_ConSearch,
    contract_mgr_ConNew,
    dmData.datasrcContract, dmData.datasrcSearchContract);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.SavingErrorMsg();
begin
  raise Exception.Create(SysToUTF8(contract_mgr_msg_db_chg_err));
end;
//---------------------------------------------------------------------------
function TfrmMain.CheckEntityFields(): boolean;
begin
  Result := false;
  with TContractEntity(Target) do
    begin
      if (Car.IDCar = Null) then
        raise Exception.Create(SysToUTF8(contract_mgr_msg_car_err));
      if (PolicyHolder.IDClient = Null) then
        raise Exception.Create(SysToUTF8(contract_mgr_msg_ph_err));
      if ((not cboxUnlimDrvs.Checked) and (Drivers.Count = 0)) then
        raise Exception.Create(SysToUTF8(contract_mgr_msg_drvs_err));
      if ((DogSer = Null) or (DogNum = Null) or (DogSer = EmptyStr)
          or (DogNum = EmptyStr)) then
        raise Exception.Create(SysToUTF8(contract_mgr_msg_bl_err));
      CheckInsClass();
    end;
  Result := true;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.SetHeadText();
begin
  if ((pgctlMain.ActivePageIndex <> 0) and (FEdSubstate <> esNone) and
    (ManagerState = msEntityCreation)) then
    begin
      case FEdSubstate of
        esReplace:
          pnHead.Caption  := SysToUtf8(contract_mgr_ConReplace);
        esProlong:
          pnHead.Caption  := SysToUtf8(contract_mgr_ConProlong);
      end;
    end
  else inherited;
end;
//---------------------------------------------------------------------------
function TfrmMain.ShowSearchResults(): boolean;
var LastEdSubs: TEdSubstate;
begin
  LastEdSubs := FEdSubstate;
  try
    FEdSubstate := esNone;
    Result := inherited ShowSearchResults();
    if (Result) then
      begin
        FBackupContract.Assign(Target);
        if ((TContractEntity(Target).IDPrevContract <> Null) and
          (TContractEntity(Target).IDPrevContract <> EmptyStr)) then
        with FPrevContract do
          begin
            DataSource := dmData.GetContByID(
              VarToStr(TContractEntity(Target).IDPrevContract)
            );
            DB_Load(ltNew);
          end;
        ChangesBlocked := true;
        ListContractCoefs();
        ChangesBlocked := false;
      end
    else
      FEdSubstate := LastEdSubs;
  except
    LogException('frmMain.ShowSearchResults:');
    FEdSubstate := LastEdSubs;
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.DataWasChanged(Sender: TObject);
begin
  if (ChangesBlocked) then exit;
  if (ManagerState = msEntityView) then FEdSubstate := esNone;
  inherited;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  SaveCurUserSettings();
  DBUpdateDispatcher.Free;
  FNumConvertor.Free;
  FreeAndNil(GroupsCollection);
  FreeAndNil(CompaniesCollection);
  FreeAndNil(ContractsCollection);
  // Делается для того, чтобы все объекты удалились ещё до разрушения ComboBox.
  // И не возникало RunError 210. Сам DBListFiler удаляется после форм.
  // DBListFiler.ClearCb(cbInsCompany);
  DBListFiler.ClearCb(cbSDocType);
  DBListFiler.ClearCb(cbSClientTypeGroup);
  DBListFiler.ClearCb(cbBonusMalus);
  with strGridDrivers do Clean(0, 1, ColCount, RowCount,
    [gzNormal, gzInvalid]);
  FBackupContract.Free;
  FPrevContract.Free;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.FormShow(Sender: TObject);
begin
  MakeCompaniesLists();
  if (ManagerState <> msEntitySearch) then ManagerState := msEntitySearch
  else
    begin
      SetControlsState(ManagerState in
        [msEntityView, msEntityEdit, msEntityCreation]);
      SetManPage();
      SetHeadText();
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.ApplyCurUserSettings();
begin
  with CurrentUser do
    begin
      if (MwLeft <> Null) then Left := MwLeft;
      if (MwTop <> Null) then Top := MwTop;
      if (MwHeight <> Null) then Height := MwHeight;
      if (MwWidth <> Null) then Width := MwWidth;
      if (MwState <> Null) then WindowState := MwState;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.SaveCurUserSettings();
begin
  with CurrentUser do
    begin
      FirstRun  := false;
      MwLeft    := Left;
      MwTop     := Top;
      MwHeight  := Height;
      MwWidth   := Width;
      MwState   := WindowState;
      UseHelper := false;
    end;
{  if (CurrentUser.SaveSettings() = false) then
    raise Exception.Create(SysToUTF8(cls_setts_svg_err_msg));}
  CurrentUser.SaveSettings();
end;
//---------------------------------------------------------------------------
procedure TfrmMain.DesignerOnSaveClick(Sender: TObject);
begin
  with TInfInsCompany(CompaniesCollection[CompaniesCollection.ItemIndex]) do
    begin
      LoadTicket(CurReport);
      if (DB_Save() = false) then
        raise Exception.Create(SysToUTF8(cls_ticket_svg_err_msg));
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.tmTrayTimer(Sender: TObject);
begin
  tmTray.Enabled := false;
  trayicMain.ShowBalloonHint();
end;
//---------------------------------------------------------------------------
procedure TfrmMain.trayicMainMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  tmTray.Enabled := not tmTray.Enabled;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.apppropMainShowHint(var HintStr: string;
  var CanShow: Boolean; var HintInfo: THintInfo);
begin
//  sbar.SimpleText := HintStr;
  CanShow := False;
//  sbar.SimplePanel := HintStr<>'';
end;
//---------------------------------------------------------------------------
procedure TfrmMain.dbgridSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    begin
      dbgridSearch.OnDblClick(Sender);
      Key := 0;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.MainMenuClick(Sender: TObject);
begin
  if (Sender = mmnMain_File_Close) then
    begin
      Close();
    end
  else if (Sender = mmnMain_Admin_InputBlanks) then
    begin
      if (frmContractsInput = nil) then
        begin
          Debug('Creating frmContractsInput.');
          Application.CreateForm(TfrmContractsInput, frmContractsInput);
        end;
      sbarMain.AutoHint := false;
      frmContractsInput.ShowModal();
      sbarMain.AutoHint := true;
    end
  else if (Sender = mmnMain_Admin_Reports_RepbyDate) then
    begin
      dmReports.PrintRepByDate();
    end
  else if (Sender = mmnMain_Admin_Reports_RepGeneral) then
    begin
      dmReports.PrintRepGeneral();
    end
  else if (Sender = mmnMain_Admin_ReportsForm_Polis) then
    begin
      dmReports.DesignPolisBlank();
    end
  else if (Sender = mmnMain_Admin_ReportsForm_Receipt) then
    begin
      dmReports.DesignReceiptBlank();
    end
  else if (Sender = mmnMain_Admin_ReportsForm_Repbydate) then
    begin
      dmReports.DesignRepByDateBlank();
    end
  else if (Sender = mmnMain_Admin_ReportsForm_RepGeneral) then
    begin
      dmReports.DesignGRBlank();
    end
  else if (Sender = mmnMain_Admin_SQLTool) then
    begin
      if (frmSQLTool = nil) then
        Application.CreateForm(TfrmSQLTool, frmSQLTool);
      sbarMain.AutoHint := false;
      frmSQLTool.Show();
      sbarMain.AutoHint := true;
    end
  else if (Sender = mmnMain_Help_Manual) then
    begin
      OpenURL(ExtractFileNameWithoutExt(ParamStrUTF8(0)) + man_ext);
    end
  else if (Sender = mmnMain_Help_About) then
    begin
      if (frmAbout = nil) then Application.CreateForm(TfrmAbout, frmAbout);
      frmAbout.ShowModal();
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.mnPopupTreePopup(Sender: TObject);
var Node: TTreeNode;
begin
  FMnTreePopupPoint := ScreenToClient(Mouse.CursorPos);
  with FMnTreePopupPoint do Node  := trvLeft.GetNodeAt(x, y);

  mnTree_BlankDamage.Visible    := false;
  mnTree_BlankReserve.Visible   := false;
  mnTree_BlankUnreserve.Visible := false;
  mnTree_CompanyInfo.Visible    := false;
  mnTree_TicketEdit.Visible     := false;
  mnTree_Sep0.Visible           := false;

  if ((Node = nil) or (Node.Data = nil)) then exit;
  if (TObject(Node.Data).ClassNameIs('TInfInsCompany')) then
    begin
      mnTree_CompanyInfo.Visible    := true;
      mnTree_TicketEdit.Visible     :=
        CurrentUser.UserGroup.Privileges[Priv_infos_edit];
      mnTree_Sep0.Visible           := mnTree_TicketEdit.Visible;
    end
  else if (TObject(Node.Data).ClassNameIs('TBlankEntity')) then
    begin
      mnTree_BlankDamage.Visible    := true;
      mnTree_BlankUnreserve.Visible :=
        (TObject(Node.Data) as TBlankEntity).Reserved;
      mnTree_BlankReserve.Visible   := (not mnTree_BlankUnreserve.Visible) and
        (not (ManagerState in [msEntitySearch]));
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.mnTreeItemsClick(Sender: TObject);
var Node: TTreeNode;
    company: TInfInsCompany;
    p: TPoint;
begin
  // p := ScreenToClient(Mouse.CursorPos);
  p     := FMnTreePopupPoint;
  Node  := trvLeft.GetNodeAt(p.x, p.y);
  if ((Node = nil) or (Node.Data = nil)) then exit;

  if (Sender = mnTree_CompanyInfo) then
    begin
      if (not TObject(Node.Data).ClassNameIs('TInfInsCompany')) then exit;
      company             := TInfInsCompany(Node.Data);
      pnotifierTree.Title := VarToStr(company.InsCompanyName);
      pnotifierTree.Text  :=
        SysToUtf8(cls_address) + ': '#09#09' ' + VarToStr(company.Address) + #13 +
        SysToUtf8(cls_phone) + ': '#09#09' ' + VarToStr(company.Phone) + #13 +
        SysToUtf8(cls_fax) + ': '#09#09' ' + VarToStr(company.Fax) + #13 +
        SysToUtf8(cls_comment) + ': '#09#09' ' + company.Comments.Text;
      p := ClientToScreen(p);
      pnotifierTree.ShowAtPos(p.x, p.y);
    end
  else if (Sender = mnTree_TicketEdit) then
    begin
      if (not TObject(Node.Data).ClassNameIs('TInfInsCompany')) then exit;
      company := TInfInsCompany(Node.Data);
      with CompaniesCollection do ItemIndex := GetEntityIndex(company);
      company.TicketBody.Position := 0;
      if (company.TicketBody.Size > 0) then
        dmReports.frreportTicket.LoadFromStream(company.TicketBody)
      else
        begin
          dmReports.frreportTicket.Clear;
          dmReports.frreportTicket.FileName := SUntitled;
        end;
//      FTicketDesign := true;
      dmReports.DesignTicketBlank(@DesignerOnSaveClick);
    end
  else if (Sender = mnTree_BlankReserve) then
    begin
      if (not TObject(Node.Data).ClassNameIs('TBlankEntity')) then exit;
      DoReserveBlank(TBlankEntity(Node.Data));
      DBUpdateDispatcher.Refresh();
    end
  else if (Sender = mnTree_BlankUnreserve) then
    begin
      if (not TObject(Node.Data).ClassNameIs('TBlankEntity')) then exit;
      with TBlankEntity(Node.Data) do
        begin
          BlankUnreserve();
          DBUpdateDispatcher.Refresh();
          if ((TContractEntity(Target).DogNum = DogNum)
              and (TContractEntity(Target).DogSer = DogSer)
              and (TContractEntity(Target).IDInsuranceCompany =
                   InsuranceCompany.IDInsCompany)) then
            with (TContractEntity(Target)) do
              begin
                DogSer          := Null;
                DogNum          := Null;
                edPolisSer.Text := EmptyStr;
                edPolisNum.Text := EmptyStr;
              end;
        end;
    end
  else if (Sender = mnTree_BlankDamage) then
    begin
      if (not TObject(Node.Data).ClassNameIs('TBlankEntity')) then exit;
      with TBlankEntity(Node.Data) do
        begin
          BlankDamage();
          DBUpdateDispatcher.Refresh();
        end;
    end
end;
//---------------------------------------------------------------------------
procedure TfrmMain.sbtnNowClick(Sender: TObject);
begin
  zvdtpStartTime.Time := Now();
end;
//---------------------------------------------------------------------------
procedure TfrmMain.mnTrayItemsClick(Sender: TObject);
begin
  if (Sender = mnTray_ShowApp) then
    begin
      if (not Visible) then MinInTray()
      else
        begin
          if (WindowState = wsMinimized) then Application.Restore();
          BringToFront();
        end;
    end
  else if (Sender = mnTray_MinInTray) then
    begin
      if (Visible) then Application.Restore;
      //Application.Minimize;
      MinInTray();
    end
  else if (Sender = mnTray_Minimize) then
    begin
      if (WindowState <> wsMinimized) then Application.Minimize;
    end
  else if (Sender = mnTray_CloseApp) then
    begin
      Close();
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.trayicMainDblClick(Sender: TObject);
begin
  mnTray_ShowApp.Click();
end;
//---------------------------------------------------------------------------
procedure TfrmMain.splitterLeftCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
var wmax: integer;
begin
  wmax := sbarMain.Width - sbarMain.Panels.Items[0].Width;
  if (NewSize >= wmax) then
    begin
      NewSize := wmax;
      Accept  := false;
    end;
  //sbarMain.Panels.Items[1].Text := IntToStr(NewSize);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.sbtnPanelClick(Sender: TObject);
var dt_delta: TDateTime;
    ic: TInfInsCompany;
    blank: TBlankEntity;
    t_node: TTreeNode;
    cnt_id: string;

begin
  with (dmData) do
  begin
  if (Sender = sbtnRemind) then
    begin
      mnPopup_RemindButton.PopUp();
    end
  else if (Sender = sbtnContractAdd) then
    begin
      if (not MakeNewEntity()) then exit;
      try
        ChangesBlocked := true;
        FBackupContract.Assign(Target);
        //cbPolicyholder.Clear();
        SetCompanyFromTree(trvLeft.Selected);
        //!!! Костыль.
        cbBonusMalus.ItemIndex  := 5;
        sbtnNow.Click();
        dt_delta                := Now();
        dtedStartDate.Date      := dt_delta;
        dtedEndDate.Date        := IncYear(dt_delta);
        dtedPeriodStart.Date    := dt_delta;
        dtedPeriodEnd.Date      := IncMonth(dt_delta);
        dtedSigningDate.Date    := dt_delta;
        dtedBeginDate.Date      := dt_delta;
        dtedTicketDate.Date     := dt_delta;
        cboxAddPeriod.Checked   := false;
        cboxAddPeriod2.Checked  := false;
        edPolisSer.Text         := EmptyStr;
        edPolisNum.Text         := EmptyStr;
        cbInsCompany.ItemIndex  := 0;
        MakeSpecialNotes();
      finally
        ChangesBlocked := false;
      end;
    end
  else if (Sender = sbtnContractSave) then
    begin
      with TContractEntity(Target).Car do
        if ((IDCar <> Null) and ((GosNum = Null) or (GosNum = EmptyStr))) then
          begin
            if (QuestionDlg(SysToUtf8(cls_warning),
              SysToUtf8(contract_mgr_no_nums_msg + cls_sure_q), mtWarning,
                [mrYes, SysToUTF8(cls_yes), mrNo, SysToUtf8(cls_no)], 0) = mrNo)
            then exit;
          end;
      if (DlgChangesCommit() = mrYes) then
        begin
          // Удаляю бланк.
          with (TContractEntity(Target)) do
            begin
              ic := TInfInsCompany(CompaniesCollection.
                GetEntityByID([IDInsuranceCompany]));
              if (ic = nil) then exit;
              blank := TBlankEntity(ic.Blanks.GetEntityByID([DogSer, DogNum]));
              if (blank = nil) then exit;
              t_node := trvLeft.Items.FindNodeWithData(blank);
              if (t_node <> nil) then t_node.Free;
              blank.DeleteSelf();
            end;
          DBUpdateDispatcher.Refresh();
        end;
      //FTargetContract.DB_Load(ltNew);
    end
  else if (Sender = sbtnContractProlong) then
    begin
      if (TContractEntity(Target).ContractProlong()) then
        begin
          ManagerState          := msEntityCreation;
          FEdSubstate           := esProlong;
          FPrevContract.Assign(FBackupContract);
          FBackupContract.Assign(Target);
          // Считается + год от текущей даты.
          dt_delta              := IncYear(Now()) - dtedStartDate.Date;
          dtedStartDate.Date    := dtedStartDate.Date + dt_delta;
          dtedEndDate.Date      := dtedEndDate.Date + dt_delta;
          dtedPeriodStart.Date  := dtedPeriodStart.Date + dt_delta;
          dtedPeriodEnd.Date    := dtedPeriodEnd.Date + dt_delta;
          if (cboxAddPeriod.Checked) then
            begin
              dtedAddPeriodStart.Date := dtedAddPeriodStart.Date + dt_delta;
              dtedAddPeriodEnd.Date   := dtedAddPeriodEnd.Date + dt_delta;
            end;
          if (cboxAddPeriod2.Checked) then
            begin
              dtedAddPeriod2Start.Date := dtedAddPeriod2Start.Date + dt_delta;
              dtedAddPeriod2End.Date   := dtedAddPeriod2End.Date + dt_delta;
            end;
          dtedSigningDate.Date  := dtedSigningDate.Date + dt_delta;
          dtedBeginDate.Date    := dtedBeginDate.Date + dt_delta;
          dtedTicketDate.Date   := dtedTicketDate.Date + dt_delta;
          edPolisSer.Text       := EmptyStr;
          edPolisNum.Text       := EmptyStr;
          SetRigthInsClass();
          SetControlsState(true);
          SetHeadText();
          MakeSpecialNotes();
        end
      else
        begin

        end;
    end
  else if (Sender = sbtnContractReplace) then
    begin
      if ((Target as TContractEntity).ContractReplace()) then
        begin
          ManagerState    := msEntityCreation;
          FEdSubstate     := esReplace;
          FPrevContract.Assign(FBackupContract);
          FBackupContract.Assign(Target);
          edPolisSer.Text := EmptyStr;
          edPolisNum.Text := EmptyStr;
          SetControlsState(true);
          SetHeadText();
          MakeSpecialNotes();
        end;
    end
  else if (Sender = sbtnContractClose) then
    begin
      if (not (Target as TContractEntity).ContractClose()) then
        begin
          SavingErrorMsg();
        end
      else
        begin
          MessageDlg(SysToUtf8(cls_info),
            SysToUtf8(contract_mgr_msg_cclosed), mtInformation, [mbOK], '');
        end;
    end
  else if (Sender = sbtnContractHistory) then
    begin
      try
        if (frmContractHistory = nil) then
          begin
            Debug('Creating frmContractHistory.');
            Application.CreateForm(TfrmContractHistory, frmContractHistory);
            frmContractHistory.OnGridClick := @HistoryGridsClick;
          end;
        with myContractOpersHistory do
          begin
            Close();
            if ((pgctlMain.ActivePage = ttsMain_Search) and
                (dmData.mySearchContract.Active)) then
              cnt_id :=
                dmData.mySearchContract.FieldByName('CNT_ID_DOGOVOR').AsString
            else
              cnt_id := VarToStr((Target as TContractEntity).IDContract);
            ParamByName('dog_id').AsString := cnt_id;
            Open();
          end;
        GetContractHistory(cnt_id);
        sbarMain.AutoHint := false;
        frmContractHistory.ShowModal();
        sbarMain.AutoHint := true;
      except
      end;
    end
  else if (Sender = sbtnContractRollBack) then
    begin
      if (DlgDataLoss()) then
        begin
          Target.Assign(FBackupContract);
          try
            ChangesBlocked := true;
            ListData();
          finally
            ChangesBlocked := false;
          end;
        end;
    end
  else if (Sender = sbtnClientManager) then
    begin
      sbarMain.AutoHint := false;
      frmClientManager.ShowManager(nil, msEntitySearch);
      sbarMain.AutoHint := true;
    end
  else if (Sender = sbtnCarManager) then
    begin
      sbarMain.AutoHint := false;
      frmCarManager.ShowManager(nil, msEntitySearch);
      sbarMain.AutoHint := true;
    end
  else if (Sender = sbtnUserManager) then
    begin
      // Чтобы показывал в StatusBar нужного окна, а не главного.
      sbarMain.AutoHint := false;
      if (frmUserManager = nil) then
        Application.CreateForm(TfrmUserManager, frmUserManager);
      frmUserManager.ShowModal();
      sbarMain.AutoHint := true;
    end
  else if (Sender = sbtnInfoManager) then
    begin
      if (frmInfoManager = nil) then
        Application.CreateForm(TfrmInfoManager, frmInfoManager);
      sbarMain.AutoHint := false;
      frmInfoManager.ShowModal();
      sbarMain.AutoHint := true;
    end;
  end; // with
end;
//---------------------------------------------------------------------------
function TfrmMain.AddCompanyToTreeAndList(const ins_company: TInfInsCompany):
  TTreeNode;
begin
  // Список.
  cbInsCompany.Items.AddObject(VarToStr(ins_company.InsCompanyName),
    ins_company);
  // Дерево.
  Result := trvLeft.Items.AddChildObject(trvLeft.Items.Item[0],
    VarToStr(ins_company.InsCompanyName), ins_company);
  if (Result <> nil) then
    with (Result) do
      begin
        ImageIndex     := 2;
        SelectedIndex  := 3;
      end;
end;
//---------------------------------------------------------------------------
function TfrmMain.AddBlankToTree(const parent_node: TTreeNode;
  const blank: TBlankEntity; const first: boolean): TTreeNode;
begin
  if (first) then
    Result := trvLeft.Items.AddChildObjectFirst(parent_node,
      blank.BlankFullNum, blank)
  else
    Result := trvLeft.Items.AddChildObject(parent_node,
      blank.BlankFullNum, blank);
  if (Result <> nil) then
    with Result do
      begin
        if (blank.Reserved) then ImageIndex := 6
        else ImageIndex := 4;
        SelectedIndex := 5;
      end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.MakeCompaniesLists();
var tp: TTreeNode;
    cn: TInfInsCompany;
    i: integer;
begin
  try
    CompaniesCollection.BeginUpdate();
    CompaniesCollection.Clear();
    trvLeft.Items.BeginUpdate();
    cbInsCompany.Items.Clear();
    cbInsCompany.Items.BeginUpdate();
    trvLeft.Items.Item[0].ImageIndex     := 0;
    trvLeft.Items.Item[0].SelectedIndex  := 1;
    // dmData.SetContractsMode(cmAll);
    with dmData.myInsCompanies, trvLeft.Items do
    begin
      Open();
      First();
      while (not EOF)
        do
          begin
            cn := CompaniesCollection.Add() as TInfInsCompany;
            if (cn = nil) then exit;
            cn.DataSource := dmData.datasrcIns_company;
            if (not cn.DB_Load(ltNew)) then exit;
            tp := AddCompanyToTreeAndList(cn);
            with (cn.Blanks) do
              for i := 0 to Count - 1 do
                AddBlankToTree(tp, Items[i] as TBlankEntity, false);
            Next();
          end; // while ins_companyes not EOF
    end; // with dmData.zqInsCompanies, trvLeft.Items
    trvLeft.Items[0].Selected := true;
    cbInsCompany.ItemIndex    := 0;
  finally
    cbInsCompany.Items.EndUpdate();
    trvLeft.Items.EndUpdate();
    CompaniesCollection.EndUpdate();
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.ClearCompaniesLists();
var i_name: string;
begin
  // Список.
  cbInsCompany.Clear();
  // Дерево.
  if (trvLeft.Items.Count <= 0) then exit;
  i_name := trvLeft.Items[0].Text;
  trvLeft.Items.Clear;
  trvLeft.Items.Add(nil, i_name);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.trvLeftChange(Sender: TObject; Node: TTreeNode);
begin
  SetCompanyFromTree(Node);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.trvLeftDblClick(Sender: TObject);
begin
  if (ManagerState in [msEntityCreation, msEntityEdit]) then
    begin
//      if (TEntity(Node.Data) is TBlankEntity) then
        begin

        end;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.trvLeftDeletion(Sender: TObject; Node: TTreeNode);
begin

end;
//---------------------------------------------------------------------------
{procedure TfrmMain.SetPHIndex(const value: variant);
var i: integer;
begin
  with cbPolicyholder do
    begin
      for i := 0 to Items.Count - 1 do
        begin
          if (cbPolicyholder.Items.Objects[i] = nil) then continue;
          if ((cbPolicyholder.Items.Objects[i] as TClientEntity).IDClient =
            value) then
              begin
                ItemIndex := i;
                exit;
              end;
        end;
      ItemIndex := -1;
    end;
end;
//---------------------------------------------------------------------------
function TfrmMain.GetPHIndex(p_holder: TClientEntity): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to cbPolicyholder.Items.Count - 1 do
    if ((cbPolicyholder.Items.Objects[i] as TClientEntity).
      CheckID([p_holder.IDClient])) then
        begin
          Result := i;
          break;
        end;
end;}
//---------------------------------------------------------------------------
procedure TfrmMain.strGridDriversColRowDeleted(Sender: TObject;
  IsColumn: Boolean; sIndex, tIndex: Integer);
var eflag: boolean;
begin
  eflag := (ManagerState in [msEntityCreation]) or
    ((ManagerState in [msEntityEdit, msEntityView]) and
      CurrentUser.UserGroup.Privileges[Priv_cont_chg]);
  if (IsColumn) then exit;
  if (sbtnDriverDel.Enabled) then
    sbtnDriverDel.Enabled := (strGridDrivers.RowCount > 1) and eflag;
  if (sbtnDriverEdit.Enabled) then
    sbtnDriverEdit.Enabled := (strGridDrivers.RowCount > 1) and eflag;
  // Макс. - 5 водителей.
  // Неограниченно.
  // sbtnDriverAdd.Enabled := (strGridDrivers.RowCount <= 6) and eflag;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.strGridDriversColRowInserted(Sender: TObject;
  IsColumn: Boolean; sIndex, tIndex: Integer);
var eflag: boolean;
begin
  eflag := (ManagerState in [msEntityCreation]) or
    ((ManagerState in [msEntityEdit, msEntityView]) and
      CurrentUser.UserGroup.Privileges[Priv_cont_chg]);
  if (not sbtnDriverDel.Enabled) then
    sbtnDriverDel.Enabled := (strGridDrivers.RowCount > 1) and eflag;
  if (not sbtnDriverEdit.Enabled) then
    sbtnDriverEdit.Enabled := (strGridDrivers.RowCount > 1) and eflag;
  if (sbtnDriverEdit.Enabled) then
    sbtnDriverAdd.Enabled := (strGridDrivers.RowCount <= 6) and eflag;
end;
//---------------------------------------------------------------------------
function TfrmMain.ClientInDriversIndex(const cln: TClientEntity): integer;
// Состояние grid соответствует состоянию коллекции водителей.
var i: integer;
    de: TDriverEntity;
begin
  Result := -1;
  for i := 0 to (Target as TContractEntity).Drivers.Count - 1 do
    begin
      de := (Target as TContractEntity).Drivers[i] as TDriverEntity;
      if (de.Client.CheckID([cln.IDClient])) then
        begin
          Result := i;
          exit;
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.sbtnDriversClick(Sender: TObject);
  procedure DeleteRowRange();
  // Удаляет диапазон строк в strGridDrivers.
  var lst: TList;
      i: integer;
  begin
    lst := TList.Create;
    try
      with strGridDrivers do
        begin
          for i := Selection.Top to Selection.Bottom do
            lst.Add(Objects[0, i]);
          // Да, вот такой изврат. Множественное удаление в TStringGrid не
          // реализовано. По-другому, не работает. Строю список объектов.
          // Затем, ищу удаляемые строки, по объектам в списке.
          while (lst.Count > 0) do
            for i := 1 to RowCount - 1 do
              if (lst[lst.Count - 1] = Pointer(Objects[0, i])) then
                begin
                  if (Objects[0, i] <> nil) then
                    (Objects[0, i] as TDriverEntity).DeleteSelf();
                  DeleteColRow(false, i);
                  lst.Delete(lst.Count - 1);
                  break;
                end;
        end;
    finally
      lst.Free;
    end;
  end;

var lr: integer;
    drv: TDriverEntity;
    cln: TClientEntity;

begin

  with strGridDrivers do
  if (Sender = sbtnDriverAdd) then
    begin
      sbarMain.AutoHint := false;
      // Перед добавлением, проверяю нет ли уже такого клиента среди водителей.
      cln := frmClientManager.ShowManager(
        (Target as TContractEntity).PolicyHolder, msEntitySearch
      ) as TClientEntity;
      sbarMain.AutoHint := true;
      if ((frmClientManager.ModalResult <> mrOK) or (cln = nil)) then exit;
      lr := ClientInDriversIndex(cln);
      if (lr >= 0) then
      // Обновляю.
        begin
          drv := (Target as TContractEntity).Drivers[lr] as TDriverEntity;
          if (drv = nil) then exit;
          drv.Client := cln;
          Clean(0, lr, ColCount, lr, [gzNormal, gzInvalid]);
          AddDriverToGrid(lr, drv);
        end
      else
      // Добавляю.
        begin
          drv := (Target as TContractEntity).DriverAdd();
          if (drv = nil) then exit;
          drv.Client := cln;
          RowCount := RowCount + 1;
          AddDriverToGrid(RowCount - 1, drv);
        end;
      // SetClientInList(cln, false);
      ListClientParams();
      DataWasChanged(Sender);
    end
  else if (Sender = sbtnDriverDel) then
    begin
      // Один ряд фиксирован.
      if ((Row > 0) and (Row < RowCount)) then
        begin
          BeginUpdate();
          try
            DeleteRowRange();
            DataWasChanged(Sender);
          finally
            EndUpdate();
          end;
        end;
    end
  else // if (Sender = sbtnDriverEdit) then
    begin
      if ((Row > 0) and (Row < RowCount)) then
        begin
          drv := (strGridDrivers.Objects[0, Row] as TDriverEntity);
          if (drv = nil) then exit;
          sbarMain.AutoHint := false;
          cln := frmClientManager.ShowManager(drv.Client, msEntityView)
            as TClientEntity;
          sbarMain.AutoHint := true;
          if (cln = nil) then exit;
          if (frmClientManager.ModalResult <> mrOK) then exit;
          drv.Client := cln;
          lr := Row;
          strGridDrivers.BeginUpdate();
          try
            Clean(0, lr, ColCount, lr, [gzNormal, gzInvalid]);
            AddDriverToGrid(lr, drv);
            Row := lr;
          finally
            strGridDrivers.EndUpdate();
            DataWasChanged(Sender);
          end;
        end; // if ((Row > 0) and (Row < RowCount))
    end;
  // Устанавливаю класс договора.
  SetRigthInsClass();
end;
//---------------------------------------------------------------------------
procedure TfrmMain.strGridDriversDblClick(Sender: TObject);
begin
  sbtnDriverEdit.Click();
end;
//---------------------------------------------------------------------------
procedure TfrmMain.strGridDriversKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((Shift = [ssAlt]) or (Shift = [ssCtrl])) then exit;
  if ((Key = VK_DELETE) and (sbtnDriverDel.Enabled)) then
    sbtnDriverDel.Click()
  else
  if ((Key = VK_INSERT) and (sbtnDriverAdd.Enabled)) then
    sbtnDriverAdd.Click()
  else
  if ((Key = VK_RETURN) and (sbtnDriverEdit.Enabled)) then
    sbtnDriverEdit.Click();
end;
//---------------------------------------------------------------------------
procedure TfrmMain.mnDriversItemsClick(Sender: TObject);
begin
  if (Sender = mnDrivers_Add) then
    begin
      sbtnDriverAdd.Click();
    end
  else if (Sender = mnDrivers_Del) then
    begin
      sbtnDriverDel.Click();
    end
  else if (Sender = mnDrivers_Chg) then
    begin
      sbtnDriverEdit.Click();
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.mnPopupDriversPopup(Sender: TObject);
begin
  mnDrivers_Add.Enabled := sbtnDriverAdd.Enabled;
  mnDrivers_Del.Enabled := sbtnDriverDel.Enabled;
  mnDrivers_Chg.Enabled := sbtnDriverEdit.Enabled;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.mnPopup_RemindButtonItemsClick(Sender: TObject);
var l_pay: boolean;
begin
  l_pay := Sender = mnRemindButton_RPerm;
  with dbgridReminder do
    begin
      if (SelectedIndex < 0) then exit;
      with DataSource.DataSet do
        dmData.RemindClient(
          FieldByName('CLN_ID_CLIENT').AsVariant,
          FieldByName('CNT_ID_DOGOVOR').AsVariant,
          l_pay
        );
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.mnReminderItemsClick(Sender: TObject);
begin
  if (Sender = mnReminder_Remind) then
    begin
      sbtnRemind.Click();
    end
  else if (Sender = mnReminder_Open) then
    begin
      dbgridReminder.OnDblClick(dbgridReminder);
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.mnPopupReminderPopup(Sender: TObject);
begin
  with dbgridReminder do
    begin
      mnReminder_Open.Enabled   := SelectedIndex >= 0;
      mnReminder_Remind.Enabled := SelectedIndex >= 0;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.dbgridReminderDblClick(Sender: TObject);
begin
  try
    SearchDS := dbgridReminder.DataSource;
    ShowSearchResults();
  finally
    SearchDS := dmData.datasrcSearchContract;
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.sbtnPrnClick(Sender: TObject);
var company: TInfInsCompany;
begin
  LoadDataInEntity();
  case rgPrint.ItemIndex of
    // Заявление.
    0: dmReports.PrintReceiptBlank();
    // Полис.
    1: dmReports.PrintPolisBlank();
    // Квитанция.
    2: begin
        company := TInfInsCompany(CompaniesCollection.GetEntityByID(
          [TContractEntity(Target).IDInsuranceCompany]
        ));
        if ((company = nil) or (company.TicketBody.GetSize = 0)) then
          begin
            Info('frmMain.sbtnPrnClick: No ticket blank for printing');
            exit;
          end;
        dmReports.PrintTicketBlank(company.TicketBody);
      end;
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.sbtnsStatementClick(Sender: TObject);
var ent: TEntity;
    ms: TManagerState;
begin
  if (Sender = sbtnCar) then
  // Выбор страхуемого ТС, через менеджер ТС.
    begin
      with TContractEntity(Target) do
        begin
          if ((ManagerState = msEntityCreation) and
              ((Car.IDCar = Null) or (Car.IDCar = EmptyStr)))
            then ms := msEntitySearch
            else ms := msEntityView;

          sbarMain.AutoHint := false;
          ent := frmCarManager.ShowManager(Car, ms);
          sbarMain.AutoHint := true;
          // Лишняя проверка, всё равно, не помешает.
          if (ent = nil) then exit;
          if (frmCarManager.ModalResult = mrOK) then
            begin
              Car := ent as TCarEntity;
              ListCarParams();
              SetRigthInsClass();
              DataWasChanged(Sender);
            end;
        end;
    end
  else if (Sender = sbtnPolicyHolder) then
  // Страхователь.
    begin
{      with cbPolicyholder do
        if ((Items.Count > 0) and (ItemIndex >= 0) and
          (Items.Objects[ItemIndex] <> nil)) then
            ent := TEntity(Items.Objects[ItemIndex])
        else}
      ent := TContractEntity(Target).PolicyHolder;
      with TContractEntity(Target) do
        begin
          if ((ManagerState = msEntityCreation) and
              ((PolicyHolder.IDClient = Null) or
               (PolicyHolder.IDClient = EmptyStr)))
            then ms := msEntitySearch
            else ms := msEntityView;
          sbarMain.AutoHint := false;
          ent := frmClientManager.ShowManager(ent, ms);
          sbarMain.AutoHint := true;
          if (ent = nil) then exit;
          if (frmClientManager.ModalResult = mrOK) then
            begin
              PolicyHolder := ent as TClientEntity;
              //SetClientInList(PolicyHolder);
              ListClientParams();
              DataWasChanged(Sender);
            end;
        end;
    end
  else if (Sender = sbtnPolisSelect) then
  // Пустой бланк полиса.
    begin
      with (cbInsCompany) do
        begin
          if (Items.Objects[ItemIndex] = nil) then exit;
          (Target as TContractEntity).IDInsuranceCompany :=
            (Items.Objects[ItemIndex] as TInfInsCompany).IDInsCompany;
          frmBlankContracts.InsCompany :=
            Items.Objects[ItemIndex] as TInfInsCompany;
        end;

      if (frmBlankContracts.ShowModal() = mrOK) then
        begin
          if (frmBlankContracts.Blank = nil) then exit;
          DoReserveBlank(frmBlankContracts.Blank);
        end; // if (mrOk)
    end // if (Sender = sbtnPolisSelect)
  else if (Sender = sbtnSetInsClass) then
    begin
      SetRigthInsClass();
      DataWasChanged(Sender);
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.sbtnFindClick(Sender: TObject);
begin
  if (Sender = sbtnSearch) then
    begin
      ShowWaiter();
      dmData.FindContract(edSSurname.Text, edSName.Text, edSPathronimyc.Text,
        edSLicenceSer.Text, edSLicenceNum.Text,
        GetCBoxStr(cbSClientTypeGroup, cbSClientTypeGroup.ItemIndex),
        edSDocSer.Text, edSDocNum.Text,
        VarToStr((cbSDocType.Items.Objects[cbSDocType.ItemIndex] as
          TStringObject).StringValue),
        edSVIN.Text, edSChassiNum.Text, edSKusovNum.Text, edSRegNum.Text,
        edSPolisSer.Text, edSPolisNum.Text, rgSearchType.ItemIndex = 1
      );
      HideWaiter();
    end
  else
    begin
      ClearEdits(ttsMain_Search);
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.edSearchKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = #13) then
    begin
      Key := #0;
      sbtnSearch.Click();
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.cbSClientTypeGroupChange(Sender: TObject);
begin
  with (cbSClientTypeGroup) do
  ListClientTypeGroup(StrToInt(GetCBoxStr(cbSClientTypeGroup, ItemIndex)),
    labelSSurname, labelSName, labelSPathronimyc, edSPathronimyc);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.dbgridSearchDblClick(Sender: TObject);
begin
  if (dbgridSearch.SelectedIndex < 0) then exit;
  ShowSearchResults();
end;
//---------------------------------------------------------------------------
procedure TfrmMain.edNumberKeyPress(Sender: TObject; var Key: char);
begin
  CheckDigitalInput(Sender, Key);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.cboxAddPeriodChange(Sender: TObject);
begin
  if (Sender = cboxAddPeriod) then
    begin
      dtedAddPeriodStart.Enabled  := cboxAddPeriod.Checked;
      dtedAddPeriodEnd.Enabled    := cboxAddPeriod.Checked;
      labelAddPeriodDelim.Enabled := cboxAddPeriod.Checked;
    end
  else if (Sender = cboxAddPeriod2) then
    begin
      dtedAddPeriod2Start.Enabled  := cboxAddPeriod2.Checked;
      dtedAddPeriod2End.Enabled    := cboxAddPeriod2.Checked;
      labelAddPeriod2Delim.Enabled := cboxAddPeriod2.Checked;
    end;
  if (ManagerState = msEntityCreation) then MakeSpecialNotes();
  DataWasChanged(Sender);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.dtedPeriodsUseChange(Sender: TObject);
begin
  //if (ManagerState = msEntityCreation) then MakeSpecialNotes();
  DataWasChanged(Sender);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.cboxUnlimDrvsChange(Sender: TObject);
var eflag: boolean;
begin
  eflag := (ManagerState in [msEntityCreation]) or
    ((ManagerState in [msEntityEdit, msEntityView]) and
      CurrentUser.UserGroup.Privileges[Priv_cont_chg]);
  sbtnDriverEdit.Enabled      := (not cboxUnlimDrvs.Checked) and
    (strGridDrivers.RowCount > 1) and eflag;
  sbtnDriverDel.Enabled       := not cboxUnlimDrvs.Checked and
    (strGridDrivers.RowCount > 1) and eflag;
  sbtnDriverAdd.Enabled       := not cboxUnlimDrvs.Checked and eflag;
  if (not ChangesBlocked) then SetRigthInsClass();
  //DataWasChanged(Sender);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.cbClientChange(Sender: TObject);
begin
{  if (Sender = cbPolicyholder) then ListClientParams();
  DataWasChanged(Sender);}
end;
//---------------------------------------------------------------------------
procedure TfrmMain.CreateICNotifier();
var b: TBevel;
begin
  with pnotifierTree do
    begin
      b             := TBevel.Create(vNotifierForm);
      b.Parent      := vNotifierForm;
      b.Style       := bsRaised;
      b.Shape       := bsFrame;
      b.Align       := alClient;
      vNotifierForm.OnDeactivate := @NotifierDeactivated;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.NotifierDeactivated(Sender: TObject);
begin
  pnotifierTree.Hide();
end;
//---------------------------------------------------------------------------
procedure TfrmMain.SetCompanyFromTree(const Node: TTreeNode);
begin
  if (Node = nil) then exit;
  if (ManagerState in [msEntityCreation, msEntityEdit]) then
    begin
      if ((TEntity(Node.Data) is TInfInsCompany){ and
          (pgctlMain.ActivePage = ttsMain_Statement)}) then
        begin
          cbInsCompany.ItemIndex :=
            cbInsCompany.Items.IndexOfObject(TObject(Node.Data));
        end
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.HistoryGridsClick(ds: TDataSource);
begin
  try
    SearchDS := ds;
    if (ShowSearchResults()) then frmContractHistory.Close();
  finally
    SearchDS := dbgridSearch.DataSource;
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.SetControlsState(cenabled: boolean);
var eflag: boolean;
begin
  with CurrentUser.UserGroup do
    begin
      eflag := ((ManagerState in [msEntityView, msEntityEdit]) and
        Privileges[Priv_cont_chg]);
      eflag := eflag or (ManagerState = msEntityCreation);
      eflag := eflag and cenabled;
      SwitchControls(ttsMain_Statement, eflag);
      SwitchControls(ttsMain_AddInfo, eflag);
      sbtnContractAdd.Enabled       := Privileges[Priv_cont_add];
      sbtnContractProlong.Enabled   := Privileges[Priv_cont_prolong] and
        (ManagerState in [msEntityView, msEntityEdit]) and
        (YearsBetween(Now, TContractEntity(Target).DateStart) <= 1);
      sbtnContractClose.Enabled     := Privileges[Priv_cont_close] and
        (ManagerState in [msEntityView, msEntityEdit]);
      sbtnContractReplace.Enabled   := Privileges[Priv_cont_replace] and
        (ManagerState in [msEntityView, msEntityEdit]);
      sbtnContractSave.Enabled      :=
        (ManagerState in [msEntityCreation, msEntityEdit]);
      sbtnContractRollBack.Enabled  :=
        ManagerState in [msEntityEdit];
      sbtnRemind.Enabled            := Privileges[Priv_cont_chg] or
        Privileges[Priv_cont_add];
      sbtnUserManager.Visible       := Privileges[Priv_user_add] or
        Privileges[Priv_user_chg] or Privileges[Priv_user_del];
      sbtnInfoManager.Visible       := Privileges[Priv_infos_edit];

      eflag := ManagerState in [msEntityView, msEntityEdit, msEntityCreation];
      rgPrint.Enabled               := eflag;
      sbtnPrint.Enabled             := eflag;
      edPolisSer.Enabled            := false;
      edPolisNum.Enabled            := false;
      labelPolisSer.Enabled         := false;
      labelPolisNum.Enabled         := false;
      edSpecialSignSer.Enabled      := false;
      edSpecialSignNum.Enabled      := false;
      labelSSCaption.Enabled        := false;
      LabelSSSer.Enabled            := false;
      LabelSSNum.Enabled            := false;
      edAgentName.Enabled           := false;
      labelAgent.Enabled            := false;
      dtedAddPeriodStart.Enabled    := eflag and cboxAddPeriod.Checked;
      dtedAddPeriodEnd.Enabled      := eflag and cboxAddPeriod.Checked;
      dtedAddPeriod2Start.Enabled   := eflag and cboxAddPeriod2.Checked;
      dtedAddPeriod2End.Enabled     := eflag and cboxAddPeriod2.Checked;
      dtedStartDate.Enabled         := eflag and
        (not (FEdSubstate in [esProlong, esReplace]));
      dtedEndDate.Enabled           := eflag and
        (not (FEdSubstate in [esProlong, esReplace]));
      strGridDrivers.Enabled        := eflag;
      gbDrivers.Enabled             := eflag;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.ListData();
  function AddPeriodUsed(const period_n: byte): boolean;
    begin
      with (Target as TContractEntity) do
        case period_n of
          1: begin
            result := not ((VarToStrDef(StartUse1, EmptyStr) = EmptyStr) or
              (VarToStrDef(EndUse1, EmptyStr) = EmptyStr));
          end;
          2: begin
            result := not ((VarToStrDef(StartUse2, EmptyStr) = EmptyStr) or
              (VarToStrDef(EndUse2, EmptyStr) = EmptyStr));
          end;
        end;
    end;

var i: integer;
begin
//  Target.DB_Load(ltNew);
  if (ManagerState <> msEntityCreation) then FillClientsLists();
  ListCarParams();
  ListDrivers();
  ListContractCoefs();
  ListAgent();
  with (Target as TContractEntity) do
    begin
      //SetPHIndex(PolicyHolder.IDClient);
      ListClientParams();
      with cbInsCompany do
      for i := 0 to Items.Count - 1 do
        if ((Items.Objects[i] as TInfInsCompany).IDInsCompany =
          IDInsuranceCompany) then
            begin
              ItemIndex := i;
              break;
            end;

      SetIndexFromObject(cbBonusMalus, VarToStr(IDInsuranceClass));

      edPolisSer.Text           := VarToStr(DogSer);
      edPolisNum.Text           := VarToStr(DogNum);
      edTicketSer.Text          := VarToStr(TicketSer);
      edTicketNum.Text          := VarToStr(TicketNum);
      edSpecialSignSer.Text     := VarToStr(ZnakSer);
      edSpecialSignNum.Text     := VarToStr(ZnakNum);
      edInsSum.Text             := VarToStr(InsSum);
      calcedAward.Text          := VarToStr(InsPrem);

      if (DateStart <> Null) then
        begin
          zvdtpStartTime.Time := TimeOf(VarToDateTime(DateStart));
          dtedStartDate.Date  := DateOf(VarToDateTime(DateStart));
        end
      else
        begin
          zvdtpStartTime.Time := 0;
          dtedStartDate.Text  := EmptyStr;
        end;
      dtedEndDate.Text          := VarToStr(DateEnd);
      dtedPeriodStart.Text      := VarToStr(StartUse);
      dtedPeriodEnd.Text        := VarToStr(EndUse);
      dtedAddPeriodStart.Text   := VarToStr(StartUse1);
      dtedAddPeriodEnd.Text     := VarToStr(EndUse1);
      dtedAddPeriod2Start.Text  := VarToStr(StartUse2);
      dtedAddPeriod2End.Text    := VarToStr(EndUse2);
      dtedSigningDate.Text      := VarToStr(DateWrite);
      dtedBeginDate.Text        := VarToStr(DateBegin);
      dtedTicketDate.Text       := VarToStr(TicketDate);
      memoSpecialNotes.Text     := VarToStr(Comments.Text);
      cboxTransit.Checked       := VarToBool(Transit);
      cboxAddPeriod.Checked     := AddPeriodUsed(1);
      cboxAddPeriod2.Checked    := AddPeriodUsed(2);
      cboxUnlimDrvs.Checked     := VarToBool(UnlimitedDrivers);
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.ListCarParams();
begin
  with ((Target as TContractEntity).Car) do
    begin
      labelVIN.Caption      := VarToStr(VIN);
      labelGosNum.Caption   := VarToStr(GosNum);
      labelPTSSer.Caption   := VarToStr(PtsSer);
      labelPTSNum.Caption   := VarToStr(PtsNum);
      labelKusov.Caption    := VarToStr(KusovNum);
      labelShassi.Caption   := VarToStr(ShassiNum);
      labelCarMark.Caption  := VarToStr(CarMarkName) + ' ' +
        VarToStr(CarModel);
      labelCarType.Caption  := VarToStr(CarTypeName);
      with (CarOwner) do
      // Параметры владельца ТС.
        begin
          labelOwnerData.Caption      := VarToStr(FullName);
          labelOwnerPassport.Caption  := VarToStr(FullDoc);
          labelOwnerINN.Caption       := VarToStr(INN);
          labelOwnerAddress.Caption   := VarToStr(FullAddress);
        end;
    end;
end;
//---------------------------------------------------------------------------
{procedure TfrmMain.SetClientInList(const cln: TClientEntity;
  const add: boolean);
var cl_index: integer;
    cen: TClientEntity;
begin
  with (Target as TContractEntity) do
    begin
      cl_index := GetPHIndex(cln);
      if (cl_index < 0) then
      // Такого клиента нет. Добавляю.
        begin
          if (not add) then exit;
          cen := ClientsCollection.Add() as TClientEntity;
          if (cen <> nil) then
            begin
              cen.Assign(PolicyHolder);
              cbPolicyholder.Items.AddObject(cen.FullName, cen);
              cbPolicyholder.ItemIndex := cbPolicyholder.Items.Count - 1;
            end;
        end
          else
          // Очень вероятно, что ФИО клиента было исправлено.
            begin
              // Надо перезаполнять или мудрить. Перезаполняю.
              cbPolicyholder.Items[cl_index]  := PolicyHolder.FullName;
              cbPolicyholder.ItemIndex        := cl_index;
              cen := (cbPolicyholder.Items.Objects[cl_index] as TClientEntity);
              cen.Assign(PolicyHolder);
            end;
    end; // with
end;}
//---------------------------------------------------------------------------
procedure TfrmMain.ListClientParams();
//var cen: TClientEntity;
begin
{  with (cbPolicyholder) do
    begin
      if ((ItemIndex < 0) or (Items.Objects[ItemIndex] = nil)) then exit;
      cen :=  Items.Objects[ItemIndex] as TClientEntity;
    end;}

  with (Target as TContractEntity).PolicyHolder do
    begin
      sbtnPolicyholder.Caption := VarToStr(FullName);
      labelPhPassport.Caption  := VarToStr(FullDoc);
      labelPhAddress.Caption   := VarToStr(FullAddress);
      labelPhINN.Caption       := VarToStr(INN);
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.AddDriverToGrid(const row_num: integer;
  const de: TDriverEntity);
// Процедура заполняет ряд и добавляет объект. Очистки не производится.
begin
  if (de = nil) then exit;
  with strGridDrivers do
    begin
      Rows[row_num].AddObject(VarToStr(de.Client.FullName), de);
      Cells[1, row_num] := VarToStr(de.Client.FullAddress);
      Cells[2, row_num] := VarToStr(de.Client.FullDoc);
      Cells[3, row_num] := VarToStr(de.Client.InsuranceClass);
      Cells[4, row_num] := VarToStr(de.Client.StartDrivingDate);
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.UpdateDrivers(const de: TDriverEntity);
var i: integer;
begin
  if (de = nil) then exit;
  i := strGridDrivers.Cols[0].IndexOfObject(de);
  // Один ряд фиксирован.
  with strGridDrivers do
  if (i > 0) then
    begin
      BeginUpdate();
      try
        Clean(0, i, ColCount, i, [gzNormal, gzInvalid]);
        AddDriverToGrid(i, de);
      finally
        strGridDrivers.EndUpdate();
      end;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.ListDrivers();
var i: integer;
begin
  try
    strGridDrivers.BeginUpdate();
    with strGridDrivers, (Target as TContractEntity) do
      begin
        // Один ряд - заголовок
        Clean(0, 1, ColCount, RowCount, [gzNormal, gzInvalid]);
        RowCount := Drivers.Count + 1;
        for i := 0 to Drivers.Count - 1
          do
            begin
              AddDriverToGrid(i + 1, Drivers[i] as TDriverEntity);
            end;
      end;
  finally
    strGridDrivers.EndUpdate();
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.ListContractCoefs();
begin
  with (FBackupContract) do
    begin
      edInsAwdBS.Text     := VarToStr(BaseSum);
      edInsAwdKT.Text     := VarToStr(CoefTer);
      edInsAwdKBM.Text    := VarToStr(CoefBonusMalus);
      edInsAwdKO.Text     := VarToStr(CoefUnlim);
      edInsAwdKVS.Text    := VarToStr(CoefStage);
      edInsAwdKM.Text     := VarToStr(CoefPower);
      edInsAwdKS.Text     := VarToStr(CoefPeriodUse);
      edInsAwdKP.Text     := VarToStr(CoefSrokIns);
      edInsAwdKN.Text     := VarToStr(CoefKN);
      stxtFormula.Caption := EmptyStr;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.ListActualCoefs();
var bs, kt, kbm, kvs, ko, km, ks, kp, kn: double;
begin
  GetActualCoefs(Target as TContractEntity,
    bs, kt, kbm, kvs, ko, km, ks, kp, kn);
  edInsAwdBS.Text   := FloatToStr(bs);
  edInsAwdKT.Text   := FloatToStr(kt);
  edInsAwdKBM.Text  := FloatToStr(kbm);
  edInsAwdKVS.Text  := FloatToStr(kvs);
  edInsAwdKO.Text   := FloatToStr(ko);
  edInsAwdKM.Text   := FloatToStr(km);
  edInsAwdKS.Text   := FloatToStr(ks);
  edInsAwdKP.Text   := FloatToStr(kp);
  edInsAwdKN.Text   := FloatToStr(kn);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.ListAgent();
begin
  if (ManagerState = msEntityCreation) then
    edAgentName.Text := dmData.GetCurUserFullName()
  else
    edAgentName.Text := VarToStr((Target as TContractEntity).UserInsertName);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.FillClientsLists();
{  function TestClnID(const id_client: variant): boolean;
  // True, если в cbPolicyholder уже сущность с заданным ID.
  var i: integer;
  begin
    Result := false;
    for i := 0 to cbPolicyholder.Items.Count - 1 do
      if ((cbPolicyholder.Items.Objects[i] <> nil) and
          (cbPolicyholder.Items.Objects[i] as TClientEntity).CheckID(id_client))
        then
        begin
          Result := true;
          break;
        end;
  end;

var ce: TClientEntity;
    cln_id: string;}
begin
{  cbPolicyholder.Items.BeginUpdate();
  try
  while (cbPolicyholder.Items.Count > 0) do
    with (cbPolicyholder.Items) do
      begin
        // Очистка. Я разрушаю только элементы коллекции ClientsCollection.
        if ((Objects[Count - 1] <> nil) and
          ClientsCollection.EntityExists(Objects[Count - 1] as TClientEntity))
          then
          begin
            (Objects[Count - 1] as TClientEntity).DeleteSelf();
          end;
        Objects[Count - 1] := nil;
        Delete(Count - 1);
      end;

  // Добавляю страхователя.
  ce := ClientsCollection.Add() as TClientEntity;
  if (ce <> nil) then
    begin
      // В списке все элементы управляются коллекцией. Поэтому он независим от
      // внутреннего состояния договора. Исключаются ошибки, при замене клиента.
      ce.Assign((Target as TContractEntity).PolicyHolder);
      cbPolicyholder.AddItem(VarToStr(ce.FullName), ce);
    end;

  cln_id := VartoStr((Target as TContractEntity).PolicyHolder.IDClient);

  if (cln_id = EmptyStr) then exit;

  with (dmData.GetMatchedClients(cln_id).DataSet) do
    begin
      First();
      while (not EOF) do
        begin
          if (not TestClnID(FieldByName('CLN_ID_CLIENT').AsVariant)) then
          // Добавляю только, если такой сущности ещё не добавлено.
            begin
              ce := ClientsCollection.Add() as TClientEntity;
              if (ce = nil) then exit;
              with (ce) do
                begin
                  DataSource := dmData.datasrcMatchedClns;
                  DB_Load(ltNew);
                  cbPolicyholder.AddItem(VarToStr(FullName), ce);
                end;
            end; // if (EntityExists)
          Next();
        end; // while (not EOF)
    end; // with (dmData.GetMatchedClients.DataSet)
  finally
    cbPolicyholder.Items.EndUpdate();
  end;}
end;
//---------------------------------------------------------------------------
procedure TfrmMain.SetRigthInsClass();
var ins_class: variant;
begin
  LoadDataInEntity();
  if (FEdSubstate = esProlong) then
    begin
      // При пролонгации, класс увеличивается.
      ins_class := FPrevContract.IDInsuranceClass + 1
    end
  else GetInsClass(TContractEntity(Target), ins_class);

  with dmCoefs.myGetInsCoef_KBM do
    if (ins_class >= RecordCount) then ins_class := RecordCount - 1;

  SetIndexFromObject(cbBonusMalus, VarToStr(ins_class));
end;
//---------------------------------------------------------------------------
procedure TfrmMain.CheckInsClass();
begin
  raise Exception.Create(SysToUTF8(contract_mgr_msg_kbm_err));
end;
//---------------------------------------------------------------------------
procedure TfrmMain.MakeSpecialNotes();
begin
  memoSpecialNotes.Clear;
  {memoSpecialNotes.Text := SysToUtf8(cls_periods + ': ') +
    dtedPeriodStart.Text + ' - ' + dtedPeriodEnd.Text;
  if (cboxAddPeriod.Checked) then
    memoSpecialNotes.Text := memoSpecialNotes.Text + ', ' +
      dtedAddPeriodStart.Text + ' - ' + dtedAddPeriodEnd.Text;
  if (cboxAddPeriod2.Checked) then
    memoSpecialNotes.Text := memoSpecialNotes.Text + ', ' +
      dtedAddPeriod2Start.Text + ' - ' + dtedAddPeriod2End.Text;}
  if (FEdSubstate <> esNone) then memoSpecialNotes.Text :=
    SysToUTF8(contract_mgr_prev_prem) + VarToStr(FPrevContract.InsPrem);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.DoReserveBlank(const blank: TBlankEntity);
var i: integer;
begin
  with blank do
    begin
      if (not BlankReserve()) then
        raise Exception.Create(SysToUTF8(contract_mgr_msg_bl_sel_err));
      edPolisSer.Text                     := VarToStr(DogSer);
      edPolisNum.Text                     := VarToStr(DogNum);
      with cbInsCompany do
      for i := 0 to Items.Count - 1 do
        if ((Items.Objects[i] as TInfInsCompany).IDInsCompany =
          InsuranceCompany.IDInsCompany) then
            begin
              ItemIndex := i;
              break;
            end;
      (Target as TContractEntity).DogSer  := edPolisSer.Text;
      (Target as TContractEntity).DogNum  := edPolisNum.Text;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.LoadDataInEntity();
var dttm: TDateTime;
begin
//  ListAgent();
  with (Target as TContractEntity) do
    begin
{      with cbPolicyholder do
        if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
          PolicyHolder := Items.Objects[ItemIndex] as TClientEntity;}

      with cbInsCompany do
        if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
          IDInsuranceCompany :=
            (Items.Objects[ItemIndex] as TInfInsCompany).IDInsCompany;

      with cbBonusMalus do
        if ((ItemIndex >= 0) and (Items.Objects[ItemIndex] <> nil)) then
          IDInsuranceClass := (Items.Objects[ItemIndex] as TStringObject).StringValue;

      DogSer    := edPolisSer.Text;
      DogNum    := edPolisNum.Text;
      TicketSer := edTicketSer.Text;
      TicketNum := edTicketNum.Text;
      ZnakSer   := edSpecialSignSer.Text;
      ZnakNum   := edSpecialSignNum.Text;
      InsSum    := edInsSum.Text;
      InsPrem   := calcedAward.Text;

      dttm      := dtedStartDate.Date;
      ReplaceTime(dttm, zvdtpStartTime.Time);

      DateStart := dttm;
      DateEnd   := dtedEndDate.Date;
      StartUse  := dtedPeriodStart.Date;
      EndUse    := dtedPeriodEnd.Date;
      if (cboxAddPeriod.Checked) then
        begin
          StartUse1 := dtedAddPeriodStart.Date;
          EndUse1   := dtedAddPeriodEnd.Date;
        end
      else
        begin
          StartUse1 := Null;
          EndUse1   := Null;
        end;
      if (cboxAddPeriod2.Checked) then
        begin
          StartUse2 := dtedAddPeriod2Start.Date;
          EndUse2   := dtedAddPeriod2End.Date;
        end
      else
        begin
          StartUse2 := Null;
          EndUse2   := Null;
        end;

      DateWrite         := dtedSigningDate.Date;
      DateBegin         := dtedBeginDate.Date;
      TicketDate        := dtedTicketDate.Date;
      Comments.Text     := memoSpecialNotes.Text;
      Transit           := cboxTransit.Checked;
      UnlimitedDrivers  := cboxUnlimDrvs.Checked;

      BaseSum           := edInsAwdBS.Text;
      CoefTer           := edInsAwdKT.Text;
      CoefBonusMalus    := edInsAwdKBM.Text;
      CoefUnlim         := edInsAwdKO.Text;
      CoefStage         := edInsAwdKVS.Text;
      CoefPower         := edInsAwdKM.Text;
      CoefPeriodUse     := edInsAwdKS.Text;
      CoefSrokIns       := edInsAwdKP.Text;
      CoefKN            := edInsAwdKN.Text;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.ClearContractLabels();
begin
  // ТС.
  labelVIN.Caption            := EmptyStr;
  labelGosNum.Caption         := EmptyStr;
  labelPTSSer.Caption         := EmptyStr;
  labelPTSNum.Caption         := EmptyStr;
  labelKusov.Caption          := EmptyStr;
  labelShassi.Caption         := EmptyStr;
  labelCarMark.Caption        := EmptyStr;
  labelCarType.Caption        := EmptyStr;
  // Страхователь.
  sbtnPolicyholder.Caption    := EmptyStr;
  labelPhPassport.Caption     := EmptyStr;
  labelPhINN.Caption          := EmptyStr;
  labelPhAddress.Caption      := EmptyStr;
  // Владелец ТС.
  labelOwnerData.Caption      := EmptyStr;
  labelOwnerPassport.Caption  := EmptyStr;
  labelOwnerINN.Caption       := EmptyStr;
  labelOwnerAddress.Caption   := EmptyStr;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.sbtnInsCoefsClick(Sender: TObject);
begin
  if (Sender = sbtnCalcInsAward) then
    begin
      CalcInsAward();
    end
  else if (Sender = sbtnGetCurrCoefs) then
    begin
      ListContractCoefs();
    end
  else if (Sender = sbtnGetActualCoefs) then
    begin
      LoadDataInEntity();
      ListActualCoefs();
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.CalcInsAward();
  procedure ShowCalcError(const msg: string; ed: TEdit);
  begin
    HighligthControl(ed);
    sbarMain.SimpleText := SysToUtf8(contract_mgr_msg_InsCalcErr + msg + ' ' +
      contract_mgr_msg_InputIncor);
  end;
var kt, kvs, ko, km, ks, kp, kbm, kn, base: double;
  formula: string;
begin
  // Начинаю с ближнего к кнопкам расчёта.
  kn    := StrToFloatDef(edInsAwdKN.Text, 0);
  if (kn <= 0) then
    begin
      ShowCalcError(contract_mgr_koef_kn, edInsAwdKN);
      exit;
    end;
  ks    := StrToFloatDef(edInsAwdKS.Text, 0);
  if (ks <= 0) then
    begin
      ShowCalcError(contract_mgr_koef_ks, edInsAwdKS);
      exit;
    end;
  kp    := StrToFloatDef(edInsAwdKP.Text, 0);
  if (kp <= 0) then
    begin
      ShowCalcError(contract_mgr_koef_kp, edInsAwdKP);
      exit;
    end;
  km    := StrToFloatDef(edInsAwdKM.Text, 0);
  if (km <= 0) then
    begin
      ShowCalcError(contract_mgr_koef_km, edInsAwdKM);
      exit;
    end;
  kvs   := StrToFloatDef(edInsAwdKVS.Text, 0);
  if (kvs <= 0) then
    begin
      ShowCalcError(contract_mgr_koef_kvs, edInsAwdKVS);
      exit;
    end;
  kbm   := StrToFloatDef(edInsAwdKBM.Text, 0);
  if (kbm <= 0) then
    begin
      ShowCalcError(contract_mgr_koef_kbm, edInsAwdKBM);
      exit;
    end;
  ko    := StrToFloatDef(edInsAwdKO.Text, 0);
  if (ko <= 0) then
    begin
      ShowCalcError(contract_mgr_koef_ko, edInsAwdKO);
      exit;
    end;
  kt    := StrToFloatDef(edInsAwdKT.Text, 0);
  if (kt <= 0) then
    begin
      ShowCalcError(contract_mgr_koef_kt, edInsAwdKT);
      exit;
    end;
  base  := StrToFloatDef(edInsAwdBS.Text, 0);
  if (base <= 0) then
    begin
      ShowCalcError(contract_mgr_koef_bs, edInsAwdBS);
      exit;
    end;

  if (FEdSubstate = esReplace) then formula := ' + ' +
    FloatToStr(FPrevContract.InsPrem);

  calcedAward.AsFloat := CalculateInsPrem(Target as TContractEntity,
    base, kt, kbm, kvs, ko, km, ks, kp, kn, formula);

  stxtFormula.Caption := formula;

end;
//---------------------------------------------------------------------------
procedure TfrmMain.edInsAwdCoefsChange(Sender: TObject);
begin
  (Sender as TEdit).Color := clInfoBk;
  //CalcInsAward();
  DataWasChanged(Sender);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.edInsAwdCoefsKeyPress(Sender: TObject;
  var Key: char);
begin
  if (Key = #13) then
    begin
      CalcInsAward();
      Key := #0;
      exit;
    end;
  CheckDigitalInput(Sender, Key);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.PolisGetValue(const ParName: String;
  var ParValue: Variant);
// Печать полиса.
var n, v: string;
    vn: integer;
    ce: TContractEntity;
begin
  ce := TContractEntity(Target);
  SeparateStrDigit(ParName, n, v);
  ParValue := ' ';
  // Переменные отчёта.
  if (n = 'blank_filer_str') then
    begin
      ParValue := blank_filer_str;
    end
  else if (n = 'blank_filer_sym') then
    begin
      ParValue := SysToUtf8(blank_filer_sym);
    end
  // Срок действия договора.
  else if (n = 's') then
    begin
      vn := StrToInt(v);
      if (ce.DateStart = Null) then
        begin
          ParValue := SysToUtf8(blank_filer_sym);
          exit;
        end;
      // Часы (строка индексирована с 1).
      if (vn in [1, 2]) then ParValue :=
        UTF8Copy(FormatDateTime('hh', ce.DateStart), vn, 1);
      // Минуты.
      if (vn in [3, 4]) then ParValue :=
        UTF8Copy(FormatDateTime('nn', ce.DateStart), vn - 2, 1);
      // Дата с ...
      if (vn in [5..10]) then ParValue :=
        UTF8Copy(FormatDateTime('ddmmyy', ce.DateStart), vn - 4, 1);
    end
  // Срок действия. Дата по ...
  else if (n = 't') then
    begin
      vn := StrToInt(v);
      if (ce.DateEnd = Null) then ParValue := SysToUtf8(blank_filer_sym)
      else ParValue  :=
        UTF8Copy(FormatDateTime('ddmmyy', ce.DateEnd), vn, 1);
    end
  // Первый период использования.
  else if (n = 'u') then
    begin
      vn := StrToInt(v);
      if (((vn in [1..6]) and (ce.StartUse = Null)) or
        ((vn in [7..12]) and (ce.EndUse = Null))) then
          ParValue := SysToUtf8(blank_filer_sym)
      else if (vn in [1..6]) then ParValue :=
        UTF8Copy(FormatDateTime('ddmmyy', ce.StartUse), vn, 1)
      else if (vn in [7..12]) then ParValue :=
        UTF8Copy(FormatDateTime('ddmmyy', ce.EndUse), vn - 6, 1);
    end
  // Второй период использования.
  else if (n = 'x') then
    begin
      vn := StrToInt(v);
      if (((vn in [1..6]) and (ce.StartUse1 = Null)) or
        ((vn in [7..12]) and (ce.EndUse1 = Null))) then
          ParValue := SysToUtf8(blank_filer_sym)
      else if (not cboxAddPeriod.Checked) then ParValue :=
        SysToUtf8(blank_filer_sym)
      else if (vn in [1..6]) then ParValue :=
        UTF8Copy(FormatDateTime('ddmmyy', ce.StartUse1), vn, 1)
      else if (vn in [7..12]) then ParValue :=
        UTF8Copy(FormatDateTime('ddmmyy', ce.EndUse1), vn - 6, 1);
    end
  // Третий период использования.
  else if (n = 'y') then
    begin
      vn := StrToInt(v);
      if (((vn in [1..6]) and (ce.StartUse2 = Null)) or
        ((vn in [7..12]) and (ce.EndUse2 = Null))) then
          ParValue := SysToUtf8(blank_filer_sym)
      else if (not cboxAddPeriod2.Checked) then
        ParValue := SysToUtf8(blank_filer_sym)
      else if (vn in [1..6]) then ParValue :=
        UTF8Copy(FormatDateTime('ddmmyy', ce.StartUse2), vn, 1)
      else if (vn in [7..12]) then ParValue :=
        UTF8Copy(FormatDateTime('ddmmyy', ce.EndUse2), vn - 6, 1);
    end
  // VIN.
  else if (n = 'v') then
    begin
      vn := StrToInt(v);
      if (vn <= Length(VarToStr(ce.Car.VIN))) then
        ParValue := UTF8Copy(VarToStr(ce.Car.VIN), vn, 1);
    end
  // Серия ПТС.
  else if (n = 'p') then
    begin
      vn := StrToInt(v);
      if (vn <= Length(VarToStr(ce.Car.PtsSer))) then
        ParValue := UTF8Copy(VarToStr(ce.Car.PtsSer), vn, 1);
    end
  // Номер ПТС.
  else if (n = 'n') then
    begin
      vn := StrToInt(v);
      if (vn <= Length(VarToStr(ce.Car.PtsNum))) then
        ParValue := UTF8Copy(VarToStr(ce.Car.PtsNum), vn, 1);
    end
  // Номер водителя.
  else if (n = 'd') then
    begin
      vn := StrToInt(v);
      if ((vn <= ce.Drivers.Count) and (not VarToBool(ce.UnlimitedDrivers)))
        then ParValue := vn
      else ParValue := SysToUtf8(blank_filer_sym);
    end
  // ФИО водителя.
  else if (n = 'driver') then
    begin
      vn := StrToInt(v);
      if ((vn <= ce.Drivers.Count) and
        (not VarToBool(ce.UnlimitedDrivers))) then
          ParValue :=
            (ce.Drivers[vn - 1] as TDriverEntity).Client.FullName
      else
        ParValue := SysToUtf8(blank_filer_str);
    end
  // Водительское удостверение.
  else if (n = 'doc') then
    begin
      vn := StrToInt(v);
      if ((vn <= ce.Drivers.Count) and
        (not VarToBool(ce.UnlimitedDrivers))) then
          ParValue :=
            VarToStr((ce.Drivers[vn - 1] as TDriverEntity).Client.LicenseSer) +
            SysToUtf8(' ' + cls_number + ' ') +
            VarToStr((ce.Drivers[vn - 1] as TDriverEntity).Client.LicenseNum)
      else
        ParValue := SysToUtf8(blank_filer_str);
    end
  else if (n = 'policy_holder') then
    begin
      ParValue := ce.PolicyHolder.FullName;
    end
  else if (n = 'owner') then
    begin
      ParValue := ce.Car.CarOwner.FullName;
    end
  else if (n = 'carmark') then
    begin
      ParValue := VarToStr(ce.Car.CarModel) + ' ' + VarToStr(ce.Car.CarMarkName);
    end
  else if (n = 'gos_num') then
    begin
      ParValue := ce.Car.GosNum;
    end
  else if (n = 'doctype') then
    begin
      ParValue  := SysToUtf8(blank_filer_sym);
    end
  else if (n = 'unlim_flag') then
    begin
      ParValue := VartoBool(ce.UnlimitedDrivers);
    end
  else if (n = 'lim_flag') then
    begin
      ParValue := not VartoBool(ce.UnlimitedDrivers);
    end
  else if (n = 'ins_prem') then
    begin
      FNumConvertor.Value := StrToFloatDef(VarToStr(ce.InsPrem), 0.0);
      ParValue := SysToUtf8(FNumConvertor.Text) +
        ' (' + VarToStr(ce.InsPrem) + ')';
    end
  else if (n = 'notes') then
    begin
      ParValue := ce.Comments.Text;
    end
  else if (n = 'agent') then
    begin
      if (ManagerState = msEntityCreation) then
        ParValue := dmData.GetCurUserFullName()
      else
        ParValue := ce.UserInsertName;
    end
  else if (n = 'cday') then
    begin
      if (ce.DateWrite = Null) then exit;
      ParValue := FormatDateTime('dd', ce.DateWrite);
    end
  else if (n = 'cmonth') then
    begin
      if (ce.DateWrite = Null) then exit;
      ParValue := SysToUtf8(FormatDateTime('mmmm', ce.DateWrite));
    end
  else if (n = 'cyear') then
    begin
      if (ce.DateWrite = Null) then exit;
      ParValue := FormatDateTime('yy', ce.DateWrite);
    end
  else if (n = 'pday') then
    begin
      if (ce.DateBegin = Null) then exit;
      ParValue := FormatDateTime('dd', ce.DateBegin);
    end
  else if (n = 'pmonth') then
    begin
      if (ce.DateBegin = Null) then exit;
      ParValue := SysToUtf8(FormatDateTime('mmmm', ce.DateBegin));
    end
  else if (n = 'pyear') then
    begin
      if (ce.DateBegin = Null) then exit;
      ParValue := FormatDateTime('yy', ce.DateBegin);
    end
  else if (n = 'ins_company') then
    begin
      ParValue := cbInsCompany.Caption;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.ReceiptGetValue(const ParName: String;
  var ParValue: Variant);
// Печать заявления.
var n, v: string;
    vn: integer;
    ce: TContractEntity;
    ic: TInfInsCompany;
begin
  ce := TContractEntity(Target);
  SeparateStrDigit(ParName, n, v);
  ParValue := ' ';
  // Переменные отчёта.
  if (n = 'blank_filer_str') then
    begin
      ParValue := blank_filer_str;
    end
  else if (n = 'blank_filer_sym') then
    begin
      ParValue := SysToUtf8(blank_filer_sym);
    end
  // Название страховой компании.
  else if (n = 'ins_company') then
    begin
      ParValue := cbInsCompany.Caption;
    end
  else if (n = 'policyholder') then
    begin
      ParValue := ce.PolicyHolder.FullName;
    end
  else if (n = 'phbirthday') then
    begin
      ParValue := ce.PolicyHolder.Birthday;
    end
  else if (n = 'phINN') then
    begin
      ParValue := ce.PolicyHolder.INN;
    end
  else if (n = 'phdoctype') then
    begin
      ParValue := ce.PolicyHolder.DocType;
    end
  else if (n = 'phdocser') then
    begin
      ParValue := ce.PolicyHolder.DocSer;
    end
  else if (n = 'phdocnum') then
    begin
      ParValue := ce.PolicyHolder.DocNum;
    end
  else if (n = 'phindex') then
    begin
      ParValue := ce.PolicyHolder.Postindex;
    end
  else if (n = 'phcountry') then
    begin
      ParValue := ce.PolicyHolder.CountryName;
    end
  else if (n = 'phregion') then
    begin
      ParValue := ce.PolicyHolder.RegionName;
    end
  else if (n = 'phtown') then
    begin
      with ce.PolicyHolder do
        begin
          n := VarToStr(Town);
          ParValue := CityName;
          if (n <> EmptyStr) then ParValue := ParValue + ' (' + Town + ')';
        end;
    end
  else if (n = 'phstreet') then
    begin
      ParValue := ce.PolicyHolder.Street;
    end
  else if (n = 'phhome') then
    begin
      ParValue := ce.PolicyHolder.Home;
    end
  else if (n = 'phcorpus') then
    begin
      ParValue := ce.PolicyHolder.Corpus;
    end
  else if (n = 'phflat') then
    begin
      ParValue := ce.PolicyHolder.FlatNum;
    end
  else if (n = 'phphone') then
    begin
      ParValue := ce.PolicyHolder.PhoneHome;
    end
  // Срок действия договора. Начало.
  else if (n = 'datestart') then
    begin
      ParValue := SysToUTF8(FormatDateTime('dd mmmm yyyy г.', ce.DateStart));
      // ParValue := ce.DateStart;
    end
  // Срок действия договора. Конец.
  else if (n = 'dateend') then
    begin
      ParValue := SysToUTF8(FormatDateTime('dd mmmm yyyy г.', ce.DateEnd));
      // ParValue := ce.DateEnd;
    end
  // Собственник.
  else if (n = 'owner') then
    begin
      ParValue := ce.Car.CarOwner.FullName;
    end
  else if (n = 'owbirthday') then
    begin
      ParValue := ce.Car.CarOwner.Birthday;
    end
  else if (n = 'owINN') then
    begin
      ParValue := ce.Car.CarOwner.INN;
    end
  else if (n = 'owdoctype') then
    begin
      ParValue := ce.Car.CarOwner.DocType;
    end
  else if (n = 'owdocser') then
    begin
      ParValue := ce.Car.CarOwner.DocSer;
    end
  else if (n = 'owdocnum') then
    begin
      ParValue := ce.Car.CarOwner.DocNum;
    end
  else if (n = 'owindex') then
    begin
      ParValue := ce.Car.CarOwner.Postindex;
    end
  else if (n = 'owcountry') then
    begin
      ParValue := ce.Car.CarOwner.CountryName;
    end
  else if (n = 'owregion') then
    begin
      ParValue := ce.Car.CarOwner.RegionName;
    end
  else if (n = 'owtown') then
    begin
      with ce.Car.CarOwner do
        begin
          n := VarToStr(Town);
          ParValue := CityName;
          if (n <> EmptyStr) then ParValue := ParValue + ' (' + Town + ')';
        end;
    end
  else if (n = 'owstreet') then
    begin
      ParValue := ce.Car.CarOwner.Street;
    end
  else if (n = 'owhome') then
    begin
      ParValue := ce.Car.CarOwner.Home;
    end
  else if (n = 'owcorpus') then
    begin
      ParValue := ce.Car.CarOwner.Corpus;
    end
  else if (n = 'owflat') then
    begin
      ParValue := ce.Car.CarOwner.FlatNum;
    end
  else if (n = 'owins_class') then
    begin
      ParValue := ce.Car.CarOwner.InsuranceClass;
    end
  // ТС.
  else if (n = 'carmark') then
    begin
      ParValue := VarToStr(ce.Car.CarMarkName) + ' ' + VarToStr(ce.Car.CarModel);
    end
  // VIN.
  else if (n = 'vin') then
    begin
      ParValue := ce.Car.VIN;
    end
  else if (n = 'year_issue') then
    begin
      ParValue := ce.Car.YearIssue;
    end
  else if (n = 'power_kwt') then
    begin
      ParValue := ce.Car.PowerKWT;
    end
  else if (n = 'power_hp') then
    begin
      ParValue := ce.Car.PowerHP;
    end
  else if (n = 'max_mass') then
    begin
      ParValue := ce.Car.MaxMass;
    end
  else if (n = 'places_count') then
    begin
      ParValue := ce.Car.NumPlaces;
    end
  else if (n = 'shassi_num') then
    begin
      ParValue := ce.Car.ShassiNum;
    end
  else if (n = 'kusov_num') then
    begin
      ParValue := ce.Car.KusovNum;
    end
  else if (n = 'car_doc_type') then
    begin
      ParValue := SysToUTF8('ПТС');
    end
  // ПТС (серия, номер, дата выдачи).
  else if (n = 'pts_ser') then
    begin
      ParValue := ce.Car.PtsSer;
    end
  else if (n = 'pts_num') then
    begin
      ParValue := ce.Car.PtsNum;
    end
  else if (n = 'pts_date') then
    begin
      ParValue := (ce.Car.PtsDate);
    end
  else if (n = 'gos_num') then
    begin
      ParValue := ce.Car.GosNum;
    end
  else if (n = 'car_puprose_use') then
    begin
      if (ce.Car.IDPurposeUse <> Null) then
        ParValue := ce.Car.IDPurposeUse
      else
        // Небольшой костыль.
        ParValue := 4;
    end
  // Номер водителя.
  else if (n = 'd') then
    begin
      vn := StrToInt(v);
      if (vn <= ce.Drivers.Count) then ParValue := vn
      else ParValue := SysToUtf8(blank_filer_sym);
    end
  // ФИО водителя.
  else if (n = 'driver') then
    begin
      vn := StrToInt(v);
      if ((vn <= ce.Drivers.Count) and
        (not VarToBool(ce.UnlimitedDrivers))) then
          ParValue :=
            (ce.Drivers[vn - 1] as TDriverEntity).Client.FullName
      else
        ParValue := SysToUtf8(blank_filer_str);
    end
  // Дата рождения водителя.
  else if (n = 'birthday_d') then
    begin
      vn := StrToInt(v);
      if ((vn <= ce.Drivers.Count) and
        (not VarToBool(ce.UnlimitedDrivers))) then
          ParValue :=
            (ce.Drivers[vn - 1] as TDriverEntity).Client.Birthday
      else
        ParValue := SysToUtf8(blank_filer_sym);
    end
  // Пол водителя.
  else if (n = 'sex_d') then
    begin
      vn := StrToInt(v);
      if ((vn <= ce.Drivers.Count) and
        (not VarToBool(ce.UnlimitedDrivers))) then
          ParValue :=
            (ce.Drivers[vn - 1] as TDriverEntity).Client.SocialState
      else
        ParValue := SysToUtf8(blank_filer_sym);
    end
  // Адрес водителя.
  else if (n = 'address_d') then
    begin
      vn := StrToInt(v);
      if ((vn <= ce.Drivers.Count) and
        (not VarToBool(ce.UnlimitedDrivers))) then
          ParValue :=
            (ce.Drivers[vn - 1] as TDriverEntity).Client.FullAddress
      else
        ParValue := SysToUtf8(blank_filer_str);
    end
  // Количество страховых случаев.
  else if (n = 'incidents_d') then
    begin
      vn := StrToInt(v);
      if ((vn <= ce.Drivers.Count) and
        (not VarToBool(ce.UnlimitedDrivers))) then
          ParValue := '0'
//            (ce.Drivers[vn - 1] as TDriverEntity).Client.
      else
        ParValue := SysToUtf8(blank_filer_str);
    end
  // Водительское удостоверение.
  else if (n = 'pts_d') then
    begin
      vn := StrToInt(v);
      if ((vn <= ce.Drivers.Count) and
        (not VarToBool(ce.UnlimitedDrivers))) then
          ParValue :=
            VarToStr((ce.Drivers[vn - 1] as TDriverEntity).Client.LicenseSer) +
            SysToUtf8(' ' + cls_number + ' ') +
            VarToStr((ce.Drivers[vn - 1] as TDriverEntity).Client.LicenseNum)
      else
        ParValue := SysToUtf8(blank_filer_str);
    end
  else if (n = 'stage_d') then
  // Стаж водителя. Вычисляется от начала действия договора.
    begin
      vn := StrToInt(v);
      if ((vn <= ce.Drivers.Count) and
        (not VarToBool(ce.UnlimitedDrivers))) then
          ParValue :=
            YearsBetween(
              (ce.Drivers[vn - 1] as TDriverEntity).Client.StartDrivingDate,
              ce.DateStart
            )
      else
        ParValue := SysToUtf8(blank_filer_sym);
    end
  // Периоды использования. Начало.
  else if (n = 'start_use') then
    begin
      vn := StrToInt(v);
      case (vn) of
        1: // ParValue := FormatDateTime('dd.mm.yy hh:nn', ce.StartUse);
          ParValue := ce.StartUse;
        2: if (not cboxAddPeriod.Checked) then
          ParValue := SysToUtf8(blank_filer_sym)
          else ParValue := ce.StartUse1;
        3: if (not cboxAddPeriod2.Checked) then
          ParValue := SysToUtf8(blank_filer_sym)
          else ParValue := ce.StartUse2;
      end;
    end
  // Периоды использования. Конец.
  else if (n = 'end_use') then
    begin
      vn := StrToInt(v);
      case (vn) of
        1: // ParValue := FormatDateTime('dd.mm.yy hh:nn', ce.StartUse);
          ParValue := ce.EndUse;
        2: if (not cboxAddPeriod.Checked) then
          ParValue := SysToUtf8(blank_filer_sym)
          else ParValue := ce.EndUse1;
        3: if (not cboxAddPeriod2.Checked) then
          ParValue := SysToUtf8(blank_filer_sym)
          else ParValue := ce.EndUse2;
      end;
    end
  // Предыдущий договор.
  else if (n = 'prev_dog_ser') then
    begin
      if ((ce.IDPrevContract <> Null) and (ce.IDPrevContract <> EmptyStr)) then
        ParValue := FPrevContract.DogSer
      else
        ParValue := SysToUtf8(blank_filer_sym);
    end
  else if (n = 'prev_dog_num') then
    begin
      if ((ce.IDPrevContract <> Null) and (ce.IDPrevContract <> EmptyStr)) then
        ParValue := FPrevContract.DogNum
      else
        ParValue := SysToUtf8(blank_filer_sym);
    end
  else if (n = 'prev_cnt_ins_comp') then
    begin
      if ((ce.IDPrevContract <> Null) and (ce.IDPrevContract <> EmptyStr)) then
        begin
          ic := TInfInsCompany(CompaniesCollection.GetEntityByID(
            FPrevContract.IDInsuranceCompany)
          );
          if (ic <> nil) then ParValue := ic.InsCompanyName
          else ParValue := SysToUtf8(blank_filer_sym);
        end
      else
        ParValue := SysToUtf8(blank_filer_sym);
    end
  else if (n = 'dog_ser') then
    begin
      ParValue := ce.DogSer;
    end
  else if (n = 'dog_num') then
    begin
      ParValue := ce.DogNum;
    end
  else if (n = 'dog_date_write') then
    begin
      ParValue := ce.DateWrite;
    end
  else if (n = 'base_sum') then
    begin
      ParValue := ce.BaseSum;
    end
  else if (n = 'coef_kt') then
    begin
      ParValue := ce.CoefTer;
    end
  else if (n = 'coef_kbm') then
    begin
      ParValue := ce.CoefBonusMalus;
    end
  else if (n = 'coef_kvs') then
    begin
      ParValue := ce.CoefStage;
    end
  else if (n = 'coef_ks') then
    begin
      ParValue := ce.CoefPeriodUse;
    end
  else if (n = 'coef_kp') then
    begin
      ParValue := ce.CoefSrokIns;
    end
  else if (n = 'coef_km') then
    begin
      ParValue := ce.CoefPower;
    end
  else if (n = 'coef_kn') then
    begin
      ParValue := ce.CoefKN;
    end
  else if (n = 'ins_prem') then
    begin
      //FNumConvertor.Value := StrToFloatDef(VarToStr(ce.InsPrem), 0.0);
      ParValue := ce.InsPrem; //SysToUtf8(FNumConvertor.Text);
    end
  else if (n = 'notes') then
    begin
      ParValue := ce.Comments.Text;
    end
  else if (n = 'agent') then
    begin
      if (ManagerState = msEntityCreation) then
        ParValue := dmData.GetCurUserFullName()
      else
        ParValue := ce.UserInsertName;
    end
  else if (n = 'unlim_flag') then
    begin
      ParValue := VartoBool(ce.UnlimitedDrivers);
    end
  else if (n = 'lim_flag') then
    begin
      ParValue := not VartoBool(ce.UnlimitedDrivers);
    end
  else if (n = 'rent_flag') then
    begin
      ParValue := VartoBool(ce.Car.InRent);
    end
  // Квитанция.
  else if (n = 'ticket_ser') then
    begin
      ParValue := ce.TicketSer;
    end
  else if (n = 'ticket_num') then
    begin
      ParValue := ce.TicketNum;
    end
  else if (n = 'ticket_date') then
    begin
      ParValue := ce.TicketDate;
    end;
end;

//---------------------------------------------------------------------------
// Обновления.
//---------------------------------------------------------------------------

procedure TfrmMain.EntityWasUpdated(const record_id: TTableRecordID;
  const update_type: TUpdateType; const user_updater: string);
begin
  // Делаю какие-либо действия, только если это выбранный договор.
  if (Target = nil) then exit;
  // Обновил текущий пользователь. Я считаю, что одновременно может быть только
  // одна сессия текущего пользователя. Не использую pseudo_thread_id.
  if (user_updater = CurrentUser.User) then exit;
  if ((Target as TContractEntity).CheckID(record_id)) then
    begin
      case update_type of
        utInsert: ;
        utUpdate:
          begin
            Target.DataSource := dmData.GetContByID(VarToStr(record_id[0]));
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
            ListData();
            ReinitManager();
          end;
        utAction: ;
      end;
    end;
  // Обновляю Alerter.
  dmData.CheckAlerter(Null, record_id[0], update_type in [utInsert]);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.OnBlanksUpdate(const entity_id: TTableRecordID;
  const update_type: TUpdateType;
  const user_updater: string);
var ins_comp: TInfInsCompany;
    blank: TBlankEntity;
    t_node: TTreeNode;
    cuser, chost: string;
begin
  t_node := nil;
  // Первое поле - ID страховой компании.
  ins_comp := CompaniesCollection.GetEntityByID([entity_id[0]])
    as TInfInsCompany;
  if (ins_comp = nil) then exit;
  case update_type of
    utInsert:
      begin
        // Добавляю в коллекцию.
        blank := ins_comp.BlankAdd(entity_id[1], entity_id[2]);
        if (blank = nil) then exit;
        if (not blank.GetBlankData()) then exit;
        if (not blank.Reserved) then
          // Свободен.
          begin
            if (AddBlankToTree(trvLeft.Items.FindNodeWithData(ins_comp), blank,
              true) = nil)
              then
                raise ETreeNodeError.Create('Can''t create node');
          end
        else
          begin
            // Удаляю бланк из коллекции, если бланк был добавлен и
            // зарезервирован другим пользователем.
            dmData.GetCurUser(chost, cuser);
            if ((cuser <> VarToStr(blank.UserReserver)) or
                (chost <> VarToStr(blank.HostReserver))) then
              begin
                ins_comp.BlankDel(blank);
                // Бланк разрушается коллекцией.
                blank := nil;
              end;
          end;
      end;
    utUpdate:
      begin
        blank := ins_comp.Blanks.GetEntityByID([entity_id[1], entity_id[2]])
          as TBlankEntity;
        if (blank = nil) then
        // Если такой бланк не учтён, я добавляю его в коллекцию.
          begin
            blank := ins_comp.BlankAdd(entity_id[1], entity_id[2]);
            if (blank = nil) then exit;
          end
        // Видимо, бланк есть в дереве.
        else t_node := trvLeft.Items.FindNodeWithData(blank);
        if (not blank.GetBlankData()) then exit;
        with trvLeft.Items do
          if (t_node = nil) then
            begin
              t_node := AddBlankToTree(FindNodeWithData(ins_comp), blank, true);
              if (t_node = nil)
                then raise ETreeNodeError.Create('Can''t create node');
            end;
        if (not blank.Reserved) then
          // Свободен.
          begin
            with trvLeft.Items do
              begin
                t_node.Text       := VarToStr(blank.BlankFullNum);
                t_node.ImageIndex := 4;
              end;
          end
        else
          // Зарезервирован.
          begin
            chost := VarToStr(CurrentUser.Host);
            cuser := VarToStr(CurrentUser.User);
            if ((cuser <> VarToStr(blank.UserReserver)) or
                (chost <> VarToStr(blank.HostReserver))) then
            // Только если этот бланк был зарезервирован другим пользователем.
              begin
                // 1. Удаляю бланк из дерева.
                if (t_node <> nil) then t_node.Free;
                // 2. Удаляю бланк из коллекции.
                ins_comp.BlankDel(blank);
                // Бланк разрушается коллекцией.
                blank := nil;
              end
            else
              if (t_node <> nil) then t_node.ImageIndex := 6;
          end;
      end;
    utDelete:
      begin
        blank := ins_comp.Blanks.GetEntityByID([entity_id[1], entity_id[2]])
          as TBlankEntity;
        if (blank = nil) then exit;
        t_node := trvLeft.Items.FindNodeWithData(blank);
        // 1. Удаляю бланк из дерева.
        if (t_node <> nil) then t_node.Free;
        // 2. Удаляю бланк из коллекции.
        ins_comp.BlankDel(blank);
        // Бланк разрушается коллекцией.
        blank := nil;
      end;
    utAction: ;
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.OnInsCompsUpdate(const entity_id: TTableRecordID;
  const update_type: TUpdateType;
  const user_updater: string);
var ins_comp: TInfInsCompany;
    t_node: TTreeNode;
    i: integer;

  function AddCompanyInCollection(): boolean;
  begin
    Result := false;
    ins_comp := TInfInsCompany(CompaniesCollection.Add());
    if (ins_comp = nil) then exit;
    // Перезагружается всё дерево компаний.
    with dmData.myInsCompanies do
      begin
        Open();
        Locate('ID_INSURANCE_COMPANY', entity_id, []);
        ins_comp.DataSource := dmData.datasrcIns_company;
        if (not ins_comp.DB_Load(ltNew)) then exit;
      end;
    Result := true;
  end;

begin
  t_node := nil;
  case update_type of
    utInsert:
      begin
        if (not AddCompanyInCollection()) then exit;
        if (AddCompanyToTreeAndList(ins_comp) = nil) then
          raise ETreeNodeError.Create('Can''t create node');
      end;
    utUpdate:
      begin
        ins_comp := CompaniesCollection.GetEntityByID(entity_id)
          as TInfInsCompany;
        if (ins_comp = nil) then exit;
        // Если такая компания не учтена, я добавляю её в коллекцию.
        // Нельзя, поскольку, записи о старых удалённых компаниях
        // могут попасть в дерево.
        {    if (not AddCompanyInCollection()) then exit;
          if (AddCompanyToTreeAndList(ins_comp) = nil) then
            raise ETreeNodeError.Create('Can''t create node');
        }

        // Видимо, компания есть в дереве.
        dmData.myInsCompanies.Active := false;
        if (ins_comp.DB_Load()) then
          begin
            // Обновляю в дереве.
            t_node := trvLeft.Items.FindNodeWithData(ins_comp);
            if (t_node = nil) then exit;
            t_node.Text := VarToStr(ins_comp.InsCompanyName);
            // Обновляю в списке.
            i := cbInsCompany.Items.IndexOfObject(ins_comp);
            if (i < 0) then exit;
            cbInsCompany.Items.Strings[i] := VarToStr(ins_comp.InsCompanyName);
          end;
      end;
    utDelete:
      begin
        ins_comp := TInfInsCompany(CompaniesCollection.GetEntityByID(entity_id));
        if (ins_comp = nil) then exit;
        t_node := trvLeft.Items.FindNodeWithData(ins_comp);
        // 1. Удаляю из дерева.
        if (t_node <> nil) then t_node.Free;
        // 2. Удаляю из списка.
        i := cbInsCompany.Items.IndexOfObject(ins_comp);
        if (i < 0) then exit;
        cbInsCompany.Items.Delete(i);
        // 3. Удаляю из коллекции.
        ins_comp.Free;
      end;
    utAction: ;
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.OnCarUpdate(const entity_id: TTableRecordID;
  const update_type: TUpdateType;
  const user_updater: string);
begin
  // Делаю какие-либо действия в этом менеджере, только если это выбранное ТС.
  if ((Target <> nil) and (Target as TContractEntity).Car.CheckID(entity_id)) then
    begin
      case update_type of
        utInsert: ;
        utUpdate:
          begin
            with (Target as TContractEntity).Car do
              begin
                DataSource := dmData.GetCarByID(VarToStr(IDCar));
                DB_Load(ltNew);
                ListCarParams();
              end;
          end;
        utDelete:
          begin
            (Target as TContractEntity).Car.Assign(nil);
            ListCarParams();
          end;
        utAction: ;
      end;
    end;
  // Обновляю менеджер ТС.
  if (frmCarManager <> nil) then
    frmCarManager.EntityWasUpdated(entity_id, update_type, user_updater);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.OnClientUpdate(const entity_id: TTableRecordID;
  const update_type: TUpdateType;
  const user_updater: string);
var i, i_index: integer;
    de: TDriverEntity;
    //cln: TClientEntity;

begin
  if (Target = nil) then exit;
  // Могли обновиться данные страхователя, собственника и водителей.
  // Проверяю каждого.
  case update_type of
    utInsert: ;
    utUpdate:
      begin
        // Список вероятных страхователей.
{        i_index := cbPolicyholder.ItemIndex;
        for i := 0 to cbPolicyholder.Items.Count - 1 do
          begin
            cln := (cbPolicyholder.Items.Objects[i] as TClientEntity);
            if (cln.CheckID(entity_id)) then
              begin
                cln.DataSource := dmData.GetClientByID(VarToStr(cln.IDClient));
                cln.DB_Load(ltNew);
                try
                  cbPolicyholder.Items.BeginUpdate;
                  cbPolicyholder.Items.Strings[i] := VarToStr(cln.FullName);
                finally
                  cbPolicyholder.Items.EndUpdate;
                  cbPolicyholder.ItemIndex := i_index;
                  ListClientParams();
                end;


                break;
              end;
          end; // for}
        // Страхователь.
        with (Target as TContractEntity).PolicyHolder do
        if (CheckID(entity_id))
          then
            begin
              DataSource := dmData.GetClientByID(VarToStr(entity_id[0]));
              DB_Load(ltNew);
              ListClientParams();
            end;

        // Владелец ТС.
        if ((Target as TContractEntity).Car.CarOwner.CheckID(entity_id)) then
          begin
            with (Target as TContractEntity).Car.CarOwner do
              begin
                DataSource := dmData.GetClientByID(VarToStr(IDClient));
                DB_Load(ltNew);
                ListCarParams();
              end;
          end;

        // Водители.
        for i := 0 to (Target as TContractEntity).Drivers.Count - 1 do
          begin
            de := (Target as TContractEntity).Drivers[i] as TDriverEntity;
            if (de.Client.CheckID(entity_id)) then
              with (de.Client) do
                begin
                  de.Client.DataSource :=
                    dmData.GetClientByID(VarToStr(entity_id[0]));
                  de.Client.DB_Load(ltNew);
                  UpdateDrivers(de);
                  break;
                end;
          end;
      end;

    utDelete:
      begin
        // Список вероятных страхователей.
{        for i := 0 to cbPolicyholder.Items.Count - 1 do
          begin
            cln := (cbPolicyholder.Items.Objects[i] as TClientEntity);
            if (cln.CheckID(entity_id)) then
              begin
                try
                  cbPolicyholder.Items.BeginUpdate;
                  cbPolicyholder.Items.Delete(i);
                finally
                  cbPolicyholder.Items.EndUpdate;
                  ListClientParams();
                end;
                cln.DeleteSelf();
                break;
              end;
          end; // for}
        // Страхователь.
        if ((Target as TContractEntity).PolicyHolder.CheckID(entity_id)) then
          begin
            (Target as TContractEntity).PolicyHolder.Assign(nil);
            ListClientParams();
          end;

        // Владелец ТС.
        if ((Target as TContractEntity).Car.CarOwner.CheckID(entity_id)) then
          begin
            with (Target as TContractEntity).Car.CarOwner do
              begin
                Assign(nil);
                ListCarParams();
              end;
          end;

        // Водители.
        for i := 0 to (Target as TContractEntity).Drivers.Count - 1 do
          begin
            de := (Target as TContractEntity).Drivers[i] as TDriverEntity;
            if (de.Client.CheckID(entity_id)) then
              begin
                i_index := strGridDrivers.Cols[0].IndexOfObject(de);
                strGridDrivers.DeleteColRow(false, i_index);
                de.DeleteSelf();
                break;
              end;
          end;
      end;
    utAction: ;
  end;
  // Обновляю Alerter.
  dmData.CheckAlerter(entity_id[0], Null, update_type in [utInsert]);
  // Обновляю менеджер клиентов.
  if (frmClientManager <> nil) then
    frmClientManager.EntityWasUpdated(entity_id, update_type, user_updater);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.OnContractUpdate(const entity_id: TTableRecordID;
  const update_type: TUpdateType;
  const user_updater: string);
begin
  EntityWasUpdated(entity_id, update_type, user_updater);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.OnUserUpdate(const entity_id: TTableRecordID;
  const update_type: TUpdateType;
  const user_updater: string);
begin
  if (CurrentUser.CheckID(entity_id)) then
    begin
      with CurrentUser.DataSource.DataSet do
        begin
          Close();
          Open();
        end;
      CurrentUser.DB_Load(ltNew);
      SetControlsState(ManagerState in
        [msEntityView, msEntityEdit, msEntityCreation]);
    end;
  if (frmUserManager <> nil) then
    frmUserManager.EntityWasUpdated(entity_id, update_type, user_updater);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.OnVisInfosUpdate(const table_name: string;
  const user_updater: string);
begin
  if (frmInfoManager <> nil) then
    frmInfoManager.InfoWasUpdated(table_name, user_updater);

  if (table_name = 'client_types') then
    begin
      DBListFiler.FillListFromDB('ID_CLIENT_TYPE', 'CLIENT_TYPE',
        dmData.myClientTypes,
        [
          frmClientManager.cbClientType
        ]
      );
    end
  else if (table_name = 'car_type') then
    begin
      DBListFiler.FillListFromDB('ID_CAR_TYPE', 'CAR_TYPE',
        dmData.myCarType, [frmCarManager.cbCarType]);
    end
  else if (table_name = 'carmark') then
    begin
      DBListFiler.FillListFromDB('ID_CARMARK', 'MARK',
        dmData.myCarMark, [frmCarManager.cbCarMark]);
    end
  else if (table_name = 'car_model') then
    begin
      with frmCarManager do
        cbCarMark.OnChange(cbCarMark);
    end
  else if (table_name = 'family_state') then
    begin
      DBListFiler.FillListFromDB('ID_FAMILY_STATE', 'FAMILY_STATE_NAME',
        dmData.myFamilyState, [frmClientManager.cbFamilyState]);
    end
  else if (table_name = 'insurance_class') then
    begin
      DBListFiler.FillListFromDB('ID_INSURANCE_CLASS', 'INSURANCE_CLASS',
        dmCoefs.myGetInsCoef_KBM,
        [
          frmMain.cbBonusMalus,
          frmClientManager.cbBonusMalus
        ]
      );
    end
  else if (table_name = 'purpose_type') then
    begin
      DBListFiler.FillListFromDB('ID_PURPOSE_TYPE', 'PURPOSE_TYPE',
        dmData.myPurposeType, [frmCarManager.cbPurposeType]);
    end
  else if (table_name = 'country') then
    begin
      DBListFiler.FillListFromDB('ID_COUNTRY', 'NAME',
        dmData.myCountries, [frmClientManager.cbCountry]);
    end
  else if (table_name = 'region') then
    begin
      with frmClientManager do
        cbCountry.OnChange(cbCountry);
    end
  else if (table_name = 'city') then
    begin
      with frmClientManager do
        cbRegion.OnChange(cbRegion);
    end
  else if (table_name = 'sex') then
    begin
      DBListFiler.FillListFromDB('ID_SEX', 'SEX_NAME',
        dmData.mySex,
        [frmClientManager.cbSocialState]
      );
    end
  else if (table_name = 'type_doc') then
    begin
      DBListFiler.FillListFromDB('ID_TYPE_DOC', 'DOC_TYPE',
        dmData.myDocTypes,
        [
          frmClientManager.cbSDocType,
          frmClientManager.cbDocType,
          frmMain.cbSDocType
        ]
      );
    end
  else if (table_name = 'valuta') then
    begin

    end;
end;
//---------------------------------------------------------------------------
procedure TfrmMain.OnInvisInfosUpdate(const table_name: string;
  const user_updater: string);
begin
  if (frmInfoManager <> nil) then
    frmInfoManager.InfoWasUpdated(table_name, user_updater);
end;
//---------------------------------------------------------------------------
procedure TfrmMain.DBError(Sender: TObject; E: EDAError;
  var Fail: boolean);
begin
  if (Application.Terminated) then exit;
  // Потеря соединения.
  if ((E.ErrorCode = 2003) or (E.ErrorCode = 2006)) then
    begin
      DBUpdateDispatcher.Active := false;

      if (QuestionDlg(SysToUtf8(cls_warning),
        SysToUtf8(mw_reconn_msg), mtConfirmation,
          [mrYes, SysToUTF8(cls_yes), mrNo, SysToUtf8(cls_no)], 0) = mrNo)
      then
        begin
          try
            dmData.myconnMain.Disconnect;
          finally
            Fail := false;
            Close();
            Application.Terminate;
          end;
        end
      else
        begin
          dmData.myconnMain.Connected;
          DBUpdateDispatcher().Active := true;
        end;
      {pgctlMain.Enabled           := false;
      trvLeft.Enabled             := false;
      dbgridReminder.Enabled      := false;
      mmnMain_Admin.Enabled       := false;
      SwitchControls(pnToolbar, false);
      with dmData do
        begin
          myconnMain.Disconnect;
          myconnAddContract.Disconnect;
        end;
      pgctlMain.Visible           := false;
      pnHead.Visible              := false;
      splitterHoriz.Visible       := false;
      exit;}
    end;
end;
//---------------------------------------------------------------------------
initialization
  {$i main_unit.lrs}

end.
