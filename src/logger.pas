unit logger;

//
// Функции и классы логирования.
//

{$I settings.inc}

interface

uses SysUtils, Classes, dateutils, lineinfo, strings_l10n;
//---------------------------------------------------------------------------
type
  TAppEventLog      = class;
  TEventType        = (etCustom, etInfo, etWarning, etError, etDebug, etFatal);
  TLogType          = (ltSystem, ltFile);
  TLogOpenMode      = (lomRewrite, lomAppend);
  TRotationMode     = (rmdNone, rmdTime, rmdSize);
  TLogCodeEvent     = procedure(Sender: TObject; var Code: DWord) of object;
  TLogCategoryEvent = procedure(Sender: TObject; var Code: Word) of object;

//===========================================================================
// Функции логирования.
//===========================================================================

procedure Log(const EventType: TEventType; const Msg: string); overload;
procedure Log(const EventType: TEventType; const Fmt: string; Args : array of const);
  overload;
procedure Log(const Msg: string); overload;
procedure Log(const Fmt: string; Args: array of const); overload;
//---------------------------------------------------------------------------
procedure Info(const Msg: string); overload;
procedure Info(const Fmt: string; Args: array of const); overload;
//---------------------------------------------------------------------------
procedure Debug(const Msg: string); overload;
procedure Debug(const Fmt: string; Args: array of const); overload;
//---------------------------------------------------------------------------
procedure Error(const Msg: string); overload;
procedure Error(const Fmt: string; args: array of const); overload;
//---------------------------------------------------------------------------
procedure Fatal(const Msg: string); overload;
procedure Fatal(const Fmt: string; args: array of const); overload;
//---------------------------------------------------------------------------
function MainLog(): TAppEventLog;
procedure DestroyLog();
//---------------------------------------------------------------------------
procedure LogException(const E: Exception); overload;
procedure LogException(const add_info: string = ''); overload;
procedure SpecialLog(const line_num: cardinal; const method_name: string;
  const msg: string);

//===========================================================================

const
  def_log_ext           = '.log';
  // Каталог отчётов.
  log_dir               = 'logs';
  def_timestamp_format  = 'yyyy-mm-dd hh:nn:ss.zzz';
  def_file_ts_format    = '_yyyy_mm_dd_hh_nn_ss';
//---------------------------------------------------------------------------
type
  TAppEventLog = class(TObject)
  private
    FEventIDOffset: dword;
    FLogHandle: pointer;
    FStream: TFileStream;
    FFirstActivation: boolean;
    FActive: boolean;
    FRaiseExceptionOnError: boolean;
    FIdentification: string;
    FDefaultEventType: TEventType;
    FLogType: TLogType;
    FFileName: string;
    FTimeStampFormat: string;
    FCustomLogType: word;

    FUseLogDir: boolean;
    FOpenMode: TLogOpenMode;
    FBlockForRead: boolean;
    FBlockForWrite: boolean;
    // В минутах.
    FRotationPeriod: longint;
    // В байтах.
    FRotationSize: longint;
    FLogRotation: TRotationMode;
    FOnGetCustomCategory: TLogCategoryEvent;
    FOnGetCustomEventID: TLogCodeEvent;
    FOnGetCustomEvent: TLogCodeEvent;
    procedure SetActive(const Value: boolean);
    procedure SetIdentification(const Value: string);
    procedure SetlogType(const Value: TLogType);
    procedure ActivateLog();
    procedure DeActivateLog();
    procedure ActivateFileLog();
    procedure SetFileName(const Value: string);
    procedure ActivateSystemLog();
    function DefaultFileName(): string;
    procedure WriteFileLog(const EventType: TEventType; const Msg: string);
    procedure WriteSystemLog(const EventType: TEventType; const Msg: string);
    procedure DeActivateFileLog();
    procedure DeActivateSystemLog();
    procedure CheckIdentification();
    Procedure DoGetCustomEventID(var Code: dword);
    Procedure DoGetCustomEventCategory(var Code: word);
    procedure DoGetCustomEvent(var Code: dword);
  protected
    procedure ExceptionLog(const di: boolean;
      const func, src, class_name, msg: string; const line, e_addr: cardinal);
    procedure CheckInactive();
    procedure EnsureActive();
    function MapTypeToEvent(const EventType: TEventType): dword;
    function MapTypeToCategory(const EventType : TEventType): word;
    function MapTypeToEventID(const EventType : TEventType): dword;
  public
    constructor Create;
    destructor Destroy; override;
    function EventTypeTostring(const E : TEventType): string;
    function RegisterMessageFile(const AFileName: string): boolean; virtual;
    procedure Log(const EventType: TEventType; const Msg: string);
      {$ifndef fpc}overload;{$endif}
    procedure Log(const EventType: TEventType; const Fmt: string;
      Args: array of const);
      {$ifndef fpc }overload;{$endif}
    procedure Log(const Msg: string);
      {$ifndef fpc}overload;{$endif}
    procedure Log(const Fmt: string; Args: array of const);
      {$ifndef fpc}overload;{$endif}
    procedure Warning(const Msg: string);
      {$ifndef fpc}overload;{$endif}
    procedure Warning(const Fmt: string; Args: array of const);
      {$ifndef fpc}overload;{$endif}
    procedure Fatal(const Msg: string);
      {$ifndef fpc}overload;{$endif}
    procedure Fatal(const Fmt: string; Args: array of const);
      {$ifndef fpc}overload;{$endif}
    procedure Error(const Msg: string);
      {$ifndef fpc}overload;{$endif}
    procedure Error(const Fmt: string; Args: array of const);
      {$ifndef fpc}overload;{$endif}
    procedure Debug(const Msg: string);
      {$ifndef fpc}overload;{$endif}
    procedure Debug(const Fmt: string; Args: array of const);
      {$ifndef fpc}overload;{$endif}
    procedure Info(const Msg: string);
      {$ifndef fpc}overload;{$endif}
    procedure Info(const Fmt: string; Args: array of const);
      {$ifndef fpc}overload;{$endif}
  public
    procedure LogException(const E: Exception);
    procedure LogException(const add_info: string = '');
      {$ifndef fpc}overload;{$endif}
    procedure OnExceptionLog(Sender: TObject; E: Exception);
  published
    property Identification : string read FIdentification
      write SetIdentification;
    property LogType : TLogType read FLogType write SetLogType;
    property Active : Boolean read FActive write SetActive;
    property RaiseExceptionOnError : Boolean read FRaiseExceptionOnError
      write FRaiseExceptionOnError;
    property DefaultEventType: TEventType Read FDEfaultEventType
      write FDefaultEventType;
    property FileName: string read FFileName write SetFileName;
    property TimeStampFormat: string read FTimeStampFormat write FTimeStampFormat;
    property CustomLogType: Word read FCustomLogType write FCustomLogType;
    property EventIDOffset: DWord read FEventIDOffset write FEventIDOffset;
    property OnGetCustomCategory : TLogCategoryEvent read FOnGetCustomCategory
      write FOnGetCustomCategory;
    property OnGetCustomEventID: TLogCodeEvent read FOnGetCustomEventID
      write FOnGetCustomEventID;
    property OnGetCustomEvent: TLogCodeEvent read FOnGetCustomEvent
      write FOnGetCustomEvent;
  end;
//===========================================================================
ELogError = class(Exception);
//===========================================================================
resourcestring
  SLogInfo          = 'Info';
  SLogWarning       = 'Warning';
  SLogError         = 'Error';
  SLogDebug         = 'Debug';
  SLogCustom        = 'Custom (%d)';
  SLogFatal         = 'Fatal';
  SErrLogFailedMsg  = 'Failed to log entry (Error: %s)';
resourcestring
  SErrOperationNotAllowed = 'Operation not allowed when eventlog is active.';
  SErrNoSysLog            = 'Could not open system log (error %d)';
  SErrLogFailed           = 'Failed to log entry (error %d)';
  SMsgFirstActivation     = 'Logging activation for "%s"';
  SMsgNextActivation      = 'Logging activation';
  SMsgDeactivation        = 'Try logging deactivation';
//===========================================================================
implementation
//===========================================================================
uses FileUtil, Dialogs {$IFDEF WINDOWS}, windows{$ENDIF};
//---------------------------------------------------------------------------
var MainLogVar: TAppEventLog;
//---------------------------------------------------------------------------
constructor TAppEventLog.Create;
begin
  FUseLogDir        := true;
  FFirstActivation  := true;
  FBlockForRead     := false;
  FBlockForWrite    := false;
  FOpenMode         := lomAppend;
end;
//---------------------------------------------------------------------------
destructor TAppEventLog.Destroy;
begin
  Active := false;
  inherited;
end;
//---------------------------------------------------------------------------
function TAppEventLog.DefaultFileName: string;
var log_path: string;
begin
  if (FUseLogDir) then
    begin
      log_path  := ExtractFilePath(ParamStrUTF8(0)) + log_dir + PathDelim;
      if (not DirectoryExistsUTF8(log_path)) then
        ForceDirectoriesUTF8(log_path);
    end
  else log_path := EmptyStr;

  if (FLogRotation <> rmdNone) then
    Result := ExtractFileNameOnly(ParamStrUTF8(0)) +
      FormatDateTime(def_file_ts_format, Now()) + def_log_ext
  else
    Result := log_path + ExtractFileNameOnly(ParamStrUTF8(0)) + def_log_ext;
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.CheckInactive();
begin
  if (Active) then raise ELogError.Create(SErrOperationNotAllowed);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Debug(const Fmt: string; Args: array of const);
begin
  Debug(Format(Fmt, Args));
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Debug(const Msg: string);
begin
  Log(etDebug,Msg);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.EnsureActive;
begin
 if (not Active) then Active := true;
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Fatal(const Fmt: string; Args: array of const);
begin
  Fatal(Format(Fmt, Args));
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Fatal(const Msg: string);
begin
  Log(etFatal, Msg);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Error(const Fmt: string; Args: array of const);
begin
  Error(Format(Fmt, Args));
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Error(const Msg: string);
begin
  Log(etError, Msg);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Info(const Fmt: string; Args: array of const);
begin
  Info(Format(Fmt, Args));
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Info(const Msg: string);
begin
  Log(etInfo, Msg);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Log(const Msg: string);
begin
  Log(DefaultEventType, Msg);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Log(const EventType: TEventType; const Fmt: string;
  Args: array of const);
begin
  Log(EventType,Format(Fmt, Args));
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Log(const EventType: TEventType; const Msg: string);
begin
  EnsureActive;
  case FlogType of
    ltFile:   WriteFileLog(EventType, Msg);
    ltSystem: WriteSystemLog(EventType, Msg);
  end;
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.WriteFileLog(const EventType: TEventType;
  const Msg: string);
var
  s, ts, t: string;
begin
  if (FTimeStampFormat = EmptyStr) then
    FTimeStampFormat := def_timestamp_format;
  ts  := FormatDateTime(FTimeStampFormat, Now);
  t   := EventTypeTostring(EventType);
  s   := Format('%s [%s %s] %s%s', [Identification, TS, T, Msg, LineEnding]);
  try
    FStream.WriteBuffer(S[1], Length(S));
    s := EmptyStr;
  except
    on E: Exception do
      s := E.Message;
  end;

  if (s <> EmptyStr) and RaiseExceptionOnError then
    raise ELogError.CreateFmt(SErrLogFailedMsg, [S]);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Log(const Fmt: string; Args: array of const);
begin
  Log(Format(Fmt, Args));
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.SetActive(const Value: boolean);
begin
  if (Value <> FActive) then
    begin
      if (Value) then ActivateLog()
      else DeActivateLog();
    end;
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.ActivateLog();
var param_string: string;
    i: integer;
begin
  try
    CheckIdentification();

    case FLogType of
      ltFile:   ActivateFileLog();
      ltSystem: ActivateSystemLog();
    end;

    FActive := true;

    if (FFirstActivation) then
      begin
        FFirstActivation  := false;
        param_string      := EmptyStr;
        for i := 0 to Paramcount do
          param_string := ParamStrUTF8(i) + ' ';
        param_string := Trim(param_string);
        Info(SMsgFirstActivation, [param_string]);
      end
    else
      Info(SMsgNextActivation);
  except
    raise;
  end;
end;
//---------------------------------------------------------------------------
Procedure TAppEventLog.DeActivateLog;
begin
  try
    Info(SMsgDeactivation);
    case FLogType of
      ltFile:   DeActivateFileLog();
      ltSystem: DeActivateSystemLog();
    end;

    FActive := false;

  except
    raise;
  end;
end;
//---------------------------------------------------------------------------
Procedure TAppEventLog.ActivateFileLog;
var fmode: word;
begin
  if (FFileName = EmptyStr) then FFileName := DefaultFileName;
  // Да, всегда так нужно из-за ошибки в конструкторе TFileStream.
  // Он не учитывает параметр Mode, при fmCreate.
  fmode := fmOpenWrite;

  if (not FileExistsUTF8(FFileName)) then
    begin
      FStream := TFileStream.Create(UTF8ToSys(FFileName), fmCreate);
      FStream.Free;
    end;

  if (FBlockForRead) then fmode := fmode or fmShareDenyRead;
  if (FBlockForWrite) then fmode := fmode or fmShareDenyWrite;

  if (not (FBlockForWrite or FBlockForRead)) then
    fmode := fmode or fmShareDenyNone;

  FStream := TFileStream.Create(UTF8ToSys(FFileName), fmode);
  if (FOpenMode = lomAppend) then FStream.Seek(0, soEnd);
end;
//---------------------------------------------------------------------------
Procedure TAppEventLog.DeActivateFileLog;
begin
  FStream.Free;
  FStream := nil;
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.SetIdentification(const Value: string);
begin
  FIdentification := Value;
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.SetlogType(const Value: TLogType);
begin
  CheckInactive;
  Flogtype := Value;
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Warning(const Fmt: string; Args: array of const);
begin
  Warning(Format(Fmt, Args));
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.Warning(const Msg: string);
begin
  Log(etWarning, Msg);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.SetFileName(const Value: string);
begin
  CheckInactive;
  FFileName := Value;
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.CheckIdentification;
begin
  if (Identification = EmptyStr) then
    Identification := ChangeFileExt(ExtractFileName(Paramstr(0)), '');
end;
//---------------------------------------------------------------------------
function TAppEventLog.EventTypeTostring(const E: TEventType): string;
begin
  case E of
    etInfo    : Result := SLogInfo;
    etWarning : Result := SLogWarning;
    etError   : Result := SLogError;
    etFatal   : Result := SLogFatal;
    etDebug   : Result := SLogDebug;
    etCustom  : Result := Format(SLogCustom, [CustomLogType]);
  end;
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.DoGetCustomEventID(var code: dword);
begin
  if (Assigned(FOnGetCustomEventID)) then FOnGetCustomEventID(Self, Code);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.DoGetCustomEventCategory(var code: word);
begin
  if (Assigned(FOnGetCustomCategory)) then FOnGetCustomCategory(Self, Code);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.DoGetCustomEvent(var code: dword);
begin
  if (Assigned(FOnGetCustomEvent)) then FOnGetCustomEvent(Self,Code);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.OnExceptionLog(Sender: TObject; E: Exception);
begin
  LogException(E);
  MessageDlg(SysToUTF8(cls_error), E.Message, mtError, [mbOK], '');
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.ExceptionLog(const di: boolean;
  const func, src, class_name, msg: string; const line, e_addr: cardinal);
begin
  if (di) then
    Error('Func: %s; src: %s; line: %d (class: %s [addr: %x]): %s)',
      [func, src, line, class_name, e_addr, UTF8ToSys(msg)])
  else
    Error('NO DEBUG INFO (class: %s [addr: %x]): %s)', [class_name,
      e_addr, UTF8ToSys(msg)]);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.LogException(const E: Exception);
var di: boolean;
    func, src: shortstring;
    line: integer;
begin
  di := GetLineInfo(LongWord(ExceptAddr), func, src, line);
  ExceptionLog(di, func, src, E.ClassName, E.Message, line,
    Cardinal(ExceptAddr));
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.LogException(const add_info: string);
var di: boolean;
    func, src: shortstring;
    line: integer;
begin
  if (ExceptObject = nil) then
    begin
      Warning('TAppEventLog.LogException: No exception.');
      exit;
    end;
  di := GetLineInfo(LongWord(ExceptAddr), func, src, line);
  ExceptionLog(di, func, src, ExceptObject.ClassName,
    add_info + ' ' + (ExceptObject as Exception).Message, line,
    Cardinal(ExceptAddr));
end;
//---------------------------------------------------------------------------
{$IFDEF WINDOWS}
//---------------------------------------------------------------------------
procedure TAppEventLog.ActivateSystemLog;
begin
  FLogHandle := Pointer(OpenEventLog(Nil,Pchar(Identification)));
  if ((FLogHandle = nil) and FRaiseExceptionOnError) then
    raise ELogError.CreateFmt(SErrNoSysLog, [GetLastError]);
end;
//---------------------------------------------------------------------------
procedure TAppEventLog.DeActivateSystemLog;
begin
  CloseEventLog(cardinal(FLogHandle));
end;
//---------------------------------------------------------------------------
{
function ReportEvent(hEventLog: THandle; wType, wCategory: Word;
  dwEventID: DWORD; lpUserSid: Pointer; wNumStrings: Word;
  dwDataSize: DWORD; lpStrings, lpRawData: Pointer): BOOL; stdcall;
}
//---------------------------------------------------------------------------
procedure TAppEventLog.WriteSystemLog(const EventType: TEventType;
  const Msg: string);
var
  p:          PChar;
  i:          integer;
  category:   word;
  event_id:   dword;
  event_type: word;
begin
  category    := MapTypeToCategory(EventType);
  event_id    := MapTypeToEventID(EventType);
  event_type  := MapTypeToEvent(EventType);
  p           := PChar(Msg);
  if (not ReportEvent(Cardinal(FLogHandle), event_type, category, event_id,
    nil, 1, 0, @p, nil) and FRaiseExceptionOnError) then
    begin
      i := GetLastError();
      raise ELogError.CreateFmt(SErrLogFailed, [i]);
    end;
end;
//---------------------------------------------------------------------------
function TAppEventLog.RegisterMessageFile(const AFileName : String): boolean;
const
  SKeyEventLog            = 'SYSTEM\CurrentControlSet\Services\EventLog\Application\%s';
  SKeyCategoryCount       = 'CategoryCount';
  SKeyEventMessageFile    = 'EventMessageFile';
  SKeyCategoryMessageFile = 'CategoryMessageFile';
  SKeyTypesSupported      = 'TypesSupported';
var
  file_name: string;
  ELKey: string;
  Handle: HKey;
  SecurityAttributes: pointer; // LPSECURITY_ATTRIBUTES;
  Value,
  Disposition: dword;
begin
  SecurityAttributes := nil;
  CheckIdentification();
  if (AFileName = EmptyStr) then file_name := ParamStr(0)
  else file_name := AFileName;
  ELKey   := Format(SKeyEventLog,[IDentification]);
  Result  := RegCreateKeyExA(HKEY_LOCAL_MACHINE,
                          PChar(ELKey), 0, '',
                          REG_OPTION_NON_VOLATILE,
                          KEY_ALL_ACCESS,
                          SecurityAttributes, Handle,
                          pdword(@Disposition)) = ERROR_SUCCESS;
  if (Result) then
    begin
      Value   := 4;
      Result  := Result and (RegSetValueExA(Handle,PChar(SKeyCategoryCount), 0,
        REG_DWORD, @Value, sizeof(DWORD)) = ERROR_SUCCESS);
      Value   := 7;
      Result  := Result and (RegSetValueExA(Handle, PChar(SKeyTypesSupported), 0,
        REG_DWORD, @Value, sizeof(DWORD)) = ERROR_SUCCESS);
      Result  := Result and (RegSetValueExA(Handle,
        PChar(SKeyCategoryMessageFile), 0, REG_SZ, @file_name[1],
        Length(AFileName)) = ERROR_SUCCESS);
      Result  := Result and (RegSetValueExA(Handle, PChar(SKeyEventMessageFile),
        0, REG_SZ, @AFileName[1], Length(file_name)) = ERROR_SUCCESS);
    end;
end;
//---------------------------------------------------------------------------
function TAppEventLog.MapTypeToCategory(const EventType: TEventType): word;
begin
  if (EventType = ETCustom) then DoGetCustomEventCategory(Result)
  else Result := Ord(EventType);
  if (Result = 0) then Result := 1;
end;
//---------------------------------------------------------------------------
function TAppEventLog.MapTypeToEventID(const EventType: TEventType): dword;
begin
  if (EventType = ETCustom) then DoGetCustomEventID(Result)
  else
    begin
      if (FEventIDOffset = 0) then
        FEventIDOffset := 1000;
      Result := FEventIDOffset + Ord(EventType);
    end;
end;
//---------------------------------------------------------------------------
function TAppEventLog.MapTypeToEvent(const EventType: TEventType): dword;
const
  EVENTLOG_SUCCESS = 0;
  WinET : Array[TEventType] of word = (EVENTLOG_SUCCESS,
     EVENTLOG_INFORMATION_TYPE,
     EVENTLOG_WARNING_TYPE, EVENTLOG_ERROR_TYPE,
     EVENTLOG_AUDIT_SUCCESS,
     EVENTLOG_AUDIT_FAILURE);
begin
  if (EventType = etCustom) Then
    begin
      If (CustomLogType = 0) then
        CustomLogType := EVENTLOG_SUCCESS;
      Result := CustomLogType;
      DoGetCustomEvent(Result);
    end
  else
    Result := WinET[EventType];
end;
{$ENDIF} // WINDOWS
//---------------------------------------------------------------------------
// Functions.
//---------------------------------------------------------------------------
function MainLog(): TAppEventLog;
begin
  if (MainLogVar = nil) then
    begin
      MainLogVar  := TAppEventLog.Create;
      {$IFDEF LOGGING_FILE}
      MainLogVar.LogType := ltFile;
      {$ELSE}
        {$IFDEF LOGGING_SYSTEM}
        MainLogVar.LogType := ltSystem;
        {$ENDIF}
      {$ENDIF}
      {$IFNDEF LOGGING_OFF}
      MainLogVar.Active := true;
      {$ENDIF}
    end;
  Result := MainLogVar;
end;
//---------------------------------------------------------------------------
procedure DestroyLog();
begin
  FreeAndNil(MainLogVar);
end;
//---------------------------------------------------------------------------
procedure SpecialLog(const line_num: cardinal; const method_name: string;
  const msg: string);
begin
  MainLog.Debug('ln: %d, method: %s, msg: %s ||', [line_num, method_name,
    UTF8ToSys(msg)]);
end;
//---------------------------------------------------------------------------
procedure Log(const EventType: TEventType; const Msg: string);
begin
  MainLog.Log(EventType, UTF8ToSys(Msg));
end;
//---------------------------------------------------------------------------
procedure Log(const EventType: TEventType; const Fmt: string; Args: array of const);
begin
  MainLog.Log(EventType, UTF8ToSys(Fmt), Args);
end;
//---------------------------------------------------------------------------
procedure Log(const Msg: string);
begin
  MainLog.Log(UTF8ToSys(Msg));
end;
//---------------------------------------------------------------------------
procedure Log(const Fmt: string; Args: array of const);
begin
  MainLog.Log(UTF8ToSys(Fmt), Args);
end;
//---------------------------------------------------------------------------
procedure Info(const Msg: string);
begin
  MainLog.Info(UTF8ToSys(Msg));
end;
//---------------------------------------------------------------------------
procedure Info(const Fmt: string; Args: array of const);
begin
  MainLog.Info(UTF8ToSys(Fmt), Args);
end;
//---------------------------------------------------------------------------
procedure Debug(const Msg: string);
begin
  MainLog.Debug(UTF8ToSys(Msg));
end;
//---------------------------------------------------------------------------
procedure Debug(const Fmt: string; Args: array of const);
begin
  MainLog.Debug(UTF8ToSys(Fmt), Args);
end;
//---------------------------------------------------------------------------
procedure Error(const Msg: string);
begin
  MainLog.Error(Msg);
end;
//---------------------------------------------------------------------------
procedure Error(const Fmt: string; args: array of const);
begin
  MainLog.Error(Fmt, args);
end;
//---------------------------------------------------------------------------
procedure Fatal(const Msg: string);
begin
  MainLog.Fatal(Msg);
end;
//---------------------------------------------------------------------------
procedure Fatal(const Fmt: string; args: array of const);
begin
  MainLog.Fatal(Fmt, args);
end;
//---------------------------------------------------------------------------
procedure LogException(const E: Exception);
begin
  {$IFNDEF LOGGING_OFF}
  MainLog.LogException(E);
  {$ENDIF}
end;
//---------------------------------------------------------------------------
procedure LogException(const add_info: string);
begin
  {$IFNDEF LOGGING_OFF}
  MainLog.LogException(add_info);
  {$ENDIF}
end;
//---------------------------------------------------------------------------
initialization
  MainLogVar := nil;
end.

