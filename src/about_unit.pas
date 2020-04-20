unit about_unit;

//
// Окно "О программе".
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, math, multigradient, gradient, ugradbtn, common_functions,
  common_consts;

const
  color_chg_step = 1;

type

  { TfrmAbout }

  TfrmAbout = class(TForm)
    btnFormClose: TGradButton;
    gradBottom: TGradient;
    imgLogo: TImage;
    Label1: TLabel;
    Label2: TLabel;
    labelMail: TLabel;
    labelAbout: TLabel;
    labelURL: TLabel;
    tmGrad: TTimer;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure labelLinksClick(Sender: TObject);
    procedure labelLinksMouseEnter(Sender: TObject);
    procedure labelLinksMouseLeave(Sender: TObject);
    procedure tmGradTimer(Sender: TObject);
  private
    FReverse: boolean;
    FStep:    integer;
    c_start0: TColor;
    c_end0: TColor;
    dR, dG, dB: integer;
    sR, sG, sB: integer;

  private
    function IncColor(AColor: TColor; AQuantity: Byte): TColor;
    function AlterColor(const cl: TColor; const dtR, dtG, dtB: integer): TColor;
  public
  end;

var
  frmAbout: TfrmAbout;

implementation
//---------------------------------------------------------------------------
procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  Caption   := Caption +  ' "' + Application.Title + '"';
  c_start0  := gradBottom.BeginColor;
  c_end0    := gradBottom.EndColor;
  FReverse  := false;
  FStep     := 0;
end;
//---------------------------------------------------------------------------
procedure TfrmAbout.FormShow(Sender: TObject);
begin
  FReverse                := false;
  gradBottom.BeginColor   := c_start0;
  gradBottom.EndColor     := c_end0;
  tmGrad.Enabled          := true;
end;
//---------------------------------------------------------------------------
procedure TfrmAbout.labelLinksMouseEnter(Sender: TObject);
begin
  with (Sender as TLabel).Font do
    begin
      Color := clBlue;
      Style := [fsBold, fsUnderline];
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmAbout.labelLinksMouseLeave(Sender: TObject);
begin
  with (Sender as TLabel).Font do
    begin
      Color := clSkyBlue;
      Style := [fsBold];
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmAbout.labelLinksClick(Sender: TObject);
begin
  if (Sender = labelMail) then OpenURL(UTF8ToSys(my_email))
  else if (Sender = labelURL) then OpenURL(UTF8ToSys(my_site))
end;
//---------------------------------------------------------------------------
procedure TfrmAbout.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  tmGrad.Enabled := false;
end;
//---------------------------------------------------------------------------
procedure TfrmAbout.tmGradTimer(Sender: TObject);
begin
  if (FStep <= 0) then
  with (gradBottom) do
    begin
      dR := Integer(Red(EndColor)) - Integer(Red(BeginColor));
      dG := Integer(Green(EndColor)) - Integer(Green(BeginColor));
      dB := Integer(Blue(EndColor)) - Integer(Blue(BeginColor));
      sR := Sign(dR);
      sG := Sign(dG);
      sB := Sign(dB);
      FStep := Max(abs(dR), abs(dG));
      FStep := Max(FStep, abs(dB));
    end;
  with (gradBottom) do
    begin
      if (dR < 0) then Inc(dR)
      else if (dR > 0) then Dec(dR)
      else sR := 0;
      if (dG < 0) then Inc(dG)
      else if (dG > 0) then Dec(dG)
      else sG := 0;
      if (dB < 0) then Inc(dB)
      else if (dB > 0) then Dec(dB)
      else sB := 0;
      EndColor    := AlterColor(EndColor, -sR * color_chg_step,
        -sG * color_chg_step, -sB * color_chg_step);
      BeginColor  := AlterColor(BeginColor, sR * color_chg_step,
        sG * color_chg_step, sB * color_chg_step);
    end;
  Dec(FStep);
end;
//---------------------------------------------------------------------------
procedure TfrmAbout.btnCloseClick(Sender: TObject);
begin
  Close();
end;
//---------------------------------------------------------------------------
function TfrmAbout.IncColor(AColor: TColor; AQuantity: Byte): TColor;
var
  R, G, B : Byte;
begin
  RedGreenBlue(ColorToRGB(AColor), R, G, B);
  R := Min(255, Integer(R) + AQuantity);
  G := Min(255, Integer(G) + AQuantity);
  B := Min(255, Integer(B) + AQuantity);
  Result := RGBToColor(R, G, B);
end;
//---------------------------------------------------------------------------
function TfrmAbout.AlterColor(const cl: TColor; const dtR, dtG, dtB: integer):
  TColor;
var
  R, G, B : Byte;
begin
  RedGreenBlue(ColorToRGB(cl), R, G, B);
  if (dtR < 0) then R := Max(0, Integer(R) - abs(dtR))
  else R := Min(255, Integer(R) + dtR);
  if (dtG < 0) then G := Max(0, Integer(G) - abs(dtG))
  else G := Min(255, Integer(G) + dtG);
  if (dtB < 0) then B := Max(0, Integer(B) - abs(dtB))
  else B := Min(255, Integer(B) + dtB);
  Result := RGBToColor(R, G, B);
end;
//---------------------------------------------------------------------------
initialization
  {$I about_unit.lrs}

end.

