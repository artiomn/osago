unit data_coefs;

//
// Модуль получения страховых коэффициентов.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Dialogs,
  MyAccess, variants, data_unit, logger;

type

  { TdmCoefs }

  TdmCoefs = class(TDataModule)
    datasrcCBaseSum: TMyDataSource;
    datasrcInsFormula: TMyDataSource;
    datasrcInsFormulaConf: TMyDataSource;
    datasrcCsForeing: TMyDataSource;
    datasrcCKM: TMyDataSource;
    datasrcCKO: TMyDataSource;
    datasrcCKP: TMyDataSource;
    datasrcCKS: TMyDataSource;
    datasrcCKT: TMyDataSource;
    datasrcCKVS: TMyDataSource;
    datasrcCOther: TMyDataSource;
    datasrcInsuranceClass: TMyDataSource;
    myGetInsCoefs_BS: TMyQuery;
    myGetInsCoefs_BSBASE: TFloatField;
    myGetInsCoefs_BSCAR_TYPE: TStringField;
    myGetInsCoefs_BSCLIENT_TYPE_GROUP: TStringField;
    myGetInsCoefs_BSID_CAR_TYPE: TLongintField;
    myGetInsCoefs_BSID_CLIENT_TYPE_GROUP: TLongintField;
    myGetInsCoefs_Foreing: TMyQuery;
    myGetInsCoefs_ForeingCLIENT_TYPE_GROUP1: TStringField;
    myGetInsCoefs_ForeingGEO_GROUP: TLongintField;
    myGetInsCoefs_ForeingID_CLIENT_TYPE_GROUP: TLongintField;
    myGetInsCoefs_ForeingNAME1: TStringField;
    myGetInsCoefs_KMCAR_TYPE: TStringField;
    myGetInsCoefs_KMID_CAR_TYPE: TLongintField;
    myGetInsCoefs_KSKS1: TFloatField;
    myGetInsCoefs_KSPERIOD_USE1: TFloatField;
    myGetInsCoefs_KTGEO_GROUP: TLongintField;
    myGetInsCoefs_KTNAME1: TStringField;
    myGetInsCoef_Foreing: TMyQuery;
    myGetInsCoefs_ForeingKBM: TFloatField;
    myGetInsCoefs_ForeingKO: TFloatField;
    myGetInsCoefs_ForeingKVS: TFloatField;
    myGetInsCoefs_KM: TMyQuery;
    myGetInsCoefs_KMKM: TFloatField;
    myGetInsCoefs_KMMAX_POWER: TFloatField;
    myGetInsCoefs_KP: TMyQuery;
    myGetInsCoefs_KPKP: TFloatField;
    myGetInsCoefs_KPPERIOD_INS: TFloatField;
    myGetInsCoefs_KS: TMyQuery;
    myGetInsCoefs_KSKS: TFloatField;
    myGetInsCoefs_KSPERIOD_USE: TFloatField;
    myGetInsCoefs_KT: TMyQuery;
    myGetInsCoefs_KTCAR_TYPE1: TStringField;
    myGetInsCoefs_KTID_CAR_TYPE: TLongintField;
    myGetInsCoefs_KTID_TERRITORY_USE: TLongintField;
    myGetInsCoefs_KTTERRITORY: TStringField;
    myGetInsCoefs_KTTERRITORY_KOEF: TFloatField;
    myGetInsCoefs_KVS: TMyQuery;
    myGetInsCoefs_KVSKVS: TFloatField;
    myGetInsCoefs_KVSMAX_AGE: TFloatField;
    myGetInsCoefs_KVSMAX_STAGE: TFloatField;
    myGetInsCoefs_Other: TMyQuery;
    myGetInsCoefs_OtherKN: TFloatField;
    myGetInsCoefs_OtherKP_TRANSIT: TFloatField;
    myGetInsCoef_BaseSum: TMyQuery;
    myGetInsCoef_KBM: TMyQuery;
    myGetInsCoef_KBMID_INSURANCE_CLASS: TLongintField;
    myGetInsCoef_KBMINSURANCE_CLASS: TStringField;
    myGetInsCoef_KBMKOEF: TFloatField;
    myGetInsCoef_KM: TMyQuery;
    myGetInsCoef_KO: TMyQuery;
    myGetInsCoef_KOKO_LIMITED: TFloatField;
    myGetInsCoef_KOKO_UNLIM: TFloatField;
    myGetInsCoef_KP: TMyQuery;
    myGetInsCoef_KS: TMyQuery;
    myInsFormulaConfCAR_TYPE1: TStringField;
    myInsFormulaConfCLIENT_TYPE_GROUP1: TStringField;
    myInsFormulaConfFORMULA1: TStringField;
    myInsFormulaConfID_CAR_TYPE: TLongintField;
    myInsFormulaConfID_CLIENT_TYPE_GROUP: TLongintField;
    myInsFormulaConfID_FORMULA: TLargeintField;
    myInsFormulaConfID_INS_FORMULA_TYPE: TLargeintField;
    myInsFormulaConfNAME1: TStringField;
    myInsFormulas: TMyQuery;
    myGetInsCoef_KT: TMyQuery;
    myGetInsCoef_KVS: TMyQuery;
    myInsFormulaConf: TMyQuery;
    myInsFormula: TMyQuery;
    myInsFormulasDESCR: TStringField;
    myInsFormulasFORMULA: TStringField;
    myInsFormulasID_FORMULA: TLargeintField;
    myInsFormulaType: TMyQuery;
    procedure myGetInsCoefs_BSBeforeOpen(DataSet: TDataSet);
    procedure myGetInsCoefs_ForeingBeforeOpen(DataSet: TDataSet);
    procedure myGetInsCoefs_KMBeforeOpen(DataSet: TDataSet);
    procedure myGetInsCoefs_KTBeforeOpen(DataSet: TDataSet);
    procedure myInsFormulaConfBeforeOpen(DataSet: TDataSet);
  public
    // Выборка соответствующих коэффициентов.
    function GetInsCoef_BaseSum(const ctg, car_type: integer): double;
    function GetInsCoef_KT(const region_grp, car_type: integer): double;
    function GetInsCoef_KBM(const id_ins_class: integer): double;
    function GetInsCoef_KVS(const stage, age: double): double;
    function GetInsCoef_KO(const unlimited: boolean): double;
    function GetInsCoef_KM(const id_car_type: integer; const power: double):
      double;
    function GetInsCoef_KS(const period: double): double;
    function GetInsCoef_KP(const period: double): double;
    function GetInsCoef_Foreing(const geo_group, cln_type: integer;
      out ko, kvs, kbm: double): boolean;
    function GetInsCoef_Other(out kn, kp_transit: double;
      const ks_refresh: boolean = false): boolean;
    function GetInsFormula(const transit, foreing: boolean;
      const car_type, ctg: integer): string;
  end;

var
  dmCoefs: TdmCoefs;

implementation
//---------------------------------------------------------------------------
procedure TdmCoefs.myGetInsCoefs_KTBeforeOpen(DataSet: TDataSet);
begin
  with (DataSet) do
    begin
      FieldByName('FL_GEO_GROUP').LookupDataSet.Open();
      FieldByName('FL_GEO_GROUP').LookupDataSet.First();
      FieldByName('FL_CAR_TYPE').LookupDataSet.Open();
      FieldByName('FL_CAR_TYPE').LookupDataSet.First();
    end;
end;
//---------------------------------------------------------------------------
procedure TdmCoefs.myGetInsCoefs_BSBeforeOpen(DataSet: TDataSet);
begin
  with (DataSet) do
    begin
      FieldByName('FL_CLIENT_TYPE_GROUP').LookupDataSet.Open();
      FieldByName('FL_CLIENT_TYPE_GROUP').LookupDataSet.First();
      FieldByName('FL_CAR_TYPE').LookupDataSet.Open();
      FieldByName('FL_CAR_TYPE').LookupDataSet.First();
    end;
end;
//---------------------------------------------------------------------------
procedure TdmCoefs.myGetInsCoefs_ForeingBeforeOpen(DataSet: TDataSet);
begin
  with (DataSet) do
    begin
      FieldByName('FL_GEO_GROUP').LookupDataSet.Open();
      FieldByName('FL_GEO_GROUP').LookupDataSet.First();
      FieldByName('FL_CLIENT_TYPE_GROUP').LookupDataSet.Open();
      FieldByName('FL_CLIENT_TYPE_GROUP').LookupDataSet.First();
    end;
end;
//---------------------------------------------------------------------------
procedure TdmCoefs.myGetInsCoefs_KMBeforeOpen(DataSet: TDataSet);
begin
  with (DataSet) do
    begin
      FieldByName('FL_CAR_TYPE').LookupDataSet.Open();
      FieldByName('FL_CAR_TYPE').LookupDataSet.First();
    end;
end;
//---------------------------------------------------------------------------
procedure TdmCoefs.myInsFormulaConfBeforeOpen(DataSet: TDataSet);
begin
  with (DataSet) do
    begin
      FieldByName('FL_CLIENT_TYPE_GROUP').LookupDataSet.Open();
      FieldByName('FL_CLIENT_TYPE_GROUP').LookupDataSet.First();
      FieldByName('FL_CAR_TYPE').LookupDataSet.Open();
      FieldByName('FL_CAR_TYPE').LookupDataSet.First();
      FieldByName('FL_INS_FORMULA_TYPE').LookupDataSet.Open();
      FieldByName('FL_INS_FORMULA_TYPE').LookupDataSet.First();
      FieldByName('FL_FORMULA').LookupDataSet.Open();
      FieldByName('FL_FORMULA').LookupDataSet.First();
    end;
end;
//---------------------------------------------------------------------------
function TdmCoefs.GetInsCoef_BaseSum(const ctg, car_type: integer): double;
begin
  Result := -1;
  with (myGetInsCoef_BaseSum) do
    begin
      Close();
      ParamByName('client_type_group').AsInteger := ctg;
      ParamByName('car_type').AsInteger          := car_type;
      Open();
      Result := FieldByName('BASE').AsFloat;
    end;
end;
//---------------------------------------------------------------------------
function TdmCoefs.GetInsCoef_KT(const region_grp, car_type: integer): double;
begin
  Result := -1;
  with (myGetInsCoef_KT) do
    begin
      Close();
      ParamByName('geo_group').AsInteger := region_grp;
      ParamByName('car_type_id').AsInteger     := car_type;
      Open();
      Result := FieldByName('TERRITORY_KOEF').AsFloat;
    end;
end;
//---------------------------------------------------------------------------
function TdmCoefs.GetInsCoef_KBM(const id_ins_class: integer): double;
var l_data: variant;
begin
  Result := -1;
  with (myGetInsCoef_KBM) do
    begin
      Open();
      l_data := Lookup('ID_INSURANCE_CLASS', id_ins_class, 'KOEF');
      if (l_data = Null) then Result := -1
      else Result := l_data;
    end;
end;
//---------------------------------------------------------------------------
function TdmCoefs.GetInsCoef_KVS(const stage, age: double): double;
begin
  Result := -1;
  with (myGetInsCoef_KVS) do
    begin
      Close();
      ParamByName('stage').AsFloat  := stage;
      ParamByName('age').AsFloat    := age;
      Open();
      Result := FieldByName('KVS').AsFloat;
    end;
end;
//---------------------------------------------------------------------------
function TdmCoefs.GetInsCoef_KO(const unlimited: boolean): double;
begin
  Result := -1;
  with (myGetInsCoef_KO) do
    begin
      Active := true;
      if (unlimited) then
        Result := FieldByName('KO_UNLIM').AsFloat
      else
        Result := FieldByName('KO_LIMITED').AsFloat;
    end;
end;
//---------------------------------------------------------------------------
function TdmCoefs.GetInsCoef_KM(const id_car_type: integer; const power: double):
  double;
begin
  Result := -1;
  with (myGetInsCoef_KM) do
    begin
      Close();
      ParamByName('id_car_type').AsInteger  := id_car_type;
      ParamByName('power').AsFloat          := power;
      Open();
      if (RecordCount = 0) then exit;
      Result := FieldByName('KM').AsFloat;
    end;
end;
//---------------------------------------------------------------------------
function TdmCoefs.GetInsCoef_KS(const period: double): double;
begin
  Result := -1;
  with (myGetInsCoef_KS) do
    begin
      Close();
      ParamByName('period').AsFloat := period;
      Open();
      Result := FieldByName('KS').AsFloat;
    end;
end;
//---------------------------------------------------------------------------
function TdmCoefs.GetInsCoef_KP(const period: double): double;
begin
  Result := -1;
  with (myGetInsCoef_KP) do
    begin
      Close();
      ParamByName('period').AsFloat := period;
      Open();
      Result := FieldByName('KP').AsFloat;
    end;
end;
//---------------------------------------------------------------------------
function TdmCoefs.GetInsCoef_Foreing(const geo_group, cln_type: integer;
  out ko, kvs, kbm: double): boolean;
begin
  Result := false;
  with (myGetInsCoef_Foreing) do
    begin
      Close();
      ParamByName('geo_group').AsInteger := geo_group;
      ParamByName('client_type_group').AsInteger := cln_type;
      Open();
      if (RecordCount = 0) then exit;
      ko  := FieldByName('KO').AsFloat;
      kvs := FieldByName('KVS').AsFloat;
      kbm := FieldByName('KBM').AsFloat;
    end;
  Result := true;
end;
//---------------------------------------------------------------------------
function TdmCoefs.GetInsCoef_Other(out kn, kp_transit: double;
  const ks_refresh: boolean): boolean;
begin
  Result := true;
  with datasrcCOther.DataSet do
    begin
      try
        if (ks_refresh) then Close();
        Open();
        kn          := FieldByName('KN').AsFloat;
        kp_transit  := FieldByName('KP_TRANSIT').AsFloat;
      except
        on E: Exception do
          begin
            LogException(E);
            Result := false;
          end;
      end;
    end;
end;
//---------------------------------------------------------------------------
function TdmCoefs.GetInsFormula(const transit, foreing: boolean;
  const car_type, ctg: integer): string;
begin
  Result := EmptyStr;
  with myInsFormula do
    begin
      Close();
      ParamByName('transit').AsBoolean  := transit;
      ParamByName('foreing').AsBoolean  := foreing;
      ParamByName('car_type').AsInteger := car_type;
      ParamByName('ctg').AsInteger      := ctg;
      Open();
      if (RecordCount > 0) then Result := FieldByName('FORMULA').AsString;
    end;
end;
//---------------------------------------------------------------------------
initialization
  {$I data_coefs.lrs}

end.
