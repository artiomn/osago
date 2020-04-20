unit login_unit;

//
// Окно подключения к СУБД.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Buttons, StdCtrls, IniFiles, common_consts,
  common_functions, logger;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    cbGlobalSaving: TCheckBox;
    edDBName: TEdit;
    edHostName: TEdit;
    edLogin: TEdit;
    edPassword: TEdit;
    edPort: TEdit;
    gbConnectionParams: TGroupBox;
    imgHead: TImage;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    labelDBName: TLabel;
    pnBaseSettings: TPanel;
    pnBottom: TPanel;
    sbtnCancel: TSpeedButton;
    sbtnOk: TSpeedButton;
    ToggleBox1: TToggleBox;
    procedure edLoginKeyPress(Sender: TObject; var Key: char);
    procedure edPortKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure sbtnPanelClick(Sender: TObject);
  private
    FGlobalSettings: string;
    FUserSettings: string;
  private
    procedure LoadInitSettings();
    procedure SaveInitSettings();
  end;

var
  frmLogin: TfrmLogin;

implementation
//---------------------------------------------------------------------------
procedure TfrmLogin.sbtnPanelClick(Sender: TObject);
begin
 if (Sender = sbtnOk) then
    begin
      SaveInitSettings();
      ModalResult := mrOk;
    end
  else if (Sender = sbtnCancel) then
    begin
      ModalResult := mrCancel;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmLogin.edPortKeyPress(Sender: TObject; var Key: char);
var ss: TShiftState;
begin
  ss := GetKeyShiftState();
  if ((ss = [ssAlt]) or (ss = [ssCtrl])) then exit;
  if (Key = #13) then
    begin
      Key := #0;
      sbtnOk.Click();
      exit;
    end;
  if (not (((Key >= '0') and (Key <= '9')) or (Key = DecimalSeparator) or
      (Key = #8))) then Key := #0;
end;
//---------------------------------------------------------------------------
procedure TfrmLogin.edLoginKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = #13) then
    begin
      Key := #0;
      sbtnOk.Click();
      exit;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmLogin.FormCreate(Sender: TObject);
var fname: string;
begin
  fname           := ChangeFileExt(ExtractFileName(ParamStrUTF8(0)), '.ini');
  FUserSettings   := GetEnvironmentVariableUTF8('USERPROFILE') +
     PathDelim + 'Application Data' + PathDelim + SysToUTF8(settings_dir);
  try
    if (not DirectoryExistsUTF8(FUserSettings)) then
      ForceDirectoriesUTF8(FUserSettings);
    FUserSettings := FUserSettings + PathDelim + fname;
  except
    LogException('TfrmLogin.FormCreate');
    exit;
  end;
  FGlobalSettings := ExtractFileDir(ParamStrUTF8(0)) + PathDelim + fname;
  LoadInitSettings();
end;
//---------------------------------------------------------------------------
procedure TfrmLogin.LoadInitSettings();
var IniFile: TIniFile;
    s_str: string;
begin
  IniFile := nil;
  try
    IniFile := TIniFile.Create(UTF8ToSys(FGlobalSettings));
    try
      edHostName.Text :=
        IniFile.ReadString('Connection', 'HostName', edHostName.Text);
      edPort.Text     :=
        IniFile.ReadString('Connection','Port', edPort.Text);
      edDBName.Text   :=
        IniFile.ReadString('Connection','Database', edDBName.Text);
      edLogin.Text    := IniFile.ReadString('User','Login', edLogin.Text);
    except
      LogException('TfrmLogin.LoadInitSettings');
    end;
    FreeAndNil(IniFile);
    IniFile         := TIniFile.Create(UTF8ToSys(FUserSettings));
    s_str           := IniFile.ReadString('Connection','HostName', EmptyStr);
    if (s_str <> EmptyStr) then
      edHostName.Text := s_str;
    s_str           := IniFile.ReadString('Connection','Port', EmptyStr);
    if (s_str <> EmptyStr) then
      edPort.Text := s_str;
    s_str           := IniFile.ReadString('Connection','Database', EmptyStr);
    if (s_str <> EmptyStr) then
      edDBName.Text := s_str;
    s_str           := IniFile.ReadString('User','Login', EmptyStr);
    if (s_str <> EmptyStr) then
      edLogin.Text := s_str;
  finally
    IniFile.Free;
  end;
end;
//---------------------------------------------------------------------------
procedure TfrmLogin.SaveInitSettings();
var IniFile: TIniFile;
begin
  IniFile := nil;
  try
    if (cbGlobalSaving.Checked) then
      IniFile := TIniFile.Create(UTF8ToSys(FGlobalSettings))
    else
      IniFile := TIniFile.Create(UTF8ToSys(FUserSettings));
    try
      IniFile.WriteString('Connection', 'HostName', edHostName.Text);
      IniFile.WriteString('Connection', 'Port', edPort.Text);
      IniFile.WriteString('Connection', 'Database', edDBName.Text);
      if (not cbGlobalSaving.Checked) then
        IniFile.WriteString('User', 'Login', edLogin.Text);

    except
      LogException('TfrmLogin.SaveInitSettings');
    end;
  finally
    IniFile.Free;
  end;
end;
//---------------------------------------------------------------------------
initialization
  {$I login_unit.lrs}

end.

