unit contracts_input;

//
// Модуль ввода пустых бланков полисов.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, Grids, Math, LCLType, variants,
  common_functions, strings_l10n, data_unit, orm_infos_inscompany, logger;

type

  { TfrmContractsInput }

  TfrmContractsInput = class(TForm)
    cbInsCompany: TComboBox;
    edPolisStartNum: TEdit;
    edPolisEndNum: TEdit;
    edPolisSer: TEdit;
    gbPolis: TGroupBox;
    gbPolisesNums: TGroupBox;
    Label10: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    pnMain: TPanel;
    pnBottom: TPanel;
    pnHead: TPanel;
    sbarMain: TStatusBar;
    sbtnApply: TSpeedButton;
    sbtnCancel: TSpeedButton;
    sbtnPolisNumAdd: TSpeedButton;
    sbtnPolisNumDel: TSpeedButton;
    sbtnPolisNumGen: TSpeedButton;
    sbtnOk: TSpeedButton;
    strgridPolises: TStringGrid;
    procedure edPolisNumKeyPress(Sender: TObject; var Key: char);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbtnPanelClick(Sender: TObject);
    procedure sbtnPolisNumClick(Sender: TObject);
    procedure strgridPolisesColRowDeleted(Sender: TObject; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure strgridPolisesColRowInserted(Sender: TObject; IsColumn: Boolean;
      sIndex, tIndex: Integer);
    procedure strgridPolisesKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    // Генерирует номера бланков.
    procedure GenBlanks();
    // Вводит бланки в БД.
    function InsBlanks(): boolean;
  public

  end; 

var
  frmContractsInput: TfrmContractsInput;

implementation

{ TfrmContractsInput }
//---------------------------------------------------------------------------
procedure TfrmContractsInput.FormDestroy(Sender: TObject);
begin
end;
//---------------------------------------------------------------------------
procedure TfrmContractsInput.FormShow(Sender: TObject);
var cn: TInfInsCompany;
    i: integer;
begin
  // Перезаполняю, каждый раз при показе.
  try
    cbInsCompany.Items.Clear();
    cbInsCompany.Items.BeginUpdate();
    for i := 0 to CompaniesCollection.Count - 1 do
      begin
        cn := CompaniesCollection[i] as TInfInsCompany;
        if (cn = nil) then exit;
        cbInsCompany.Items.AddObject(VarToStr(cn.InsCompanyName), cn);
      end;
    if (i > 0) then cbInsCompany.ItemIndex := 0;
  finally
    cbInsCompany.Items.EndUpdate();
  end;

  with strgridPolises do Clean(0, 1, ColCount, RowCount, [gzNormal]);
end;
//---------------------------------------------------------------------------
procedure TfrmContractsInput.sbtnPanelClick(Sender: TObject);
begin
  if (Sender = sbtnOk) then
    begin
      if (InsBlanks()) then ModalResult := mrOk;
    end
  else if (Sender = sbtnApply) then
    begin
      if (InsBlanks()) then with strgridPolises do
        Clean(0, 1, ColCount, RowCount, [gzNormal]);
    end
  else if (Sender = sbtnCancel) then
    begin
      ModalResult := mrCancel;
    end
end;
//---------------------------------------------------------------------------
procedure TfrmContractsInput.edPolisNumKeyPress(Sender: TObject; var Key: char
  );
var ss: TShiftState;
begin
  if (Key = #13) then
    begin
      Key := #0;
      sbtnPolisNumGen.Click();
    end;
  ss := GetKeyShiftState();
  if ((ssAlt in ss) or (ssCtrl in ss)) then exit;
  if (not (((Key >= '0') and (Key <= '9')) or (Key = DecimalSeparator) or
      (Key = #8))) then Key := #0;
end;
//---------------------------------------------------------------------------
procedure TfrmContractsInput.sbtnPolisNumClick(Sender: TObject);
begin
  with strgridPolises do
  begin
  if (Sender = sbtnPolisNumGen) then
    begin
      GenBlanks();
    end
  else if (Sender = sbtnPolisNumDel) then
    begin
      if ((Row > 0) and (Row < RowCount)) then DeleteColRow(false, Row);
    end
  else if (Sender = sbtnPolisNumAdd) then
    begin
      RowCount    := RowCount + 1;
      Row         := RowCount - 1;
      EditorMode  := true;
    end;
  end; // with
end;
//---------------------------------------------------------------------------
procedure TfrmContractsInput.strgridPolisesColRowInserted(Sender: TObject;
  IsColumn: Boolean; sIndex, tIndex: Integer);
begin
  if (not sbtnPolisNumDel.Enabled) then
    sbtnPolisNumDel.Enabled := (strgridPolises.RowCount > 1);
  sbtnPolisNumAdd.Enabled := (strgridPolises.RowCount < maxSmallint);
end;
//---------------------------------------------------------------------------
procedure TfrmContractsInput.strgridPolisesKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ((Shift = [ssAlt]) or (Shift = [ssCtrl])) then exit;
  if ((Key = VK_DELETE) and (sbtnPolisNumDel.Enabled)) then
    sbtnPolisNumDel.Click()
  else
  if ((Key = VK_INSERT) and (sbtnPolisNumAdd.Enabled)) then
    sbtnPolisNumAdd.Click
  else
  if ((Key = VK_RETURN) and (sbtnPolisNumGen.Enabled)) then
    sbtnPolisNumGen.Click;
end;
//---------------------------------------------------------------------------
procedure TfrmContractsInput.strgridPolisesColRowDeleted(Sender: TObject;
  IsColumn: Boolean; sIndex, tIndex: Integer);
begin
  if (sbtnPolisNumDel.Enabled) then
    sbtnPolisNumDel.Enabled := (strgridPolises.RowCount > 1);
  sbtnPolisNumAdd.Enabled := (strgridPolises.RowCount < maxSmallint);
end;
//---------------------------------------------------------------------------
procedure TfrmContractsInput.GenBlanks();
var i: Cardinal;
    j, d, digits_count, start_num, end_num: Int64;
    ser: string;
begin
  start_num := StrToInt64Def(edPolisStartNum.Text, 0);
  end_num   := StrToInt64Def(edPolisEndNum.Text, 0);
  d         := Max(start_num, end_num) - Min(start_num, end_num) + 2;
  ser       := edPolisSer.Text;
  if (d >= maxSmallint) then
    begin
      MessageDlg(SysToUTF8(cls_error), SysToUTF8(cont_input_err_range),
        mtError, [mbOK], 0);
      exit;
    end;

  if (d = 0) then exit;
  digits_count := trunc(log10(d) + 1);
  // Один ряд - заголовок
  with strgridPolises do
    begin
      Clean(0, 1, ColCount, RowCount, [gzNormal]);
      RowCount := d;
    end;
  j := Min(start_num, end_num);
  // Номера определяют порядок создания
  if (start_num < end_num) then
    for i := 1 to d - 1 do
      begin
        strgridPolises.Cells[0, i] := ser;
        strgridPolises.Cells[1, i] := Format('%.*d', [digits_count, j]);
        Inc(j);
      end
  else
    for i := d - 1 downto 1 do
      begin
        strgridPolises.Cells[0, i] := ser;
        strgridPolises.Cells[1, i] := Format('%.*d', [digits_count, j]);
        Inc(j);
      end;
end;
//---------------------------------------------------------------------------
function TfrmContractsInput.InsBlanks(): boolean;

  procedure SwitchEnabled(const en: boolean);
  var i: integer;
  begin
    for i := 0 to pnMain.ControlCount - 1
      do
        pnMain.Controls[i].Enabled := en;
    for i := 0 to gbPolis.ControlCount - 1
      do
        gbPolis.Controls[i].Enabled := en;
    strgridPolises.Enabled  := en;
    sbtnPolisNumGen.Enabled := en;
  end;

begin
  SwitchEnabled(false);
  Result := true;
  try
    with dmData.myProcBlankAdd, strgridPolises, cbInsCompany do
      while (RowCount > 1) do
        begin
          ParamByName('v_id_ins_company').AsString  :=
            VarToStr((Items.Objects[ItemIndex] as TInfInsCompany).IDInsCompany);
          ParamByName('v_dog_ser').AsString         := Cells[0, 1];
          ParamByName('v_dog_num').AsString         := Cells[1, 1];
          try
            ExecProc();
          except
            on E: Exception do
              begin
                LogException(E);
                Result := false;
                MessageDlg(SysToUTF8(cls_error), SysToUTF8(cont_input_err_input),
                  mtError, [mbOK], 0);
                break;
              end;
          end;
          if (dmData.GetErrCode(Connection) <> 0) then
            begin
              Result := false;
              MessageDlg(SysToUTF8(cls_error), SysToUTF8(cont_input_err_input),
                mtError, [mbOK], 0);
              break;
            end
          else DeleteColRow(false, 1);
        end;
  finally
    SwitchEnabled(true);
  end;
end;
//---------------------------------------------------------------------------
initialization
  {$I contracts_input.lrs}

end.

