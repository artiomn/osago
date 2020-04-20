unit ins_prem_calc;

//
// Вычисление страховых коэффициентов и страховой премии.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, FileUtil, LCLProc, math, orm_contract, strings_l10n,
  common_consts
  {, Dialogs};

// Получение класса договора и КБМ.
function GetInsClass(const contract: TContractEntity;
  out insclass_id: variant): double;
// Получение актуальных коэффициентов для договора.
procedure GetActualCoefs(const contract: TContractEntity;
  out bs, kt, kbm, kvs, ko, km, ks, kp, kn: double);
// Расчёт сраховой премии. Foreign надо каждый раз получать заново.
// Он может поменяться.
function CalculateInsPrem(const contract: TContractEntity;
  const bs, kt, kbm, kvs, ko, km, ks, kp, kn: double; var formula: string): double;

implementation

uses data_unit, data_coefs, common_functions, dateutils;
//---------------------------------------------------------------------------
type

  ESyntaxUnknown  = class(Exception);
  ESyntaxError    = class(Exception);

  TLexemeType = (ltNone, ltEOF, ltNumber, ltIdentifier, ltOp2, ltPlusMinus,
    ltLBracket, ltRBracket, ltPower, ltComma);

  TLexeme = class(TCollectionItem)
  private
    FPosition: integer;
    FLType:    TLexemeType;
    FValue:    string;
  public
    property Position: integer Read FPosition Write FPosition;
    property LType: TLexemeType Read FLType Write FLType;
    property Value: string Read FValue Write FValue;
  end;
//---------------------------------------------------------------------------
// Коллекция лексем.
  TLexemeCollection = class(TCollection)
  private
    FIndex: integer;
  public
    function AddLexeme(const position: integer; const ltype: TLexemeType;
      const Value: string): TLexeme;
    function SetOnFirst(): TLexeme;
    function GetCurLexeme(): TLexeme;
    function PrevLexeme(): TLexeme;
    function NextLexeme(): TLexeme;
  protected
    function GetLexeme(const idx: integer): TLexeme;
    procedure SetLexeme(const idx: integer; const Value: TLexeme);
  public
    property CurLexeme: TLexeme read GetCurLexeme;
    property Index: integer Read FIndex Write FIndex;
    property Items[Index: integer]: TLexeme Read GetLexeme Write SetLexeme; default;
  end;
//---------------------------------------------------------------------------
// Предопределённая функция.
  TFunctionCode = function(const args: array of double): double;

  TFunction = class(TCollectionItem)
  private
    FFunctionName: string;
    // Отриц. ArgCount - неорганиченное число аргументов.
    FMinArgcount: integer;
    FMaxArgcount: integer;
    FFunctionCode: TFunctionCode;
  private
    procedure SetFunctionName(const value: string);
  public
    property FunctionName: string read FFunctionName write SetFunctionName;
    property MinArgCount: integer read FMinArgcount write FMinArgcount;
    property MaxArgCount: integer read FMaxArgcount write FMaxArgcount;
    property Code: TFunctionCode read FFunctionCode write FFunctionCode;
  public
    function Exec(const args: array of double): double;
  end;
//---------------------------------------------------------------------------
// Коллекция функций.
  TFunctionCollection = class(TCollection)
    function AddFunction(const fname: string;
      const min_argc, max_argc: integer;
      const code: TFunctionCode): TFunction;
    function FuncIndex(const fname: string): integer;
  protected
    function GetFunction(const idx: integer): TFunction;
    procedure SetFunction(const idx: integer; const Value: TFunction);
  public
    property Items[Index: integer]: TFunction Read GetFunction Write SetFunction;
      default;
  end;
//---------------------------------------------------------------------------
// TLexemeCollection.
function TLexemeCollection.AddLexeme(const position: integer;
  const ltype: TLexemeType; const Value: string): TLexeme;
begin
  Result          := Add as TLexeme;
  Result.Position := position;
  Result.LType    := ltype;
  Result.Value    := Value;
end;
//---------------------------------------------------------------------------
function TLexemeCollection.GetLexeme(const idx: integer): TLexeme;
begin
  Result := GetItem(idx) as TLexeme;
end;
//---------------------------------------------------------------------------
procedure TLexemeCollection.SetLexeme(const idx: integer; const Value: TLexeme);
begin
  SetItem(idx, Value);
end;
//---------------------------------------------------------------------------
function TLexemeCollection.SetOnFirst(): TLexeme;
begin
  FIndex := 0;
  if (Count > FIndex) then Result := Self[FIndex]
  else Result := nil;
end;
//---------------------------------------------------------------------------
function TLexemeCollection.GetCurLexeme(): TLexeme;
begin
  if ((FIndex >= Count) or (FIndex < 0))  then Result := nil
  else Result := Self[FIndex];
end;
//---------------------------------------------------------------------------
function TLexemeCollection.PrevLexeme(): TLexeme;
begin
  Dec(FIndex);
  Result := GetCurLexeme();
end;
//---------------------------------------------------------------------------
function TLexemeCollection.NextLexeme(): TLexeme;
begin
  Inc(FIndex);
  Result := GetCurLexeme();
end;

//---------------------------------------------------------------------------
// TFunction.
procedure TFunction.SetFunctionName(const value: string);
begin
  if (FFunctionName <> value) then
    begin
      FFunctionName := UTF8UpperCase(SysToUTF8(value));
    end;
end;
//---------------------------------------------------------------------------
function TFunction.Exec(const args: array of double): double;
begin
  if ((FMinArgcount >= 0) and (Length(args) < FMinArgcount)) then
    raise ESyntaxError.CreateFmt(SysToUTF8(insp_calc_err_argcnt), [FFunctionName]);
  if ((FMaxArgcount >= 0) and (Length(args) > FMaxArgcount)) then
    raise ESyntaxError.CreateFmt(SysToUTF8(insp_calc_err_argcnt), [FFunctionName]);
  if (FFunctionCode <> nil) then Result := FFunctionCode(args);
end;
//---------------------------------------------------------------------------
// TFunctionCollection.
function TFunctionCollection.AddFunction(const fname: string;
  const min_argc, max_argc: integer;
  const code: TFunctionCode): TFunction;
var i: integer;
begin
  i := FuncIndex(fname);
  if (i > -1) then Result := Self[i]
  else Result := Add as TFunction;
  Result.FFunctionName  := fname;
  Result.MinArgCount    := min_argc;
  Result.MaxArgCount    := max_argc;
  Result.FFunctionCode  := code;
end;
//---------------------------------------------------------------------------
function TFunctionCollection.FuncIndex(const fname: string): integer;
var i: integer;
    s: string;
begin
  Result  := -1;
  s       := UTF8UpperCase(fname);
  for i := 0 to Count - 1 do
    if ((Items[i] as TFunction).FunctionName = s) then
      begin
        Result := i;
        break;
      end;
end;
//---------------------------------------------------------------------------
function TFunctionCollection.GetFunction(const idx: integer): TFunction;
begin
  Result := GetItem(idx) as TFunction;
end;
//---------------------------------------------------------------------------
procedure TFunctionCollection.SetFunction(const idx: integer;
  const Value: TFunction);
begin
  SetItem(idx, Value);
end;
//---------------------------------------------------------------------------
// Функции.
function fcalc_OKR(const args: array of double): double;
// ОКР(выражение, степень).
begin
  Result := RoundTo(args[0], trunc(args[1]));
end;
//---------------------------------------------------------------------------
function fcalc_SREDN(const args: array of double): double;
var i: integer;
begin
  Result := 0;
  for i := 0 to Length(args) - 1 do
    Result := Result + args[i];
  if (i <> 0) then Result := Result / i;
end;
//---------------------------------------------------------------------------
function fcalc_MIN(const args: array of double): double;
var i: integer;
begin
  Result := args[0];
  for i := 0 to Length(args) - 1 do
    if (args[i] < Result) then Result := args[i];
end;
//---------------------------------------------------------------------------
function fcalc_MAX(const args: array of double): double;
var i: integer;
begin
  Result := args[0];
  for i := 0 to Length(args) - 1 do
    if (args[i] > Result) then Result := args[i];
end;
//---------------------------------------------------------------------------
function fcalc_DROB(const args: array of double): double;
begin
  Result := frac(args[0]);
end;
//---------------------------------------------------------------------------
function fcalc_LOG(const args: array of double): double;
begin
  Result := logn(args[0], args[1]);
end;
//---------------------------------------------------------------------------
function fcalc_KORENKV(const args: array of double): double;
begin
  Result := sqrt(args[0]);
end;
//---------------------------------------------------------------------------
function fcalc_MODUL(const args: array of double): double;
begin
  Result := abs(args[0]);
end;
//---------------------------------------------------------------------------
function fcalc_LOGNAT(const args: array of double): double;
begin
  Result := ln(args[0]);
end;
//---------------------------------------------------------------------------
var
  LexemeCollection: TLexemeCollection;
  FunctionCollection: TFunctionCollection;
//---------------------------------------------------------------------------
function GetInsClass(const contract: TContractEntity;
  out insclass_id: variant): double;
var
  drv_id_ins_class: variant;
  tmp_kbm: double;
  i: integer;
begin
  // При неогр. водителях - класс собственника ТС, а также класс,
  // который был определен при заключении последнего договора.
  Result  := 0;
  tmp_kbm := 0;
  with contract do
    if (VarToBool(UnlimitedDrivers)) then
      begin
        if (Car.CarOwner.IDInsuranceClass <> Null) then
          Result := dmCoefs.GetInsCoef_KBM(Car.CarOwner.IDInsuranceClass);
        insclass_id := Car.CarOwner.IDInsuranceClass;
      end
    else
      // При огр. - по наихудшему водителю.
      with contract do
        for i := 0 to Drivers.Count - 1 do
          begin
            drv_id_ins_class :=
              (Drivers[i] as TDriverEntity).Client.IDInsuranceClass;
            if (drv_id_ins_class <> Null) then
            begin
              tmp_kbm := dmCoefs.GetInsCoef_KBM(drv_id_ins_class);
              if (tmp_kbm > Result) then
                begin
                  Result      := tmp_kbm;
                  insclass_id := drv_id_ins_class;
                end;
            end;
          end;
end;
//---------------------------------------------------------------------------
procedure GetActualCoefs(const contract: TContractEntity;
  out bs, kt, kbm, kvs, ko, km, ks, kp, kn: double);
var
  foreign:  boolean;
  id_car_type:     variant;
  ow_geo_group:    variant;
  ow_id_client_type, ow_ctg: variant;

  // Базовая ставка.
  function GetBS(): double;
  begin
    Result := 0;
    if ((ow_ctg <> Null) and (id_car_type <> Null)) then
      Result := dmCoefs.GetInsCoef_BaseSum(ow_ctg, id_car_type);
  end;

  // КТ.
  function GetKT(): double;
  begin
    Result := 0;
    if ((ow_geo_group <> Null) and (id_car_type <> Null)) then
      Result := dmCoefs.GetInsCoef_KT(ow_geo_group, id_car_type);
  end;

  // КБМ.
  function GetKBM(): double;
  begin
    with contract do
    begin
      if (IDInsuranceClass = Null) then Result := 0
      else Result := dmCoefs.GetInsCoef_KBM(IDInsuranceClass);
    end;
  end;

  // КО.
  function GetKO(): double;
  begin
    with contract do
      Result := dmCoefs.GetInsCoef_KO(VarToBool(UnlimitedDrivers));
  end;

  // КВС.
  function GetKVS(): double;
  var
    tmp_kvs: double;
    sdate: TDateTime;
    i: integer;
  begin
    // КВС считается по наихудшему водителю или 1, при неогр. водителях.
    with contract do
    begin
      if (VarToBool(UnlimitedDrivers)) then
        Result := 1
      else
      begin
        Result := 0;
        if (DateStart = Null) then
          sdate := Now()
        else
          sdate := DateStart;
        for i := 0 to Drivers.Count - 1 do
        begin
          tmp_kvs := dmCoefs.GetInsCoef_KVS(
            (Drivers[i] as TDriverEntity).Client.GetStageOnDate(sdate),
            (Drivers[i] as TDriverEntity).Client.GetAgeOnDate(
            sdate));
          if (tmp_kvs > Result) then
            Result := tmp_kvs;
        end;
      end; // else.
    end;   // with.
  end;

  // КМ.
  function GetKM(): double;
  var power_hp: double;
  begin
    // Только для легковых.
    Result := 0;
    with contract.Car do
      begin
        if (IDCarType = Null) then exit;
        if (PowerHP <> Null) then power_hp := PowerHP
        else if (PowerKWT <> Null) then power_hp := PowerKWT * ct_kwt2hp
        else exit;
        Result := dmCoefs.GetInsCoef_KM(IDCarType, power_hp);
      end;
      if (Result <= 0) then Result := 1;
  end;

  // КС.
  function GetKS(): double;
  var mu: variant;
  begin
    // Суммируются все периоды использования.
    Result := 0;
    contract.MonthsInUse;
    if (mu <> Null) then
      Result := dmCoefs.GetInsCoef_KS(mu);
  end;

  // КП.
  function GetKP(): double;
  var
    period: variant;
  begin
    // Для иностранцев или владельцев ТС, следующих транзитом.
    Result := 0;
    with contract do
    begin
      if (foreign) then
      begin
        period := InsPeriodInDays;
        if (period = Null) then
          exit;
        // Пересчёт в месяцы.
        if (period <= 15) then
          period := 0.5
        else if (period < ApproxDaysPerMonth) then
          period := 1
        else
          period := period / ApproxDaysPerMonth;
        Result := dmCoefs.GetInsCoef_KP(period);
      end
      else if (VarToBool(Transit)) then
      begin
        if (dmCoefs.GetInsCoef_Other(kn, kp)) then
          Result := kp;
      end
      else
        Result := 1;
    end;
  end;

  // КН.
  function GetKN(): double;
  begin
    Result := 0;
    with contract do
      if (VarToBool(Car.CarOwner.GrossViolations)) then
      begin
        dmCoefs.GetInsCoef_Other(kn, kp);
        Result := kn;
      end
      else
        Result := 1;
  end;

begin
  // КО, КБМ, КВС, КН, КП.
  bs      := 0;
  kt      := 0;
  kbm     := 0;
  kvs     := 0;
  ko      := 0;
  km      := 0;
  ks      := 0;
  kn      := 0;
  kp      := 0;
  foreign := False;

  with dmData, dmCoefs, contract do
  begin
    id_car_type := Car.IDCarType;
    ow_geo_group := Car.CarOwner.GeoGroup;
    ow_id_client_type := Car.CarOwner.IDClientType;
    ow_ctg := Car.CarOwner.IDClientTypeGroup;

    // Для иностранцев.
    if ((ow_geo_group <> Null) and (ow_id_client_type <> Null)) then
    begin
      foreign := GetInsCoef_Foreing(ow_geo_group, ow_id_client_type,
        ko, kvs, kbm);
    end
    else
    begin
      ko    := 0;
      kvs   := 0;
      kbm   := 0;
    end;
  end;

  bs := GetBS();
  kt := GetKT();
  if (not foreign) then
    kbm := GetKBM();
  if (not foreign) then
    ko := GetKO();
  if (not foreign) then
    kvs := GetKVS();
  ks    := GetKS();
  km    := GetKM();
  kp    := GetKP();
  kn    := GetKN();
end;
//---------------------------------------------------------------------------
function ParseFormula(const formula: ansistring;
  const bs, kt, kbm, kvs, ko, km, ks, kp, kn: double): double;

var
  RUSAlphabet: array[1..66] of
  string = ('А', 'а', 'Б', 'б', 'В', 'в', 'Г', 'г',
    'Д', 'д', 'Е', 'е', 'Ё', 'ё', 'Ж', 'ж', 'З', 'з',
    'И', 'и', 'Й', 'й', 'К', 'к', 'Л', 'л', 'М', 'м',
    'Н', 'н', 'О', 'о', 'П', 'п', 'Р', 'р', 'С', 'с', 'Т',
    'т', 'У', 'у', 'Ф', 'ф', 'Х', 'х', 'Ц', 'ц', 'Ч',
    'ч', 'Ш', 'ш', 'Щ', 'щ', 'Ъ', 'ъ', 'Ы', 'ы', 'Ь',
    'ь', 'Э', 'э', 'Ю', 'ю', 'Я', 'я');

  // Выделение лексем.

  function IsDigit(const c: char): boolean; inline;
  begin
    Result := (c in ['0'..'9']);
  end;

  function IsLetter(const c: char): boolean; inline;
  var
    i: integer;
  begin
    Result := ((c in ['a'..'z']) or (c in ['A'..'Z']) or (SysToUTF8(c) = '_'));
    if (not Result) then
      for i := 1 to Length(RUSAlphabet) do
        if (RUSAlphabet[i] = SysToUTF8(c)) then
        begin
          Result := True;
          break;
        end;
  end;

  function IsSpace(const c: char): boolean; inline;
  begin
    Result := (c in [' ', #09, #13, #10]);
  end;

  function IsOperator2(const op: string): boolean; inline;
  var _op: string;
  begin
    _op     := SysToUTF8(op);
    Result  := (_op = '*') or (_op = '/') or (_op = '%') or (_op = 'div');
  end;

  function GetBracket(const s: string; var p: integer): boolean; inline;
  begin
    Result := False;
    case s[p] of
      '(': LexemeCollection.AddLexeme(p, ltLBracket, SysToUTF8(s[p]));
      ')': LexemeCollection.AddLexeme(p, ltRBracket, SysToUTF8(s[p]));
      else
        exit;
    end;
    Inc(p);
    Result := True;
  end;

  function GetPlusMinus(const s: string; var p: integer): boolean; inline;
  begin
    Result := False;
    case s[p] of
      '+', '-': LexemeCollection.AddLexeme(p, ltPlusMinus, SysToUTF8(s[p]));
      else
        exit;
    end;
    Inc(p);
    Result := True;
  end;

  function GetPower(const s: string; var p: integer): boolean; inline;
  begin
    Result := SysToUTF8(s[p]) = '^';
    if (not Result) then exit;
    LexemeCollection.AddLexeme(p, ltPower, SysToUTF8(s[p]));
    Inc(p);
  end;

  function GetComma(const s: string; var p: integer): boolean;
  begin
    Result := SysToUTF8(s[p]) = ',';
    if (not Result) then exit;
    LexemeCollection.AddLexeme(p, ltComma, SysToUTF8(s[p]));
    Inc(p);
  end;

  procedure SkipSpaces(const s: string; var p: integer); inline;
  begin
    repeat
      if (IsSpace(s[p])) then Inc(p);
    until ((p > Length(s)) or (not IsSpace(s[p])));
  end;

  function GetNumber(const s: string; var p: integer): boolean;
  var
    init_pos, rollback_pos: integer;
  begin
    init_pos := p;
    Result   := False;
    if (not IsDigit(s[p])) then exit;

    repeat
      Inc(p);
    until (p > Length(s)) or not IsDigit(s[p]);

    if (p <= Length(s)) and (s[p] = '.') then
      begin
        Inc(p);
        if ((p > Length(s)) or not IsDigit(s[p])) then Dec(P)
        else
          repeat
            Inc(p)
          until ((p > Length(s)) or not IsDigit(s[p]));
      end;

    if ((p <= Length(s)) and (UpperCase(s[p]) = 'E')) then
    begin
      rollback_pos := p;
      Inc(p);
      if (p > Length(s)) then
        p := rollback_pos
      else
      begin
        if (s[p] in ['+', '-']) then
        begin
          Inc(p);
        end;
        if ((p > Length(s)) or not IsDigit(s[p])) then
          p := rollback_pos
        else
          repeat
            Inc(p);
          until (p > Length(s)) or not IsDigit(s[p]);
      end;
    end;

    LexemeCollection.AddLexeme(init_pos, ltNumber,
      SysToUTF8(Copy(s, init_pos, p - init_pos)));
    Result := True;
  end;

  function GetWord(const s: string; var p: integer): boolean;
  var
    init_pos: integer;
    cword: string;
  begin
    Result   := false;
    init_pos := p;
    if (not IsLetter(s[p])) then exit;
    Inc(p);
    while ((p <= Length(s)) and ((IsLetter(s[p]) or IsDigit(s[p])))) do
    begin
      Inc(p);
    end;

    cword := Copy(s, init_pos, p - init_pos);
    if (IsOperator2(cword)) then
      LexemeCollection.AddLexeme(init_pos, ltOp2, SysToUTF8(cword))
    else
      LexemeCollection.AddLexeme(init_pos, ltIdentifier, SysToUTF8(cword));

    Result := true;
  end;

  procedure GetLexeme(const s: string; var p: integer);
  begin
    if (GetBracket(s, p)) then exit;
    if (IsOperator2(s[p])) then
    begin
      LexemeCollection.AddLexeme(p, ltOp2, SysToUTF8(s[p]));
      Inc(p);
      exit;
    end;

    if (GetPlusMinus(s, p)) then exit;
    if (GetNumber(s, p)) then exit;
    if (GetWord(s, p)) then exit;
    if (GetPower(s, p)) then exit;
    if (GetComma(s, p)) then exit;
    LexemeCollection.AddLexeme(p, ltNone, s[p]);
    Inc(p);
  end;

  // Синтаксис и семантика.

  procedure AddFunctions();
  begin
    if (FunctionCollection = nil) then
      begin
        FunctionCollection := TFunctionCollection.Create(TFunction);
        with FunctionCollection do
          begin
            AddFunction('ОКР', 2, 2, @fcalc_OKR);
            AddFunction('СРЕДНЕЕ', 1, -1, @fcalc_SREDN);
            AddFunction('МИН', 1, -1, @fcalc_MIN);
            AddFunction('МАКС', 1, -1, @fcalc_MAX);
            AddFunction('ДРОБ', 1, 1, @fcalc_DROB);
            AddFunction('ЛОГ', 2, 2, @fcalc_LOG);
            AddFunction('КОРЕНЬКВ', 1, 1, @fcalc_KORENKV);
            AddFunction('МОДУЛЬ', 1, 1, @fcalc_MODUL);
            AddFunction('ЛОГНАТ', 1, 1, @fcalc_LOGNAT);
          end;
      end;
  end;

  function IsEOF(const lexeme: TLexeme): boolean;
  begin
    Result := ((lexeme = nil) or (lexeme.LType = ltEOF));
  end;

  function FuncExists(const func_name: string): boolean;
  begin
    Result := FunctionCollection.FuncIndex(func_name) > -1;
  end;

  function DoFunc(const func_name: string; const argv: array of double): double;
  begin
    with FunctionCollection[FunctionCollection.FuncIndex(func_name)]
      as TFunction do
        Result := Exec(argv);
  end;

  function GetVariable(const var_name: string): double;
  begin
    // Страховые коэффициенты.
    if (UTF8UpperCase(var_name) = 'ТБ') then Result       := bs
    else if (UTF8UpperCase(var_name) = 'КТ') then Result  := kt
    else if (UTF8UpperCase(var_name) = 'КБМ') then Result := kbm
    else if (UTF8UpperCase(var_name) = 'КО') then Result  := ko
    else if (UTF8UpperCase(var_name) = 'КВС') then Result := kvs
    else if (UTF8UpperCase(var_name) = 'КМ') then Result  := km
    else if (UTF8UpperCase(var_name) = 'КС') then Result  := ks
    else if (UTF8UpperCase(var_name) = 'КП') then Result  := kp
    else if (UTF8UpperCase(var_name) = 'КН') then Result  := kn
    // Пи.
    else if (UTF8UpperCase(var_name) = 'ПИ') then Result  := pi
    // E.
    else if ((UTF8UpperCase(var_name) = 'Е') or (UTF8UpperCase(var_name) = 'E'))
      then Result := exp(1)
    else raise ESyntaxError.CreateFmt(SysToUTF8(insp_calc_err_var), [var_name]);
  end;

  function Expr(): double; forward;

  function Func(): double;
  // Настолько увеличивается массив аргументов.
  const length_quant = 10;
  var func_name: string;
      arg_arr: array of double;
      arg_num: byte;
  begin
    with (LexemeCollection) do
      begin
        func_name := CurLexeme.Value;
        NextLexeme();
        if (IsEOF(CurLexeme) or (CurLexeme.LType <> ltLBracket)) then
          raise ESyntaxUnknown.CreateFmt(SysToUTF8(insp_calc_err_nolbrkt),
          [CurLexeme.Position]);
        // Функции нет.
        if (not FuncExists(func_name)) then
          raise ESyntaxError.CreateFmt(SysToUTF8(insp_calc_err_nofunc),
          [func_name, PrevLexeme().Position]);

        arg_num := 0;
        SetLength(arg_arr, length_quant);
        repeat
          // Слишком много агументов.
          if (arg_num = 255) then raise ESyntaxError.CreateFmt(
            SysToUTF8(insp_calc_err_argmax), [CurLexeme.Position]);
          if (Length(arg_arr) < arg_num) then
            SetLength(arg_arr, arg_num + length_quant);
          NextLexeme();
          arg_arr[arg_num] := Expr();
          Inc(arg_num);

        until (IsEOF(CurLexeme) or (CurLexeme.LType <> ltComma));

        // Ожидается )
        if (IsEOF(CurLexeme)) then
          raise ESyntaxError.CreateFmt(SysToUTF8(insp_calc_err_norbrkt),
            [PrevLexeme().Position])
        else if (CurLexeme.LType <> ltRBracket) then
        // Ожидается запятая.
          raise ESyntaxError.CreateFmt(
            SysToUTF8(insp_calc_err_nocomma), [CurLexeme.Position]);

        SetLength(arg_arr, arg_num);
        Result := DoFunc(func_name, arg_arr);

        NextLexeme();
    end; // with
  end;

  function Base(): double;
  begin
    with LexemeCollection do
      begin
        case CurLexeme.LType of
          ltLBracket:
          begin
            // Ожидается выражение.
            if (IsEOF(NextLexeme())) then raise ESyntaxError.CreateFmt(
              SysToUTF8(insp_calc_err_nolexpr), [CurLexeme.Position]);
            Result := Expr();
            // Ожидается ")".
            if (IsEOF(CurLexeme) or (CurLexeme.LType <> ltRBracket)) then
              raise ESyntaxError.CreateFmt(SysToUTF8(insp_calc_err_norbrkt),
                [CurLexeme.Position]);
            NextLexeme();
          end;
          ltIdentifier:
          begin
            // ID. По левой скобке определяется переменная это или функция.
            if (IsEOF(NextLexeme()) or (CurLexeme.LType <> ltLBracket)) then
              begin
                PrevLexeme();
                Result := GetVariable(CurLexeme.Value);
                // GetVariable() не меняет лексему.
                NextLexeme();
              end
            else
              begin
                PrevLexeme();
                Result := Func();
              end;
          end;
          ltNumber:
          begin
            Result := StrToFloat(CurLexeme.Value);
            NextLexeme();
          end;
          ltComma: begin (* для функций *) end;
          ltNone:
            // Некорректный символ.
            raise ESyntaxError.CreateFmt(SysToUTF8(insp_calc_err_symbol),
              [CurLexeme.Value, CurLexeme.Position])
          else
            // Некорректный символ.
            raise ESyntaxError.CreateFmt(SysToUTF8(insp_calc_err_symbol),
              [CurLexeme.Value, CurLexeme.Position]);
        end; // case
      end; // with
  end; // Base()

  function Factor(): double;
  var lvalue: string;
  begin
    with (LexemeCollection) do
      begin
        case CurLexeme.LType of
          ltPlusMinus:
          begin
            lvalue := CurLexeme.Value;
            // Ожидается выражение.
            if (IsEOF(NextLexeme())) then raise ESyntaxError.CreateFmt(
              SysToUTF8(insp_calc_err_nolexpr), [CurLexeme.Position]);
            if (lvalue = '-') then Result := -Factor()
            else Result := Factor();
          end
          else
            begin
              Result := Base();
              if (CurLexeme.LType = ltPower) then
                begin
                  // Ожидается выражение.
                  if (IsEOF(NextLexeme())) then raise ESyntaxError.CreateFmt(
                    SysToUTF8(insp_calc_err_nolexpr), [CurLexeme.Position]);
                  Result := Power(Result, Factor());
                end;
            end;
        end; // case
    end; // with
  end; // Factor()

  function Term(): double;
  var op: string;
      fr: double;
  begin
    with (LexemeCollection) do
      begin
        Result := Factor();
        while (CurLexeme.LType = ltOp2) do
          begin
            op := CurLexeme.Value;
            // Ожидается выражение.
            if (IsEOF(NextLexeme())) then raise ESyntaxError.CreateFmt(
              SysToUTF8(insp_calc_err_nolexpr), [CurLexeme.Position]);
            if (op = '*') then
              begin
                Result := Result * Factor();
                continue;
              end;
            // Попытка деления на ноль. SIGFPE. Ловлю раньше.
            fr := Factor();
            if (fr = 0) then raise ESyntaxError.Create(
              SysToUTF8(insp_calc_err_ariph));
            if (op = '/') then Result := Result / fr
            else if (op = 'div') then Result := Trunc(Result) div Trunc(fr)
            else if (op = '%') then Result := Trunc(Result) mod Trunc(fr);
          end; // while
      end; // with
  end;

  function Expr(): double;
  var op: string;
  begin
    with (LexemeCollection) do
      begin
        // Ожидается выражение.
        if (IsEOF(CurLexeme)) then raise ESyntaxError.CreateFmt(
          SysToUTF8(insp_calc_err_nolexpr), [CurLexeme.Position]);
        Result := Term();
        while (CurLexeme.LType = ltPlusMinus) do
          begin
            op := CurLexeme.Value;
            // Ожидается выражение.
            if (IsEOF(NextLexeme())) then raise ESyntaxError.CreateFmt(
              SysToUTF8(insp_calc_err_nolexpr), [CurLexeme.Position]);
            if (op = '+') then Result := Result + Term()
            else if (op = '-') then Result := Result - Term();
          end; // while
      end; // with
  end;


(*
  Грамматика формулы расчёта:
    <Expr>          ::= <Term> {<Operator1> <Term>}
    <Operator1>     ::= '+' | '-'
    <Term>          ::= <Factor> {<Operator2> <Factor>}
    <Operator2>     ::= '*' | '/' | 'div' | '%'
    <Factor>        ::= <UnaryOp> <Factor> | <Base> ['^' <Factor>]
    <UnaryOp>       ::= '+' | '-'
    <Base>          ::= <Variable> | <Function> | <Number> |
      <lbracket> <Expr> <rbracket>
    <Function>      ::= <Identifier> <lbracket>
      [{<Expr>} [{<comma> <Expr>}]] <rbracket>
    <Variable>      ::= <Identifier>
    <Identifier>    ::= <letter>{<letter>|<digit>}
    <lbracket>      ::= '('
    <rbracket>      ::= ')'
    <comma>         ::= ','
    <letter>        ::= 'A' | ... | 'Z' | 'a' | ... | 'z' | '_' |
      'А' | ... | 'Я' | 'а' | ... | 'я'
    <number>        ::= <digit> {<digit>} ['.' <digit> {<digit>}]
      [('E' | 'e') ['+' | '-'] <digit> {<digit>}]
    <digit>         ::= '0' | ... | '9'
  Функции:
    1. ОКР(выражение, степень).
    2. СРЕДНЕЕ(пар_1, пар_2, ..., пар_n).
    3. МИН(пар_1, пар_2, ..., пар_n).
    4. МАКС(пар_1, пар_2, ..., пар_n).
    5. ДРОБ(выражение).
    6. ЛОГ(основание, показатель).
    7. КОРЕНЬКВ(выражение).
    8. МОДУЛЬ(выражение).
    9. ЛОГНАТ(выражение).
  Предопределённые переменные:
    1. Страховые коэффициенты.
    2. Пи - число Пи.
    3. e|е - число e.
*)

var
  p: integer;
  s: string;

begin
  p := 1;
  if (LexemeCollection = nil) then
    LexemeCollection := TLexemeCollection.Create(TLexeme)
  else
    LexemeCollection.Clear();
  // И никакого UTF!!!
  s := UTF8ToAnsi(formula);
  // Лексический анализ.
  while (p <= Length(s)) do
  begin
    SkipSpaces(s, p);
    GetLexeme(s, p);
  end;
  LexemeCollection.AddLexeme(p, ltEOF, EmptyStr);
  LexemeCollection.Index := 0;

  // Синтаксический разбор и вычисление.
{  for p := 0 to LexemeCollection.Count - 1 do
  begin
    with LexemeCollection[p] as TLexeme do
      ShowMessage('Type: ' + IntToStr(integer(LType)) + #13'Position: ' +
        IntToStr(Position) + #13'Value: ' + Value);
  end;
}
  AddFunctions();
  Result := Expr();
end;
//---------------------------------------------------------------------------
function CalculateInsPrem(const contract: TContractEntity;
  const bs, kt, kbm, kvs, ko, km, ks, kp, kn: double; var formula: string): double;
var foreing: boolean;
    dumb: double;
begin

  with contract, dmCoefs do
  begin
    if ((Car.IDCarType = Null) or (Car.CarOwner.IDClientTypeGroup = Null)
      or (car.CarOwner.GeoGroup = null)) then
        raise Exception.Create(SysToUTF8(insp_get_car_own_err));
    foreing := GetInsCoef_Foreing(car.CarOwner.GeoGroup,
      Car.CarOwner.IDClientTypeGroup, dumb, dumb, dumb);

      formula := GetInsFormula(VarToBool(contract.Transit), foreing,
        Car.IDCarType, Car.CarOwner.IDClientTypeGroup) + formula;
    Result := ParseFormula(formula, bs, kt, kbm, kvs, ko, km, ks, kp, kn);
  end;
end;
//---------------------------------------------------------------------------
initialization
  LexemeCollection    := nil;
  FunctionCollection  := nil;

finalization
  FreeAndNil(LexemeCollection);
  FreeAndNil(FunctionCollection);
end.
