unit orm_group; 

//
// Модуль объектного представления группы пользователя.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, variants, ZSysUtils, db, data_unit,
  orm_abstract, common_functions, logger;

//
// TGroupEntity.
//

var GroupsCollection: TEntityesCollection;

// Загружает группы в коллекцию.
procedure LoadGroups();

type

TGroupPrivs = (Priv_cln_add, Priv_cln_chg, Priv_cln_del,
  Priv_car_add, Priv_car_chg, Priv_car_del, Priv_cont_add, Priv_cont_chg,
  Priv_cont_del, Priv_cont_prolong, Priv_cont_replace, Priv_cont_close,
  Priv_user_add, Priv_user_chg, Priv_user_del, Priv_group_add, Priv_group_chg,
  Priv_group_del, Priv_blanks, Priv_infos_edit);

TGroupEntity = class(TEntity)
private
  FIDGroup: variant;
  FGroupName: variant;
  FGroupDescr: TStringList;
  FGroupPrivs: array[Low(TGroupPrivs)..High(TGroupPrivs)] of boolean;
private
  procedure ReInitEntity(); override;
protected
  procedure SetID(const value: variant);
  procedure SetPriv(const AIndex: TGroupPrivs; value: boolean);
  function GetPriv(const AIndex: TGroupPrivs): boolean;
  procedure SetGroupName(const value: variant);
  procedure SetGroupDescr(const value: TStringList);
protected
  function SetEntityData(): boolean; override;
  function InsertRecord(): boolean; override;
  function LoadSavedRecord(): boolean; override;
  function UpdateRecord(): boolean; override;
  function DeleteRecord(): boolean; override;
  procedure Assign(Source: TEntity); override;
public
  constructor Create(ACollection: TCollection); override;
  destructor Destroy; override;
public
  function CheckID(const id_fields: array of variant): boolean;
    override;
public
  property IDGroup: variant read FIDGroup;
  property GroupName: variant read FGroupName write SetGroupName;
  property GroupDescr: TStringList read FGroupDescr write SetGroupDescr;
  property Privileges[AIndex: TGroupPrivs]: boolean read GetPriv write SetPriv;
    default;
end;

implementation
//---------------------------------------------------------------------------
constructor TGroupEntity.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FGroupDescr := TStringList.Create();
end;
//---------------------------------------------------------------------------
destructor TGroupEntity.Destroy;
begin
  FGroupDescr.Free;
  inherited;
end;
//---------------------------------------------------------------------------
function TGroupEntity.GetPriv(const AIndex: TGroupPrivs): boolean;
begin
  if ((AIndex < Low(TGroupPrivs)) or (AIndex > High(TGroupPrivs))) then
    raise ERangeError.Create('Privileges array out of bounds.');
  Result := FGroupPrivs[AIndex];
end;
//---------------------------------------------------------------------------
procedure TGroupEntity.SetPriv(const AIndex: TGroupPrivs; value: boolean);
begin
  if (FGroupPrivs[AIndex] <> value) then
    begin
      FGroupPrivs[AIndex] := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TGroupEntity.SetGroupName(const value: variant);
begin
  if (FGroupName <> value) then
    begin
      FGroupName  := EncodeCString(value);
      DisplayName := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TGroupEntity.SetGroupDescr(const value: TStringList);
begin
  if (FGroupDescr <> value) then
    begin
      FGroupDescr.Assign(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TGroupEntity.SetID(const value: variant);
begin
  if (FIDGroup <> value) then
    begin
      FIDGroup  := EncodeCString(value);
      IsNew     := false;
    end;
end;
//---------------------------------------------------------------------------
function TGroupEntity.CheckID(const id_fields: array of variant): boolean;
begin
  Result := false;
  if (Length(id_fields) <> 1) then exit;
  Result := VarSameValue(FIDGroup, id_fields[0]);
end;
//---------------------------------------------------------------------------
function TGroupEntity.SetEntityData(): boolean;
begin
  Result := false;
  if ((DataSource = nil) or (DataSource.DataSet = nil)) then exit;
  with DataSource.DataSet do
  try
    FIDGroup          := FieldByName('ID_GROUP').AsVariant;
    FGroupName        := FieldByName('GROUP_NAME').AsVariant;
    FGroupDescr.Text  := FieldByName('GROUP_DESCR').AsString;

    FGroupPrivs[Priv_cln_add]       :=
      VarToBool(FieldByName('PRIV_CLN_ADD').AsVariant);
    FGroupPrivs[Priv_cln_chg]       :=
      VarToBool(FieldByName('PRIV_CLN_CHG').AsVariant);
    FGroupPrivs[Priv_cln_del]       :=
      VarToBool(FieldByName('PRIV_CLN_DEL').AsVariant);
    FGroupPrivs[Priv_car_add]       :=
      VarToBool(FieldByName('PRIV_CAR_ADD').AsVariant);
    FGroupPrivs[Priv_car_chg]       :=
      VarToBool(FieldByName('PRIV_CAR_CHG').AsVariant);
    FGroupPrivs[Priv_car_del]       :=
      VarToBool(FieldByName('PRIV_CAR_DEL').AsVariant);
    FGroupPrivs[Priv_cont_add]      :=
      VarToBool(FieldByName('PRIV_CONT_ADD').AsVariant);
    FGroupPrivs[Priv_cont_chg]      :=
      VarToBool(FieldByName('PRIV_CONT_CHG').AsVariant);
    FGroupPrivs[Priv_cont_del]      :=
      VarToBool(FieldByName('PRIV_CONT_DEL').AsVariant);
    FGroupPrivs[Priv_cont_prolong]  :=
      VarToBool(FieldByName('PRIV_CONT_PROLONG').AsVariant);
    FGroupPrivs[Priv_cont_replace]  :=
      VarToBool(FieldByName('PRIV_CONT_REPLACE').AsVariant);
    FGroupPrivs[Priv_cont_close]    :=
      VarToBool(FieldByName('PRIV_CONT_CLOSE').AsVariant);
    FGroupPrivs[Priv_user_add]      :=
      VarToBool(FieldByName('PRIV_USER_ADD').AsVariant);
    FGroupPrivs[Priv_user_chg]      :=
      VarToBool(FieldByName('PRIV_USER_CHG').AsVariant);
    FGroupPrivs[Priv_user_del]      :=
      VarToBool(FieldByName('PRIV_USER_DEL').AsVariant);
    FGroupPrivs[Priv_group_add]     :=
      VarToBool(FieldByName('PRIV_GROUP_ADD').AsVariant);
    FGroupPrivs[Priv_group_chg]     :=
      VarToBool(FieldByName('PRIV_GROUP_CHG').AsVariant);
    FGroupPrivs[Priv_group_del]     :=
      VarToBool(FieldByName('PRIV_GROUP_DEL').AsVariant);
    FGroupPrivs[Priv_blanks]        :=
      VarToBool(FieldByName('PRIV_BLANKS').AsVariant);
    FGroupPrivs[Priv_infos_edit]    :=
      VarToBool(FieldByName('PRIV_INFOS_EDIT').AsVariant);

    Result := true;
  except
    LogException('TGroupEntity.SetEntityData:');
    exit;
  end;
end;
//---------------------------------------------------------------------------
function TGroupEntity.InsertRecord(): boolean;
begin
  Result := false;
{  with (dmData.zqProc) do
  try
    ParamByName('').AsString := F;

    ExecSQL();

    if (dmData.GetErrCode() <> 0) then
      begin
        Result := false;
        exit;
      end;
    FID := dmData.GetLastInsertID();
  except
    on E: Exception do LogException(E);
    Result := false;
  end;}
end;
//---------------------------------------------------------------------------
function TGroupEntity.UpdateRecord(): boolean;
begin
  Result := false;
{  with (dmData.zqProc) do
  try
    ParamByName('id_').AsString := FID;

    ExecSQL();
    Result := (dmData.GetErrCode() = 0);
  except
    on E: Exception do LogException(E);
    Result := false;
  end;}
end;
//---------------------------------------------------------------------------
function TGroupEntity.LoadSavedRecord(): boolean;
begin
  Result := false;
  with (DataSource.DataSet) do
  try
    if (Active) then
      Result := Locate('ID_GROUP', VarArrayOf([FIDGroup]), [loCaseInsensitive]);
  except
    LogException('TGroupEntity.LoadSavedRecord:');
  end;
end;
//---------------------------------------------------------------------------
function TGroupEntity.DeleteRecord(): boolean;
begin
  Result := false;
{  with (dmData.zqProc) do
  try
    ParamByName('id_').AsString := ID_;
    ExecSQL();
    Result := (dmData.GetErrCode(Connection) = 0);
  except
    on E: Exception do LogException(E);
    Result := false;
  end;}
end;
//---------------------------------------------------------------------------
procedure TGroupEntity.ReInitEntity();
var i: TGroupPrivs;
begin
  inherited;
  FIDGroup    := Null;
  FGroupName  := Null;
  FGroupDescr.Clear();

  for i := Low(TGroupPrivs) to High(TGroupPrivs)
    do FGroupPrivs[i] := false;
end;
//---------------------------------------------------------------------------
procedure TGroupEntity.Assign(Source: TEntity);
var s: TGroupEntity;
    i: TGroupPrivs;
begin
  inherited Assign(Source);
  if (Source = nil) then exit;

  if (not (Source is TGroupEntity)) then exit;
  s := Source as TGroupEntity;

  FIDGroup    := s.FIDGroup;
  FGroupName  := s.FGroupName;
  FGroupDescr.Assign(s.FGroupDescr);

  for i := Low(TGroupPrivs) to High(TGroupPrivs)
    do FGroupPrivs[i] := s.FGroupPrivs[i];
end;
//---------------------------------------------------------------------------

//
// LoadGroups().
//

procedure LoadGroups();
var grp: TGroupEntity;
begin
  if (GroupsCollection = nil) then exit;
  GroupsCollection.BeginUpdate;
  GroupsCollection.Clear;
  try
    with dmData.myGetGroups do
    begin
      Open();
      First();
      while (not EOF)
        do
          begin
            grp := GroupsCollection.Add() as TGroupEntity;
            if (grp = nil) then exit;
            grp.DataSource := dmData.datasrcGroups;//DataSource;
            if (not grp.DB_Load(ltNew)) then exit;
            Next();
          end;
    end;
  finally
    GroupsCollection.EndUpdate;
  end;
end;
//---------------------------------------------------------------------------

end.

