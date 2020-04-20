unit reports_unit;

{$I settings.inc}

//
// Модуль, реализующий печать бланков и отчётов.
//

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Dialogs,
  LR_Const, LR_Class, LR_Desgn, LR_DSet, LR_PGrid, PrintersDlgs, MyAccess,
  common_consts, data_unit, common_functions, strings_l10n, rep_filter,
  LR_Shape, LR_ChBox, LR_RRect, LR_E_CSV, LR_E_TXT, LR_E_HTM, LR_DBSet,
  LR_Pars, DBAccess, variants, ZSysUtils,
  logger;

type

  TReportMode = (rmPolis, rmReceipt, rmTicket);
  TExportType = (etCSV, etTXT, etHTM);
  { TdmReports }

  TdmReports = class(TDataModule)
    frCheckBox: TfrCheckBoxObject;
    frCSVExport: TfrCSVExport;
    frdbdsCBDReport: TfrDBDataSet;
    frdbdsDrivers: TfrDBDataSet;
    frdesignMain: TfrDesigner;
    frHTMExport: TfrHTMExport;
    frreportReceipt: TfrReport;
    frreportPolis: TfrReport;
    frreportTicket: TfrReport;
    frreportReps: TfrReport;
    frRoundRect: TfrRoundRectObject;
    frShape: TfrShapeObject;
    frTextExport: TfrTextExport;
    dlgSaveExport: TSaveDialog;
    myRepGeneral: TMyQuery;
    myRepContractsByDate: TMyQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure frdbdsDriversFirst(Sender: TObject);
    procedure frdbdsDriversNext(Sender: TObject);
    procedure frdsCBDReportFirst(Sender: TObject);
    procedure frdsCBDReportNext(Sender: TObject);
    procedure frreportRepsGetValue(const ParName: String; var ParValue: Variant
      );
    procedure frreportRepsUserFunction(const FnName: String; p1, p2, p3: Variant;
      var Val: Variant);
    procedure frreportsGetValue(const ParName: String; var ParValue: Variant);
  private
    // Даты последнего изменения бланков.
    FPolisChgDate:    TDateTime;
    FReceiptChgDate:  TDateTime;
    FRepByDateChgDate: TDateTime;
    FRepGeneralChgDate: TDateTime;
    // Файлы бланков
    FPolisFileName: string;
    FReceiptFileName: string;
    FRepByDateFilename: string;
    FRepGeneralFilename: string;
    FReportMode: TReportMode;
    FOnPolisGetValue: TDetailEvent;
    FOnReceiptGetValue: TDetailEvent;
    FOnTicketGetValue: TDetailEvent;
  private
    function GetValueForPolis(const ParName: string): variant;
    function GetValueForReceipt(const ParName: string): variant;
    function GetValueForTicket(const ParName: string): variant;
    procedure AddDateParams(SQL: TStrings; const tbl_prefix: string = '';
      const column_name: string = 'DATE_START');
    procedure CheckAndLoad(const report: TfrReport;
      const file_name: string; var rep_date: TDateTime);
    procedure SetDesignerDefs();
  public
    procedure DesignPolisBlank();
    procedure DesignReceiptBlank();
    procedure DesignTicketBlank(OnSavePress: TNotifyEvent);
    procedure DesignNewBlank();
    procedure DesignGRBlank();
    procedure DesignRepByDateBlank();
  public
    procedure PrintPolisBlank();
    procedure PrintReceiptBlank();
    procedure PrintTicketBlank(ticket_blank: TStream);
  public
    procedure PrintRepByDate();
    procedure PrintRepGeneral();
  public
    procedure ExportReport(const filter: TExportType;
      const report: TfrReport);
  public
    property OnPolisGetValue: TDetailEvent read FOnPolisGetValue write
      FOnPolisGetValue;
    property OnReceiptGetValue: TDetailEvent read FOnReceiptGetValue write
      FOnReceiptGetValue;
    property OnTicketGetValue: TDetailEvent read FOnTicketGetValue write
      FOnTicketGetValue;
  end; 

var
  dmReports: TdmReports;

implementation
//---------------------------------------------------------------------------
procedure TdmReports.DataModuleCreate(Sender: TObject);
begin
  frdesignMain.TemplateDir := GetCurrentDirUTF8() + PathDelim +
    AnsiToUtf8(blanks_dir);
  FPolisFileName := ExtractFilePath(ParamStrUTF8(0)) + PathDelim +
    AnsiToUtf8(blanks_dir) + PathDelim + AnsiToUtf8(blanks_polis);
  FReceiptFileName := ExtractFilePath(ParamStrUTF8(0)) + PathDelim +
    AnsiToUtf8(blanks_dir) + PathDelim + AnsiToUtf8(blanks_receipt);
  FRepByDateFilename := ExtractFilePath(ParamStrUTF8(0)) + PathDelim +
    AnsiToUtf8(blanks_dir) + PathDelim + AnsiToUtf8(blanks_rep_bydate);
  FRepGeneralFilename := ExtractFilePath(ParamStrUTF8(0)) + PathDelim +
    AnsiToUtf8(blanks_dir) + PathDelim + AnsiToUtf8(blanks_rep_general);

  FRepGeneralChgDate  := 0;
  FReceiptChgDate     := 0;
  FPolisChgDate       := 0;
  FRepByDateChgDate   := 0;
end;
//---------------------------------------------------------------------------
procedure TdmReports.CheckAndLoad(const report: TfrReport;
  const file_name: string; var rep_date: TDateTime);
var fa: TDateTime;
begin
  fa := GetFileDateTime(file_name);
  if ((fa > rep_date) or (report.FileName <> file_name))
    then
    begin
      report.LoadFromFile(file_name);
      rep_date := fa;
    end;
end;
//---------------------------------------------------------------------------
procedure TdmReports.SetDesignerDefs();
begin
  if(Assigned(ProcedureInitDesigner) and (frDesigner = nil)) then
    ProcedureInitDesigner();
  if (Assigned(frDesigner)) then with (frDesigner as TfrDesignerForm) do
    begin
      OnCloseQuery          := @frDesignerFormCloseQuery;
      FileBtn3.OnClick      := @FileBtn3Click;
    end;
end;
//---------------------------------------------------------------------------
procedure TdmReports.frreportsGetValue(const ParName: String;
  var ParValue: Variant);
begin
  if (FReportMode = rmPolis) then ParValue := GetValueForPolis(ParName)
  else if (FReportMode = rmReceipt) then ParValue := GetValueForReceipt(ParName)
  else if (FReportMode = rmTicket) then ParValue := GetValueForTicket(ParName);
end;
//---------------------------------------------------------------------------
function TdmReports.GetValueForPolis(const ParName: string): variant;
var param_v: Variant;
begin
  if (Assigned(FOnPolisGetValue)) then FOnPolisGetValue(ParName, param_v)
  else param_v := varEmpty;
  Result := param_v;
end;
//---------------------------------------------------------------------------
function TdmReports.GetValueForReceipt(const ParName: string): variant;
var param_v: Variant;
begin
  if (Assigned(FOnReceiptGetValue)) then FOnReceiptGetValue(ParName, param_v)
  else param_v := varEmpty;
  Result := param_v;
end;
//---------------------------------------------------------------------------
function TdmReports.GetValueForTicket(const ParName: string): variant;
var param_v: Variant;
begin
  if (Assigned(FOnTicketGetValue)) then FOnTicketGetValue(ParName, param_v)
  else param_v := varEmpty;
  Result := param_v;
end;
//---------------------------------------------------------------------------
procedure TdmReports.DesignPolisBlank();
begin
  SetDesignerDefs();
  frreportPolis.LoadFromFile(FPolisFileName);
  if (not FileExistsUTF8(frreportPolis.FileName)) then
    begin
      MessageDlg(AnsiToUtf8(cls_warning), AnsiToUtf8(rep_new_ps_blank_msg),
      mtInformation, [mbOK], '');
      frreportPolis.Pages.Clear;
      frreportPolis.FileName := SUntitled;
    end;

  frreportPolis.DesignReport();
end;
//---------------------------------------------------------------------------
procedure TdmReports.DesignReceiptBlank();
begin
  SetDesignerDefs();
  frreportReceipt.LoadFromFile(FReceiptFileName);
  if (not FileExistsUTF8(frreportReceipt.FileName)) then
    begin
      MessageDlg(AnsiToUtf8(cls_warning), AnsiToUtf8(rep_new_rt_blank_msg),
      mtInformation, [mbOK], '');
      frreportReceipt.Pages.Clear;
      frreportReceipt.FileName := SUntitled;
    end;
  frreportReceipt.DesignReport();
end;
//---------------------------------------------------------------------------
procedure TdmReports.DesignTicketBlank(OnSavePress: TNotifyEvent);
begin
  if(Assigned(ProcedureInitDesigner) and (frDesigner = nil)) then
    ProcedureInitDesigner();
  if (Assigned(frDesigner)) then with (frDesigner as TfrDesignerForm) do
    begin
      OnCloseQuery          := nil;
      FileBtn3.OnClick      := OnSavePress;
    end;
  frreportTicket.DesignReport();
end;
//---------------------------------------------------------------------------
procedure TdmReports.DesignNewBlank();
begin
  frreportPolis.FileName := SUntitled;
  frreportPolis.Clear();
  frreportPolis.Pages.Add();
  frreportPolis.DesignReport();
end;
//---------------------------------------------------------------------------
procedure TdmReports.DesignGRBlank();
begin
  frreportReps.LoadFromFile(FRepGeneralFilename);
  if (not FileExistsUTF8(frreportReps.FileName)) then
    begin
      MessageDlg(AnsiToUtf8(cls_warning), AnsiToUtf8(rep_new_blank_msg),
      mtInformation, [mbOK], '');
      frreportReps.Pages.Clear;
      frreportReps.FileName := SUntitled;
    end;
  frreportReps.DesignReport();
end;
//---------------------------------------------------------------------------
procedure TdmReports.DesignRepByDateBlank();
begin
  frreportReps.LoadFromFile(FRepByDateFilename);
  if (not FileExistsUTF8(frreportReps.FileName)) then
    begin
      MessageDlg(AnsiToUtf8(cls_warning), AnsiToUtf8(rep_new_blank_msg),
      mtInformation, [mbOK], '');
      frreportReps.Pages.Clear;
      frreportReps.FileName := SUntitled;
    end;
  frreportReps.DesignReport();
end;
//---------------------------------------------------------------------------
procedure TdmReports.AddDateParams(SQL: TStrings; const tbl_prefix: string;
  const column_name: string);
var r_prefix: string;
begin
  if (frmRepFilter = nil) then exit;

  r_prefix := Trim(tbl_prefix);
  if (r_prefix <> EmptyStr) then r_prefix := r_prefix + '.';

  with frmRepFilter do
  if (not (cbStartDate.Checked or cbEndDate.Checked)) then
    begin
    end
  else if (cbStartDate.Checked and cbEndDate.Checked) then
    begin
      SQL.Add('and (' + r_prefix + column_name + ' between ''' +
        DateTimeToAnsiSQLDate(dtedStartDate.Date) + ''' and ''' +
        DateTimeToAnsiSQLDate(dtedEndDate.Date) + ''')');
      // :dt_start and :dt_end)');
    end
  else if (cbStartDate.Checked and not cbEndDate.Checked) then
    begin
      SQL.Add('and (' + r_prefix + column_name + ' >= ''' +
        DateTimeToAnsiSQLDate(dtedStartDate.Date) + ''')');
      //:dt_start)');
    end
  else if (not cbStartDate.Checked and cbEndDate.Checked) then
    begin
      SQL.Add('and (' + r_prefix + column_name + ' <= ''' +
        DateTimeToAnsiSQLDate(dtedEndDate.Date) + ''')');
      // :dt_end)');
    end;
end;
//---------------------------------------------------------------------------
procedure TdmReports.PrintPolisBlank();
var bg_image: TfrObject;
begin
  FReportMode := rmPolis;
  CheckAndLoad(frreportPolis, FPolisFileName, FPolisChgDate);
  // Всегда скрывается. Надо.
  bg_image := frreportPolis.FindObject('bg_image');
  if (bg_image <> nil) then
    begin
      bg_image.Visible := false;
    end;
  frreportPolis.ShowReport();
end;
//---------------------------------------------------------------------------
procedure TdmReports.PrintReceiptBlank();
begin
  FReportMode := rmReceipt;
  CheckAndLoad(frreportReceipt, FReceiptFileName, FReceiptChgDate);
//  if (frreportReceipt.PrepareReport) then frreportReceipt.ShowPreparedReport();
  frreportReceipt.ShowReport();
end;
//---------------------------------------------------------------------------
procedure TdmReports.PrintTicketBlank(ticket_blank: TStream);
begin
  FReportMode           := rmTicket;
  ticket_blank.Position := 0;
  frreportTicket.LoadFromStream(ticket_blank);
  frreportTicket.ShowReport();
end;
//---------------------------------------------------------------------------
procedure TdmReports.PrintRepByDate();
var param: TDAParam;
begin
  CheckAndLoad(frreportReps, FRepByDateFilename, FRepByDateChgDate);
  if (frmRepFilter = nil) then
    Application.CreateForm(TfrmRepFilter, frmRepFilter);
  if (frmRepFilter.ShowModal() = mrCancel) then exit;

  frreportReps.Dataset := frdbdsCBDReport;

  with frmRepFilter, myRepContractsByDate.SQL do
    begin
      Clear();
      Add('select dogovor.ID_DOGOVOR,');
      Add('dogovor.DOG_SER as CNT_DOG_SER, dogovor.DOGNUMB as CNT_DOGNUMB,');
      Add('dogovor.START_USE as CNT_START_USE, dogovor.END_USE as CNT_END_USE,');
      Add('dogovor.START_USE1 as CNT_START_USE1, dogovor.END_USE1 as CNT_END_USE1,');
      Add('dogovor.START_USE2 as CNT_START_USE2, dogovor.END_USE2 as CNT_END_USE2,');
      Add('dogovor.INS_PREM as CNT_INS_PREM, dogovor.UNLIMITED_DRIVERS,');
      Add('dogovor.USER_INSERT_NAME as CNT_INSERT_USER,');
      Add('CONCAT_WS(" ", client.surname, client.name, client.middlename) as FULL_NAME,');
      Add('CONCAT_WS(" ", carmark.MARK, car.CAR_MODEL) as FULL_MODEL');
      Add('from');
      Add('(');
      Add('select');
      Add('dogovor.ID_DOGOVOR as CNT_ID,');
      Add('dogovor.ID_CAR as CAR_ID,');
      Add('dogovor.ID_CLIENT as CLN_ID from dogovor');
      Add('where ID_DOGOVOR_TYPE <> 4');

      AddDateParams(myRepContractsByDate.SQL);

      Add(') subq');
      Add('join dogovor on dogovor.ID_DOGOVOR = subq.CNT_ID');
      Add('join car on car.ID_CAR = subq.CAR_ID');
      Add('join client on client.ID_CLIENT = subq.CLN_ID');
      Add('join car_type on car.ID_CAR_TYPE = car_type.ID_CAR_TYPE');
      Add('join carmark on carmark.ID_CARMARK = car.CAR_MARK');
    end;

  with myRepContractsByDate, frmRepFilter do
    begin
{      param := Params.FindParam('dt_start');
      if (param <> nil) then param.AsDate := dtedStartDate.Date;
      param := Params.FindParam('dt_end');
      if (param <> nil) then param.AsDate := dtedEndDate.Date;}
      {$IFDEF DEBUG}
      logger.Debug('reports_unit.PrintRepByDate:'#13 + SQL.Text);
      {$ENDIF}
      Open();
    end;
//  frreportReps.PrepareReport();
  frreportReps.ShowReport();
end;
//---------------------------------------------------------------------------
procedure TdmReports.PrintRepGeneral();
var param: TDAParam;
begin
  CheckAndLoad(frreportReps, FRepGeneralFilename, FRepGeneralChgDate);

  if (frmRepFilter = nil) then
    Application.CreateForm(TfrmRepFilter, frmRepFilter);
  if (frmRepFilter.ShowModal() = mrCancel) then exit;

  frreportReps.Dataset := nil;

  with frmRepFilter, myRepGeneral.SQL do
    begin
      Clear();
      Add('select 1 as Q_TYPE, SUM(dogovor.INS_PREM) as INS_PREM, ');
      Add('COUNT(dogovor.ID_DOGOVOR) as CNT_CNT,');
      Add('NULL as BLANKS_DAMAGED');
      Add('from dogovor');
      Add('join dogovor d on dogovor.ID_DOGOVOR = d.ID_DOGOVOR');
      AddDateParams(myRepGeneral.SQL, 'dogovor');
      Add('join client on dogovor.ID_CLIENT = client.ID_CLIENT');
      Add('join client_types on client.ID_CLIENT_TYPE = client_types.ID_CLIENT_TYPE');
      Add('join client_type_group ctg');
      Add('  on client_types.ID_CLIENT_TYPE_GROUP = ctg.ID_CLIENT_TYPE_GROUP');
      Add('  and ctg.ID_CLIENT_TYPE_GROUP = ' + IntToStr(ind_person));
      Add('union');
      Add('select 2 as Q_TYPE, SUM(dogovor.INS_PREM) as INS_PREM, ');
      Add('COUNT(dogovor.ID_DOGOVOR) as CNT_CNT,');
      Add('NULL as BLANKS_DAMAGED');
      Add('from dogovor');
      Add('join dogovor d on dogovor.ID_DOGOVOR = d.ID_DOGOVOR');
      AddDateParams(myRepGeneral.SQL, 'dogovor');
      Add('join client on dogovor.ID_CLIENT = client.ID_CLIENT');
      Add('join client_types on client.ID_CLIENT_TYPE = client_types.ID_CLIENT_TYPE');
      Add('join client_type_group ctg');
      Add('  on client_types.ID_CLIENT_TYPE_GROUP = ctg.ID_CLIENT_TYPE_GROUP');
      Add('  and ctg.ID_CLIENT_TYPE_GROUP = ' + IntToStr(legal_entity));
      Add('union');
      Add('select 3 as Q_TYPE, SUM(dogovor.INS_PREM) as INS_PREM, ');
      Add('COUNT(dogovor.ID_DOGOVOR) as CNT_CNT,');
      Add('NULL as BLANKS_DAMAGED');
      Add('from dogovor');
      Add('join dogovor d on dogovor.ID_DOGOVOR = d.ID_DOGOVOR');
      AddDateParams(myRepGeneral.SQL, 'dogovor');
      Add('join client on dogovor.ID_CLIENT = client.ID_CLIENT');
      Add('union');
      Add('select 4 as Q_TYPE,');
      Add('NULL as INS_PREM, NULL as CNT_CNT, COUNT(*) as BLANKS_DAMAGED');
      Add('from blanks_journal where ID_BSO_STATUS = 3');
      AddDateParams(myRepGeneral.SQL, 'blanks_journal', 'DATE_INSERT');
    end;

  with myRepGeneral, frmRepFilter do
    begin
{      param := Params.FindParam('dt_start');
      if (param <> nil) then param.AsDate := dtedStartDate.Date;
      param := Params.FindParam('dt_end');
      if (param <> nil) then param.AsDate := dtedEndDate.Date;}
      {$IFDEF DEBUG}
      logger.Debug('reports_unit.PrintRepGeneral:'#13 + SQL.Text);
      {$ENDIF}
      Open();
      First();
    end;
//  frreportReps.PrepareReport();
  frreportReps.ShowReport();
end;
//---------------------------------------------------------------------------
procedure TdmReports.frdsCBDReportFirst(Sender: TObject);
begin
  frdbdsDrivers.Close();
  myRepContractsByDate.First();
  dmData.GetDriversByContID(myRepContractsByDate.FieldByName('ID_DOGOVOR').AsString);
  frdbdsDrivers.Open();
  frdbdsDrivers.First();
  while (not frdbdsDrivers.Eof) do
    frdbdsDrivers.Next();
end;
//---------------------------------------------------------------------------
procedure TdmReports.frdsCBDReportNext(Sender: TObject);
begin
  {$IFDEF DEBUG}
  Debug('Rep. by date next: ' + myRepContractsByDate.FieldByName('FULL_NAME').AsString);
  {$ENDIF}
  frdbdsDrivers.Close();
  myRepContractsByDate.Next();
  try
    dmData.GetDriversByContID(myRepContractsByDate.FieldByName('ID_DOGOVOR').AsString);
    frdbdsDrivers.Open();
    frdbdsDrivers.First();
    while (not frdbdsDrivers.Eof) do
      frdbdsDrivers.Next();

  except
    LogException();
  end;
end;
//---------------------------------------------------------------------------
procedure TdmReports.frreportRepsGetValue(const ParName: String;
  var ParValue: Variant);
begin
  if (ParName = 'o_s_date') then
    begin
      with frmRepFilter do
        if (cbStartDate.Checked) then
          ParValue := dtedStartDate.Date
        else
          ParValue := SysToUtf8(blank_filer_sym);
    end
  else if (ParName = 'o_e_date') then
    begin
      with frmRepFilter do
        if (cbEndDate.Checked) then
          ParValue := dtedEndDate.Date
        else
          ParValue := SysToUtf8(blank_filer_sym);
    end
  else if (ParName = 'phys_ins_prem') then
    begin
      with myRepGeneral do
        begin
          if (Locate('Q_TYPE', VarArrayOf([1]), [])) then
            ParValue := FieldByName('INS_PREM').AsVariant
          else
            ParValue := 0;
        end;
    end
  else if (ParName = 'phys_cnt_count') then
    begin
      with myRepGeneral do
        begin
          if (Locate('Q_TYPE', VarArrayOf([1]), [])) then
            ParValue := FieldByName('CNT_CNT').AsVariant
          else
            ParValue := 0;
        end;
    end
  else if (ParName = 'jur_ins_prem') then
    begin
      with myRepGeneral do
        begin
          if (Locate('Q_TYPE', VarArrayOf([2]), [])) then
            ParValue := FieldByName('INS_PREM').AsVariant
          else
            ParValue := 0;
        end;
    end
  else if (ParName = 'jur_cnt_count') then
    begin
      with myRepGeneral do
        begin
          if (Locate('Q_TYPE', VarArrayOf([2]), [])) then
            ParValue := FieldByName('CNT_CNT').AsVariant
          else
            ParValue := 0;
        end;
    end
  else if (ParName = 'full_ins_prem') then
    begin
      with myRepGeneral do
        begin
          if (Locate('Q_TYPE', VarArrayOf([3]), [])) then
            ParValue := FieldByName('INS_PREM').AsVariant
          else
            ParValue := 0;
        end;
    end
  else if (ParName = 'full_cnt_count') then
    begin
      with myRepGeneral do
        begin
          if (Locate('Q_TYPE', VarArrayOf([3]), [])) then
            ParValue := FieldByName('CNT_CNT').AsVariant
          else
            ParValue := 0;
        end;
    end
  else if (ParName = 'full_dmgbs_cnt') then
    begin
      with myRepGeneral do
        begin
          if (Locate('Q_TYPE', VarArrayOf([4]), [])) then
            ParValue := FieldByName('BLANKS_DAMAGED').AsVariant
          else
            ParValue := 0;
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure TdmReports.frdbdsDriversFirst(Sender: TObject);
begin
  {$IFDEF DEBUG}
  Debug('Drivers first: ' + dmData.myDrivers.FieldByName('FULL_NAME').AsString);
  {$ENDIF}
  dmData.myDrivers.First();
end;
//---------------------------------------------------------------------------
procedure TdmReports.frdbdsDriversNext(Sender: TObject);
begin
  {$IFDEF DEBUG}
  Debug('Drivers next: ' + dmData.myDrivers.FieldByName('FULL_NAME').AsString);
  {$ENDIF}
  dmData.myDrivers.Next();
end;
//---------------------------------------------------------------------------
procedure TdmReports.frreportRepsUserFunction(const FnName: String; p1, p2,
  p3: Variant; var Val: Variant);
begin
  if (FnName <> 'ISNULL') then exit;
	Val := frParser.Calc(p1);
  Val := (Val = Null) or (Val = EmptyStr);
end;
//---------------------------------------------------------------------------
procedure TdmReports.ExportReport(const filter: TExportType;
  const report: TfrReport);
var fclass: TfrExportFilterClass;
begin
  if (report.PrepareReport) then
    begin
      case filter of
        etCSV:
        begin
          dlgSaveExport.DefaultExt := '.csv';
          fclass := TfrCSVExportFilter;
        end;
        etTXT:
        begin
          dlgSaveExport.DefaultExt := '.txt';
          fclass := TfrTextExportFilter;
        end;
        etHTM:
        begin
          dlgSaveExport.DefaultExt := '.htm';
          fclass := TfrHTMExportFilter;
        end;
      end;

      if (dlgSaveExport.Execute) then
        report.ExportTo(fclass, dlgSaveExport.FileName);
    end
  else
    raise Exception.Create(AnsiToUtf8(rep_export_err));
end;
//---------------------------------------------------------------------------
initialization
  {$I reports_unit.lrs}

end.

