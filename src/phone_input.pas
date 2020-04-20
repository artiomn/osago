unit phone_input;

//
// Форма ввода номера телефона.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type

  { TfrmInputPhone }

  TfrmInputPhone = class(TForm)
    bevelTop: TBevel;
    sbtnBacksp: TSpeedButton;
    sbtnCancel: TSpeedButton;
    sbtnClear: TSpeedButton;
    sbtnd0: TSpeedButton;
    sbtnd1: TSpeedButton;
    sbtnd2: TSpeedButton;
    sbtnd3: TSpeedButton;
    sbtnd4: TSpeedButton;
    sbtnd5: TSpeedButton;
    sbtnd6: TSpeedButton;
    sbtnd7: TSpeedButton;
    sbtnd8: TSpeedButton;
    sbtnd9: TSpeedButton;
    sbtnlA: TSpeedButton;
    sbtnlB: TSpeedButton;
    sbtnlC: TSpeedButton;
    sbtnlD: TSpeedButton;
    sbtnlE: TSpeedButton;
    sbtnlF: TSpeedButton;
    sbtnlG: TSpeedButton;
    sbtnlH: TSpeedButton;
    sbtnlI: TSpeedButton;
    sbtnlJ: TSpeedButton;
    sbtnlK: TSpeedButton;
    sbtnlL: TSpeedButton;
    sbtnlM: TSpeedButton;
    sbtnlN: TSpeedButton;
    sbtnlO: TSpeedButton;
    sbtnlP: TSpeedButton;
    sbtnlR: TSpeedButton;
    sbtnlS: TSpeedButton;
    sbtnlT: TSpeedButton;
    sbtnlU: TSpeedButton;
    sbtnlV: TSpeedButton;
    sbtnlW: TSpeedButton;
    sbtnlX: TSpeedButton;
    sbtnlY: TSpeedButton;
    sbtnOk: TSpeedButton;
    sbtns3: TSpeedButton;
    sbtnsAsteriks: TSpeedButton;
    sbtnsBsp: TSpeedButton;
    sbtnsDefis: TSpeedButton;
    sbtnsDot: TSpeedButton;
    sbtnsFsp: TSpeedButton;
    sbtnsPL: TSpeedButton;
    sbtnsPlus: TSpeedButton;
    sbtnsPR: TSpeedButton;
    sbtnsSlash: TSpeedButton;
    procedure FormDeactivate(Sender: TObject);
    procedure ledPhoneKeyPress(Sender: TObject; var Key: char);
    procedure sbtnsCtrlClick(Sender: TObject);
    procedure sbtnsInputClick(Sender: TObject);
  private
    FOrigText: string;
    FCaller: TCustomEdit;
  private
    function GetPhonenumber(): string;
  public
    procedure PopupThis(const w_pos: TPoint; caller: TCustomEdit);
    property PhoneNumber: string read GetPhoneNumber;
  end; 

var
  frmInputPhone: TfrmInputPhone;

implementation
//---------------------------------------------------------------------------
procedure TfrmInputPhone.PopupThis(const w_pos: TPoint; caller: TCustomEdit);
var ABounds: TRect;
begin
  if (caller = nil) then exit;
  FCaller   := caller;
  FOrigText := FCaller.Text;
  // Из календарика.
  ABounds := Screen.MonitorFromPoint(w_pos).BoundsRect;
  if (w_pos.x + Width > ABounds.Right) then
    Left := ABounds.Right - Width
  else
    Left := w_pos.x;
  if (w_pos.y + Height > ABounds.Bottom) then
    Top := ABounds.Bottom - Height
  else
    Top := w_pos.y;
  //TODO: Change to PopupForm.Show when gtk supports non modal forms on top of
  //modal forms.
//  {$IFDEF windows}
  Show;
{  {$ELSE}
  PopupForm.ShowModal;
  {$ENDIF}}
end;
//---------------------------------------------------------------------------
procedure TfrmInputPhone.sbtnsInputClick(Sender: TObject);
begin
  FCaller.Text := FCaller.Text + (Sender as TSpeedButton).Caption;
end;
//---------------------------------------------------------------------------
procedure TfrmInputPhone.sbtnsCtrlClick(Sender: TObject);
var s: string;
begin
  if (Sender = sbtnOk) then
    begin
      //FCaller.Text := PhoneNumber;
      ModalResult   := mrOk;
      Close();
    end
  else if (Sender = sbtnBacksp) then
    begin
      s := FCaller.Text;
      if (Length(s) > 0) then
        begin
          SetLength(s, Length(s) - 1);
          FCaller.Text := s;
        end;
    end
  else if (Sender = sbtnCancel) then
    begin
      FCaller.Text  := FOrigText;
      ModalResult   := mrCancel;
      Close();
    end
  else if (Sender = sbtnClear) then
    begin
      FCaller.Text := EmptyStr;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmInputPhone.FormDeactivate(Sender: TObject);
begin
  if (Visible) then sbtnCancel.Click();
end;
//---------------------------------------------------------------------------
procedure TfrmInputPhone.ledPhoneKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = #13) then
    begin
      Key := #0;
      sbtnOk.Click();
    end;
end;
//---------------------------------------------------------------------------
function TfrmInputPhone.GetPhonenumber(): string;
begin
  Result := FCaller.Text;
end;
//---------------------------------------------------------------------------
initialization
  {$I phone_input.lrs}

end.

