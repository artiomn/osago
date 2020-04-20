unit orm_abstract;

//
// Модуль базовых классов объектного представления.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, db, logger;

type

//
// Абстрактная сущность.
//

TEntityesCollection = class;
TEntity = class;

TLoadType = (ltAuto, ltNew, ltSaved);
TEntityNotifyEvent = procedure(Sender: TEntity) of object;

TEntity = class(TCollectionItem)
private
  FDataSource: TDataSource;
  FSaved: boolean;
  FIsNew: boolean;
  FOnChanged: TEntityNotifyEvent;
  FOnDBDeletion: TEntityNotifyEvent;
  FOnDestroy: TEntityNotifyEvent;
protected
  // Устанавливает поля сущности, при её переинициализации.
  procedure ReInitEntity(); virtual;
  // Устанавливает поля сущности, при её загрузке из базы.
  function SetEntityData(): boolean; virtual; abstract;
protected
  // Вызывается сущностью, при добавлении новой записи в БД.
  function InsertRecord(): boolean; virtual; abstract;
  // Вызывается функцией DB_Load, при загрузке новой сущности из БД.
  function LoadNewRecord(): boolean; virtual;
  // Вызывается функцией DB_Load, при загрузке новой сущности из БД.
  function LoadSavedRecord(): boolean; virtual; abstract;
  // Вызывается функцией DB_Save сущности, при изменении существующей в БД
  // записи.
  function UpdateRecord(): boolean; virtual; abstract;
  // Вызывается функцией DB_Delete сущности, при удалении сущности из БД.
  function DeleteRecord(): boolean; virtual; abstract;
protected
  procedure DoOnChanged();
  procedure DoOnDBDeletion();
  procedure DoOnDestroy();
  property OnChanged: TEntityNotifyEvent read FOnChanged write FOnChanged;
  property OnDBDeletion: TEntityNotifyEvent read FOnDBDeletion
    write FOnDBDeletion;
  property OnDestroy: TEntityNotifyEvent read FOnDestroy write FOnDestroy;
  // Узнать сохранены ли изменения.
  property IsSaved: boolean read FSaved write FSaved;
  // Это вновь созданная запись или, загруженная из БД.
  property IsNew: boolean read FIsNew write FIsNew;
protected
  // Коллекция-владелец.
  function GetCollection(): TEntityesCollection;
  function GetDisplayName(): string; override;

public
  // Загрузить из БД.
  function DB_Load(const load_type: TLoadType = ltAuto): boolean; virtual;
  // Сохранить в БД.
  function DB_Save(): boolean; virtual;
  // Удалить данную сущность.
  function DB_Delete(): boolean; virtual;
  // Удалить данный объект.
  procedure DeleteSelf();
  // Проверить соответствие ID.
  function CheckID(const id_fields: array of variant): boolean;
    virtual; abstract;
  // Проверить не обновилась ли сущность в БД (если существует).
  function DB_IsUpdated(): boolean; virtual;
  // Скопировать поля источника в данную запись.
  // Если передаётся nil - запись очищается и приводится в нач. положение.
  procedure Assign(Source: TEntity); virtual;
public
  // Источник данных, для загрузки.
  property DataSource: TDataSource read FDataSource write FDataSource;
public
  constructor Create(ACollection: TCollection); override;
  destructor Destroy; override;
end;

TEntityClass = class of TEntity;

//
// Коллекция сущностей.
//

TEntityesCollection = class(TCollection)
private
  // Нужно для создания сущности.
  FEntityesClass: TEntityClass;
  FItemIndex: integer;
protected
  function GetItem(const AIndex: Integer): TEntity;
  procedure SetItem(const AIndex: Integer; const AValue: TEntity);
  procedure SetItemIndex(const value: integer);
public
  // Создать сущность.
  function Add(): TEntity;
  // Получить сущность по ID.
  function GetEntityByID(const id_fields: array of variant): TEntity;
  // Получить индекс заданной сущности или -1.
  function GetEntityIndex(const ent: TEntity): integer;
  // Проверить существует ли сущность по ID (без получения всех данных).
  function EntityExists(const id_fields: array of variant): boolean;
  // Проверить содержится ли данная сущность в коллекции.
  function EntityExists(const ent: TEntity): boolean;
  // Удалить сущность с заданным ID из БД.
  function DB_DelEntity(const id_fields: array of variant): boolean;
  // Удалить сущность с заданным ID из коллекции.
  function DelEntity(const id_fields: array of variant): boolean;
public
  procedure Assign(Source: TPersistent); override;
public
  // Элементы.
  property Items[AIndex: Integer]: TEntity read GetItem write SetItem; default;
  // Текущий элемент.
  property ItemIndex: integer read FItemIndex write SetItemIndex;
public
  constructor Create(AItemClass: TEntityClass); virtual;
  destructor Destroy; override;
public

end;

implementation

//
// TEntity.
//

constructor TEntity.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FIsNew := true;
end;
//---------------------------------------------------------------------------
destructor TEntity.Destroy;
begin
  DoOnDestroy();
  inherited;
end;
//---------------------------------------------------------------------------
procedure TEntity.ReInitEntity();
begin
  FIsNew  := true;
  FSaved  := false;
end;
//---------------------------------------------------------------------------
procedure TEntity.DoOnChanged();
begin
  IsSaved := false;
  if (Assigned(FOnChanged)) then FOnChanged(Self);
end;
//---------------------------------------------------------------------------
procedure TEntity.DoOnDBDeletion();
begin
  IsSaved := false;
  IsNew   := true;
  if (Assigned(FOnDBDeletion)) then FOnDBDeletion(Self);
end;
//---------------------------------------------------------------------------
procedure TEntity.DoOnDestroy();
begin
  if (Assigned(FOnDestroy)) then FOnDestroy(Self);
end;
//---------------------------------------------------------------------------
function TEntity.GetCollection(): TEntityesCollection;
begin
  Result  := TEntityesCollection(Collection);

end;
//---------------------------------------------------------------------------
function TEntity.GetDisplayName(): string;
begin
  // Не используется.
  Result := EmptyStr;
  if (Result = EmptyStr) then Result := inherited GetDisplayName();
end;
//---------------------------------------------------------------------------
function TEntity.LoadNewRecord(): boolean;
begin
  Result := false;
  try
    if ((DataSource = nil) or (DataSource.DataSet = nil)) then exit;
    with (DataSource.DataSet) do if (not Active) then Open();
    Result := true;
  except
    LogException('TEntity.LoadNewRecord:');
  end;
end;
//---------------------------------------------------------------------------
function TEntity.DB_Load(const load_type: TLoadType): boolean;
var lt: TLoadType;
begin
  Result  := false;
  lt      := load_type;
  // IsSaved не учитывается, поскольку, возможна принудительная загрузка
  // (запись обновилась в БД, но это не было учтено).
  if (IsNew) then
    begin
      if (lt = ltAuto) then lt := ltNew;
      IsNew   := false;
      IsSaved := true;
    end
  else
    begin
      if (lt = ltAuto) then lt := ltSaved;
      IsSaved := true;
    end;
  if (lt = ltNew) then Result := LoadNewRecord()
  else Result := LoadSavedRecord();
  if (Result) then Result := SetEntityData();
end;
//---------------------------------------------------------------------------
function TEntity.DB_Save(): boolean;
begin
  Result := false;
  if ((not IsNew) and IsSaved) then exit;

  if (IsNew) then
    begin
      if (InsertRecord()) then
        begin
          IsSaved := true;
          IsNew   := false;
          Result  := true;
        end;
    end
  else
    begin
      if (UpdateRecord()) then
        begin
          IsSaved := true;
          Result  := true;
        end;
    end;
end;
//---------------------------------------------------------------------------
function TEntity.DB_Delete(): boolean;
begin
  Result := false;
  if (IsNew) then exit;
  if (DeleteRecord()) then
    begin
      Result  := true;
      {IsNew   := true;
      IsSaved := false;}
      // Устанавливается здесь:
      DoOnDBDeletion();
    end;
end;
//---------------------------------------------------------------------------
procedure TEntity.DeleteSelf();
var ec: TEntityesCollection;
begin
  ec := GetCollection();
  if (ec <> nil) then
    begin
      ec.Delete(ec.GetEntityIndex(Self));
      // Free сделает коллекция.
    end
  else Free;
end;
//---------------------------------------------------------------------------
function TEntity.DB_IsUpdated(): boolean;
begin
  Result := false;
end;
//---------------------------------------------------------------------------
procedure TEntity.Assign(Source: TEntity);
begin
  // Переинициализация.
  if (Source = nil) then ReInitEntity()
  else if (Source is TEntity) then
    begin
      FDataSource       := Source.FDataSource;
      FSaved            := Source.FSaved;
      FIsNew            := Source.FIsNew;
      FOnChanged        := Source.FOnChanged;
      FOnDBDeletion     := Source.FOnDBDeletion;
      FOnDestroy        := Source.FOnDestroy;
    end
  else
    inherited Assign(Source);
end;

//
// TEntityesCollection.
//

//---------------------------------------------------------------------------
function TEntityesCollection.GetItem(const AIndex: Integer): TEntity;
begin
  Result := (inherited GetItem(AIndex)) as TEntity;
end;
//---------------------------------------------------------------------------
procedure TEntityesCollection.SetItem(const AIndex: Integer;
  const AValue: TEntity);
begin
  inherited SetItem(AIndex, AValue);
end;
//---------------------------------------------------------------------------
procedure TEntityesCollection.SetItemIndex(const value: integer);
begin
  if (value >= Count) then exit;
  FItemIndex := value;
  if (FItemIndex < 0) then FItemIndex := -1;
end;
//---------------------------------------------------------------------------
function TEntityesCollection.Add(): TEntity;
begin
  Result := FEntityesClass.Create(Self);
end;
//---------------------------------------------------------------------------
function TEntityesCollection.GetEntityByID(const id_fields: array of variant):
  TEntity;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    begin
      if (Items[i].CheckID(id_fields)) then
        begin
          Result := Items[i];
          exit;
        end;
    end;
end;
//---------------------------------------------------------------------------
function TEntityesCollection.GetEntityIndex(const ent: TEntity): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    begin
      if (Items[i] = ent) then
        begin
          Result := i;
          exit;
        end;
    end;
end;
//---------------------------------------------------------------------------
function TEntityesCollection.EntityExists(const id_fields: array of variant):
  boolean;
//var i: integer;
begin
{  Result := false;
  for i := 0 to Count - 1 do
    begin
      if (Items[i].CheckID(id_fields)) then
        begin
          Result := true;
          exit;
        end;
    end;}
  Result := GetEntityByID(id_fields) <> nil;
end;
//---------------------------------------------------------------------------
function TEntityesCollection.EntityExists(const ent: TEntity):
  boolean;
begin
  Result := GetEntityIndex(ent) >= 0;
end;
//---------------------------------------------------------------------------
function TEntityesCollection.DB_DelEntity(const id_fields: array of variant):
  boolean;
var e: TEntity;
begin
  Result := false;
  e := GetEntityByID(id_fields);
  if (e = nil) then exit;
  Result := e.DB_Delete();
end;
//---------------------------------------------------------------------------
function TEntityesCollection.DelEntity(const id_fields: array of variant):
  boolean;
var e: TEntity;
begin
  Result := false;
  e := GetEntityByID(id_fields);
  if (e = nil) then exit;
  e.DeleteSelf();
  if ((e.Index = FItemIndex) or (FItemIndex >= Count)) then FItemIndex := -1;
  Result := true;
end;
//---------------------------------------------------------------------------
procedure TEntityesCollection.Assign(Source: TPersistent);
var s: TEntityesCollection;
    i: integer;
begin
  if (Source = nil) then Clear()
  else if (Source is TEntityesCollection) then
    begin
      Clear();
      s := Source as TEntityesCollection;
      for i := 0 To s.Count - 1 do
        Add.Assign(s.Items[i]);
      FEntityesClass  := s.FEntityesClass;
      FItemIndex      := s.FItemIndex;
    end
  else inherited Assign(Source);
end;
//---------------------------------------------------------------------------
constructor TEntityesCollection.Create(AItemClass: TEntityClass);
begin
  inherited Create(AItemClass);
  FEntityesClass := AItemClass;
end;
//---------------------------------------------------------------------------
destructor TEntityesCollection.Destroy;
begin
  inherited;
end;
//---------------------------------------------------------------------------
end.
