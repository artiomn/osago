unit orm_user; 

//
// Модуль объектного представления пользователя программы.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, variants, Forms, ZSysUtils, db, data_unit,
  orm_abstract, orm_group, common_functions, logger;

type TUserEntity = class;

var CurrentUser: TUserEntity;

type

//
// TUserEntity.
//

TUserEntity = class(TEntity)
private
  FHost: variant;
  FUser: variant;
  FOldHost: variant;
  FOldUser: variant;
  FIDGroup: variant;
  FUserSurname: variant;
  FUserName: variant;
  FUserPathr: variant;
  FAddress: variant;
  FPhoneHome: variant;
  FCellPhone: variant;
  FComments: TStringList;
  FPassword: variant;
  // Настройки из другой таблицы.
  FMwWidth: variant;
  FMwHeight: variant;
  FMwLeft: variant;
  FMwTop: variant;
  FMwState: TWindowState;
  FUseHelper: boolean;
  FFirstRun: boolean;
private
  procedure ReInitEntity(); override;
protected
  // [0] - Host, [1] - User.
  procedure SetID(const value: array of variant);
  procedure SetUser(const value: variant);
  procedure SetHost(const value: variant);
  procedure SetIDGroup(const value: variant);
  procedure SetUserSurname(const value: variant);
  procedure SetUserName(const value: variant);
  procedure SetUserPathr(const value: variant);
  procedure SetAddress(const value: variant);
  procedure SetPhoneHome(const value: variant);
  procedure SetCellPhone(const value: variant);
  procedure SetComments(const value: TStringList);
  procedure SetPassword(const value: variant);
  procedure SetMwWidth(const value: variant);
  procedure SetMwHeight(const value: variant);
  procedure SetMwLeft(const value: variant);
  procedure SetMwTop(const value: variant);
  procedure SetMwState(const value: TWindowState);
  procedure SetUseHelper(const value: boolean);
  procedure SetFirstRun(const value: boolean);
private
  function GetUserGroup(): TGroupEntity;
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
  property Host: variant read FHost write SetHost;
  property User: variant read FUser write SetUser;
  property IDGroup: variant read FIDGroup write SetIDGroup;
  // Динамически возвращается из коллекции.
  property UserGroup: TGroupEntity read GetUserGroup;
  property UserSurname: variant read FUserSurname write SetUserSurname;
  property UserName: variant read FUserName write SetUserName;
  property UserPathronimyc: variant read FUserPathr write SetUserPathr;
  property Address: variant read FAddress write SetAddress;
  property PhoneHome: variant read FPhoneHome write SetPhoneHome;
  property CellPhone: variant read FCellPhone write SetCellPhone;
  property Comments: TStringList read FComments write SetComments;
  // Устанавливается в NULL, при загрузке или сохранении сущности.
  property Password: variant read FPassword write SetPassword;
  // Настройки из другой таблицы.
  property MwWidth: variant read FMwWidth write SetMwWidth;
  property MwHeight: variant read FMwHeight write SetMwHeight;
  property MwLeft: variant read FMwLeft write SetMwLeft;
  property MwTop: variant read FMwTop write SetMwTop;
  property MwState: TWindowState read FMwState write SetMwState;
  property UseHelper: boolean read FUseHelper write SetUseHelper;
  property FirstRun: boolean read FFirstRun write SetFirstRun;
public
  function SaveSettings(): boolean;
end;

implementation
//---------------------------------------------------------------------------
constructor TUserEntity.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FComments := TStringList.Create();
end;
//---------------------------------------------------------------------------
destructor TUserEntity.Destroy;
begin
  FComments.Free;
  inherited;
end;
//---------------------------------------------------------------------------
function TUserEntity.GetUserGroup(): TGroupEntity;
begin
  Result := GroupsCollection.GetEntityByID([IDGroup]) as TGroupEntity;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetIDGroup(const value: variant);
begin
  if (FIDGroup <> value) then
    begin
      FIDGroup := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetUser(const value: variant);
begin
  if (FUser <> value) then
    begin
      FUser := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetHost(const value: variant);
begin
  if (FHost <> value) then
    begin
      FHost := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetUserSurname(const value: variant);
begin
  if (FUserSurname <> value) then
    begin
      FUserSurname  := EncodeCString(value);
      DisplayName   := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetUserName(const value: variant);
begin
  if (FUserName <> value) then
    begin
      FUserName := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetUserPathr(const value: variant);
begin
  if (FUserPathr <> value) then
    begin
      FUserPathr := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetAddress(const value: variant);
begin
  if (FAddress <> value) then
    begin
      FAddress := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetPhoneHome(const value: variant);
begin
  if (FPhoneHome <> value) then
    begin
      FPhoneHome := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetCellPhone(const value: variant);
begin
  if (FCellPhone <> value) then
    begin
      FCellPhone := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetComments(const value: TStringList);
begin
  if (FComments <> value) then
    begin
      FComments.Assign(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetPassword(const value: variant);
begin
  if (FPassword <> value) then
    begin
      FPassword := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetMwWidth(const value: variant);
begin
  if (FMwWidth <> value) then
    begin
      FMwWidth := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetMwHeight(const value: variant);
begin
  if (FMwHeight <> value) then
    begin
      FMwHeight := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetMwLeft(const value: variant);
begin
  if (FMwLeft <> value) then
    begin
      FMwLeft := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetMwTop(const value: variant);
begin
  if (FMwTop <> value) then
    begin
      FMwTop := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetMwState(const value: TWindowState);
begin
  if (FMwState <> value) then
    begin
      FMwState := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetUseHelper(const value: boolean);
begin
  if (FUseHelper <> value) then
    begin
      FUseHelper := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetFirstRun(const value: boolean);
begin
  if (FFirstRun <> value) then
    begin
      FFirstRun := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
function TUserEntity.SaveSettings(): boolean;
begin
  Result := true;
  with (dmData.mySaveCurUserSettings) do
  try
    ParamByName('v_mw_width').AsInteger   := FMwWidth;
    ParamByName('v_mw_height').AsInteger  := FMwHeight;
    ParamByName('v_mw_left').AsInteger    := FMwLeft;
    ParamByName('v_mw_top').AsInteger     := FMwTop;
    ParamByName('v_mw_state').AsBoolean   := FMwState = wsMaximized;
    ParamByName('v_use_helper').AsBoolean := VarToBool(FUseHelper);
    ParamByName('v_first_run').AsBoolean  := VarToBool(FFirstRun);

    Execute();

  except
    LogException('TUserEntity.SaveSettings:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.SetID(const value: array of variant);
// [0] - Host, [1] - User.
begin
  if ((FHost <> value[0]) or (FUser <> value[1])) then
    begin
      if (Length(value) <> 2) then exit;
      FHost := EncodeCString(value[0]);
      FUser := EncodeCString(value[1]);
      IsNew := false;
    end;
end;
//---------------------------------------------------------------------------
function TUserEntity.CheckID(const id_fields: array of variant): boolean;
begin
  Result := false;
  if (Length(id_fields) <> 2) then exit;
  Result := VarSameValue(FHost, id_fields[0])
    and VarSameValue(FUser, id_fields[1]);
end;
//---------------------------------------------------------------------------
function TUserEntity.SetEntityData(): boolean;
begin
  Result := false;
  if ((DataSource = nil) or (DataSource.DataSet = nil)) then exit;
  with DataSource.DataSet do
  try
    FUser           := FieldByName('User').AsVariant;
    FHost           := FieldByName('Host').AsVariant;
    FOldHost        := FHost;
    FOldUser        := FUser;
    FIDGroup        := FieldByName('ID_GROUP').AsVariant;
    FUserSurname    := FieldByName('SURNAME').AsVariant;
    FUserName       := FieldByName('NAME').AsVariant;
    FUserPathr      := FieldByName('PATHRONIMYC').AsVariant;
    FAddress        := FieldByName('ADDRESS').AsVariant;
    FPhoneHome      := FieldByName('HOME_PHONE').AsVariant;
    FCellPhone      := FieldByName('CELL_PHONE').AsVariant;
    FComments.Text  := FieldByName('COMMENTS').AsString;
    FPassword       := Null;
    // Настройки из другой таблицы.
    FMwWidth        := FieldByName('MW_WIDTH').AsVariant;
    FMwHeight       := FieldByName('MW_HEIGHT').AsVariant;
    FMwLeft         := FieldByName('MW_LEFT').AsVariant;
    FMwTop          := FieldByName('MW_TOP').AsVariant;
    if (VarToBool(FieldByName('MW_STATE').AsVariant)) then
      FMwState := wsMaximized
    else
      FMwState := wsNormal;
    FUseHelper      := VarToBool(FieldByName('USE_HELPER').AsVariant);
    FFirstRun       := VarToBool(FieldByName('FIRST_RUN').AsVariant);

    Result := true;
  except
    LogException('TUserEntity.SetEntityData:');
    exit;
  end;
end;
//---------------------------------------------------------------------------
function TUserEntity.InsertRecord(): boolean;
begin
  Result := true;
  with (dmData.SQLAction(dmData.myProcUserMain, atInsert)) do
  try
    ParamByName('v_user_name').AsString   := VarToStr(FUser);
    ParamByName('v_user_host').AsString   := VarToStr(FHost);
    if (FPassword <> Null) then
      begin
        ParamByName('v_password').AsString  := VarToStr(FPassword);
        FPassword                           := Null;
      end;
    ParamByName('v_surname').AsString     := VarToStr(FUserSurname);
    ParamByName('v_name').AsString        := VarToStr(FUserName);
    ParamByName('v_pathr').AsString       := VarToStr(FUserPathr);
    ParamByName('v_address').AsString     := VarToStr(FAddress);
    ParamByName('v_home_phone').AsString  := VarToStr(FPhoneHome);
    ParamByName('v_cell_phone').AsString  := VarToStr(FCellPhone);
    ParamByName('v_id_group').AsString    := VarToStr(FIDGroup);
    ParamByName('v_comments').AsString    := FComments.Text;

    Execute();

    Result := (dmData.GetErrCode(Connection) = 0);

  except
    LogException('TUserEntity.InsertRecord:');
    Result := false;
  end;

  if (Result) then
    begin
      FOldHost  := FHost;
      FOldUser  := FUser;
    end;
end;
//---------------------------------------------------------------------------
function TUserEntity.UpdateRecord(): boolean;
begin
  Result := true;
  with (dmData.SQLAction(dmData.myProcUserMain, atUpdate)) do
  try
    ParamByName('v_old_user_name').AsString := VarToStr(FOldUser);
    ParamByName('v_old_user_host').AsString := VarToStr(FOldHost);
    ParamByName('v_new_user_name').AsString := VarToStr(FUser);
    ParamByName('v_new_user_host').AsString := VarToStr(FHost);
    if (FPassword <> Null) then
      begin
        ParamByName('v_password').AsString  := VarToStr(FPassword);
        //FPassword                           := Null;
      end;
    ParamByName('v_surname').AsString     := VarToStr(FUserSurname);
    ParamByName('v_name').AsString        := VarToStr(FUserName);
    ParamByName('v_pathr').AsString       := VarToStr(FUserPathr);
    ParamByName('v_address').AsString     := VarToStr(FAddress);
    ParamByName('v_home_phone').AsString  := VarToStr(FPhoneHome);
    ParamByName('v_cell_phone').AsString  := VarToStr(FCellPhone);
    ParamByName('v_id_group').AsString    := VarToStr(FIDGroup);
    ParamByName('v_comments').AsString    := FComments.Text;

    Execute();

    // Здесь SaveSettings() не нужен.
    Result := (dmData.GetErrCode(Connection) = 0);
  except
    LogException('TUserEntity.UpdateRecord:');
    Result := false;
  end;

  if (Result) then
    begin
      FOldHost  := FHost;
      FOldUser  := FUser;
    end;
end;
//---------------------------------------------------------------------------
function TUserEntity.LoadSavedRecord(): boolean;
begin
  Result := false;
  with (DataSource.DataSet) do
  try
    if (Active) then
      Result := Locate('Host;User', VarArrayOf([Host, User]), [loCaseInsensitive]);
  except
    LogException('TUserEntity.LoadSavedRecord:');
  end;
end;
//---------------------------------------------------------------------------
function TUserEntity.DeleteRecord(): boolean;
begin
  Result := true;
  with (dmData.SQLAction(dmData.myProcUserMain, atDelete)) do
  try
    ParamByName('v_user_name').AsString := VarToStr(FUser);
    ParamByName('v_user_host').AsString := VarToStr(FHost);
    Execute();
    Result := (dmData.GetErrCode(Connection) = 0);
  except
    LogException('TUserEntity.DeleteRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
procedure TUserEntity.ReInitEntity();
begin
  inherited;
  FHost         := Null;
  FUser         := Null;
  FOldHost      := Null;
  FOldUser      := Null;
  FIDGroup      := Null;
  FUserSurname  := Null;
  FUserName     := Null;
  FUserPathr    := Null;
  FAddress      := Null;
  FPhoneHome    := Null;
  FCellPhone    := Null;
  FPassword     := Null;
  // Настройки из другой таблицы.
  FMwWidth      := Null;
  FMwHeight     := Null;
  FMwLeft       := Null;
  FMwTop        := Null;
  FMwState      := wsNormal;
  FUseHelper    := false;
  FFirstRun     := false;

  FComments.Clear();
end;
//---------------------------------------------------------------------------
procedure TUserEntity.Assign(Source: TEntity);
var s: TUserEntity;
begin
  inherited Assign(Source);
  if (Source = nil) then exit;

  if (not (Source is TUserEntity)) then exit;
  s := Source as TUserEntity;

  FHost         := s.FHost;
  FUser         := s.FUser;
  FOldHost      := s.FOldHost;
  FOldUser      := s.FOldUser;
  FIDGroup      := s.FIDGroup;
  FUserSurname  := s.FUserSurname;
  FUserName     := s.FUserName;
  FUserPathr    := s.FUserPathr;
  FAddress      := s.FAddress;
  FPhoneHome    := s.FPhoneHome;
  FCellPhone    := s.FCellPhone;
  FPassword     := s.FPassword;
  // Настройки из другой таблицы.
  FMwWidth      := s.FMwWidth;
  FMwHeight     := s.FMwHeight;
  FMwLeft       := s.FMwLeft;
  FMwTop        := s.FMwTop;
  FMwState      := s.FMwState;
  FUseHelper    := s.FUseHelper;
  FFirstRun     := s.FFirstRun;

  FComments.Assign(s.FComments);
end;
//---------------------------------------------------------------------------
end.
