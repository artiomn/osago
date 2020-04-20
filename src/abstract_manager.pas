unit abstract_manager;

//
// Модуль базового класса для всех менеджеров.
//

{$I settings.inc}

interface

uses
  Classes, ComCtrls, Controls, Dialogs, Forms, ExtCtrls, SysUtils, FileUtil,
  orm_abstract, update_dispatcher,
  common_functions, common_consts, db, strings_l10n;

type
  TManagerState = (msEntitySearch, msEntityView, msEntityEdit,
    msEntityCreation);
type

  TAbstractManager = class(TForm)
  private
    FHead:            TControl;
    FEntCollection:   TEntityesCollection;
    FTarget:          TEntity;
    FManPages:        TPageControl;
    // Тексты сообщений, выводимых пользователю
    FMsgView:         string;
    FMsgChange:       string;
    FMsgSearch:       string;
    FMsgNew:          string;
    // Изменение состояния менеджера в DataWasChanged() - запрещено.
    FChangesBlocked:  boolean;
    FDefData:         TDataSource;
    FSearch:          TDataSource;
    FManagerState:    TManagerState;
    FOnApply:         TNotifyEvent;
  private
    procedure SetManagerState(const ms: TManagerState);
  protected
    property ChangesBlocked: boolean read FChangesBlocked write FChangesBlocked;
  protected
    // Вызывается, когда необходимо установить состояние элементов управления
    // менеджера. Потомок должен устанавливать состояние, в зависимости от флага
    // enabled и прав текущего пользователя. Возвращает новое состояние.
    procedure SetControlsState(cenabled: boolean); virtual; abstract;
    procedure ListData(); virtual; abstract;
    // В этой процедуре, потомок должен вызвать процедуру
    // SetCreationParameters. К таким извращщениям приходится прибегать,
    // поскольку нормального полиморфизма в "паскале" нету. :-\
    procedure SetParamsDuringCreation(); virtual; abstract;
  protected
    property SearchDS: TDataSource read FSearch write FSearch;
  protected
    procedure SetTarget(const ctarget: TEntity);
    procedure SetDataSource(dc:  TDataSource);
    function GetDataSource(): TDataSource;
    procedure SetManPage(); virtual;
    procedure SetHeadText(); virtual;
    function ShowSearchResults(): boolean; virtual;
    // Загружает введённые данные в сущность.
    procedure LoadDataInEntity(); virtual; abstract;
    // Вызывает OnApply().
    procedure DoApply();
    // Проверяет, что была нажата цифровая клавиша или служебная
    procedure CheckDigitalInput(Sender: TObject; var Key: char); virtual;
    // Устанавливает менеджер в состояние поиска.
    procedure ReinitManager(); virtual;
    property ManagerState: TManagerState read FManagerState write
      SetManagerState;
  protected
    procedure SetCreationParameters(const ecollection: TEntityesCollection;
      head_control: TControl; pages: TPageControl;
      const view_msg, change_msg, search_msg, new_msg: string;
      const def_data_container, search: TDataSource); //virtual;
    property Target: TEntity read FTarget;
  protected
    function DlgDataLoss(): boolean;
    function DlgChangesCommit(): TModalResult;
    // Показать сообщение, что сохранить не удалось.
    procedure SavingErrorMsg(); virtual;
    // Проверяет поля перед занесением.
    function CheckEntityFields(): boolean; virtual;
    // Устанавливает режим создания сущности. Переинициализирует сущность.
    function MakeNewEntity(): boolean; virtual;
  public
    function ShowManager(etarget: TEntity;
      const manager_state: TManagerState): TEntity; virtual;
    property DataSource: TDataSource read GetDataSource;
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  public
    // Оповещение менеджера об обновлении сущности.
    procedure EntityWasUpdated(const record_id: TTableRecordID;
      const update_type: TUpdateType; const user_updater: string); virtual; abstract;
  published
    // Вызывается, если какие-либо данные были изменены
    procedure DataWasChanged(Sender: TObject); virtual;
    // Происходит, при нажатии на кнопку "Применить". Вызывается потомком.
    property OnApply: TNotifyEvent read FOnApply write FOnApply;
  end;
//---------------------------------------------------------------------------
implementation
//---------------------------------------------------------------------------
constructor TAbstractManager.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FOnApply            := nil;
  FManagerState       := msEntitySearch;
  SetParamsDuringCreation();
  // Удаляется он коллекцией.
  FTarget             := FEntCollection.Add();
  FTarget.DataSource  := FDefData;
end;
//---------------------------------------------------------------------------
procedure TAbstractManager.SetCreationParameters(
      const ecollection: TEntityesCollection;
      head_control: TControl; pages: TPageControl;
      const view_msg, change_msg, search_msg, new_msg: string;
      const def_data_container, search: TDataSource
);
begin
  FHead           := head_control;
  FManPages       := pages;
  FMsgView        := view_msg;
  FMsgChange      := change_msg;
  FMsgSearch      := search_msg;
  FMsgNew         := new_msg;
  FDefData        := def_data_container;
  FSearch         := search;
  FEntCollection  := ecollection;
end;
//---------------------------------------------------------------------------
destructor TAbstractManager.Destroy;
begin
  inherited Destroy;
end;
//---------------------------------------------------------------------------
procedure TAbstractManager.SetTarget(const ctarget: TEntity);
begin
  FTarget.Assign(ctarget);
end;
//---------------------------------------------------------------------------
function TAbstractManager.ShowManager(etarget: TEntity;
  const manager_state: TManagerState): TEntity;
begin
  Result := nil;
  if (manager_state = msEntitySearch) then Target.Assign(nil)
  else
    begin
      if (not (etarget is FEntCollection.ItemClass)) then exit;
      FTarget.Assign(etarget);
    end;
  try
    FChangesBlocked := true;
    ListData();
  finally
    FChangesBlocked := false;
  end;
  FManagerState := manager_state;
  SetControlsState(manager_state in
    [msEntityView, msEntityEdit, msEntityCreation]);
  SetManPage();
  SetHeadText();
  if (ShowModal() = mrOK) then
    begin
      // Загружается при сохранении. Сохранение всегда, при нажатии Ok.
//      LoadDataInEntity();
      Result := FTarget;
    end;
end;
//---------------------------------------------------------------------------
procedure TAbstractManager.SetManagerState(const ms: TManagerState);
begin
  if (FManagerState = ms) then exit;
  // Устанавливаю состояние изменения только если сейчас нет создания сущности.
  if ((FManagerState = msEntityCreation) and (ms = msEntityEdit)) then exit;
  // Нельзя получить msEntityEdit из msEntitySearch. Вначале - msEntityView.
  if ((FManagerState = msEntitySearch) and (ms = msEntityEdit)) then exit;
  // Если пользователь поменял данные, надо спросить его о сохранении
  // изменений.
  if (not DlgDataLoss()) then exit;
  FManagerState := ms;
  SetControlsState(ms in [msEntityView, msEntityEdit, msEntityCreation]);
  SetManPage();
  SetHeadText();
end;
//---------------------------------------------------------------------------
procedure TAbstractManager.SetHeadText();
begin
  if (FManPages.ActivePageIndex = 0) then
  // При открытии диалога поиска заголовок всегда меняется на поиск.
  // Я предполагаю, что страница 0 всегда отводится под поиск.
    begin
      // (FManagerState = msEntitySearch)
      FHead.Caption := SysToUtf8(FMsgSearch);
      exit;
    end;
  // Выбор заголовка, в зависимости от внутреннего состояния.
  case FManagerState of
    msEntityView:
      FHead.Caption := SysToUtf8(FMsgView);
    msEntityEdit:
      FHead.Caption := SysToUtf8(FMsgChange);
    msEntityCreation:
      FHead.Caption := SysToUtf8(FMsgNew);
    msEntitySearch:
      FHead.Caption := SysToUtf8(FMsgSearch);
  end;
end;
//---------------------------------------------------------------------------
function TAbstractManager.ShowSearchResults(): boolean;
begin
  Result        := false;
  ManagerState  := msEntityView;
  if (ManagerState <> msEntityView) then exit;
  SetDataSource(FSearch);
  FTarget.DB_Load(ltNew);
  try
    FChangesBlocked := true;
    ListData();
  finally
    FChangesBlocked := false;
  end;
  FManagerState := msEntityView;
  SetManPage();
  SetHeadText();
  Result := true;
end;
//---------------------------------------------------------------------------
procedure TAbstractManager.SetDataSource(dc: TDataSource);
begin
  if (dc <> FTarget.DataSource) then FTarget.DataSource := dc;
end;
//---------------------------------------------------------------------------
function TAbstractManager.GetDataSource(): TDataSource;
begin
  if (FTarget <> nil) then Result := FTarget.DataSource;
end;
//---------------------------------------------------------------------------
procedure TAbstractManager.SetManPage();
var pages_on_chg: TNotifyEvent;
begin
  if (FManPages = nil) then exit;
  pages_on_chg         := FManPages.OnChange;
  FManPages.OnChange   := nil;
  try
    if (FManagerState = msEntitySearch) then
      begin
        FManPages.ActivePageIndex := 0;
      end
    else
      begin
        // Первая страница - всегда поиск.
        // Затем может быть несколько пользовательских страниц.
        // Проверяю, чтобы не переключалось на первую страницу, при изменениях.
        if (FManPages.ActivePageIndex = 0) then FManPages.ActivePageIndex := 1;
      end;
  finally
    FManPages.OnChange := pages_on_chg;
  end;
end;
//---------------------------------------------------------------------------
procedure TAbstractManager.checkDigitalInput(Sender: TObject; var Key: char);
var ss: TShiftState;
begin
  ss := GetKeyShiftState();
  if ((ssAlt in ss) or (ssCtrl in ss)) then exit;
  if (not (((Key >= '0') and (Key <= '9')) or (Key = DecimalSeparator) or
      (Key = #8))) then Key := #0
  else DataWasChanged(Sender);
end;
//---------------------------------------------------------------------------
procedure TAbstractManager.ReinitManager();
begin
  FManagerState := msEntitySearch;
  SetControlsState(false);
  SetManPage();
  SetHeadText();
end;
//---------------------------------------------------------------------------
procedure TAbstractManager.DataWasChanged(Sender: TObject);
begin
  if (FChangesBlocked) then exit;
  ManagerState := msEntityEdit;
end;
//---------------------------------------------------------------------------
function TAbstractManager.DlgDataLoss(): boolean;
begin
  Result := true;
  if (ManagerState in [msEntityCreation, msEntityEdit]) then
  Result := QuestionDlg(SysToUtf8(cls_warning),
    SysToUtf8(cls_lossdata_q + cls_sure_q), mtWarning,
    [mrYes, SysToUtf8(cls_yes), mrNo, SysToUtf8(cls_no)], 0) = mrYes;
end;
//---------------------------------------------------------------------------
procedure TAbstractManager.SavingErrorMsg();
begin

end;
//---------------------------------------------------------------------------
function TAbstractManager.CheckEntityFields(): boolean;
begin
  Result := true;
end;
//---------------------------------------------------------------------------
function TAbstractManager.DlgChangesCommit(): TModalResult;
begin
  Result := mrYes;
  if (ManagerState in [msEntityCreation, msEntityEdit]) then
    begin
      if (not CheckEntityFields()) then
        begin
          Result := mrRetry;
          exit;
        end;
      Result := QuestionDlg(SysToUtf8(cls_warning),
        SysToUtf8(cls_data_commit_q + cls_sure_q), mtWarning,
        [mrYes, SysToUTF8(cls_yes), mrNo, SysToUtf8(cls_no),
         mrCancel, SysToUTF8(cls_cancel)], 0);
      if (Result = mrYes) then
        begin
          LoadDataInEntity();
          if (Target.DB_Save() = false) then
            begin
              SavingErrorMsg();
              Result := mrRetry;
            end
          else
            begin
              FManagerState := msEntitySearch;
              SetManagerState(msEntityView);
            end;
        end
      else if (Result <> mrCancel) then
        begin
          FManagerState := msEntitySearch;
          SetManagerState(msEntityView);
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure TAbstractManager.DoApply();
begin
  if (Assigned(FOnApply)) then FOnApply(Self);
end;
//---------------------------------------------------------------------------
function TAbstractManager.MakeNewEntity(): boolean;
begin
  Result        := false;
  ManagerState  := msEntityCreation;
  // Пользователь не разрешил изменения.
  if (ManagerState <> msEntityCreation) then exit;
  // Переинициализирую экземпляр.
  Target.Assign(nil);
  try
    ChangesBlocked := true;
    ListData();
  finally
    ChangesBlocked := false;
  end;
  Result := true;
end;
//---------------------------------------------------------------------------
end.
