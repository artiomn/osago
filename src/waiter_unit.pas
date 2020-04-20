unit waiter_unit;

//
// Монолог ожидания.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls;

// Интервал в мс
const def_waiter_interval = 150;
//---------------------------------------------------------------------------
procedure ShowWaiter();
procedure HideWaiter();
//---------------------------------------------------------------------------
type

  { TfrmWaiter }
  TWaiterRefresher = class;

  TfrmWaiter = class(TForm)
    bevelWaiter: TBevel;
    imglistWaiting: TImageList;
    imgWaiting: TImage;
    labelWaiting: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure ChangeTimer(Sender: TObject);
  private
    FImgIndex: integer;
    FCloseAccepted: boolean;
  end;
//---------------------------------------------------------------------------
// Обновляет форму через определённые промежутки. Используется только в
// TfrmWaiter.
  TWaiterRefresher = class(TThread)
  private
    FLastTime:    TDateTime;
    FOnTimer:     TNotifyEvent;
    FWaiterForm:  TfrmWaiter;
  private
    procedure Execute(); override;
    procedure DoOnTimer();
  public
    constructor Create();
    procedure Run();
    procedure Stop();
    destructor Destroy; override;
  public
    procedure StartOper();
    procedure EndOper();
  public
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;

var
  frmWaiter: TfrmWaiter;
  WaiterRefresher: TWaiterRefresher;

implementation
//---------------------------------------------------------------------------
constructor TWaiterRefresher.Create();
begin
  inherited Create(true);
end;
//---------------------------------------------------------------------------
destructor TWaiterRefresher.Destroy;
begin
  inherited;
end;
//---------------------------------------------------------------------------
procedure TWaiterRefresher.Execute();
var h, m, s0, s1, ms0, ms1: word;
begin
  FWaiterForm := TfrmWaiter.Create(nil);
  OnTimer     := @FWaiterForm.ChangeTimer;
  while (not Terminated) do
    begin
      DecodeTime(Time(), h, m, s0, ms0);
      DecodeTime(FLastTime, h, m, s1, ms1);
      ms0 := ms0 + s0;
      ms1 := ms1 + s1;
      if (ms0 - ms1 >= def_waiter_interval) then
        begin
          // Без Synchronize
          DoOnTimer();
          FLastTime := Time();
        end;
    end;
  FWaiterForm.Free;
end;
//---------------------------------------------------------------------------
procedure TWaiterRefresher.Run();
begin
  FLastTime := Time();
  Resume();
end;
//---------------------------------------------------------------------------
procedure TWaiterRefresher.Stop();
begin
  if (FWaiterForm <> nil) then FWaiterForm.Hide;
  if (not Suspended) then Suspend();
end;
//---------------------------------------------------------------------------
procedure TWaiterRefresher.DoOnTimer();
begin
  if (Assigned(FOnTimer)) then FOntimer(Self);
end;
//---------------------------------------------------------------------------
procedure TWaiterRefresher.StartOper();
begin
  FWaiterForm.ShowModal();
  Application.ProcessMessages();
  Run();
end;
//---------------------------------------------------------------------------
procedure TWaiterRefresher.EndOper();
begin
  Stop();
  FWaiterForm.FCloseAccepted := true;
  FWaiterForm.Close();
end;
//---------------------------------------------------------------------------
// TfrmWaiter
//---------------------------------------------------------------------------
procedure TfrmWaiter.ChangeTimer(Sender: TObject);
begin
  if (FImgIndex >= imglistWaiting.Count - 1) then FImgIndex := 0
  else Inc(FImgIndex);
  imglistWaiting.GetBitmap(FImgIndex, imgWaiting.Picture.Bitmap);
  Show();
  Application.ProcessMessages();
end;
//---------------------------------------------------------------------------
procedure TfrmWaiter.FormShow(Sender: TObject);
begin
  FImgIndex      := 0;
  FCloseAccepted := false;
  imglistWaiting.GetBitmap(0, imgWaiting.Picture.Bitmap);
  //timerImageChange.Enabled := true;
end;
//---------------------------------------------------------------------------
procedure TfrmWaiter.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := FCloseAccepted;
end;
//---------------------------------------------------------------------------
procedure ShowWaiter();
begin
//  WaiterRefresher.Run();
end;
//---------------------------------------------------------------------------
procedure HideWaiter();
begin
//  WaiterRefresher.Stop();
end;
//---------------------------------------------------------------------------
initialization
  {$I waiter_unit.lrs}
  WaiterRefresher := TWaiterRefresher.Create;
finalization
  WaiterRefresher.Terminate();
  WaiterRefresher.Resume();
  WaiterRefresher.Free();
end.

