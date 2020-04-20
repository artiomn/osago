unit blank_contracts;

{$I settings.inc}

//
// Окно выбора пустого бланка.
//

interface

uses
  Classes, SysUtils, variants, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, Buttons, ComCtrls, Grids, StdCtrls, strings_l10n,
  common_functions, data_unit, orm_infos_inscompany;

type

  { TfrmBlankContracts }

  TfrmBlankContracts = class(TForm)
    gbInsCompanyBlanks: TGroupBox;
    pnBottom: TPanel;
    pnHead: TPanel;
    sbarMain: TStatusBar;
    sbtnCancel: TSpeedButton;
    sbtnOk: TSpeedButton;
    strgridPolises: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure sbtnPanelClick(Sender: TObject);
    procedure strgridPolisesDblClick(Sender: TObject);
    procedure strgridPolisesHeaderClick(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure strgridPolisesKeyPress(Sender: TObject; var Key: char);
  private
    FInsCompany: TInfInsCompany;
    FPolis: TBlankEntity;
  public
    property InsCompany: TInfInsCompany read FInsCompany write FInsCompany;
    property Blank: TBlankEntity read FPolis;
  end;

var
  frmBlankContracts: TfrmBlankContracts;

implementation
//---------------------------------------------------------------------------
procedure TfrmBlankContracts.FormShow(Sender: TObject);
var i: integer;
begin
  if (InsCompany = nil) then
    begin
      ModalResult := mrAbort;
      Visible     := false;
      exit;
    end;
  FPolis                      := nil;
  gbInsCompanyBlanks.Caption  := SysToUTF8(blank_sel_inscmp_hdr) + '`' +
    VarToStr(FInsCompany.InsCompanyName) + '`';

  with (strgridPolises) do
    begin
      Clean(0, 1, 1, RowCount - 1, [gzNormal, gzInvalid]);
      // Один ряд фиксирован.
      RowCount := InsCompany.Blanks.Count + 1;
    end;

  for i := 0 to InsCompany.Blanks.Count - 1 do
    begin
      with (strgridPolises) do
        begin
          Rows[i + 1].AddObject((InsCompany.Blanks[i] as TBlankEntity).DogSer,
            InsCompany.Blanks[i]);
          Cells[1, i + 1] :=
            VartoStr((InsCompany.Blanks[i] as TBlankEntity).DogNum);
        end;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmBlankContracts.sbtnPanelClick(Sender: TObject);
begin
  if (Sender = sbtnOk) then
    begin
      with strgridPolises do
        FPolis := Rows[Row].Objects[0] as TBlankEntity;
      ModalResult := mrOK;
    end
  else if (Sender = sbtnCancel) then
    begin
      ModalResult := mrCancel;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmBlankContracts.strgridPolisesDblClick(Sender: TObject);
begin
{  with strgridPolises do
    FPolis := Rows[Row].Objects[0] as TBlankEntity;
  ModalResult := mrOK;}
//  sbtnOk.Click();
end;
//---------------------------------------------------------------------------
procedure TfrmBlankContracts.strgridPolisesKeyPress(Sender: TObject;
  var Key: char);
begin
  if (Key = #13) then sbtnOk.Click();
end;
//---------------------------------------------------------------------------
procedure TfrmBlankContracts.strgridPolisesHeaderClick(Sender: TObject;
  IsColumn: Boolean; Index: Integer);
begin
  GridSort(strgridPolises, Index);
end;
//---------------------------------------------------------------------------
initialization
  {$I blank_contracts.lrs}

end.

