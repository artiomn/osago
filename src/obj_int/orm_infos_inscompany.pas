unit orm_infos_inscompany;

//
// Модуль объектного представления страховой компании и бланков договора.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, variants, ZSysUtils, db, LR_DBRel, data_unit, logger,
  orm_abstract, orm_user, LR_Class;

var CompaniesCollection: TEntityesCollection;

type

//
// TInfInsCompany.
//

TBlankEntity = class;

TInfInsCompany = class(TEntity)
private
  FIDInsCompany: variant;
  FInsCompanyName: variant;
  FAddress: variant;
  FPhone: variant;
  FFax: variant;
  FComments: TStringList;
  FTicketBody: TMemoryStream;
  FBlanks: TEntityesCollection;
private
  procedure ReInitEntity(); override;
protected
  procedure SetID(const value: variant);
  procedure SetInsCompanyName(const value: variant);
  procedure SetAddress(const value: variant);
  procedure SetPhone(const value: variant);
  procedure SetFax(const value: variant);
  procedure SetComments(const value: TStringList);
  procedure SetTicketBody(const value: TMemoryStream);
protected
  // Загружает свободные бланки, для страховой компании.
  // Вызывается в SetEntityData().
  function LoadFreeBlanks(): boolean;
  // function SaveBlanks(): boolean;
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
  property IDInsCompany: variant read FIDInsCompany;
  property InsCompanyName: variant read FInsCompanyName write SetInsCompanyName;
  property Address: variant read FAddress write SetAddress;
  property Phone: variant read FPhone write SetPhone;
  property Fax: variant read FFax write SetFax;
  property Comments: TStringList read FComments write SetComments;
  property TicketBody: TMemoryStream read FTicketBody write SetTicketBody;
public
  property Blanks: TEntityesCollection read FBlanks;
  function BlankAdd(const ser, num: variant): TBlankEntity;
  function BlankDel(blank: TBlankEntity): boolean;
  function BlankDel(const ser, num: variant): boolean; overload;
public
  function LoadTicket(const report: TfrReport): boolean;
end;

//
// TBlankEntity. Бланк.
//

TBlankEntity = class(TEntity)
private
  FInsComp: TInfInsCompany;
  FDogSer: variant;
  FDogNum: variant;
  FBSOStatus: variant;
  FHostReserver: variant;
  FUserReserver: variant;
  FDateInsert: variant;
  FDateUpdate: variant;
protected
  function GetReserved(): boolean;
  procedure SetReserved(const value: boolean);
protected
  function SetEntityData(): boolean; override;
  function InsertRecord(): boolean; override;
  function LoadSavedRecord(): boolean; override;
  function UpdateRecord(): boolean; override;
  function DeleteRecord(): boolean; override;
  procedure Assign(Source: TEntity); override;
protected
  function GetBlankFullNum(): variant;
protected
  constructor Create(ACollection: TCollection); override;
public
  function GetBlankData(): boolean;
public
  constructor Create(ACollection: TCollection; AInsCompany: TInfInsCompany;
    const ser, num: variant); virtual;
  destructor Destroy; override;
public
  function CheckID(const id_fields: array of variant): boolean;
    override;
protected
  procedure ReInitEntity(); override;
public
  property InsuranceCompany: TInfInsCompany read FInsComp;
  property DogSer: variant read FDogSer;
  property DogNum: variant read FDogNum;
  property IDBSOStatus: variant read FBSOStatus;
  property HostReserver: variant read FHostReserver;
  property UserReserver: variant read FUserReserver;
  property DateInsert: variant read FDateInsert;
  property DateUpdate: variant read FDateUpdate;
  property Reserved: boolean read GetReserved write SetReserved;
  property BlankFullNum: variant read GetBlankFullNum;
  function BlankReserve(): boolean;
  function BlankUnreserve(): boolean;
  function BlankDamage(): boolean;
end;

implementation
//---------------------------------------------------------------------------
constructor TInfInsCompany.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
  FComments   := TStringList.Create();
  FBlanks     := TEntityesCollection.Create(TBlankEntity);
  FTicketBody := TMemoryStream.Create;
end;
//---------------------------------------------------------------------------
destructor TInfInsCompany.Destroy;
begin
  FTicketBody.Free;
  FBlanks.Free;
  FComments.Free;
  inherited;
end;
//---------------------------------------------------------------------------
procedure TInfInsCompany.SetInsCompanyName(const value: variant);
begin
  if (FInsCompanyName <> value) then
    begin
      FInsCompanyName := EncodeCString(value);
      DisplayName     := value;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TInfInsCompany.SetAddress(const value: variant);
begin
  if (FAddress <> value) then
    begin
      FAddress := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TInfInsCompany.SetPhone(const value: variant);
begin
  if (FPhone <> value) then
    begin
      FPhone := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TInfInsCompany.SetFax(const value: variant);
begin
  if (FFax <> value) then
    begin
      FFax := EncodeCString(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TInfInsCompany.SetComments(const value: TStringList);
begin
  if (FComments <> value) then
    begin
      FComments.Assign(value);
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
procedure TInfInsCompany.SetTicketBody(const value: TMemoryStream);
begin
  if (FTicketBody <> value) then
    begin
      FTicketBody.LoadFromStream(value);
      FTicketBody.Position := 0;
      DoOnChanged();
    end;
end;
//---------------------------------------------------------------------------
function TInfInsCompany.LoadTicket(const report: TfrReport): boolean;
begin
  Result := false;
  if (report = nil) then exit;
  try
    FTicketBody.Clear;
    FTicketBody.Position := 0;
    report.SaveToStream(FTicketBody);
    FTicketBody.Position := 0;
  except
    LogException('TInfInsCompany.LoadTicket:');
    exit;
  end;
  DoOnChanged();
  Result := true;
end;
//---------------------------------------------------------------------------
procedure TInfInsCompany.SetID(const value: variant);
begin
  if (FIDInsCompany <> value) then
    begin
      FIDInsCompany := EncodeCString(value);
      IsNew         := false;
    end;
end;
//---------------------------------------------------------------------------
function TInfInsCompany.CheckID(const id_fields: array of variant): boolean;
begin
  Result := false;
  if (Length(id_fields) <> 1) then exit;
  Result := VarSameValue(FIDInsCompany, id_fields[0]);
end;
//---------------------------------------------------------------------------
function TInfInsCompany.LoadFreeBlanks(): boolean;
var be: TBlankEntity;
    host, user: string;
begin
  Result  := false;
  if (CurrentUser <> nil) then
    begin
      host    := VarToStr(CurrentUser.Host);
      user    := VarToStr(CurrentUser.User);
    end
  else
    begin
      host    := EmptyStr;
      user    := EmptyStr;
    end;
  try
    FBlanks.Clear();
    try
      FBlanks.BeginUpdate();
      with (dmData.GetFreeBlanks(IDInsCompany, host, user).DataSet) do
        begin
          First();
          while (not EOF) do
            begin
              be := BlankAdd(Null, Null);
              if (be = nil) then
                raise EOutOfResources.Create('Can''t create blank');
              be.DataSource := dmData.datasrcFreeBlanks;
              be.DB_Load(ltNew);
              Next();
            end;
          Result := true;
        end;
    finally
      FBlanks.EndUpdate();
    end;
  except
    LogException('TInfInsCompany.LoadFreeBlanks:');
  end;
end;
//---------------------------------------------------------------------------
function TInfInsCompany.SetEntityData(): boolean;
begin
  Result := false;
  if ((DataSource = nil) or (DataSource.DataSet = nil)) then exit;
  with DataSource.DataSet do
  try
    FIDInsCompany   := FieldByName('ID_INSURANCE_COMPANY').AsVariant;
    FInsCompanyName := FieldByName('INSURANCE_COMPANY').AsVariant;
    FAddress        := FieldByName('ADDRESS').AsVariant;
    FPhone          := FieldByName('PHONE').AsVariant;
    FFax            := FieldByName('FAX').AsVariant;
    FComments.Text  := FieldByName('COMMENTS').AsString;
    with FieldByName('TICKET_BODY') as TBlobField do
//      if (BlobSize > 0) then
        begin
          FTicketBody.Clear;
          SaveToStream(FTicketBody);
          FTicketBody.Position := 0;
        end;

    Result          := LoadFreeBlanks();
  except
    LogException('TInfInsCompany.SetEntityData');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
function TInfInsCompany.InsertRecord(): boolean;
begin
  // Пока что, только для чтения.
  Result := false;
{  Result := true;
  with (dmData.zqProc) do
  try

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
function TInfInsCompany.UpdateRecord(): boolean;
begin
  Result := false;
  if ((DataSource = nil) or (DataSource.DataSet = nil)) then exit;
  with DataSource.DataSet do
  try
    if (not Locate('ID_INSURANCE_COMPANY', VarArrayOf([FIDInsCompany]), []))
      then exit;

    Edit();

    // FieldByName('ID_INSURANCE_COMPANY').AsVariant := FIDInsCompany;
    FieldByName('INSURANCE_COMPANY').AsVariant    := FInsCompanyName;
    FieldByName('ADDRESS').AsVariant              := FAddress;
    FieldByName('PHONE').AsVariant                := FPhone;
    FieldByName('FAX').AsVariant                  := FFax;
    FieldByName('COMMENTS').AsString              := FComments.Text;
    with (FieldByName('TICKET_BODY') as TBlobField) do
      begin
        // FTicketBody.Position := 0;
        LoadFromStream(FTicketBody);
      end;

    Post();

    Result := true;
  except
    LogException('TInfInsCompany.UpdateRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
function TInfInsCompany.LoadSavedRecord(): boolean;
begin
  Result := false;
  with (DataSource.DataSet) do
  try
    Active := true;
    Result := Locate('ID_INSURANCE_COMPANY', IDInsCompany,
      [loCaseInsensitive]);
  except
    LogException('TInfInsCompany.LoadSavedRecord:');
  end;
end;
//---------------------------------------------------------------------------
function TInfInsCompany.DeleteRecord(): boolean;
begin
  Result := false;
{  with (dmData.zqProcClnDel) do
  try
    ParamByName('id_').AsString := ID_;
    ExecSQL();
    Result := (dmData.GetErrCode() = 0);
  except
    on E: Exception do LogException(E);
    Result := false;
  end;}
end;
//---------------------------------------------------------------------------
procedure TInfInsCompany.ReInitEntity();
begin
  inherited;
  FIDInsCompany     := Null;
  FInsCompanyName   := Null;
  FAddress          := Null;
  FPhone            := Null;
  FFax              := Null;
  FTicketBody.Clear();
  FComments.Clear();
end;
//---------------------------------------------------------------------------
procedure TInfInsCompany.Assign(Source: TEntity);
var s: TInfInsCompany;
begin
  inherited Assign(Source);
  if (Source = nil) then exit;

  if (not (Source is TInfInsCompany)) then exit;
  s := Source as TInfInsCompany;
  FBlanks.Assign(s.FBlanks);
  FIDInsCompany     := s.FIDInsCompany;
  FInsCompanyName   := s.FInsCompanyName;
  FAddress          := s.FAddress;
  FPhone            := s.FPhone;
  FFax              := s.FFax;
  FTicketBody.LoadFromStream(s.FTicketBody);
  FComments.Assign(s.FComments);
end;
//---------------------------------------------------------------------------
function TInfInsCompany.BlankAdd(const ser, num: variant): TBlankEntity;
begin
  Result := TBlankEntity.Create(FBlanks, Self, ser, num);
end;
//---------------------------------------------------------------------------
function TInfInsCompany.BlankDel(blank: TBlankEntity): boolean;
var idx: integer;
begin
  Result  := false;
  idx     := FBlanks.GetEntityIndex(blank);
  if (idx < 0) then exit;
  FBlanks.Delete(idx);
end;
//---------------------------------------------------------------------------
function TInfInsCompany.BlankDel(const ser, num: variant): boolean; overload;
begin
  Result := FBlanks.DelEntity([ser, num]);
end;

//
// TBlankEntity.
//

constructor TBlankEntity.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);
end;
//---------------------------------------------------------------------------
constructor TBlankEntity.Create(ACollection: TCollection;
  AInsCompany: TInfInsCompany; const ser, num: variant);
begin
  Create(ACollection);
  FInsComp  := AInsCompany;
  FDogSer   := ser;
  FDogNum   := num;
end;
//---------------------------------------------------------------------------
destructor TBlankEntity.Destroy;
begin
  // Ссылка.
  FInsComp := nil;
  inherited;
end;
//---------------------------------------------------------------------------
function TBlankEntity.GetReserved(): boolean;
begin
  Result := ((FUserReserver <> Null) or (FHostReserver <> Null)
    or (IDBSOStatus <> 1));
end;
//---------------------------------------------------------------------------
procedure TBlankEntity.SetReserved(const value: boolean);
begin
  if (value <> GetReserved()) then
    begin
      if (value) then BlankReserve()
      else BlankUnreserve();
    end;
end;
//---------------------------------------------------------------------------
function TBlankEntity.CheckID(const id_fields: array of variant): boolean;
begin
  Result := false;
  if (Length(id_fields) <> 2) then exit;
  Result := VarSameValue(FDogSer, id_fields[0]) and
    VarSameValue(FDogNum, id_fields[1]);
end;
//---------------------------------------------------------------------------
function TBlankEntity.GetBlankFullNum(): variant;
begin
  Result := VarToStr(FDogSer) + ' - ' + VarToStr(FDogNum);
end;
//---------------------------------------------------------------------------
function TBlankEntity.SetEntityData(): boolean;
begin
  Result := false;
  if ((DataSource = nil) or (DataSource.DataSet = nil)) then exit;
  with DataSource.DataSet do
  try
    FDogSer       := FieldByName('DOG_SER').AsVariant;
    FDogNum       := FieldByName('DOGNUMB').AsVariant;
    FBSOStatus    := FieldByName('ID_BSO_STATUS').AsVariant;
    FDateInsert   := FieldByName('DATE_INSERT').AsVariant;
    FDateUpdate   := FieldByName('DATE_UPDATE').AsVariant;
    FHostReserver := FieldByName('HOST_RESERVER').AsVariant;
    FUserReserver := FieldByName('USER_RESERVER').AsVariant;
    Result := true;
  except
    LogException('TBlankEntity.SetEntityData:');
    exit;
  end;
end;
//---------------------------------------------------------------------------
function TBlankEntity.InsertRecord(): boolean;
begin
  Result := true;
  with (dmData.myProcBlankAdd) do
  try
    ParamByName('v_id_ins_company').AsString  := VarToStr(FInsComp.IDInsCompany);
    ParamByName('v_dog_ser').AsString         := FDogSer;
    ParamByName('v_dog_num').AsString         := FDogNum;

    ExecProc();

    if (dmData.GetErrCode(Connection) <> 0) then
      begin
        Result := false;
        exit;
      end;
  except
    LogException('TBlankEntity.InsertRecord:');
    Result := false;
  end;
end;
//---------------------------------------------------------------------------
function TBlankEntity.UpdateRecord(): boolean;
begin
  // Не реализован.
  Result := false;
{  with (dmData.zqProc) do
  try
    ParamByName('id_ins_company').AsString  := VarToStr(FInsComp.IDInsCompany);
    ParamByName('dog_ser').AsString         := FDogSer;
    ParamByName('dog_num').AsString         := FDogNum;

    ExecSQL();

    Result := (dmData.GetErrCode() = 0);
  except
    on E: Exception do LogException(E);
    Result := false;
  end;}
end;
//---------------------------------------------------------------------------
function TBlankEntity.LoadSavedRecord(): boolean;
begin
  Result := false;
  with (DataSource.DataSet) do
  try
    if (Active) then
      Result := Locate('ID_INSURANCE_COMPANY;DOG_SER;DOGNUMB',
        VarArrayOf([FInsComp.IDInsCompany, DogSer, DogNum]),
        [loCaseInsensitive]); // loPartialKey
  except
    LogException('TBlankEntity.LoadSavedRecord:');
  end;
end;
//---------------------------------------------------------------------------
function TBlankEntity.DeleteRecord(): boolean;
begin
  Result := false;
{  with (dmData.zqProcClnDel) do
  try
    ParamByName('id_').AsString := ID_;
    ExecSQL();
    Result := (dmData.GetErrCode() = 0);
  except
    on E: Exception do LogException(E);
    Result := false;
  end;}
end;
//---------------------------------------------------------------------------
procedure TBlankEntity.ReInitEntity();
begin
  inherited;
//  FInsComp      := nil;
  FDogSer       := Null;
  FDogNum       := Null;
  FBSOStatus    := Null;
  FHostReserver := Null;
  FUserReserver := Null;
  FDateInsert   := Null;
  FDateUpdate   := Null;
end;
//---------------------------------------------------------------------------
procedure TBlankEntity.Assign(Source: TEntity);
var s: TBlankEntity;
begin
  inherited Assign(Source);

  if (Source = nil) then exit;

  if (not (Source is TBlankEntity)) then exit;
  s := Source as TBlankEntity;

  // Это ссылка.
  FInsComp      := s.FInsComp;
  FDogSer       := s.FDogSer;
  FDogNum       := s.FDogNum;
  FBSOStatus    := s.FBSOStatus;
  FHostReserver := s.FHostReserver;
  FUserReserver := s.FUserReserver;
  FDateInsert   := s.FDateInsert;
  FDateUpdate   := s.FDateUpdate;
end;
//---------------------------------------------------------------------------
function TBlankEntity.GetBlankData(): boolean;
var old_ds: TDataSource;
begin
  // Я полон оптимизма. :-/
  Result := true;
  // Загружаю данные (USER_RESERVER, HOST_RESERVER).
  with (dmData.myGetBlankData) do
    try
      Close();
      ParamByName('id_ins_company').AsInteger := FInsComp.IDInsCompany;
      ParamByName('dog_ser').AsString         := VarToStr(FDogSer);
      ParamByName('dog_num').AsString         := VarToStr(FDogNum);
      Open();
      First();
      Result := (dmData.GetErrCode(Connection) = 0);
    except
      LogException('TBlankEntity.GetBlankData:');
      Result := false;
    end;
    if (Result) then
      try
        old_ds      := DataSource;
        DataSource  := dmData.datasrcGetBlankData;
        Result      := DB_Load(ltNew);
      finally
        DataSource := old_ds;
      end;
end;
//---------------------------------------------------------------------------
function TBlankEntity.BlankReserve(): boolean;
begin
  Result := true;
  if (IsNew or not IsSaved) then Result := DB_Save();
  if (not Result) then exit;
  with (dmData.myProcBlankReserve) do
  try
    ParamByName('v_id_ins_company').AsInteger := FInsComp.IDInsCompany;
    ParamByName('v_dog_ser').AsString         := VarToStr(FDogSer);
    ParamByName('v_dog_num').AsString         := VarToStr(FDogNum);
    ExecProc();
    Result := (dmData.GetErrCode(Connection) = 0);
  except
    LogException('TBlankEntity.BlankReserve:');
    Result := false;
  end;

  if (Result) then Result := GetBlankData();
end;
//---------------------------------------------------------------------------
function TBlankEntity.BlankUnreserve(): boolean;
begin
  Result := true;
  if (IsNew) then
    begin
      Result := false;
      exit;
    end;
  if (not IsSaved) then Result := DB_Save();
  if (not Result) then exit;
  with (dmData.myProcBlankUnreserve) do
  try
    ParamByName('v_id_ins_company').AsInteger := FInsComp.IDInsCompany;
    ParamByName('v_dog_ser').AsString         := VarToStr(FDogSer);
    ParamByName('v_dog_num').AsString         := VarToStr(FDogNum);
    ExecProc();
    Result := (dmData.GetErrCode(Connection) = 0);
  except
    LogException('TBlankEntity.BlankUnreserve:');
    Result := false;
  end;

  if (Result) then Result := GetBlankData();
end;
//---------------------------------------------------------------------------
function TBlankEntity.BlankDamage(): boolean;
begin
  Result := true;
  if (IsNew) then
    begin
      Result := false;
      exit;
    end;
  if (not IsSaved) then Result := DB_Save();
  if (not Result) then exit;
  with (dmData.myProcBlankDamage) do
  try
    ParamByName('v_id_ins_company').AsInteger := FInsComp.IDInsCompany;
    ParamByName('v_dog_ser').AsString         := VarToStr(FDogSer);
    ParamByName('v_dog_num').AsString         := VarToStr(FDogNum);
    ExecProc();
    Result := (dmData.GetErrCode(Connection) = 0);
  except
    LogException('TBlankEntity.BlankDamage:');
    Result := false;
  end;

  if (Result) then Result := GetBlankData();
end;
//---------------------------------------------------------------------------
end.
