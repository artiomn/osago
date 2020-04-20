unit orm_client; 

//
// Модуль объектного представления клиента.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, variants, ZSysUtils, MyAccess, db, data_unit, data_coefs,
  orm_abstract, dateutils, common_functions, logger;

var ClientsCollection: TEntityesCollection;

type

//
// TClientEntity.
//

TClientEntity = class(TEntity)
private
  FIDClient: variant;
  FClientType: variant;
  FClientName: variant;
  FClientPathr: variant;
  FClientSurname: variant;
  FINN: variant;
  FDocType: variant;
  FDocSer: variant;
  FDocNum: variant;
  FPostindex: variant;
  FBirthday: variant;
  FIDCountry: variant;
  FIDRegion: variant;
  FIDCity: variant;
  FTown: variant;
  FStreet: variant;
  FHome: variant;
  FCorpus: variant;
  FFlatNum: variant;
  FPhoneHome: variant;
  FBusinessPhone: variant;
  FCellPhone: variant;
  FLastCallDate: variant;
  FLicenseSer: variant;
  FLicenseNum: variant;
  FSDDate: variant;
  FSocialState: variant;
  FFamilyState: variant;
  FGViolations: variant;
  FInsClass: variant;
  FInsClassName: variant;
  FComments: TStringList;
  FDateInsert: variant;
  FDateUpdate: variant;
  FUIName: variant;
  FUUName: variant;

  FCountryName: variant;
  FRegionName: variant;
  FCityName: variant;
  FGeoGroup: variant;
  FFullName: variant;
  FFullAddress: variant;
  FDocTypeName: variant;
  FCTG: variant;
  FSSName: variant;
protected
  procedure ReInitEntity(); override;
protected
  // Устанавливает ID. После установки ID, считается, что сущность уже есть в
  // базе, поскольку ID формируется сервером.
  procedure SetID(const value: variant);
  procedure SetClientType(const value: variant);
  procedure SetClientName(const value: variant);
  procedure SetClientPathr(const value: variant);
  procedure SetClientSurname(const value: variant);
  procedure SetINN(const value: variant);
  procedure SetDocType(const value: variant);
  procedure SetDocSer(const value: variant);
  procedure SetDocNum(const value: variant);
  procedure SetPostindex(const value: variant);
  procedure SetBirthday(const value: variant);
  procedure SetCountry(const value: variant);
  procedure SetRegion(const value: variant);
  procedure SetCity(const value: variant);
  procedure SetTown(const value: variant);
  procedure SetStreet(const value: variant);
  procedure SetHome(const value: variant);
  procedure SetCorpus(const value: variant);
  procedure SetFlat(const value: variant);
  procedure SetPhoneHome(const value: variant);
  procedure SetBusinessPhone(const value: variant);
  procedure SetCellPhone(const value: variant);
  procedure SetLicenseSer(const value: variant);
  procedure SetLicenseNum(const value: variant);
  procedure SetSDDate(const value: variant);
  procedure SetSocialState(const value: variant);
  procedure SetFamilyState(const value: variant);
  procedure SetGViolations(const value: variant);
  procedure SetInsClass(const value: variant);
  procedure SetComments(const value: TStringList);
protected
  function SetEntityData(): boolean; override;
  function InsertRecord(): boolean; override;
  function LoadSavedRecord(): boolean; override;
  function UpdateRecord(): boolean; override;
  function DeleteRecord(): boolean; override;
  procedure Assign(Source: TEntity); override;
protected
  function GetAge(): variant;
  function GetStage(): variant;
  function GetFullName(): variant;
  function GetCountryName(): variant;
  function GetRegionName(): variant;
  function GetCityName(): variant;
  function GetGeoGroup(): variant;
  function GetFullAddress(): variant;
  function GetFullDoc(): variant;
  function GetInsClassName(): variant;
  function GetDocTypeName(): variant;
  function GetClientTypeGroup(): variant;
  function GetSocialState(): variant;
public
  constructor Create(ACollection: TCollection); override;
  destructor Destroy; override;
public
  function CheckID(const id_fields: array of variant): boolean;
    override;
public
  function GetAgeOnDate(const value: TDateTime): variant;
  function GetStageOnDate(const value: TDateTime): variant;
public
  property IDClient: variant read FIDClient write SetID;
  property IDClientType: variant read FClientType write SetClientType;
  property IDClientTypeGroup: variant read GetClientTypeGroup;
  property ClientName: variant read FClientName write SetClientName;
  property ClientPathronimyc: variant read FClientPathr write SetClientPathr;
  property ClientSurname: variant read FClientSurname write SetClientSurname;
  property INN: variant read FINN write SetINN;
  property IDDocType: variant read FDocType write SetDocType;
  property DocType: variant read GetDocTypeName;
  property DocSer: variant read FDocSer write SetDocSer;
  property DocNum: variant read FDocNum write SetDocNum;
  property Postindex: variant read FPostindex write SetPostindex;
  property Birthday: variant read FBirthday write SetBirthday;
  property Age: variant read GetAge;
  property Stage: variant read GetStage;
  property IDCountry: variant read FIDCountry write SetCountry;
  property CountryName: variant read GetCountryName;
  property IDRegion: variant read FIDRegion write SetRegion;
  property RegionName: variant read GetRegionName;
  property IDCity: variant read FIDCity write SetCity;
  property CityName: variant read GetCityName;
  property GeoGroup: variant read GetGeoGroup;
  property Town: variant read FTown write SetTown;
  property Street: variant read FStreet write SetStreet;
  property Home: variant read FHome write SetHome;
  property Corpus: variant read FCorpus write SetCorpus;
  property FlatNum: variant read FFlatNum write SetFlat;
  property PhoneHome: variant read FPhoneHome write SetPhoneHome;
  property BusinessPhone: variant read FBusinessPhone write SetBusinessPhone;
  property CellPhone: variant read FCellPhone write SetCellPhone;
  property LastCallDate: variant read FLastCallDate;
  property LicenseSer: variant read FLicenseSer write SetLicenseSer;
  property LicenseNum: variant read FLicenseNum write SetLicenseNum;
  property StartDrivingDate: variant read FSDDate write SetSDDate;
  property IDSocialState: variant read FSocialState write SetSocialState;
  property SocialState: variant read GetSocialState;
  property IDFamilyState: variant read FFamilyState write SetFamilyState;
  property GrossViolations: variant read FGViolations write SetGViolations;
  property IDInsuranceClass: variant read FInsClass write SetInsClass;
  property InsuranceClass: variant read GetInsClassName;
  property Comments: TStringList read FComments write SetComments;
  property DateInsert: variant read FDateInsert;
  property DateUpdate: variant read FDateUpdate;
  property UserInsertName: variant read FUIName;
  property UserUpdateName: variant read FUUName;
  property FullName: variant read GetFullName;
  property FullAddress: variant read GetFullAddress;
  property FullDoc: variant read GetFullDoc;
end;

implementation
//---------------------------------------------------------------------------
constructor TClientEntity.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FComments := TStringList.Create();
  ReInitEntity();
end;
//---------------------------------------------------------------------------
destructor TClientEntity.Destroy;
begin
  FComments.Free;
  inherited;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetClientType(const value: variant);
begin
  if (FClientType <> value) then
    begin
      FClientType := value;
      FCTG        := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetClientName(const value: variant);
begin
  if (FClientName <> value) then
    begin
      FClientName := EncodeCString(value);
      FFullName   := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetClientPathr(const value: variant);
begin
  if (FClientPathr <> value) then
    begin
      FClientPathr  := EncodeCString(value);
      FFullName     := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetClientSurname(const value: variant);
begin
  if (FClientSurname <> value) then
    begin
      FClientSurname  := EncodeCString(value);
      FFullName       := Null;
      DisplayName     := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetINN(const value: variant);
begin
  if (FINN <> value) then
    begin
      FINN := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetDocType(const value: variant);
begin
  if (FDocType <> value) then
    begin
      FDocType      := value;
      FDocTypeName  := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetDocSer(const value: variant);
begin
  if (FDocSer <> value) then
    begin
      FDocSer := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetDocNum(const value: variant);
begin
  if (FDocNum <> value) then
    begin
      FDocNum := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetPostindex(const value: variant);
begin
  if (FPostindex <> value) then
    begin
      FPostindex  := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetBirthday(const value: variant);
begin
  if (FBirthday <> value) then
    begin
      FBirthday   := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetCountry(const value: variant);
begin
  if (FIDCountry <> value) then
    begin
      FIDCountry    := EncodeCString(value);
      FFullAddress  := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetRegion(const value: variant);
begin
  if (FIDRegion <> value) then
    begin
      FIDRegion     := value;
      FRegionName   := Null;
{      FCityName     := Null;
      FGeoGroup     := Null;}
      FFullAddress  := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetCity(const value: variant);
begin
  if (FIDCity <> value) then
    begin
      FIDCity       := EncodeCString(value);
      FFullAddress  := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetTown(const value: variant);
begin
  if (FTown <> value) then
    begin
      FTown         := EncodeCString(value);
      FFullAddress  := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetStreet(const value: variant);
begin
  if (FStreet <> value) then
    begin
      FStreet       := EncodeCString(value);
      FFullAddress  := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetHome(const value: variant);
begin
  if (FHome <> value) then
    begin
      FHome         := EncodeCString(value);
      FFullAddress  := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetCorpus(const value: variant);
begin
  if (FCorpus <> value) then
    begin
      FCorpus       := EncodeCString(value);
      FFullAddress  := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetFlat(const value: variant);
begin
  if (FFlatNum <> value) then
    begin
      FFlatNum      := EncodeCString(value);
      FFullAddress  := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetPhoneHome(const value: variant);
begin
  if (FPhoneHome <> value) then
    begin
      FPhoneHome := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetBusinessPhone(const value: variant);
begin
  if (FBusinessPhone <> value) then
    begin
      FBusinessPhone := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetCellPhone(const value: variant);
begin
  if (FCellPhone <> value) then
    begin
      FCellPhone := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetLicenseSer(const value: variant);
begin
  if (FLicenseSer <> value) then
    begin
      FLicenseSer := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetLicenseNum(const value: variant);
begin
  if (FLicenseNum <> value) then
    begin
      FLicenseNum := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetSDDate(const value: variant);
begin
  if (FSDDate <> value) then
    begin
      FSDDate := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetSocialState(const value: variant);
begin
  if (FSocialState <> value) then
    begin
      FSocialState  := value;
      FSSName       := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetFamilyState(const value: variant);
begin
  if (FFamilyState <> value) then
    begin
      FFamilyState := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetGViolations(const value: variant);
begin
  if (FGViolations <> value) then
    begin
      FGViolations := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetInsClass(const value: variant);
begin
  if (FInsClass <> value) then
    begin
      FInsClass     := value;
      FInsClassName := Null;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetComments(const value: TStringList);
begin
  if (FComments <> value) then
    begin
      FComments.Assign(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.SetID(const value: variant);
begin
  if (FIDClient <> value) then
    begin
      FIDClient := EncodeCString(value);
      IsNew     := false;
    end;
end;
//---------------------------------------------------------------------------
function TClientEntity.CheckID(const id_fields: array of variant): boolean;
begin
  Result := false;
  if (Length(id_fields) <> 1) then exit;
  Result := VarSameValue(FIDClient, id_fields[0]);
end;
//---------------------------------------------------------------------------
function TClientEntity.GetAgeOnDate(const value: TDateTime): variant;
begin
  if ((Birthday = Null) or (value = Null)) then Result := Null
  else Result := YearsBetween(VarToDateTime(Birthday), value);
end;
//---------------------------------------------------------------------------
function TClientEntity.GetStageOnDate(const value: TDateTime): variant;
begin
  if ((StartDrivingDate = Null) or (value = Null)) then Result := Null
  else Result := YearsBetween(VarToDateTime(StartDrivingDate), value);
end;
//---------------------------------------------------------------------------
function TClientEntity.GetAge(): variant;
begin
  Result := GetAgeOnDate(Now());
end;
//---------------------------------------------------------------------------
function TClientEntity.GetStage(): variant;
begin
  Result := GetStageOnDate(Now());
end;
//---------------------------------------------------------------------------
function TClientEntity.GetFullName(): variant;
begin
  if (FFullName = Null) then
    begin
      FFullName := VarToStr(FClientSurname) + ' ' + VarToStr(FClientName) +
        ' ' + VarToStr(FClientPathr);
    end;
  Result := FFullName;
end;
//---------------------------------------------------------------------------
function TClientEntity.GetCountryName(): variant;
begin
  Result := FCountryName;
  if (Result <> Null) then exit;
  with (dmData.myCountries) do
    begin
      Open();
      if (Locate('ID_COUNTRY', StrToIntDef(VarToStr(FIDCountry), -1),
        [loCaseInsensitive]) = false) then
        begin
          FCountryName   := Null;
        end
      else
        begin
          FCountryName   := FieldByName('NAME').AsVariant;
        end;
    end;
  Result := FCountryName;
end;
//---------------------------------------------------------------------------
function TClientEntity.GetRegionName(): variant;
begin
  Result := FRegionName;
  if (Result <> Null) then exit;
  with (dmData.myRegion) do
    begin
      if (not ((Active) and
           VarSameValue(FieldByName('ID_COUNTRY').AsVariant, FIDCountry))) then
        begin
          Close();
          if (FIDCountry <> Null) then
            ParamByName('id_country').AsInteger := FIDCountry;
        end;

      Open();

      if (Locate('ID_REGION', StrToIntDef(VarToStr(FIDRegion), -1),
        [loCaseInsensitive]) = false) then
        begin
          FRegionName   := Null;
        end
      else
        begin
          FRegionName   := FieldByName('NAME').AsVariant;
        end;
    end;
  Result := FRegionName;
end;
//---------------------------------------------------------------------------
function TClientEntity.GetCityName(): variant;
begin
  Result := FCityName;
  if (Result <> Null) then exit;
  with (dmData.myCity) do
    begin
//      if ((Active) and
//           VarSameValue(FieldByName('ID_COUNTRY').AsVariant, FIDCountry) and
//           VarSameValue(FieldByName('ID_REGION').AsVariant, FIDRegion)) then
        begin
          Close();
          if ((FIDCountry <> Null) and (FIDRegion <> Null)) then
            begin
              ParamByName('id_country').AsInteger := FIDCountry;
              ParamByName('id_region').AsInteger  := FIDRegion;
            end;
        end;

      Open();

      if (Locate('ID_CITY', StrToIntDef(VarToStr(FIDCity), -1),
        [loCaseInsensitive]) = false) then
        begin
          FCityName   := Null;
          FGeoGroup   := Null;
        end
      else
        begin
          FCityName   := FieldByName('NAME').AsVariant;
          FGeoGroup   := FieldByName('GEO_GROUP').AsVariant;
        end;
    end;
  Result := FCityName;
end;
//---------------------------------------------------------------------------
function TClientEntity.GetGeoGroup(): variant;
begin
  if (FGeoGroup = Null) then GetCityName();
  Result := FGeoGroup;
end;
//---------------------------------------------------------------------------
function TClientEntity.GetFullAddress(): variant;
var s: string;
begin
  if (FFullAddress = Null) then
    begin
      FFullAddress := EmptyStr;
      s := VarToStr(FTown);
      if (s <> EmptyStr) then FFullAddress := FFullAddress + ', ' + s;
      s := VarToStr(FStreet);
      if (s <> EmptyStr) then FFullAddress := FFullAddress + ', ' + s;
      s := VarToStr(FHome);
      if (s <> EmptyStr) then FFullAddress := FFullAddress + ', ' + s;
      s := VarToStr(FCorpus);
      if (s <> EmptyStr) then FFullAddress := FFullAddress + ', ' + s;
      s := VarToStr(FFlatNum);
      if (s <> EmptyStr) then FFullAddress := FFullAddress + ', ' + s;
    end;
  Result := FFullAddress;
end;
//---------------------------------------------------------------------------
function TClientEntity.GetFullDoc(): variant;
begin
  Result := DocSer + ' - ' + DocNum;
end;
//---------------------------------------------------------------------------
function TClientEntity.GetInsClassName(): variant;
begin
  if (FInsClassName = Null) then
    begin
      with (dmCoefs.myGetInsCoef_KBM) do
        begin
          Active := true;
          if (Locate('ID_INSURANCE_CLASS', StrToIntDef(VarToStr(FInsClass), -1),
            [loCaseInsensitive]) = false) then
              FInsClassName := Null
          else FInsClassName := FieldByName('INSURANCE_CLASS').AsVariant;
        end;
    end;
  Result := FInsClassName;
end;
//---------------------------------------------------------------------------
function TClientEntity.GetDocTypeName(): variant;
begin
  if (FDocTypeName = Null) then
    begin
      with (dmData.myDocTypes) do
        begin
          Active := true;
          if (Locate('ID_TYPE_DOC', StrToIntDef(VarToStr(FDocType), -1),
            [loCaseInsensitive]) = false) then
              FDocTypeName := Null
          else FDocTypeName := FieldByName('DOC_TYPE').AsVariant;
        end;
    end;
  Result := FDocTypeName;
end;
//---------------------------------------------------------------------------
function TClientEntity.GetClientTypeGroup(): variant;
begin
  if (FCTG = Null) then
    begin
      with (dmData.myClientTypes) do
        begin
          Active := true;
          if (Locate('ID_CLIENT_TYPE', StrToIntDef(VarToStr(FClientType), -1),
            [loCaseInsensitive]) = false) then
              FCTG := Null
          else FCTG := FieldByName('ID_CLIENT_TYPE_GROUP').AsVariant;
        end;
    end;
  Result := FCTG;
end;
//---------------------------------------------------------------------------
function TClientEntity.GetSocialState(): variant;
begin
  if (FSSName = Null) then
    begin
      with (dmData.mySex) do
        begin
          Active := true;
          if (Locate('ID_SEX', StrToIntDef(VarToStr(FSocialState), -1),
            [loCaseInsensitive]) = false) then
              FSSName := Null
          else FSSName := FieldByName('SEX_NAME').AsVariant;
        end;
    end;
  Result := FSSName;
end;
//---------------------------------------------------------------------------
function TClientEntity.SetEntityData(): boolean;
begin
  Result := false;
  if ((DataSource = nil) or (DataSource.DataSet = nil)) then exit;
  with DataSource.DataSet do
  try
    FIDClient       := FieldByName('CLN_ID_CLIENT').AsVariant;
    FClientType     := FieldByName('CLN_ID_CLIENT_TYPE').AsVariant;
    FDocType        := FieldByName('CLN_ID_TYPE_DOC').AsVariant;
    FFamilyState    := FieldByName('CLN_ID_FAMILY_STATE').AsVariant;
    FSocialState    := FieldByName('CLN_ID_SEX').AsVariant;
    FGViolations    := FieldByName('CLN_GROSS_VIOLATIONS').AsVariant;
    FInsClass       := FieldByName('CLN_ID_INSURANCE_CLASS').AsVariant;
    FINN            := FieldByName('CLN_INN').AsVariant;
    FClientName     := FieldByName('CLN_NAME').AsVariant;
    FClientPathr    := FieldByName('CLN_MIDDLENAME').AsVariant;
    FClientSurname  := FieldByName('CLN_SURNAME').AsVariant;
    FPhoneHome      := FieldByName('CLN_HOME_PHONE').AsVariant;
    FCellPhone      := FieldByName('CLN_CELL_PHONE').AsVariant;
    FBusinessPhone  := FieldByName('CLN_BUSINESS_PHONE').AsVariant;
    FLastCallDate   := FieldByName('CLN_LAST_CALL_DATE').AsVariant;
    FDocSer         := FieldByName('CLN_DOC_SER').AsVariant;
    FDocNum         := FieldByName('CLN_DOC_NUM').AsVariant;
    FLicenseSer     := FieldByName('CLN_LICENCE_SER').AsVariant;
    FLicenseNum     := FieldByName('CLN_LICENCE_NO').AsVariant;
    FPostindex      := FieldByName('CLN_POSTINDEX').AsVariant;
    FIDCountry      := FieldByName('CLN_ID_COUNTRY').AsVariant;
    FIDRegion       := FieldByName('CLN_ID_REGION').AsVariant;
    FIDCity         := FieldByName('CLN_ID_CITY').AsVariant;
    FTown           := FieldByName('CLN_TOWN').AsVariant;
    FStreet         := FieldByName('CLN_STREET').AsVariant;
    FHome           := FieldByName('CLN_HOME').AsVariant;
    FCorpus         := FieldByName('CLN_KORPUS').AsVariant;
    FFlatNum        := FieldByName('CLN_FLAT').AsVariant;
    FBirthday       := FieldByName('CLN_BIRTHDAY').AsVariant;
    FSDDate         := FieldByName('CLN_START_DRIVING_DATE').AsVariant;
    FComments.Text  := FieldByName('CLN_COMMENTS').AsString;
    FDateInsert     := FieldByName('CLN_DATE_INSERT').AsVariant;
    FDateUpdate     := FieldByName('CLN_DATE_UPDATE').AsVariant;
    FUIName         := FieldByName('CLN_USER_INSERT_NAME').AsVariant;
    FUUName         := FieldByName('CLN_USER_UPDATE_NAME').AsVariant;

    FFullName       := FieldByName('FULL_NAME').AsVariant;
    FFullAddress    := FieldByName('FULL_ADDRESS').AsVariant;
    FCountryName    := Null;
    FRegionName     := Null;
    FCityName       := Null;
    FGeoGroup       := Null;
    FDocTypeName    := Null;
    FCTG            := Null;
    FSSName         := Null;

    Result := true;
  except
    LogException('TClientEntity.SetEntityData:');
    exit;
  end;
end;
//---------------------------------------------------------------------------
function TClientEntity.InsertRecord(): boolean;
begin
  Result := false;
  with (dmData.SQLAction(dmData.myProcClnMain, atInsert)) do
  try
    ParamByName('v_surname').AsString             := VarToStr(FClientSurname);
    ParamByName('v_name').AsString                := VarToStr(FClientName);
    ParamByName('v_middlename').AsString          := VarToStr(FClientPathr);
    ParamByName('v_birthday').AsDate              := FBirthday;
    ParamByName('v_inn').AsString                 := VarToStr(FINN);
    ParamByName('v_id_type_doc').AsString         := VarToStr(FDocType);
    ParamByName('v_doc_ser').AsString             := VarToStr(FDocSer);
    ParamByName('v_doc_num').AsString             := VarToStr(FDocNum);
    ParamByName('v_postindex').AsString           := VarToStr(FPostindex);

    if (FIDCountry <> Null) then
      ParamByName('v_id_country').AsInteger       := FIDCountry;
    if (FIDRegion <> Null) then
      ParamByName('v_id_region').AsInteger        := FIDRegion;
    if (FIDCity <> Null) then
      ParamByName('v_id_city').AsInteger          := FIDCity;

    ParamByName('v_town').AsString                := VarToStr(FTown);
    ParamByName('v_street').AsString              := VarToStr(FStreet);
    ParamByName('v_home').AsString                := VarToStr(FHome);
    ParamByName('v_korpus').AsString              := VarToStr(FCorpus);
    ParamByName('v_flat').AsString                := VarToStr(FFlatNum);
    ParamByName('v_home_phone').AsString          := VarToStr(FPhoneHome);
    ParamByName('v_cell_phone').AsString          := VarToStr(FCellPhone);
    ParamByName('v_business_phone').AsString      := VarToStr(FBusinessPhone);
    if (FSocialState <> Null) then
      ParamByName('v_id_sex').AsInteger           := FSocialState;
    if (FFamilyState <> Null) then
      ParamByName('v_id_family_state').AsInteger  := FFamilyState;
    ParamByName('v_id_client_type').AsString      := VarToStr(FClientType);
    ParamByName('v_gross_violations').AsBoolean   := VarToBool(FGViolations);
    ParamByName('v_id_insurance_class').AsString  := VarToStr(FInsClass);
    ParamByName('v_license_ser').AsString         := VarToStr(FLicenseSer);
    ParamByName('v_license_no').AsString          := VarToStr(FLicenseNum);
    ParamByName('v_start_driving_date').AsDate    := FSDDate;
    ParamByName('v_comments').AsString            := FComments.Text;

    Execute();

    Result := true;

    if (dmData.GetErrCode(Connection) <> 0) then
      begin
        Result := false;
        exit;
      end;
    FIDClient := dmData.GetLastInsertID();
  except
    LogException('TClientEntity.InsertRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
function TClientEntity.UpdateRecord(): boolean;
begin
  Result := false;

  with (dmData.SQLAction(dmData.myProcClnMain, atUpdate)) do
  try
    ParamByName('v_id_client').AsString           := VarToStr(FIDClient);
    ParamByName('v_surname').AsString             := VarToStr(FClientSurname);
    ParamByName('v_name').AsString                := VarToStr(FClientName);
    ParamByName('v_middlename').AsString          := VarToStr(FClientPathr);
    ParamByName('v_birthday').AsDate              := FBirthday;
    ParamByName('v_inn').AsString                 := VarToStr(FINN);
    ParamByName('v_id_type_doc').AsString         := VarToStr(FDocType);
    ParamByName('v_doc_ser').AsString             := VarToStr(FDocSer);
    ParamByName('v_doc_num').AsString             := VarToStr(FDocNum);
    ParamByName('v_postindex').AsString           := VarToStr(FPostindex);

    if (FIDCountry <> Null) then
      ParamByName('v_id_country').AsInteger       := FIDCountry;
    if (FIDRegion <> Null) then
      ParamByName('v_id_region').AsInteger        := FIDRegion;
    if (FIDCity <> Null) then
      ParamByName('v_id_city').AsInteger          := FIDCity;

    ParamByName('v_town').AsString                := VarToStr(FTown);
    ParamByName('v_street').AsString              := VarToStr(FStreet);
    ParamByName('v_home').AsString                := VarToStr(FHome);
    ParamByName('v_korpus').AsString              := VarToStr(FCorpus);
    ParamByName('v_flat').AsString                := VarToStr(FFlatNum);
    ParamByName('v_home_phone').AsString          := VarToStr(FPhoneHome);
    ParamByName('v_cell_phone').AsString          := VarToStr(FCellPhone);
    ParamByName('v_business_phone').AsString      := VarToStr(FBusinessPhone);
    if (FSocialState <> Null) then
      ParamByName('v_id_sex').AsInteger           := FSocialState;
    if (FFamilyState <> Null) then
      ParamByName('v_id_family_state').AsInteger  := FFamilyState;
    ParamByName('v_id_client_type').AsString      := VarToStr(FClientType);
    ParamByName('v_gross_violations').AsBoolean   := VarToBool(FGViolations);
    ParamByName('v_id_insurance_class').AsString  := VarToStr(FInsClass);
    ParamByName('v_license_ser').AsString         := VarToStr(FLicenseSer);
    ParamByName('v_license_no').AsString          := VarToStr(FLicenseNum);
    ParamByName('v_start_driving_date').AsDate    := FSDDate;
    ParamByName('v_comments').AsString            := FComments.Text;

    Execute();

    Result := (dmData.GetErrCode(Connection) = 0);
  except
    LogException('TClientEntity.UpdateRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
function TClientEntity.LoadSavedRecord(): boolean;
begin
  Result := false;
  with (DataSource.DataSet) do
  try
    if (Active) then
      Result := Locate('ID_CLIENT', IDClient, [loCaseInsensitive]);
  except
    LogException('TClientEntity.LoadSavedRecord:');
  end;
end;
//---------------------------------------------------------------------------
function TClientEntity.DeleteRecord(): boolean;
begin
  Result := false;
  with (dmData.SQLAction(dmData.myProcClnMain, atDelete)) do
  try
    ParamByName('v_id_client').AsString := VarToStr(FIDClient);
    Execute();
    Result := (dmData.GetErrCode(Connection) = 0);
  except
    LogException('TClientEntity.DeleteRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
procedure TClientEntity.ReInitEntity();
begin
  inherited;
  FIDClient       := Null;
  FClientType     := Null;
  FClientName     := Null;
  FClientPathr    := Null;
  FClientSurname  := Null;
  FINN            := Null;
  FDocType        := Null;
  FDocSer         := Null;
  FDocNum         := Null;
  FGViolations    := Null;
  FPostindex      := Null;
  FBirthday       := Null;
  FIDCountry      := Null;
  FIDRegion       := Null;
  FIDCity         := Null;
  FTown           := Null;
  FStreet         := Null;
  FHome           := Null;
  FCorpus         := Null;
  FFlatNum        := Null;
  FPhoneHome      := Null;
  FBusinessPhone  := Null;
  FCellPhone      := Null;
  FLastCallDate   := Null;
  FLicenseSer     := Null;
  FLicenseNum     := Null;
  FSDDate         := Null;
  FSocialState    := Null;
  FFamilyState    := Null;
  FInsClass       := Null;
  FDateInsert     := Null;
  FDateUpdate     := Null;
  FUIName         := Null;
  FUUName         := Null;

  FFullName       := Null;
  FFullAddress    := Null;
  FInsClassName   := Null;
  FCountryName    := Null;
  FRegionName     := Null;
  FCityName       := Null;
  FGeoGroup       := Null;
  FDocTypeName    := Null;
  FCTG            := Null;
  FSSName         := Null;
  FComments.Clear();
end;
//---------------------------------------------------------------------------
procedure TClientEntity.Assign(Source: TEntity);
var s: TClientEntity;
begin
  inherited Assign(Source);
  if (Source = nil) then exit;

  if (not (Source is TClientEntity)) then exit;
  s := Source as TClientEntity;
  FIDClient       := s.FIDClient;
  FClientType     := s.FClientType;
  FClientName     := s.FClientName;
  FClientPathr    := s.FClientPathr;
  FClientSurname  := s.FClientSurname;
  FINN            := s.FINN;
  FDocType        := s.FDocType;
  FDocSer         := s.FDocSer;
  FDocNum         := s.FDocNum;
  FGViolations    := s.FGViolations;
  FPostindex      := s.FPostindex;
  FBirthday       := s.FBirthday;
  FIDCountry      := s.FIDCountry;
  FIDRegion       := s.FIDRegion;
  FIDCity         := s.FIDCity;
  FTown           := s.FTown;
  FStreet         := s.FStreet;
  FHome           := s.FHome;
  FCorpus         := s.FCorpus;
  FFlatNum        := s.FFlatNum;
  FPhoneHome      := s.FPhoneHome;
  FBusinessPhone  := s.FBusinessPhone;
  FCellPhone      := s.FCellPhone;
  FLastCallDate   := s.FLastCallDate;
  FLicenseSer     := s.FLicenseSer;
  FLicenseNum     := s.FLicenseNum;
  FSDDate         := s.FSDDate;
  FSocialState    := s.FSocialState;
  FFamilyState    := s.FFamilyState;
  FInsClass       := s.FInsClass;
  FDateInsert     := s.FDateInsert;
  FDateUpdate     := s.FDateUpdate;
  FUIName         := s.FUIName;
  FUUName         := s.FUUName;

  FFullName       := s.FFullName;
  FFullAddress    := s.FFullAddress;
  FInsClassName   := s.FInsClassName;
  FCountryName    := s.FCountryName;
  FRegionName     := s.FRegionName;
  FCityName       := s.FCityName;
  FGeoGroup       := s.FGeoGroup;
  FDocTypeName    := s.FDocType;
  FCTG            := s.FCTG;
  FSSName         := s.FSSName;

  FComments.Assign(s.FComments);
end;
//---------------------------------------------------------------------------
end.
