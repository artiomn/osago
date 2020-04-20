unit contract_history;

//
// Окно "История договоров".
//

{$I settings.inc}

interface

uses
  SysUtils, Classes, Variants, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DBCtrls, Grids, DBGrids,
  Buttons, strings_l10n, LResources, db;

type
  TDataSourceNotifyEvent = procedure(DataSource: TDataSource) of object;

  TfrmContractHistory = class(TForm)
    dbgridPrevs: TDBGrid;
    dbgridOpers: TDBGrid;
    gboxPrevContracts: TGroupBox;
    gboxContractOpers: TGroupBox;
    pnHead: TPanel;
    sbarMain: TStatusBar;
    pnBottom: TPanel;
    sbtnClose: TSpeedButton;
    pnMain: TPanel;
    procedure dbgridsDblClick(Sender: TObject);
    procedure sbtnPanelClick(Sender: TObject);
  private
    FOnGridClick: TDataSourceNotifyEvent;
  public
    property OnGridClick: TDataSourceNotifyEvent read FOnGridClick
      write FOnGridClick;
  end;

var
  frmContractHistory: TfrmContractHistory;

implementation

//---------------------------------------------------------------------------
procedure TfrmContractHistory.sbtnPanelClick(Sender: TObject);
begin
  Close();    
end;
//---------------------------------------------------------------------------
procedure TfrmContractHistory.dbgridsDblClick(Sender: TObject);
begin
  if (Assigned(FOnGridClick) and (Sender is TCustomDBGrid)) then
    FOnGridClick((Sender as TDBGrid).DataSource);
end;
//---------------------------------------------------------------------------

initialization
  {$i contract_history.lrs}

end.
