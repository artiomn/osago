unit rep_filter;

//
// Диалог фильтрации договоров по датам.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, EditBtn, Buttons, logger;

type

  { TfrmRepFilter }

  TfrmRepFilter = class(TForm)
    cbStartDate: TCheckBox;
    cbEndDate: TCheckBox;
    dtedStartDate: TDateEdit;
    dtedEndDate: TDateEdit;
    sbtnCancel: TSpeedButton;
    sbtnOk: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbtnsClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmRepFilter: TfrmRepFilter;

implementation
//---------------------------------------------------------------------------
procedure TfrmRepFilter.FormCreate(Sender: TObject);
begin
  {$IFDEF DEBUG}
  Debug('OnCreate: Creating frmRepFilter.');
  {$ENDIF}
  dtedStartDate.Date  := Now();
  dtedEndDate.Date    := Now();
end;
//---------------------------------------------------------------------------
procedure TfrmRepFilter.sbtnsClick(Sender: TObject);
begin
  if (Sender = sbtnOk) then ModalResult := mrOK
  else if (Sender = sbtnCancel) then ModalResult := mrCancel;
end;
//---------------------------------------------------------------------------
procedure TfrmRepFilter.FormShow(Sender: TObject);
begin

end;
//---------------------------------------------------------------------------
initialization
  {$I rep_filter.lrs}

end.

