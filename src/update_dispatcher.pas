unit update_dispatcher;

//
// Модуль диспетчера обновлений.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, ExtCtrls, contnrs, data_unit, logger;

const key_parts_delim = ';';

type

// Тип обновления.
TUpdateType = (utInsert, utUpdate, utDelete, utAction);

// Тип ID записи.
TTableRecordID = array of variant;

// Тип обновления записи.
TUpdateAttr = (uaExists, uaNew, uaOld);

//
// Тип записи в таблице.
//

TTableRecord = class(TCollectionItem)
private
  FUpdType:   TUpdateType;
  FRecordIDU: string;
  FUpdAttr:   TUpdateAttr;
  FUpdTime:   TDateTime;
  FUpdUser:   string;
protected
  function GetRecordID(): TTableRecordID;
  procedure SetUpdType(const value: TUpdateType);
  procedure SetRecordIDU(const value: string);
public
  // Аттрибут обновления.
  property UpdateAttr: TUpdateAttr read FUpdAttr write FUpdAttr;
  property UpdateTime: TDateTime read FUpdTime write FUpdTime;
  property User: string read FUpdUser write FUpdUser;
public
  property UpdateType: TUpdateType read FUpdType write SetUpdType;
  property RecordID: TTableRecordID read GetRecordID;
  property RecordIDUnparsed: string read FRecordIDU write SetRecordIDU;
public
  constructor Create(ACollection: TCollection); override;
end;

//
// Обновляемая таблица.
//

TTableObject = class(TObject)
private
  FTableName:   string;
  FUpdFlag:     boolean;
  FUpdRecords:  TCollection;
protected
  function GetUpdRecords(const index: integer): TTableRecord;
  function GetRecCount(): integer;
public
  function GetRecord(const record_name: string;
    const update_type: TUpdateType): TTableRecord;
  // Добавляет запись, если такой записи ещё нет.
  function AddRecord(const record_name: string; const upd_type: TUpdateType;
    const upd_time: TDateTime; const upd_user: string): TTableRecord;
  // Удаление записи.
  procedure DelRecord(const r_index: integer);
  procedure ClearRecords();
public
  // Имя таблицы.
  property TableName: string read FTableName;
  // Флаг обновления.
  property UpdateFlag: boolean read FUpdFlag write FUpdFlag;
  // Обновлённые записи.
  property UpdatedRecords[index: integer]: TTableRecord read GetUpdRecords;
  property RecordsCount: integer read GetRecCount;
public
  constructor Create(const table_name: string);
  destructor Destroy; override;
end;

// Тип события, создаваемого, при обновлении таблицы.
TTableUpdateEvent = procedure(const table_name: string;
  const update_type: TUpdateType; const record_id: TTableRecordID;
  const user_inserter: string) of object;

//
// Диспетчер обновления таблиц.
//

TTablesRefreshDispatcher = class(TObject)
private
  FTables:    TObjectList;
  FUpdTimer:  TTimer;
  FOnUpdate:  TTableUpdateEvent;
  FOnStartUpdCycle: TNotifyEvent;
  FOnEndUpdCycle: TNotifyEvent;
  // Флаг завершения.
  FTerminating: boolean;
protected
  function GetActive(): boolean;
  procedure SetActive(const value: boolean);
protected
  function AddTableToList(const table_name: string): TTableObject;
  function GetTableByName(const table_name: string): TTableObject;
protected
  procedure DoOnUpdate(const table_name: string;
    const update_type: TUpdateType; const record_id: TTableRecordID;
    const user_inserter: string);
  procedure OnUpdateTimer(Sender: TObject);
public
  procedure ReadSettings();
  procedure Refresh();
public
  property Active: boolean read GetActive write SetActive;
  property OnUpdate: TTableUpdateEvent read FOnUpdate write FOnUpdate;
  property OnStartUpdateCycle: TNotifyEvent read FOnStartUpdCycle
    write FOnStartUpdCycle;
  property OnEndUpdateCycle: TNotifyEvent read FOnEndUpdCycle
    write FOnEndUpdCycle;
public
  constructor Create();
  destructor Destroy; override;
end;

// Тип события, создаваемого, при обновлении сущности.
TEntityUpdateEvent = procedure(const entity_id: TTableRecordID;
  const update_type: TUpdateType;
  const user_updater: string) of object;
// Тип события, создаваемого, при обновлении справочника.
TInfoUpdateEvent = procedure(const table_name: string;
  const user_updater: string) of object;

//
// Диспетчер обновлений.
//

TDBUpdateDispatcher = class(TObject)
private
  FTRDispatcher:      TTablesRefreshDispatcher;
  FOnClientUpdate:    TEntityUpdateEvent;
  FOnCarUpdate:       TEntityUpdateEvent;
  FOnContractUpdate:  TEntityUpdateEvent;
  FOnUserUpdate:      TEntityUpdateEvent;
  FOnBlanksUpdate:    TEntityUpdateEvent;
  FOnInsCompsUpdate:  TEntityUpdateEvent;
  FOnInfosVUpdate:    TInfoUpdateEvent;
  FOnInfosIVUpdate:   TInfoUpdateEvent;
  // Список обновлённых таблиц. Используется для слияния событий.
  // Для таблиц из этого списка события не генерируются.
  FTables:            TStringList;
protected
  procedure SetActive(const value: boolean);
  function GetActive(): boolean;
  procedure OnStartUpdating(Sender: TObject);
  procedure OnUpdateMsg(const table_name: string;
    const update_type: TUpdateType; const record_id: TTableRecordID;
    const user_inserter: string);
public
  procedure Refresh();
  property Active: boolean read GetActive write SetActive;
public
  property OnClientUpdate: TEntityUpdateEvent read FOnClientUpdate
    write FOnClientUpdate;
  property OnCarUpdate: TEntityUpdateEvent read FOnCarUpdate
    write FOnCarUpdate;
  property OnContractUpdate: TEntityUpdateEvent read FOnContractUpdate
    write FOnContractUpdate;
  property OnUserUpdate: TEntityUpdateEvent read FOnUserUpdate
    write FOnUserUpdate;
  property OnBlanksUpdate: TEntityUpdateEvent read FOnBlanksUpdate
    write FOnBlanksUpdate;
  property OnInsCompsUpdate: TEntityUpdateEvent read FOnInsCompsUpdate
    write FOnInsCompsUpdate;
  property OnInfosVisibleUpdate: TInfoUpdateEvent read FOnInfosVUpdate
    write FOnInfosVUpdate;
  property OnInfosInvisibleUpdate: TInfoUpdateEvent read FOnInfosIVUpdate
    write FOnInfosIVUpdate;
public
  constructor Create();
  destructor Destroy; override;
end;
//---------------------------------------------------------------------------
function DBUpdateDispatcher(): TDBUpdateDispatcher;
//---------------------------------------------------------------------------
implementation

var DBUpdDispatcherVar: TDBUpdateDispatcher;

//
// TTableRecord.
//

constructor TTableRecord.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FUpdAttr  := uaNew;
  //FUpdTime  := Now();
end;
//---------------------------------------------------------------------------
procedure TTableRecord.SetUpdType(const value: TUpdateType);
begin
  if (FUpdType = value) then exit;
  FUpdType  := value;
end;
//---------------------------------------------------------------------------
procedure TTableRecord.SetRecordIDU(const value: string);
begin
  if (FRecordIDU = value) then exit;
  FRecordIDU  := value;
end;
//---------------------------------------------------------------------------
function TTableRecord.GetRecordID(): TTableRecordID;
var i, l: integer;
    key_part: string;
begin
  SetLength(Result, 0);
  key_part := EmptyStr;

  for i := 1 to Length(FRecordIDU) do
    begin
      if (FRecordIDU[i] <> key_parts_delim) then
        key_part := key_part + FRecordIDU[i]
      else
        begin
          l := Length(Result);
          SetLength(Result, l + 1);
          Result[l] := key_part;
          key_part  := EmptyStr;
        end;
    end;

  if (key_part <> EmptyStr) then
    begin
      l := Length(Result);
      SetLength(Result, l + 1);
      Result[l] := key_part;
    end;
end;

//
// TTableObject.
//

constructor TTableObject.Create(const table_name: string);
begin
  FTableName  := table_name;
  FUpdFlag    := false;
  FUpdRecords := TCollection.Create(TTableRecord);
end;
//---------------------------------------------------------------------------
destructor TTableObject.Destroy;
begin
  FUpdRecords.Free;
  inherited;
end;
//---------------------------------------------------------------------------
function TTableObject.GetUpdRecords(const index: integer): TTableRecord;
begin
  Result := FUpdRecords.Items[index] as TTableRecord;
end;
//---------------------------------------------------------------------------
function TTableObject.GetRecCount(): integer;
begin
  Result := FUpdRecords.Count;
end;
//---------------------------------------------------------------------------
function TTableObject.GetRecord(const record_name: string;
  const update_type: TUpdateType): TTableRecord;
var i: integer;
    tr: TTableRecord;
begin
  Result := nil;
  for i := 0 to FUpdRecords.Count - 1 do
    begin
      tr := FUpdRecords.Items[i] as TTableRecord;
      if ((tr.RecordIDUnparsed = record_name) and (tr.UpdateType = update_type))
        then
          begin
            Result := tr;
            break;
          end;
    end; // for.
end;
//---------------------------------------------------------------------------
function TTableObject.AddRecord(const record_name: string;
  const upd_type: TUpdateType; const upd_time: TDateTime;
  const upd_user: string): TTableRecord;
begin
  Result := GetRecord(record_name, upd_type);
  if (Result = nil) then
    begin
      Result := FUpdRecords.Add as TTableRecord;
      if (Result = nil) then exit;
    end;
  // Надо обновлять.
  Result.RecordIDUnparsed := record_name;
  Result.UpdateType       := upd_type;
  Result.UpdateTime       := upd_time;
  Result.User             := upd_user;
end;
//---------------------------------------------------------------------------
procedure TTableObject.DelRecord(const r_index: integer);
begin
  FUpdRecords.Delete(r_index);
end;
//---------------------------------------------------------------------------
procedure TTableObject.ClearRecords();
begin
  // Коллекция разрушает записи.
  FUpdRecords.Clear;
end;

//
// TTablesRefreshDispatcher.
//

constructor TTablesRefreshDispatcher.Create();
begin
  FTerminating      := false;
  FTables           := TObjectList.Create();
  FUpdTimer         := TTimer.Create(nil);
  FUpdTimer.Enabled := false;
  FUpdTimer.OnTimer := @OnUpdateTimer;
  ReadSettings();
end;
//---------------------------------------------------------------------------
destructor TTablesRefreshDispatcher.Destroy;
var obj: TTableObject;
begin
  FTerminating      := true;
  FUpdTimer.Enabled := false;
  while (FTables.Count > 0) do
    if (FTables.Last <> nil) then
      begin
        obj := FTables.Extract(FTables.Last) as TTableObject;
        FreeAndNil(obj);
      end;
  FUpdTimer.Free;
  FTables.Free;
  inherited;
end;
//---------------------------------------------------------------------------
procedure TTablesRefreshDispatcher.SetActive(const value: boolean);
begin
  if (value = FUpdTimer.Enabled) then exit;
  if (value = true) then
    begin
      FTerminating      := false;
      Refresh();
      FUpdTimer.Enabled := true;
    end
  else
    begin
      FTerminating      := true;
      FUpdTimer.Enabled := false;
    end;
end;
//---------------------------------------------------------------------------
function TTablesRefreshDispatcher.GetActive(): boolean;
begin
  Result := FUpdTimer.Enabled;
end;
//---------------------------------------------------------------------------
function TTablesRefreshDispatcher.AddTableToList(const table_name: string):
  TTableObject;
begin
  Result := TTableObject.Create(table_name);
  FTables.Add(Result);
end;
//---------------------------------------------------------------------------
function TTablesRefreshDispatcher.GetTableByName(const table_name: string):
  TTableObject;
var i: integer;
begin
  Result := nil;
  // Временно - поиск неоптимальный.
  for i := 0 to FTables.Count - 1 do
    begin
      if ((FTables[i] as TTableObject).FTableName = table_name) then
        begin
          Result := (FTables[i] as TTableObject);
          break;
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure TTablesRefreshDispatcher.DoOnUpdate(const table_name: string;
  const update_type: TUpdateType; const record_id: TTableRecordID;
  const user_inserter: string);
begin
  if (Assigned(FOnUpdate)) then FOnUpdate(table_name, update_type, record_id,
    user_inserter);
end;
//---------------------------------------------------------------------------
procedure TTablesRefreshDispatcher.OnUpdateTimer(Sender: TObject);
begin
  Refresh();
end;
//---------------------------------------------------------------------------
procedure TTablesRefreshDispatcher.ReadSettings();
begin
  with dmData.SelfInfo() do
    begin
      Active              := true;
      FUpdTimer.Interval  := FieldByName('REFRESH_TIME').AsInteger * 1000;
    end;
end;
//---------------------------------------------------------------------------
procedure TTablesRefreshDispatcher.Refresh();
var tbl:      TTableObject;
    tbl_name: string;
    tbl_ut:   TUpdateType;
    tbl_rec:  TTableRecord;
    tm:       TDateTime;
    i, j:     integer;
begin
  if (FTerminating) then exit;
  try
    with dmData.GetPreparedChangeLog().DataSet do
      begin
        if (Assigned(FOnStartUpdCycle)) then FOnStartUpdCycle(Self);
        // Проход 1. Создание списка.
        while (not EOF) do
          begin
            tbl_name  := FieldByName('TABLE_NAME').AsString;
            tbl       := GetTableByName(tbl_name);

            if (FieldByName('ACTION_TYPE').AsString = 'i') then
              tbl_ut := utInsert
            else if (FieldByName('ACTION_TYPE').AsString = 'u') then
              tbl_ut := utUpdate
            else if (FieldByName('ACTION_TYPE').AsString = 'd') then
              tbl_ut := utDelete
            else if (FieldByName('ACTION_TYPE').AsString = 'a') then
              tbl_ut := utAction;

            tm := FieldByName('INSERT_TIME').AsDateTime;

            // Создание таблицы или добавление записей.
            if (tbl = nil) then
              begin
                tbl := AddTableToList(tbl_name);
                tbl.AddRecord(FieldByName('RECORD_ID').AsString, tbl_ut, tm,
                  FieldByName('USER_INSERTER').AsString);
                tbl.UpdateFlag := true;
              end
            else
              begin
                // Получаю запись с тем же ID и типом обновления.
                tbl_rec := tbl.GetRecord(FieldByName('RECORD_ID').AsString, tbl_ut);
                // Записи нет в списке.
                if (tbl_rec = nil) then
                  begin
                    tbl_rec := tbl.AddRecord(FieldByName('RECORD_ID').AsString,
                      tbl_ut, tm, FieldByName('USER_INSERTER').AsString);
                    tbl.UpdateFlag := true;
                  end
                else
                  begin
                    // Если время обновления данной записи меньше или равно
                    // времени обновления записи в списке. Для записи в списке,
                    // аттрибут обновления устанавливается в значение
                    // "Существует".
                    if (tm <= tbl_rec.UpdateTime) then
                      tbl_rec.UpdateAttr := uaExists
                    else
                      begin
                        // Время обновления данной записи больше времени
                        // обновления записи в списке. Для записи в списке,
                        // аттрибут обновления устанавливается в значение
                        // "Обновлена". Время обновления переустанавливается.
                        tbl_rec.UpdateAttr  := uaNew;
                        tbl_rec.UpdateTime  := tm;
                        tbl.UpdateFlag      := true;
                      end;
                  end;

              end; // if (NEW_TABLE) ... else
            Next();
          end; // while
      end; // with
  except
    LogException();
    Active := false;
    raise;
  end;
  // Проход 2. Создание сообщений.
  for i := 0 to FTables.Count - 1 do
    if ((FTables[i] as TTableObject).UpdateFlag) then
      begin
        (FTables[i] as TTableObject).UpdateFlag := false;
        with (FTables[i] as TTableObject) do
          for j := 0 to RecordsCount - 1 do
            begin
              if (j >= RecordsCount) then break;
              case (UpdatedRecords[j].UpdateAttr) of
                uaExists:
                  UpdatedRecords[j].UpdateAttr := uaOld;
                uaNew:
                  begin
                    try
                      DoOnUpdate(TableName, UpdatedRecords[j].UpdateType,
                        UpdatedRecords[j].RecordID, UpdatedRecords[j].User);
                      UpdatedRecords[j].UpdateAttr := uaOld;
                    except
                      LogException();
                    end;
                  end;
                uaOld:
                  DelRecord(j);
              end; // case
            end; // fro j := 0 to RecordsCount
      end; // Table[i].UpdateFlag = true
  if (Assigned(FOnEndUpdCycle)) then FOnEndUpdCycle(Self);
end;

//
// TDBUpdateDispatcher.
//

constructor TDBUpdateDispatcher.Create();
begin
  FTRDispatcher                     := TTablesRefreshDispatcher.Create();
  FTRDispatcher.OnStartUpdateCycle  := @OnStartUpdating;
  FTRDispatcher.OnUpdate            := @OnUpdateMsg;
  FTables                           := TStringList.Create;
end;
//---------------------------------------------------------------------------
destructor TDBUpdateDispatcher.Destroy;
begin
  Active := false;
  FTables.Free();
  FTRDispatcher.Free();
  inherited;
end;
//---------------------------------------------------------------------------
procedure TDBUpdateDispatcher.SetActive(const value: boolean);
begin
  if (FTRDispatcher.Active = value) then exit;
  FTRDispatcher.Active := value;
end;
//---------------------------------------------------------------------------
function TDBUpdateDispatcher.GetActive(): boolean;
begin
  Result := FTRDispatcher.Active;
end;
//---------------------------------------------------------------------------
procedure TDBUpdateDispatcher.Refresh();
begin
  FTRDispatcher.Refresh();
end;
//---------------------------------------------------------------------------
procedure TDBUpdateDispatcher.OnStartUpdating(Sender: TObject);
begin
  FTables.Clear();
end;
//---------------------------------------------------------------------------
procedure TDBUpdateDispatcher.OnUpdateMsg(const table_name: string;
  const update_type: TUpdateType; const record_id: TTableRecordID;
  const user_inserter: string);
begin
  if ((table_name = 'base_sum') or (table_name = 'ins_koefs_km') or
      (table_name = 'ins_koefs_ko') or (table_name = 'ins_koefs_kp') or
      (table_name = 'ins_koefs_ks') or (table_name = 'ins_koefs_kvs') or
      (table_name = 'ins_koefs_other') or (table_name = 'territory_use') or
      (table_name = 'ins_koefs_foreing') or (table_name = 'ins_formula') or
      (table_name = 'ins_formula_conf') or (table_name = 'ins_formula_type')) then
  // Тип 1.
    begin
      if (FTables.IndexOf(table_name) < 0) then
        begin
          if (Assigned(FOnInfosIVUpdate)) then
            FOnInfosIVUpdate(table_name, user_inserter);
          FTables.Add(table_name);
        end;
    end
  else if ((table_name = 'client_types') or (table_name = 'car_type') or
           (table_name = 'carmark') or (table_name = 'car_model') or
           (table_name = 'family_state') or
           (table_name = 'insurance_class') or (table_name = 'purpose_type') or
           (table_name = 'country') or (table_name = 'region') or
           (table_name = 'city') or (table_name = 'sex') or
           (table_name = 'type_doc') or (table_name = 'valuta'))
  // Тип 2.
    then
      begin
      if (FTables.IndexOf(table_name) < 0) then
        begin
          if (Assigned(FOnInfosVUpdate)) then
            FOnInfosVUpdate(table_name, user_inserter);
          FTables.Add(table_name);
        end;
      end
  else if  (table_name = 'blanks_journal') then
  // Тип 3.
    begin
      if (Assigned(FOnBlanksUpdate)) then
        FOnBlanksUpdate(record_id, update_type, user_inserter);
    end
  else if (table_name = 'insurance_company') then
  // Тип 3.
    begin
      if (Assigned(FOnInsCompsUpdate)) then
        FOnInsCompsUpdate(record_id, update_type, user_inserter);
    end
  else if (table_name = 'client') then
  // Тип 4.
    begin
      if (Assigned(FOnClientUpdate)) then
        FOnClientUpdate(record_id, update_type, user_inserter);
    end
  else if (table_name = 'car') then
  // Тип 4.
    begin
      if (Assigned(FOnCarUpdate)) then
        FOnCarUpdate(record_id, update_type, user_inserter);
    end
  else if (table_name = 'dogovor') then
  // Тип 4.
    begin
      if (Assigned(FOnContractUpdate)) then
        FOnContractUpdate(record_id, update_type, user_inserter);
    end
  else if (table_name = 'user_data') then
  // Тип 5.
    begin
      if (Assigned(FOnUserUpdate)) then
        FOnUserUpdate(record_id, update_type, user_inserter);
    end;
end;
//---------------------------------------------------------------------------
function DBUpdateDispatcher(): TDBUpdateDispatcher;
begin
  if (DBUpdDispatcherVar = nil) then
    begin
      DBUpdDispatcherVar := TDBUpdateDispatcher.Create();
    end;
  Result := DBUpdDispatcherVar;
end;
//---------------------------------------------------------------------------
initialization

DBUpdDispatcherVar := nil;

end.

