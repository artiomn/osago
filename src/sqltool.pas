unit SQLTool;

//
// Служебный инструмент - SQL консоль.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, Buttons, DBGrids, DbCtrls, SynHighlighterSQL,
  SynEdit, SynCompletion, MyAccess, data_unit, windows;

type

  { TfrmSQLTool }

  TfrmSQLTool = class(TForm)
    dbgridQueryResult: TDBGrid;
    dbnavQueryResult1: TDBNavigator;
    gbQueryResult: TGroupBox;
    gbSQLEditor: TGroupBox;
    mydatasrcQuery: TMyDataSource;
    myQuery: TMyQuery;
    pnBottom: TPanel;
    sbtnCancel: TSpeedButton;
    sbtnExecQuery: TSpeedButton;
    synautocomplQuery: TSynAutoComplete;
    syneditSQLText: TSynEdit;
    synsqlsQueryText: TSynSQLSyn;
    procedure sbtnPanelClick(Sender: TObject);
    procedure syneditSQLTextKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmSQLTool: TfrmSQLTool;

implementation

{ TfrmSQLTool }
//---------------------------------------------------------------------------
procedure TfrmSQLTool.sbtnPanelClick(Sender: TObject);
begin
  if (Sender = sbtnExecQuery) then
    begin
      myQuery.Close();
      myQuery.SQL.Assign(syneditSQLText.Lines);
      try
        myQuery.Open();
      except
        myQuery.Execute();
      end;
    end
  else
    begin
      Close();
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmSQLTool.syneditSQLTextKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((ssCtrl in Shift) and (Key = VK_RETURN)) then sbtnExecQuery.Click();
end;
//---------------------------------------------------------------------------
initialization
  {$I sqltool.lrs}

end.

