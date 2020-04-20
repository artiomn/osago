unit orm_car;

//
// Модуль объектного представления ТС.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, variants, ZSysUtils, MyAccess, db, data_unit,
  orm_abstract, orm_client, common_functions, logger;

var CarsCollection: TEntityesCollection;

type

//
// TCarEntity.
//

TCarEntity = class(TEntity)
private
  FIDCar: variant;
  FCarOwner: TClientEntity;
  FPtsSer: variant;
  FPtsNum: variant;
  FPtsDate: variant;
  FCarMark: variant;
  FCarMarkName: variant;
  FCarModel: variant;
  FVIN: variant;
  FYearIssue: variant;
  FPowerKWT: variant;
  FPowerHP: variant;
  FMaxMass: variant;
  FNumPlaces: variant;
  FShassiNum: variant;
  FKusovNum: variant;
  FGosNum: variant;
  FForeign: variant;
  FInRent: variant;
  FCarType: variant;
  FCarTypeName: variant;
  FPurposeUse: variant;
  FPurposeTypeName: Variant;
  FComments: TStringList;
  FDateInsert: variant;
  FDateUpdate: variant;
  FUIName: variant;
  FUUName: variant;
private
  procedure ReInitEntity(); override;
protected
  // Устанавливает ID. После установки ID, считается, что сущность уже есть в
  // базе, поскольку ID формируется сервером.
  procedure SetID(const value: variant);
  procedure SetCarOwner(const value: TClientEntity);
  procedure SetPtsSer(const value: variant);
  procedure SetPtsNum(const value: variant);
  procedure SetPtsDate(const value: variant);
  procedure SetCarMark(const value: variant);
  procedure SetCarModel(const value: variant);
  procedure SetVIN(const value: variant);
  procedure SetYearIssue(const value: variant);
  procedure SetPowerKWT(const value: variant);
  procedure SetPowerHP(const value: variant);
  procedure SetMaxMass(const value: variant);
  procedure SetNumPlaces(const value: variant);
  procedure SetShassiNum(const value: variant);
  procedure SetKusovNum(const value: variant);
  procedure SetGosNum(const value: variant);
  procedure SetForeign(const value: variant);
  procedure SetInRent(const value: variant);
  procedure SetCarType(const value: variant);
  procedure SetPurposeUse(const value: variant);
  procedure SetComments(const value: TStringList);
protected
  function SetEntityData(): boolean; override;
  function InsertRecord(): boolean; override;
  function LoadSavedRecord(): boolean; override;
  function UpdateRecord(): boolean; override;
  function DeleteRecord(): boolean; override;
  procedure Assign(Source: TEntity); override;
protected
  function GetCarMarkName(): variant;
  function GetCarTypeName(): variant;
  function GetPurposeTypeName(): variant;
public
  constructor Create(ACollection: TCollection); override;
  destructor Destroy; override;
public
  function CheckID(const id_fields: array of variant): boolean;
    override;
public
  property IDCar: variant read FIDCar write SetID;
  property CarOwner: TClientEntity read FCarOwner write SetCarOwner;
  property PtsSer: variant read FPtsSer write SetPtsSer;
  property PtsNum: variant read FPtsNum write SetPtsNum;
  property PtsDate: variant read FPtsDate write SetPtsDate;
  property IDCarMark: variant read FCarMark write SetCarMark;
  property CarMarkName: variant read GetCarMarkName;
  property CarModel: variant read FCarModel write SetCarModel;
  property VIN: variant read FVIN write SetVIN;
  property YearIssue: variant read FYearIssue write SetYearIssue;
  property PowerKWT: variant read FPowerKWT write SetPowerKWT;
  property PowerHP: variant read FPowerHP write SetPowerHP;
  property MaxMass: variant read FMaxMass write SetMaxMass;
  property NumPlaces: variant read FNumPlaces write SetNumPlaces;
  property ShassiNum: variant read FShassiNum write SetShassiNum;
  property KusovNum: variant read FKusovNum write SetKusovNum;
  property GosNum: variant read FGosNum write SetGosNum;
  property Foreign: variant read FForeign write SetForeign;
  property InRent: variant read FInRent write SetInRent;
  property IDCarType: variant read FCarType write SetCarType;
  property CarTypeName: variant read GetCarTypeName;
  property IDPurposeUse: variant read FPurposeUse write SetPurposeUse;
  property PurposeUse: variant read GetPurposeTypeName;
  property Comments: TStringList read FComments write SetComments;
  property DateInsert: variant read FDateInsert;
  property DateUpdate: variant read FDateUpdate;
  property UserInsertName: variant read FUIName;
  property UserUpdateName: variant read FUUName;
end;

implementation
//---------------------------------------------------------------------------
constructor TCarEntity.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FComments         := TStringList.Create();
  FCarOwner         := TClientEntity.Create(nil);
  FCarMarkName      := Null;
  FCarTypeName      := Null;
  FPurposeTypeName  := Null;
end;
//---------------------------------------------------------------------------
destructor TCarEntity.Destroy;
begin
  FCarOwner.Free;
  FComments.Free;
  inherited;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetCarOwner(const value: TClientEntity);
begin
  if (value = nil) then exit;
  // if (FCarOwner.IDClient <> value.IDClient) then
    begin
      FCarOwner.Assign(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetPtsSer(const value: variant);
begin
  if (FPtsSer <> value) then
    begin
      FPtsSer := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetPtsNum(const value: variant);
begin
  if (FPtsNum <> value) then
    begin
      FPtsNum := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetPtsDate(const value: variant);
begin
  if (FPtsDate <> value) then
    begin
      FPtsDate := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetCarMark(const value: variant);
begin
  if (FCarMark <> value) then
    begin
      FCarMark      := value;
      FCarMarkName  := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetCarModel(const value: variant);
begin
  if (FCarModel <> value) then
    begin
      FCarModel := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetVIN(const value: variant);
begin
  if (FVIN <> value) then
    begin
      FVIN        := EncodeCString(value);
      DisplayName := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetYearIssue(const value: variant);
begin
  if (FYearIssue <> value) then
    begin
      FYearIssue := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetPowerKWT(const value: variant);
begin
  if (FPowerKWT <> value) then
    begin
      FPowerKWT := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetPowerHP(const value: variant);
begin
  if (FPowerHP <> value) then
    begin
      FPowerHP := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetMaxMass(const value: variant);
begin
  if (FMaxMass <> value) then
    begin
      FMaxMass := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetNumPlaces(const value: variant);
begin
  if (FNumPlaces <> value) then
    begin
      FNumPlaces := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetShassiNum(const value: variant);
begin
  if (FShassiNum <> value) then
    begin
      FShassiNum := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetKusovNum(const value: variant);
begin
  if (FKusovNum <> value) then
    begin
      FKusovNum := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetGosNum(const value: variant);
begin
  if (FGosNum <> value) then
    begin
      FGosNum := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetForeign(const value: variant);
begin
  if (FForeign <> value) then
    begin
      FForeign := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetInRent(const value: variant);
begin
  if (FInRent <> value) then
    begin
      FInRent := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetCarType(const value: variant);
begin
  if (FCarType <> value) then
    begin
      FCarType      := value;
      FCarTypeName  := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetPurposeUse(const value: variant);
begin
  if (FPurposeUse <> value) then
    begin
      FPurposeUse       := value;
      FPurposeTypeName  := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetComments(const value: TStringList);
begin
  if (FComments <> value) then
    begin
      FComments.Assign(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.SetID(const value: variant);
begin
  if (FIDCar <> value) then
    begin
      FIDCar  := EncodeCString(value);
      IsNew   := false;
    end;
end;
//---------------------------------------------------------------------------
function TCarEntity.CheckID(const id_fields: array of variant): boolean;
begin
  Result := false;
  if (Length(id_fields) <> 1) then exit;
  Result := VarSameValue(FIDCar, id_fields[0]);
end;
//---------------------------------------------------------------------------
function TCarEntity.GetCarMarkName(): variant;
begin
  if (FCarMarkName = Null) then
    begin
      // Автор предыдущего клиента заносил в это поле не ID,
      // а название марки. Я хочу поддерживать прошлую БД, но заносить ID.
      // Строка преобразуется к типу ID - INT. -1 там быть не может.
      with (dmData.myCarMark) do
        begin
          Active := true;
          if (Locate('ID_CARMARK', StrToIntDef(VarToStr(FCarMark), -1),
            [loCaseInsensitive]) = false) then
              FCarMarkName := FCarMark
          else FCarMarkName := FieldByName('MARK').AsVariant;
        end;
    end;
  Result := FCarMarkName;
end;
//---------------------------------------------------------------------------
function TCarEntity.GetCarTypeName(): variant;
begin
  if (FCarTypeName = Null) then
    begin
      with (dmData.myCarType) do
        begin
          Active := true;
          if (Locate('ID_CAR_TYPE', StrToIntDef(VarToStr(FCarType), -1),
            [loCaseInsensitive]) = false) then
              FCarTypeName := EmptyStr
          else FCarTypeName := FieldByName('CAR_TYPE').AsVariant;
        end;
    end;
  Result := FCarTypeName;
end;
//---------------------------------------------------------------------------
function TCarEntity.GetPurposeTypeName(): variant;
begin
  if (FPurposeTypeName = Null) then
    begin
      with (dmData.myPurposeType) do
        begin
          Active := true;
          if (Locate('ID_PURPOSE_TYPE', StrToIntDef(VarToStr(FPurposeUse), -1),
            [loCaseInsensitive]) = false) then
              FPurposeTypeName := EmptyStr
          else FPurposeTypeName := FieldByName('PURPOSE_TYPE').AsVariant;
        end;
    end;
  Result := FPurposeTypeName;
end;
//---------------------------------------------------------------------------
function TCarEntity.SetEntityData(): boolean;
begin
  Result := false;
  if ((DataSource = nil) or (DataSource.DataSet = nil)) then exit;
  with DataSource.DataSet do
  try
    FIDCar          := FieldByName('CAR_ID_CAR').AsVariant;
    FCarType        := FieldByName('CAR_ID_CAR_TYPE').AsVariant;
    FPurposeUse     := FieldByName('CAR_ID_PURPOSE_TYPE').AsVariant;
    FCarMark        := FieldByName('CAR_CAR_MARK').AsVariant;
    FCarModel       := FieldByName('CAR_CAR_MODEL').AsVariant;
    FPtsSer         := FieldByName('CAR_PTS_SER').AsVariant;
    FPtsNum         := FieldByName('CAR_PTS_NO').AsVariant;
    FPtsDate        := FieldByName('CAR_PTS_DATE').AsVariant;
    FVIN            := FieldByName('CAR_VIN_NUM').AsVariant;
    FShassiNum      := FieldByName('CAR_SHASSI').AsVariant;
    FKusovNum       := FieldByName('CAR_KUSOV').AsVariant;
    FGosNum         := FieldByName('CAR_GOS_NUM').AsVariant;
    FYearIssue      := FieldByName('CAR_YEAR_ISSUE').AsVariant;
    FPowerKWT       := FieldByName('CAR_POWER_KVT').AsVariant;
    FPowerHP        := FieldByName('CAR_POWER_LS').AsVariant;
    FMaxMass        := FieldByName('CAR_MAX_KG').AsVariant;
    FNumPlaces      := FieldByName('CAR_NUM_PLACES').AsVariant;
    FInRent         := FieldByName('CAR_ARENDA').AsVariant;
    FForeign        := FieldByName('CAR_FOREING').AsVariant;
    FComments.Text  := FieldByName('CAR_COMMENTS').AsString;

    // Обязательно, иначе они не будут переинициализированы.
    FCarMarkName      := Null;
    FCarTypeName      := Null;
    FPurposeTypeName  := Null;

    // Не катит, поскольку названия некоторых полей дублируются.
    // FCarOwner.DataSource  := Self.DataSource;

    FCarOwner.DataSource  :=
      dmData.GetClientByID(FieldByName('CAR_ID_CLIENT').AsString);
    Result                := FCarOwner.DB_Load(ltNew);
  except
    LogException('TCarEntity.SetEntityData:');
    exit;
  end;
end;
//---------------------------------------------------------------------------
function TCarEntity.InsertRecord(): boolean;
begin
  Result := false;
  with (dmData.SQLAction(dmData.myProcCarMain, atInsert)) do
  try
    ParamByName('v_arenda').AsBoolean         := VarToBool(FInRent);
    ParamByName('v_id_purpose_type').AsString := VarToStr(FPurposeUse);
    ParamByName('v_id_car_type').AsString     := VarToStr(FCarType);
    ParamByName('v_id_client').AsString       := VarToStr(FCarOwner.IDClient);
    if (FCarMark <> Null) then
      ParamByName('v_id_car_mark').AsInteger  := FCarMark;
    ParamByName('v_car_model').AsString       := VarToStr(FCarModel);
    ParamByName('v_vin_num').AsString         := VarToStr(FVIN);
    if (FYearIssue <> Null) then
      ParamByName('v_year_issue').AsInteger   := FYearIssue;
    if (FPowerKWT <> Null) then
      ParamByName('v_power_kvt').AsFloat      := FPowerKWT;
    if (FPowerHP <> Null) then
      ParamByName('v_power_ls').AsFloat       := FPowerHP;
    if (FMaxMass <> Null) then
      ParamByName('v_max_kg').AsFloat         := FMaxMass;
    if (FNumPlaces <> Null) then
      ParamByName('v_num_places').AsInteger   := FNumPlaces;
    ParamByName('v_shassi').AsString          := VarToStr(FShassiNum);
    ParamByName('v_kusov').AsString           := VarToStr(FKusovNum);
    ParamByName('v_gos_num').AsString         := VarToStr(FGosNum);
    ParamByName('v_pts_date').AsDate          := FPtsDate;
    ParamByName('v_pts_ser').AsString         := VarToStr(FPtsSer);
    ParamByName('v_pts_no').AsString          := VarToStr(FPtsNum);
    ParamByName('v_foreing').AsBoolean        := VarToBool(FForeign);
    ParamByName('v_comments').AsString        := FComments.Text;

    Execute();

    Result := true;

    if (dmData.GetErrCode(Connection) <> 0) then
      begin
        Result := false;
        exit;
      end;
    FIDCar := dmData.GetLastInsertID();
  except
    LogException('TCarEntity.InsertRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
function TCarEntity.UpdateRecord(): boolean;
begin
  Result := false;
  with (dmData.SQLAction(dmData.myProcCarMain, atUpdate)) do
  try
    ParamByName('v_id_car').AsString          := VarToStr(FIDCar);
    ParamByName('v_arenda').AsBoolean         := VarToBool(FInRent);
    ParamByName('v_id_purpose_type').AsString := VarToStr(FPurposeUse);
    ParamByName('v_id_car_type').AsString     := VarToStr(FCarType);
    ParamByName('v_id_client').AsString       := VarToStr(FCarOwner.IDClient);
    if (FCarMark <> Null) then
      ParamByName('v_id_car_mark').AsInteger  := FCarMark;
    ParamByName('v_car_model').AsString       := VarToStr(FCarModel);
    ParamByName('v_vin_num').AsString         := VarToStr(FVIN);
    if (FYearIssue <> Null) then
      ParamByName('v_year_issue').AsInteger   := FYearIssue;
    if (FPowerKWT <> Null) then
      ParamByName('v_power_kvt').AsFloat      := FPowerKWT;
    if (FPowerHP <> Null) then
      ParamByName('v_power_ls').AsFloat       := FPowerHP;
    if (FMaxMass <> Null) then
      ParamByName('v_max_kg').AsFloat         := FMaxMass;
    if (FNumPlaces <> Null) then
      ParamByName('v_num_places').AsInteger   := FNumPlaces;
    ParamByName('v_shassi').AsString          := VarToStr(FShassiNum);
    ParamByName('v_kusov').AsString           := VarToStr(FKusovNum);
    ParamByName('v_gos_num').AsString         := VarToStr(FGosNum);
    ParamByName('v_pts_date').AsDate          := FPtsDate;
    ParamByName('v_pts_ser').AsString         := VarToStr(FPtsSer);
    ParamByName('v_pts_no').AsString          := VarToStr(FPtsNum);
    ParamByName('v_foreing').AsBoolean        := VarToBool(FForeign);
    ParamByName('v_comments').AsString        := FComments.Text;

    Execute();

    Result := (dmData.GetErrCode(Connection) = 0);
  except
    LogException('TCarEntity.UpdateRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
function TCarEntity.LoadSavedRecord(): boolean;
begin
  Result := false;
  with (DataSource.DataSet) do
  try
    if (Active) then
      Result := Locate('ID_CAR', IDCar, [loCaseInsensitive]);
  except
    LogException('TCarEntity.LoadSavedRecord:');
  end;
end;
//---------------------------------------------------------------------------
function TCarEntity.DeleteRecord(): boolean;
begin
  Result := true;
  with (dmData.SQLAction(dmData.myProcCarMain, atDelete)) do
  try
    ParamByName('v_id_car').AsString := VarToStr(FIDCar);
    Execute();
    Result := (dmData.GetErrCode(Connection) = 0);
  except
    LogException('TCarEntity.DeleteRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
procedure TCarEntity.ReInitEntity();
begin
  inherited;
  FCarOwner.Assign(nil);
  FIDCar            := Null;
  FPtsSer           := Null;
  FPtsNum           := Null;
  FPtsDate          := Null;
  FCarMark          := Null;
  FCarModel         := Null;
  FVIN              := Null;
  FYearIssue        := Null;
  FPowerKWT         := Null;
  FPowerHP          := Null;
  FMaxMass          := Null;
  FNumPlaces        := Null;
  FShassiNum        := Null;
  FKusovNum         := Null;
  FGosNum           := Null;
  FForeign          := Null;
  FInRent           := Null;
  FCarType          := Null;
  FCarTypeName      := Null;
  FPurposeUse       := Null;
  FDateInsert       := Null;
  FDateUpdate       := Null;
  FUIName           := Null;
  FUUName           := Null;

  FCarMarkName      := Null;
  FCarTypeName      := Null;
  FPurposeTypeName  := Null;

  FComments.Clear();
end;
//---------------------------------------------------------------------------
procedure TCarEntity.Assign(Source: TEntity);
var s: TCarEntity;
begin
  inherited Assign(Source);
  if (Source = nil) then exit;

  if (not (Source is TCarEntity)) then exit;
  s := Source as TCarEntity;
  FCarOwner.Assign(s.CarOwner);
  FIDCar            := s.FIDCar;
  FPtsSer           := s.FPtsSer;
  FPtsNum           := s.FPtsNum;
  FPtsDate          := s.FPtsDate;
  FCarMark          := s.FCarMark;
  FCarModel         := s.FCarModel;
  FVIN              := s.FVIN;
  FYearIssue        := s.FYearIssue;
  FPowerKWT         := s.FPowerKWT;
  FPowerHP          := s.FPowerHP;
  FMaxMass          := s.FMaxMass;
  FNumPlaces        := s.FNumPlaces;
  FShassiNum        := s.FShassiNum;
  FKusovNum         := s.FKusovNum;
  FGosNum           := s.FGosNum;
  FForeign          := s.FForeign;
  FInRent           := s.FInRent;
  FCarType          := s.FCarType;
  FCarTypeName      := s.FCarTypeName;
  FPurposeUse       := s.FPurposeUse;
  FDateInsert       := s.FDateInsert;
  FDateUpdate       := s.FDateUpdate;
  FUIName           := s.FUIName;
  FUUName           := s.FUUName;

  FCarMarkName      := s.FCarMarkName;
  FCarTypeName      := s.FCarTypeName;
  FPurposeTypeName  := s.FPurposeTypeName;

  FComments.Assign(s.FComments);
end;
//---------------------------------------------------------------------------
end.
