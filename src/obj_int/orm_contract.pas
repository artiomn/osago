unit orm_contract; 

//
// Модуль объектного представления договора и водителей.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, variants, ZSysUtils, MyAccess, db, data_unit, data_coefs,
  orm_abstract, orm_car, orm_client, common_functions, dateutils, logger;

var ContractsCollection: TEntityesCollection;

type

TDriverEntity = class;

TCESubstate = (cesNone, cesReplace, cesProlong);

//
// TContractEntity.
//

TContractEntity = class(TEntity)
private
  FIDContract: variant;
  FCar: TCarEntity;
  FPH: TClientEntity;
  FDrivers: TEntityesCollection;
  FInsComp: variant;
  FContractType: variant;
  FTerrUse: variant;
  FPrevCont: variant;
  FDogSer: variant;
  FDogNum: variant;
  FDateCreate: variant;
  FDateStart: variant;
  FDateEnd: variant;
  FStartUse: variant;
  FEndUse: variant;
  FStartUse1: variant;
  FEndUse1: variant;
  FStartUse2: variant;
  FEndUse2: variant;
  FDateWrite: variant;
  FDateBegin: variant;
  FTransit: variant;
  FUDrivers: variant;
  FIDInsClass: variant;
  FInsSum: variant;
  FInsPrem: variant;
  FCoefTer: variant;
  FCoefBonusMalus: variant;
  FCoefStage: variant;
  FCoefUnlim: variant;
  FCoefPower: variant;
  FCoefPeriodUse: variant;
  FCoefSrokIns: variant;
  FCoefKN: variant;
  FBaseSum: variant;
  FDateInsert: variant;
  FDateUpdate: variant;
  FTicketSer: variant;
  FTicketNum: variant;
  FTicketDate: variant;
  FUIName: variant;
  FUUName: variant;

  FZnakSer: variant;
  FZnakNo: variant;

  FComments: TStringList;

  FSubState: TCESubstate;
protected
  procedure ReInitEntity(); override;
protected
  function GetInsPeriod(): variant;
  function GetMonthsInUse(): variant;
  function GetTerrUse(): variant;
protected
  // Устанавливает в DataSet текущий ID.
  procedure SetCurIDInDataset();
  // Устанавливает ID. После установки ID, считается, что сущность уже есть в
  // базе, поскольку ID формируется сервером.
  procedure SetID(const value: variant);
  procedure SetCar(const value: TCarEntity);
  procedure SetPH(const value: TClientEntity);
  procedure SetDrivers(const value: TEntityesCollection);
  procedure SetInsComp(const value: variant);
  procedure SetContractType(const value: variant);
  procedure SetTerrUse(const value: variant);
  procedure SetDogSer(const value: variant);
  procedure SetDogNum(const value: variant);
  procedure SetDateStart(const value: variant);
  procedure SetDateEnd(const value: variant);
  procedure SetDateWrite(const value: variant);
  procedure SetDateBegin(const value: variant);
  procedure SetTransit(const value: variant);
  procedure SetUDrivers(const value: variant);
  procedure SetIDInsClass(const value: variant);
  procedure SetInsSum(const value: variant);
  procedure SetInsPrem(const value: variant);
  procedure SetCoefTer(const value: variant);
  procedure SetCoefBonusMalus(const value: variant);
  procedure SetCoefStage(const value: variant);
  procedure SetCoefUnlim(const value: variant);
  procedure SetCoefPower(const value: variant);
  procedure SetFCoefPeriodUse(const value: variant);
  procedure SetCoefSrokIns(const value: variant);
  procedure SetCoefKN(const value: variant);
  procedure SetBaseSum(const value: variant);
  procedure SetTicketSer(const value: variant);
  procedure SetTicketNum(const value: variant);
  procedure SetTicketDate(const value: variant);
  procedure SetComments(const value: TStringList);
protected
  procedure SetStartUse(const idx: integer; const su: variant);
  procedure SetEndUse(const idx: integer; const eu: variant);
protected
  // Загружает водителей, для сохранённого договора.
  // Вызывается в SetEntityData().
  function LoadDrivers(): boolean;
  // Сохраняет водителей в БД.
  function SaveDrivers(): boolean;
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
  property IDContract: variant read FIDContract write SetID;
  property Car: TCarEntity read FCar write SetCar;
  property PolicyHolder: TClientEntity read FPH write SetPH;
  property Drivers: TEntityesCollection read FDrivers;
  property IDInsuranceCompany: variant read FInsComp write SetInsComp;
  property ContractType: variant read FContractType;
  property IDTerritoryUse: variant read GetTerrUse write SetTerrUse;
  property IDPrevContract: variant read FPrevCont;
  property DogSer: variant read FDogSer write SetDogSer;
  property DogNum: variant read FDogNum write SetDogNum;
  property DateCreate: variant read FDateCreate;
  property DateStart: variant read FDateStart write SetDateStart;
  property DateEnd: variant read FDateEnd write SetDateEnd;
  property InsPeriodInDays: variant read GetInsPeriod;
  property StartUse: variant index 0 read FStartUse write SetStartUse;
  property EndUse: variant index 0 read FEndUse write SetEndUse;
  property StartUse1: variant index 1 read FStartUse1 write SetStartUse;
  property EndUse1: variant index 1 read FEndUse1 write SetEndUse;
  property StartUse2: variant index 2 read FStartUse2 write SetStartUse;
  property EndUse2: variant index 2 read FEndUse2 write SetEndUse;
  property MonthsInUse: variant read GetMonthsInUse;
  property DateWrite: variant read FDateWrite write SetDateWrite;
  property DateBegin: variant read FDateBegin write SetDateBegin;
  property Transit: variant read FTransit write SetTransit;
  property UnlimitedDrivers: variant read FUDrivers write SetUDrivers;
  property IDInsuranceClass: variant read FIDInsClass write SetIDInsclass;
  property InsSum: variant read FInsSum write SetInsSum;
  property InsPrem: variant read FInsPrem write SetInsPrem;
  property CoefTer: variant read FCoefTer write SetCoefTer;
  property CoefBonusMalus: variant read FCoefBonusMalus write SetCoefBonusMalus;
  property CoefStage: variant read FCoefStage write SetCoefStage;
  property CoefUnlim: variant read FCoefUnlim write SetCoefUnlim;
  property CoefPower: variant read FCoefPower write SetCoefPower;
  property CoefPeriodUse: variant read FCoefPeriodUse write SetFCoefPeriodUse;
  property CoefSrokIns: variant read FCoefSrokIns write SetCoefSrokIns;
  property CoefKN: variant read FCoefKN write SetCoefKN;
  property BaseSum: variant read FBaseSum write SetBaseSum;
  property TicketSer: variant read FTicketSer write SetTicketSer;
  property TicketNum: variant read FTicketNum write SetTicketNum;
  property TicketDate: variant read FTicketDate write SetTicketDate;
  property Comments: TStringList read FComments write SetComments;
  property DateInsert: variant read FDateInsert;
  property DateUpdate: variant read FDateUpdate;
  property UserInsertName: variant read FUIName;
  property UserUpdateName: variant read FUUName;

  property ZnakSer: variant read FZnakSer write FZnakSer; deprecated;
  property ZnakNum: variant read FZnakNo write FZnakNo; deprecated;

  function ContractClose(): boolean;
  function ContractReplace(): boolean;
  function ContractProlong(): boolean;
  function DriverAdd(): TDriverEntity;
  function DriverDel(driver: TDriverEntity): boolean;
  function DriverDel(id_driver: variant): boolean; overload;
end;

//
// TDriverEntity. Водитель.
//


TDriverEntity = class(TEntity)
private
  FIDDriver: variant;
  FClient: TClientEntity;
  FContract: TContractEntity;
  FDateInsert: variant;
  FDateUpdate: variant;
protected
  procedure SetID(const value: variant);
  procedure SetClient(const value: TClientEntity);
protected
  function SetEntityData(): boolean; override;
  function InsertRecord(): boolean; override;
  function LoadSavedRecord(): boolean; override;
  function UpdateRecord(): boolean; override;
  function DeleteRecord(): boolean; override;
  procedure Assign(Source: TEntity); override;
protected
public
  constructor Create(ACollection: TCollection); override;
public
  constructor Create(ACollection: TCollection; AContract: TContractEntity);
    virtual;
  destructor Destroy; override;
public
  function CheckID(const id_fields: array of variant): boolean;
    override;
protected
  procedure ReInitEntity(); override;
public
  property IDDriver: variant read FIDDriver;
  property Client: TClientEntity read FClient write SetClient;
  property OwnerContract: TContractEntity read FContract;
  // Не имеет значения. В БД всегда равно OwnerContract.Car.
  // property Car: TCarEntity read FCar write SetCar;
  property DateInsert: variant read FDateInsert;
  property DateUpdate: variant read FDateUpdate;
end;

implementation
//---------------------------------------------------------------------------
constructor TContractEntity.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FComments := TStringList.Create();
  FPH       := TClientEntity.Create(nil);
  FCar      := TCarEntity.Create(nil);
  FDrivers  := TEntityesCollection.Create(TDriverEntity);
  FTerrUse  := Null;
  FSubState := cesNone;
end;
//---------------------------------------------------------------------------
destructor TContractEntity.Destroy;
begin
  FDrivers.Free;
  FCar.Free;
  FPH.Free;
  FComments.Free;
  inherited;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetCar(const value: TCarEntity);
begin
//  if (value = nil) then exit;
  if (FCar.IDCar <> value.IDCar) then
    begin
      FCar.Assign(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetPH(const value: TClientEntity);
begin
//  if (value = nil) then exit;
  // Вообще-то, у него могут меняться внутрение параметры. :-\
  if (FPH.IDClient <> value.IDClient) then
    begin
      FPH.Assign(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetDrivers(const value: TEntityesCollection);
begin
//  if (value = nil) then exit;
  if (FDrivers <> value) then
    begin
      FDrivers.Assign(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetInsComp(const value: variant);
begin
  if (not VarSameValue(FInsComp, value)) then
    begin
      FInsComp := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetContractType(const value: variant);
begin
  if (not VarSameValue(FContractType, value)) then
    begin
      FContractType := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
function TContractEntity.GetInsPeriod(): variant;
begin
  if ((FDateStart = Null) or (FDateEnd = Null)) then Result := Null
  else Result := DaysBetween(VarToDateTime(FDateStart), VarToDateTime(FDateEnd));
end;
//---------------------------------------------------------------------------
function TContractEntity.GetMonthsInUse(): variant;
var ydelta: double;
begin
  Result := Null;
  if ((FStartUse = Null) or (FEndUse = Null)) then exit;
  ydelta := Abs(YearOf(VarToDateTime(FEndUse)) -
    YearOf(VarToDateTime(FStartUse))) * MonthsPerYear;
  Result := Abs(MonthOf(VarToDateTime(FEndUse)) -
    MonthOf(VarToDateTime(FStartUse)) + ydelta);
  if ((FStartUse1 <> Null) and (FEndUse1 <> Null)) then
    begin
      ydelta := Abs(YearOf(VarToDateTime(FEndUse1)) -
        YearOf(VarToDateTime(FStartUse1))) * MonthsPerYear;
      Result := Result + Abs(MonthOf(VarToDateTime(FEndUse1)) -
        MonthOf(VarToDateTime(FStartUse1)) + ydelta);
    end;
  if ((FStartUse2 <> Null) and (FEndUse2 <> Null)) then
    begin
      ydelta := Abs(YearOf(VarToDateTime(FEndUse1)) -
        YearOf(VarToDateTime(FStartUse1))) * MonthsPerYear;
      Result := Result + Abs(MonthOf(VarToDateTime(FEndUse2)) -
        MonthOf(VarToDateTime(FStartUse2)));
    end;

{  Result := MonthsBetween(VarToDateTime(FStartUse), VarToDateTime(FEndUse));
  if ((FStartUse1 <> Null) and (FEndUse1 <> Null)) then
    Result := Result + MonthsBetween(VarToDateTime(FStartUse1),
      VarToDateTime(FEndUse1));
  if ((FStartUse2 <> Null) and (FEndUse2 <> Null)) then
    Result := Result + MonthsBetween(VarToDateTime(FStartUse2),
      VarToDateTime(FEndUse2));}
end;
//---------------------------------------------------------------------------
function TContractEntity.GetTerrUse(): variant;
begin
  // "Место жительства (нахождения) _собственника_ транспортного средства."
  if (FTerrUse = Null) then
    begin
      with (dmCoefs.myGetInsCoef_KT) do
        begin
          Close();
          ParamByName('car_type_id').AsString := VarToStr(Car.IDCarType);
          ParamByName('geo_group').AsString   := VarToStr(Car.CarOwner.GeoGroup);
          Open();
          FTerrUse := FieldByName('ID_TERRITORY_USE').AsVariant;
{          if (Locate('ID_CAR_TYPE;ID_REGION_GROUP',
            VarArrayOf([Car.IDCarType, Car.CarOwner.IDRegionGroup]),
            [loCaseInsensitive]) = false) then
              FTerrUse := Null
          else FTerrUse := FieldByName('ID_TERRITORY_USE').AsVariant;}
        end;
    end;
  Result := FTerrUse;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetTerrUse(const value: variant);
begin
  if (not VarSameValue(FTerrUse, value)) then
    begin
      FTerrUse := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetDogSer(const value: variant);
begin
  if (not VarSameValue(FDogSer, value)) then
    begin
{      if ((DogSer <> Null) and (DogNum <> Null)) then
        begin
          FDogSer     := EncodeCString(value);
          //DisplayName := DogSer + ' - ' + DogNum;
        end
      else
        begin
          FDogSer     := Null;
          DisplayName := EmptyStr;
        end;}
      FDogSer := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetDogNum(const value: variant);
begin
  if (not VarSameValue(FDogNum, value)) then
    begin
{      if ((DogSer <> Null) and (DogNum <> Null)) then
        begin
          FDogNum     := EncodeCString(value);
          DisplayName := DogSer + ' - ' + DogNum;
        end
      else
        begin
          FDogNum     := Null;
          DisplayName := EmptyStr;
        end;}
      FDogNum := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetDateStart(const value: variant);
begin
  if (not VarSameValue(FDateStart, value)) then
    begin
      FDateStart := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetDateEnd(const value: variant);
begin
  if (not VarSameValue(FDateEnd, value)) then
    begin
      FDateEnd := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetDateWrite(const value: variant);
begin
  if (not VarSameValue(FDateWrite, value)) then
    begin
      FDateWrite := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetDateBegin(const value: variant);
begin
  if (not VarSameValue(FDateBegin, value)) then
    begin
      FDateBegin := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetTransit(const value: variant);
begin
  if (not VarSameValue(FTransit, value)) then
    begin
      FTransit := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetUDrivers(const value: variant);
begin
  if (not VarSameValue(FUDrivers, value)) then
    begin
      FUDrivers := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetIDInsClass(const value: variant);
begin
  if (not VarSameValue(FIDInsClass, value)) then
    begin
      FIDInsClass := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetInsSum(const value: variant);
begin
  if (not VarSameValue(FInsSum, value)) then
    begin
      FInsSum := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetInsPrem(const value: variant);
begin
  if (not VarSameValue(FInsPrem, value)) then
    begin
      FInsPrem := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetCoefTer(const value: variant);
begin
  if (not VarSameValue(FCoefTer, value)) then
    begin
      FCoefTer := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetCoefBonusMalus(const value: variant);
begin
  if (not VarSameValue(FCoefBonusMalus, value)) then
    begin
      FCoefBonusMalus := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetCoefStage(const value: variant);
begin
  if (not VarSameValue(FCoefStage, value)) then
    begin
      FCoefStage := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetCoefUnlim(const value: variant);
begin
  if (not VarSameValue(FCoefUnlim, value)) then
    begin
      FCoefUnlim := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetCoefPower(const value: variant);
begin
  if (not VarSameValue(FCoefPower, value)) then
    begin
      FCoefPower := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetFCoefPeriodUse(const value: variant);
begin
  if (not VarSameValue(FCoefPeriodUse, value)) then
    begin
      FCoefPeriodUse := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetCoefSrokIns(const value: variant);
begin
  if (not VarSameValue(FCoefSrokIns, value)) then
    begin
      FCoefSrokIns := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetCoefKN(const value: variant);
begin
  if (not VarSameValue(FCoefKN, value)) then
    begin
      FCoefKN := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetBaseSum(const value: variant);
begin
  if (not VarSameValue(FBaseSum, value)) then
    begin
      FBaseSum := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetTicketSer(const value: variant);
begin
  if (not VarSameValue(FTicketSer, value)) then
    begin
      FTicketSer := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetTicketNum(const value: variant);
begin
  if (not VarSameValue(FTicketNum, value)) then
    begin
      FTicketNum := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetTicketDate(const value: variant);
begin
  if (not VarSameValue(FTicketDate, value)) then
    begin
      FTicketDate := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetStartUse(const idx: integer; const su: variant);
begin
  case idx of
    0:
      if (not VarSameValue(FStartUse, su)) then
        begin
          FStartUse := su;
          DoOnChanged();
        end;
    1:
      if (not VarSameValue(FStartUse1, su)) then
        begin
          FStartUse1 := su;
          DoOnChanged();
        end;
    2:
      if (not VarSameValue(FStartUse2, su)) then
        begin
          FStartUse2 := su;
          DoOnChanged();
        end;
  end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetEndUse(const idx: integer; const eu: variant);
begin
  case idx of
    0:
      if (not VarSameValue(FEndUse, eu)) then
        begin
          FEndUse := eu;
          DoOnChanged();
        end;
    1:
      if (not VarSameValue(FEndUse1, eu)) then
        begin
          FEndUse1 := eu;
          DoOnChanged();
        end;
    2:
      if (not VarSameValue(FEndUse2, eu)) then
        begin
          FEndUse2 := eu;
          DoOnChanged();
        end;
  end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetComments(const value: TStringList);
begin
  if (FComments <> value) then
    begin
      FComments.Assign(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetID(const value: variant);
begin
  if (not VarSameValue(FIDContract, value)) then
    begin
      FIDContract := EncodeCString(value);
      IsNew       := false;
    end;
end;
//---------------------------------------------------------------------------
function TContractEntity.CheckID(const id_fields: array of variant): boolean;
begin
  Result := false;
  if (Length(id_fields) <> 1) then exit;
  Result := VarSameValue(FIDContract, id_fields[0]);
end;
//---------------------------------------------------------------------------
function TContractEntity.LoadDrivers(): boolean;
var de: TDriverEntity;
begin
  Result := false;
  try
    FDrivers.Clear();
    try
      FDrivers.BeginUpdate();
      with (dmData.GetDriversByContID(VarToStr(IDContract)).DataSet) do
        begin
          First();
          while (not EOF) do
            begin
              de := DriverAdd();
              if (de = nil) then
                raise EOutOfResources.Create('Can''t create driver');
              de.DataSource := dmData.datasrcDriver;
              de.DB_Load(ltNew);
              Next();
            end;
          Result := true;
        end;
    finally
      FDrivers.EndUpdate();
    end;
  except
    LogException('TContractEntity.LoadDrivers:');
  end;
end;
//---------------------------------------------------------------------------
function TContractEntity.SaveDrivers(): boolean;
var i: integer;
begin
  if (FDrivers.Count = 0) then
    begin
      Result := true;
      exit;
    end;
  Result := dmData.ClearDriversList();
  if (not Result) then exit;
  try
    for i := 0 to FDrivers.Count - 1 do
      if (not dmData.AddDriver((FDrivers[i] as TDriverEntity).FClient.IDClient))
        then
          begin
            Result := false;
            break;
          end;
  except
    LogException('TContractEntity.SaveDrivers:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.SetCurIDInDataset();
begin
  with (DataSource.DataSet as TCustomMyDataSet) do
    if (not VarSameValue(FieldByName('ID_DOGOVOR').AsVariant, FIDContract)) then
      with (FieldByName('ID_DOGOVOR')) do
        begin
          ReadOnly  := false;
          AsVariant := FIDContract;
          ReadOnly  := true;
        end;
end;
//---------------------------------------------------------------------------
function TContractEntity.SetEntityData(): boolean;
begin
  Result := false;
  if ((DataSource = nil) or (DataSource.DataSet = nil)) then exit;
  with DataSource.DataSet do
  try
    FIDContract     := FieldByName('CNT_ID_DOGOVOR').AsVariant;
    FPrevCont       := FieldByName('CNT_ID_PREV_DOG').AsVariant;
    FInsComp        := FieldByName('CNT_ID_INSURANCE_COMPANY').AsVariant;
    FTerrUse        := FieldByName('CNT_ID_TERRITORY_USE').AsVariant;
    FDateCreate     := FieldByName('CNT_DATE_DOG_CREATE').AsVariant;
    FDateStart      := FieldByName('CNT_DATE_START').AsVariant;
    FDateEnd        := FieldByName('CNT_DATE_END').AsVariant;
    FDogSer         := FieldByName('CNT_DOG_SER').AsVariant;
    FDogNum         := FieldByName('CNT_DOGNUMB').AsVariant;
    FInsSum         := FieldByName('CNT_INS_SUM').AsVariant;
    FInsPrem        := FieldByName('CNT_INS_PREM').AsVariant;
    FStartUse       := FieldByName('CNT_START_USE').AsVariant;
    FEndUse         := FieldByName('CNT_END_USE').AsVariant;
    FStartUse1      := FieldByName('CNT_START_USE1').AsVariant;
    FEndUse1        := FieldByName('CNT_END_USE1').AsVariant;
    FStartUse2      := FieldByName('CNT_START_USE2').AsVariant;
    FEndUse2        := FieldByName('CNT_END_USE2').AsVariant;
    FDateWrite      := FieldByName('CNT_DATE_WRITE').AsVariant;
    FDateBegin      := FieldByName('CNT_DATE_BEGIN').AsVariant;
    FTransit        := FieldByName('CNT_TRANSIT').AsVariant;

    // Коэффициенты.
    FBaseSum        := FieldByName('CNT_BASE_SUM').AsVariant;
    FCoefTer        := FieldByName('CNT_KOEF_TER').AsVariant;
    FCoefBonusMalus := FieldByName('CNT_KOEF_BONUSMALUS').AsVariant;
    FCoefUnlim      := FieldByName('CNT_KOEF_UNLIMITED').AsVariant;
    FCoefStage      := FieldByName('CNT_KOEF_STAG').AsVariant;
    FCoefPower      := FieldByName('CNT_KOEF_POWER').AsVariant;
    FCoefPeriodUse  := FieldByName('CNT_KOEF_PERIOD_USE').AsVariant;
    FCoefSrokIns    := FieldByName('CNT_KOEF_SROK_INS').AsVariant;
    FCoefKN         := FieldByName('CNT_KOEF_KN').AsVariant;
    //
    FUDrivers   := FieldByName('CNT_UNLIMITED_DRIVERS').AsVariant;
    FIDInsClass := FieldByName('CNT_ID_INSURANCE_CLASS').AsVariant;
    FTicketSer  := FieldByName('CNT_TICKET_SER').AsVariant;
    FTicketNum  := FieldByName('CNT_TICKET_NUM').AsVariant;
    FTicketDate := FieldByName('CNT_TICKET_DATE').AsVariant;
    FComments.Text  := FieldByName('CNT_COMMENT').AsString;
    FDateInsert     := FieldByName('CNT_DATE_INSERT').AsVariant;
    FDateUpdate     := FieldByName('CNT_DATE_UPDATE').AsVariant;
    FUIName         := FieldByName('CNT_USER_INSERT_NAME').AsVariant;
    FUUName         := FieldByName('CNT_USER_UPDATE_NAME').AsVariant;

    FZnakSer        := FieldByName('CNT_ZNAK_SER').AsVariant;
    FZnakNo         := FieldByName('CNT_ZNAK_NO').AsVariant;

    FCar.DataSource := Self.DataSource;
    // Обязательно сразу, поскольку, набор данных, связанный с источником для
    // клиента меняется.
    Result          := FCar.DB_Load(ltNew);
    // FPH.DataSource  := Self.DataSource;
    FPH.DataSource  := Self.DataSource;
    Result          := Result and FPH.DB_Load(ltNew) and LoadDrivers();
  except
    LogException('TContractEntity.SetEntityData:');
    exit;
  end;
end;
//---------------------------------------------------------------------------
function TContractEntity.InsertRecord(): boolean;
var ds: TCustomMyDataSet;
{$IFDEF DEBUG}
  e_code: integer;
{$ENDIF}
begin
  Result := true;
  if (SaveDrivers() = false) then
    begin
      Result := false;
      exit;
    end;

  case FSubState of
    cesNone: begin
      Info('Insert contract');
      ds := dmData.SQLAction(dmData.myProcContMain, atInsert);
    end;
    cesReplace: begin
      Info('Repace contract');
      ds := dmData.myProcContReplace;
      ds.ParamByName('v_id_dogovor').AsString := VarToStr(FIDContract);
    end;
    cesProlong: begin
      Info('Prolong contract');
      ds := dmData.myProcContProlong;
      ds.ParamByName('v_id_dogovor').AsString := VarToStr(FIDContract);
    end;
  end;

  with (ds) do
  try
    ParamByName('v_dog_ser').AsString               := VarToStr(FDogSer);
    ParamByName('v_dog_numb').AsString              := VarToStr(FDogNum);
    if (FSubState = cesNone) then
      begin
        ParamByName('v_date_start').AsDateTime      := FDateStart;
        ParamByName('v_date_end').AsDate            := FDateEnd;
      end;

    ParamByName('v_start_use').AsDate               := FStartUse;
    ParamByName('v_end_use').AsDate                 := FEndUse;

    if ((FStartUse1 <> Null) and (FEndUse1 <> Null)) then
      begin
        ParamByName('v_start_use1').AsDate          := FStartUse1;
        ParamByName('v_end_use1').AsDate            := FEndUse1;
      end;
    if ((FStartUse2 <> Null) and (FEndUse2 <> Null)) then
      begin
        ParamByName('v_start_use2').AsDate          := FStartUse2;
        ParamByName('v_end_use2').AsDate            := FEndUse2;
      end;

    if (FInsComp <> Null) then
      ParamByName('v_id_insurance_company').AsInteger := FInsComp;
    ParamByName('v_transit').AsBoolean              := VarToBool(FTransit);
    if (FTerrUse <> Null) then
      ParamByName('v_id_territory_use').AsInteger   := FTerrUse;
    ParamByName('v_ins_sum').AsFloat                :=
      StrToFloatDef(VarToStr(FInsSum), 1);
    ParamByName('v_ins_prem').AsFloat               :=
      StrToFloatDef(VarToStr(FInsPrem), 1);
    ParamByName('v_koef_ter').AsFloat               :=
      StrToFloatDef(VarToStr(FCoefTer), 1);
    ParamByName('v_koef_bonus_malus').AsFloat       :=
      StrToFloatDef(VarToStr(FCoefBonusMalus), 1);
    ParamByName('v_koef_stag').AsFloat              :=
      StrToFloatDef(VarToStr(FCoefStage), 1);
    ParamByName('v_koef_unlimited').AsFloat         :=
      StrToFloatDef(VarToStr(FCoefUnlim), 1);
    ParamByName('v_koef_power').AsFloat             :=
      StrToFloatDef(VarToStr(FCoefPower), 1);
    ParamByName('v_koef_period_use').AsFloat        :=
      StrToFloatDef(VarToStr(FCoefPeriodUse), 1);
    ParamByName('v_koef_srok_ins').AsFloat          :=
      StrToFloatDef(VarToStr(FCoefSrokIns), 1);
    ParamByName('v_koef_kn').AsFloat                :=
      StrToFloatDef(VarToStr(FCoefKN), 1);
    ParamByName('v_base_sum').AsFloat               :=
      StrToFloatDef(VarToStr(FBaseSum), 0);
    ParamByName('v_unlimited_drivers').AsBoolean    := VarToBool(FUDrivers);
    if (FDateWrite <> Null) then
      ParamByName('v_date_write').AsDate := FDateWrite;
    if (FDateBegin <> Null) then
      ParamByName('v_date_begin').AsDate := FDateBegin;
    if (FIDInsClass <> Null) then
      ParamByName('v_id_insurance_class').AsInteger := FIDInsClass;
    ParamByName('v_ticket_ser').AsString            := FTicketSer;
    ParamByName('v_ticket_num').AsString            := FTicketNum;
    if (FTicketDate <> Null) then
      ParamByName('v_ticket_date').AsDate := FTicketDate;
    ParamByName('v_comment').AsString               := FComments.Text;

    ParamByName('v_id_client').AsString := VarToStr(FPH.IDClient);
    ParamByName('v_id_car').AsString := VarToStr(FCar.IDCar);

    Execute();

    // dmData.zconnAddContract.
    {$IFDEF DEBUG}
    e_code := dmData.GetErrCode(Connection);
    if (e_code <> 0) then
      begin
        logger.Debug('TContractEntity.InsertRecord: error_code = %d', [e_code]);
        Result := false;
        exit;
      end;
    {$ELSE}
    if (dmData.GetErrCode(Connection) <> 0) then
      begin
        Result := false;
        exit;
      end;
    {$ENDIF}
    FIDContract := dmData.GetLastInsertID();
    FSubState   := cesNone;
  except
    LogException('TContractEntity.InsertRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
function TContractEntity.UpdateRecord(): boolean;
begin
  Result := false;

  if (SaveDrivers() = false) then exit;

  with (dmData.SQLAction(dmData.myProcContMain, atUpdate)) do
  try
    ParamByName('v_id_dogovor').AsString            := VarToStr(FIDContract);
    ParamByName('v_dog_ser').AsString               := VarToStr(FDogSer);
    ParamByName('v_dog_numb').AsString              := VarToStr(FDogNum);
    ParamByName('v_date_start').AsDateTime          := FDateStart;
    ParamByName('v_date_end').AsDate                := FDateEnd;
    ParamByName('v_start_use').AsDate               := FStartUse;
    ParamByName('v_end_use').AsDate                 := FEndUse;
    if ((FStartUse1 <> Null) and (FEndUse1 <> Null)) then
      begin
        ParamByName('v_start_use1').AsDate          := FStartUse1;
        ParamByName('v_end_use1').AsDate            := FEndUse1;
      end;
    if ((FStartUse2 <> Null) and (FEndUse2 <> Null)) then
      begin
        ParamByName('v_start_use2').AsDate          := FStartUse2;
        ParamByName('v_end_use2').AsDate            := FEndUse2;
      end;

    if (FInsComp <> Null) then
      ParamByName('v_id_insurance_company').AsInteger := FInsComp;
    ParamByName('v_transit').AsBoolean              := VarToBool(FTransit);
    if (FTerrUse <> Null) then
      ParamByName('v_id_territory_use').AsInteger   := FTerrUse;
    ParamByName('v_ins_sum').AsFloat                :=
      StrToFloatDef(VarToStr(FInsSum), 1);
    ParamByName('v_ins_prem').AsFloat               :=
      StrToFloatDef(VarToStr(FInsPrem), 1);
    ParamByName('v_koef_ter').AsFloat               :=
      StrToFloatDef(VarToStr(FCoefTer), 1);
    ParamByName('v_koef_bonus_malus').AsFloat       :=
      StrToFloatDef(VarToStr(FCoefBonusMalus), 1);
    ParamByName('v_koef_stag').AsFloat              :=
      StrToFloatDef(VarToStr(FCoefStage), 1);
    ParamByName('v_koef_unlimited').AsFloat         :=
      StrToFloatDef(VarToStr(FCoefUnlim), 1);
    ParamByName('v_koef_power').AsFloat             :=
      StrToFloatDef(VarToStr(FCoefPower), 1);
    ParamByName('v_koef_period_use').AsFloat        :=
      StrToFloatDef(VarToStr(FCoefPeriodUse), 1);
    ParamByName('v_koef_srok_ins').AsFloat          :=
      StrToFloatDef(VarToStr(FCoefSrokIns), 1);
    ParamByName('v_koef_kn').AsFloat                :=
      StrToFloatDef(VarToStr(FCoefKN), 1);
    ParamByName('v_base_sum').AsFloat               :=
      StrToFloatDef(VarToStr(FBaseSum), 0);
    ParamByName('v_unlimited_drivers').AsBoolean    := VarToBool(FUDrivers);
    if (FDateWrite <> Null) then
      ParamByName('v_date_write').AsDate := FDateWrite;
    if (FDateBegin <> Null) then
      ParamByName('v_date_begin').AsDate := FDateBegin;
    if (FIDInsClass <> Null) then
      ParamByName('v_id_insurance_class').AsInteger := FIDInsClass;
    ParamByName('v_ticket_ser').AsString            := FTicketSer;
    ParamByName('v_ticket_num').AsString            := FTicketNum;
    if (FTicketDate <> Null) then
      ParamByName('v_ticket_date').AsDate := FTicketDate;
    ParamByName('v_comment').AsString               := FComments.Text;

    ParamByName('v_id_client').AsString := VarToStr(FPH.IDClient);
    ParamByName('v_id_car').AsString := VarToStr(FCar.IDCar);

    Execute();

    Result := true;

    // dmData.zconnAddContract.
    if (dmData.GetErrCode(Connection) <> 0) then
      begin
        Result := false;
        exit;
      end;
  except
    LogException('TContractEntity.UpdateRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
function TContractEntity.LoadSavedRecord(): boolean;
begin
  Result := false;
  with (DataSource.DataSet) do
  try
    if (Active) then
      Result := Locate('ID_DOGOVOR', IDContract, [loCaseInsensitive]);
  except
    LogException('TContractEntity.LoadSavedRecord:');
  end;
end;
//---------------------------------------------------------------------------
function TContractEntity.DeleteRecord(): boolean;
begin
  Result := false;

  with (dmData.SQLAction(dmData.myProcContMain, atDelete)) do
  try
    ParamByName('v_id_dogovor').AsString := VarToStr(FIDContract);
    Execute();
    Result := (dmData.GetErrCode(Connection) = 0);
  except
    LogException('TContractEntity.DeleteRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.ReInitEntity();
begin
  inherited;
  Car.Assign(nil);
  FPH.Assign(nil);
  FDrivers.Clear();
  FIDContract     := Null;
  FInsComp        := Null;
  FContractType   := Null;
  FTerrUse        := Null;
  FPrevCont       := Null;
  FDogSer         := Null;
  FDogNum         := Null;
  FDateCreate     := Null;
  FDateStart      := Null;
  FDateEnd        := Null;
  FStartUse       := Null;
  FEndUse         := Null;
  FStartUse1      := Null;
  FEndUse1        := Null;
  FStartUse2      := Null;
  FEndUse2        := Null;
  FDateWrite      := Null;
  FDateBegin      := Null;
  FTransit        := Null;
  FUDrivers       := Null;
  FIDInsClass     := Null;
  FInsSum         := Null;
  FInsPrem        := Null;
  FCoefTer        := Null;
  FCoefBonusMalus := Null;
  FCoefStage      := Null;
  FCoefUnlim      := Null;
  FCoefPower      := Null;
  FCoefPeriodUse  := Null;
  FCoefSrokIns    := Null;
  FCoefKN         := Null;
  FBaseSum        := Null;
  FTicketSer      := Null;
  FTicketNum      := Null;
  FTicketDate     := Null;
  FDateInsert     := Null;
  FDateUpdate     := Null;
  FUIName         := Null;
  FUUName         := Null;

  FZnakSer        := Null;
  FZnakNo         := Null;

  FComments.Clear();

  FSubState       := cesNone;
end;
//---------------------------------------------------------------------------
procedure TContractEntity.Assign(Source: TEntity);
var s: TContractEntity;
begin
  inherited Assign(Source);
  if (Source = nil) then exit;

  if (not (Source is TContractEntity)) then exit;
  s := Source as TContractEntity;
  Car.Assign(s.Car);
  FPH.Assign(s.PolicyHolder);
  FDrivers.Assign(s.FDrivers);
  FIDContract     := s.FIDContract;
  FInsComp        := s.FInsComp;
  FContractType   := s.FContractType;
  FTerrUse        := s.FTerrUse;
  FPrevCont       := s.FPrevCont;
  FDogSer         := s.FDogSer;
  FDogNum         := s.FDogNum;
  FDateCreate     := s.FDateCreate;
  FDateStart      := s.FDateStart;
  FDateEnd        := s.FDateEnd;
  FStartUse       := s.FStartUse;
  FEndUse         := s.FEndUse;
  FStartUse1      := s.FStartUse1;
  FEndUse1        := s.FEndUse1;
  FStartUse2      := s.FStartUse2;
  FEndUse2        := s.FEndUse2;
  FDateWrite      := s.FDateWrite;
  FDateBegin      := s.FDateBegin;
  FTransit        := s.FTransit;
  FUDrivers       := s.FUDrivers;
  FIDInsClass     := s.FIDInsClass;
  FInsSum         := s.FInsSum;
  FInsPrem        := s.FInsPrem;
  FCoefTer        := s.FCoefTer;
  FCoefBonusMalus := s.FCoefBonusMalus;
  FCoefStage      := s.FCoefStage;
  FCoefUnlim      := s.FCoefUnlim;
  FCoefPower      := s.FCoefPower;
  FCoefPeriodUse  := s.FCoefPeriodUse;
  FCoefSrokIns    := s.FCoefSrokIns;
  FCoefKN         := s.FCoefKN;
  FBaseSum        := s.FBaseSum;
  FTicketSer      := s.FTicketSer;
  FTicketNum      := s.FTicketNum;
  FTicketDate     := s.FTicketDate;
  FDateInsert     := s.FDateInsert;
  FDateUpdate     := s.FDateUpdate;
  FUIName         := s.FUIName;
  FUUName         := s.FUUName;

  FZnakSer        := s.FZnakSer;
  FZnakNo         := s.FZnakNo;

  FComments.Assign(s.FComments);

  FSubState       := s.FSubState;
end;
//---------------------------------------------------------------------------
function TContractEntity.ContractClose(): boolean;
begin
  Result := true;
  if (IsNew) then
    begin
      Result := false;
      exit;
    end;
  with (dmData.myProcContClose) do
  try
    ParamByName('v_id_dogovor').AsString := VarToStr(FIDContract);
    ExecProc();
    // dmData.zconnAddContract.
    Result := dmData.GetErrCode(Connection) = 0;
  except
    LogException('TContractEntity.ContractClose:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
function TContractEntity.ContractReplace(): boolean;
begin
  Result := false;
  if (IsNew) then exit;
  IsNew     := true;
  IsSaved   := false;
  Result    := true;
  FSubState := cesReplace;
end;
//---------------------------------------------------------------------------
function TContractEntity.ContractProlong(): boolean;
begin
  Result := false;
  if (IsNew) then exit;
  if (YearsBetween(Now, FDateStart) > 1) then exit;
  IsNew     := true;
  IsSaved   := false;
  Result    := true;
  FSubState := cesProlong;
end;
//---------------------------------------------------------------------------
function TContractEntity.DriverAdd(): TDriverEntity;
begin
  Result := TDriverEntity.Create(FDrivers, Self);
end;
//---------------------------------------------------------------------------
function TContractEntity.DriverDel(driver: TDriverEntity): boolean;
var idx: integer;
begin
  Result  := false;
  idx     := FDrivers.GetEntityIndex(driver);
  if (idx < 0) then exit;
  FDrivers.Delete(idx);
end;
//---------------------------------------------------------------------------
function TContractEntity.DriverDel(id_driver: variant): boolean;
begin
  Result := FDrivers.DelEntity([id_driver]);
end;
//---------------------------------------------------------------------------

//
// TDriverEntity.
//

constructor TDriverEntity.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FClient := TClientEntity.Create(nil);
end;
//---------------------------------------------------------------------------
constructor TDriverEntity.Create(ACollection: TCollection;
  AContract: TContractEntity);
begin
  Create(ACollection);
  FContract := AContract;
end;
//---------------------------------------------------------------------------
destructor TDriverEntity.Destroy;
begin
  FClient.Free;
  // На всякий случай. На договор - только ссылка.
  FContract := nil;
  inherited;
end;
//---------------------------------------------------------------------------
procedure TDriverEntity.SetClient(const value: TClientEntity);
begin
  // if (value = nil) then exit;
  // Данные клиента могут изменяться.
//  if (FClient.IDClient <> value.IDClient) then
  if (FClient <> value) then
    begin
      FClient.Assign(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TDriverEntity.SetID(const value: variant);
begin
  if (not VarSameValue(FIDDriver, value)) then
    begin
      FIDDriver := EncodeCString(value);
      IsNew       := false;
    end;
end;
//---------------------------------------------------------------------------
function TDriverEntity.CheckID(const id_fields: array of variant): boolean;
begin
  Result := false;
  if (Length(id_fields) <> 1) then exit;
  Result := VarSameValue(FIDDriver, id_fields[0]);
end;
//---------------------------------------------------------------------------
function TDriverEntity.SetEntityData(): boolean;
begin
  Result := false;
  if ((DataSource = nil) or (DataSource.DataSet = nil)) then exit;
  with DataSource.DataSet do
  try
    FIDDriver       := FieldByName('ID_DRIVER').AsVariant;
    FDateInsert     := FieldByName('DATE_INSERT').AsVariant;
    FDateUpdate     := FieldByName('DATE_UPDATE').AsVariant;
    FClient.DataSource :=
      dmData.GetClientByID(FieldByName('ID_CLIENT').AsString);
    Result := FClient.DB_Load(ltNew);
  except
    LogException('TDriverEntity.SetEntityData:');
    exit;
  end;
end;
//---------------------------------------------------------------------------
function TDriverEntity.InsertRecord(): boolean;
begin
  try
    Result := dmData.AddDriver(FClient.IDClient);
  except
    LogException('TDriverEntity.InsertRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
function TDriverEntity.UpdateRecord(): boolean;
begin
  // Водителя нельзя обновить в БД.
  Result := false;
end;
//---------------------------------------------------------------------------
function TDriverEntity.LoadSavedRecord(): boolean;
begin
  Result := false;
  with (DataSource.DataSet) do
  try
    if (Active) then
      Result := Locate('ID_DRIVER', IDDriver, [loCaseInsensitive]);
  except
    LogException('TDriverEntity.LoadSavedRecord:');
  end;
end;
//---------------------------------------------------------------------------
function TDriverEntity.DeleteRecord(): boolean;
begin
  // Водителя нельзя удалить из БД.
  // Водителями оперирует договор. Функции добавления договора,
  // передаётся список водителей. Предыдущие водители, для договора, удаляются.
  // Затем, список заносится в БД из временной таблицы.
  Result := false;
end;
//---------------------------------------------------------------------------
procedure TDriverEntity.ReInitEntity();
begin
  inherited;
  FClient.Assign(nil);
  FIDDriver   := Null;
  FContract   := nil;
  FDateInsert := Null;
  FDateUpdate := Null;
end;
//---------------------------------------------------------------------------
procedure TDriverEntity.Assign(Source: TEntity);
var s: TDriverEntity;
begin
  inherited Assign(Source);
  if (Source = nil) then exit;

  if (not (Source is TDriverEntity)) then exit;
  s := Source as TDriverEntity;
  FClient.Assign(s.Client);
  FIDDriver   := s.FIDDriver;
  FContract   := s.FContract;
  FDateInsert := s.FDateInsert;
  FDateUpdate := s.FDateUpdate;
end;
end.