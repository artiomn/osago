unit common_functions;

//
// Функции, используемые в нескольких модулях.
//

{$I settings.inc}

interface

uses SysUtils, Controls, StdCtrls, ExtCtrls, Graphics, db, MyAccess,
     Classes, strings_l10n, common_consts, Dialogs, Grids,
     FileUtil, Forms, contnrs, logger
     {$IFDEF WINDOWS}, windows
     {$ELSE IF UNIX}, unix
     {$ENDIF};
//---------------------------------------------------------------------------
type

TStringObject = class(TObject)
// Класс, инкапсулирующий строку. Исключает проблемы с приведением типов,
// непереносимостью указателей и подсчётом ссылок на строки.
private
  FStringValue: string;
public
  constructor Create(const s: string);
  constructor Create(Source: TStringObject);
  procedure Assign(Source: TStringObject); virtual;
  property StringValue: string read FStringValue write FStringValue;
end;
//---------------------------------------------------------------------------
TDBListFiler = class(TObject)
// Содержит метод, заполняющий ComboBox'ы из БД.
// В качестве Items.Objects метод устанавливает динамически созданную строку,
// взятую из заданного поля. Класс организует создание строки и очистку памяти.
private
  // Список инициализированных TComboBox
  cbs: TList;
private
  // Очищает заполенный массив, удаляя созданные динамически строки
  procedure ClearStringLists(cb: array of TCustomComboBox);
  // Добавляет ComboBox в список, если он ещё не был туда занесён
  procedure AddCbToList(cb: array of TCustomComboBox);
public
  // Заполняет массив ComboBox'ов значениями из БД (плюс Items.Objects)
  procedure FillListFromDB(const id_field, display_field: string;
    query: TCustomMyDataSet; cb: array of TCustomComboBox);
  // Очищает ComboBox
  procedure ClearCb(cb: TCustomComboBox; del_from_list: boolean = true);
  constructor Create;
  destructor Destroy; override;
end;
//---------------------------------------------------------------------------
TIndexedStringList = class(TObject)
private
  // Пригодился код из oldcode.pas :-)
  // Здесь лучше инкапсулировать TList, чем наследовать от него.
  // Выше управляемость.
  FStrings: TList;
  FItemIndex: integer;
private
  function DoCompareText(const s1, s2: string): PtrInt;
  function GetCount(): integer;
  function GetValue(const index: integer): string;
  procedure SetValue(const index: integer; const value: string);
  procedure SetIndex(const index: integer);
public
  constructor Create;
  destructor Destroy; override;
  procedure Assign(const source: TIndexedStringList);
  function IndexOfValue(const value: string): integer;
  function GetCurItem: string;
  procedure Clear();
  procedure Add(const value: string);
  procedure Delete(index: integer);
public
  property Count: Integer read GetCount;
  property ItemIndex: integer read FItemIndex write SetIndex;
  property Values[const index: integer]: string read GetValue write SetValue; default;
end;
//---------------------------------------------------------------------------
TControlHighlighter = class(TObject)
// Подсветка контрола.
private
  FTimer: TTimer;
  FControl: TControl;
  FHlColor: TColor;
  FOldColor: TColor;
  FAutoFocus: boolean;
private
  procedure OnTimer(Sender: TObject);
  procedure OnStopTimer(Sender: TObject);
private
  function GetInterval(): word;
  procedure SetInterval(const cinterval: word);
public
  constructor Create(const cinterval: word);
  destructor Destroy;
public
  procedure Highlight(); overload;
  procedure Highlight(const ccolor: TColor); overload;
  procedure Highlight(ccontrol: TControl); overload;
  procedure Highlight(ccontrol: TControl; const ccolor: TColor); overload;

  property AutoFocus: boolean read FAutoFocus write FAutoFocus;
  property Control: TControl read FControl write FControl;
  property Interval: word read GetInterval write SetInterval;
  property HlColor: TColor read FHlColor write FHlColor;
end;

//---------------------------------------------------------------------------
// Функции
//---------------------------------------------------------------------------

// Включает/отключает контролы.
procedure SwitchControls(const Parent: TWinControl; enabled: boolean;
   const WithChilds: boolean = true);
// Очищает свойство Text у всех объектов класса TEdit на родителе.
// Если установлен WithChildGbs, то и на его потомках класса TGroupBox.
procedure ClearEdits(const Parent: TWinControl;
   const WithChildGbs: boolean = true);
// Сортирует TStringGrid.
procedure GridSort(StrGrid: TStringGrid; const NoColumn: Integer);
// Убирает концевые разделители
function TrimDelim(const S, delimiter: widestring): widestring;
// Разделяет строку вида: 'строка'число на строку в nm и число в value
procedure SeparateStrDigit(const s: string; out nm, value: string);
// Преобразует любой тип в тип string
function ToString(const Value: Variant): String;
// Variant в boolean. Null - тоже false.
function VarToBool(const value: variant): boolean;
// Строку в variant. Если строка пустаявозвращает Null.
function StrToVar(const value: string): variant;
// Понятно, что она возвращает.
function GetFileDateTime(const FileName: string): TDateTime;
// Устанавливает ItemInex в списке по значению строки в массиве Objects
procedure SetIndexFromObject(const cb: TComboBox; const value: string);
// В зависимости от того юр. или физ. лицо клиент, устанавливает состояние
// данных элементов управления (название, видимость и т.д.)
procedure ListClientTypeGroup(const group: integer;
  const labelSurname, labelName, labelPathronimyc: TLabel;
  const edPathronimyc: TEdit);
// Устанавливает индекс внутри переданного контейнера, на запись,
// соответствующую переданному ID. Если такой нет, возвращает ложь.
function SetContainerIndex(const data_container: TCustomMyDataSet;
  const key_f, value: string): boolean;
// Открывает URL в браузере по умолчанию.
function OpenURL(const aURL: string): Boolean;
//---------------------------------------------------------------------------
// Функции получают строку из ComboBox и устанавливают строку в ComboBox.
function GetCBoxStr(cb: TCustomComboBox; const index: integer): string;
procedure SetCBoxStr(cb: TCustomComboBox; const index: integer;
  const s: string);
procedure AddCBoxStr(cb: TCustomComboBox; const display_label, s: string);
function IndexOfStrObject(cb: TCustomComboBox; const s: string): integer;
function IndexOfStrObject(cb: TCustomComboBox; so: TStringObject): integer;
//---------------------------------------------------------------------------
// Подсветка контрола.
procedure HighligthControl(control: TControl; const color: TColor = clAlert);
//---------------------------------------------------------------------------
procedure MinInTray();
//---------------------------------------------------------------------------
var DBListFiler: TDBListFiler;
    Highligther: TControlHighlighter;
//---------------------------------------------------------------------------
implementation
//---------------------------------------------------------------------------
var vis_forms_list: TList;
//---------------------------------------------------------------------------
procedure SwitchControls(const Parent: TWinControl; enabled: boolean;
   const WithChilds: boolean = true);

  procedure DisableControlsInControl(const ctrl: TWinControl);
  var i: integer;
  begin
    for i := 0 to ctrl.ControlCount - 1 do
      ctrl.Controls[i].Enabled := enabled;
  end;

var i: integer;
begin
  DisableControlsInControl(Parent);
  if (WithChilds) then
    for i := 0 to Parent.ControlCount - 1 do
      if (Parent.Controls[i] is TWinControl) then
        begin
          if ((Parent.Controls[i] as TWinControl).ControlCount > 0) then;
            SwitchControls((Parent.Controls[i] as TWinControl), enabled, true);
        end;
end;
//---------------------------------------------------------------------------
procedure ClearEdits(const Parent: TWinControl; const WithChildGbs: boolean);

  procedure ClearEditsInControl(const ctrl: TWinControl);
  var i: integer;
  begin
    for i := 0 to ctrl.ControlCount - 1 do
      if (ctrl.Controls[i].ClassType = TEdit) then
         TEdit(ctrl.Controls[i]).Clear;
  end;

var i: integer;
begin
  ClearEditsInControl(Parent);
  if (WithChildGbs) then
    for i := 0 to Parent.ControlCount - 1
      do
        if (Parent.Controls[i].ClassName = 'TGroupBox') then
          ClearEditsInControl(Parent.Controls[i] as TWinControl);
end;
//---------------------------------------------------------------------------
procedure GridSort(StrGrid: TStringGrid; const NoColumn: Integer);
var Line, PosActual: Integer;
    Row: TStrings;
begin
//  Renglon := TStringList.Create;
  for Line := 1 to StrGrid.RowCount-1 do
  begin
    Row := StrGrid.Rows[Line];
    PosActual := Line;
    Row.Assign(TStringlist(StrGrid.Rows[PosActual]));
    while (true) do
    begin
      if (PosActual = 0) or (StrToInt(Row.Strings[NoColumn-1]) >=
          StrToInt(StrGrid.Cells[NoColumn-1, PosActual-1])) then
        Break;
      StrGrid.Rows[PosActual] := StrGrid.Rows[PosActual-1];
      Dec(PosActual);
    end;
    if StrToInt(Row.Strings[NoColumn-1]) <
      StrToInt(StrGrid.Cells[NoColumn-1, PosActual]) then
        StrGrid.Rows[PosActual] := Row;
  end;
//  Renglon.Free;
end;
//---------------------------------------------------------------------------
function TrimDelim(const S, delimiter: widestring): widestring;
var
  Ofs, Len: sizeint;
begin
  len := Length(S);
  while (Len > 0) and (S[Len] <= delimiter) do Dec(Len);
        Ofs := 1;
        while (Ofs <= Len) and (S[Ofs] <= delimiter) do Inc(Ofs);

  result := Copy(S, Ofs, 1 + Len - Ofs);
end;
//---------------------------------------------------------------------------
procedure SeparateStrDigit(const s: string; out nm, value: string);
var i, l: integer;
begin
  l := length(s);
  for i := 1 to l do
    if (s[i] in ['0'..'9']) then
      begin
        nm    := copy(s, 1, i - 1);
        value := copy(s, i, l);
        exit;
      end;
  nm    := s;
  value := EmptyStr;
end;
//---------------------------------------------------------------------------
function ToString(const Value: Variant): String;
begin
  case TVarData(Value).VType of
    varSmallInt,
    varInteger   : Result := IntToStr(Value);
    varSingle,
    varDouble,
    varCurrency  : Result := FloatToStr(Value);
    varDate      : Result := FormatDateTime('dd.mm.yyyy', Value);
    varBoolean   : if Value then Result := 'T' else Result := 'F';
    varString    : Result := Value;
    else            Result := '';
  end;
end;
//---------------------------------------------------------------------------
function VarToBool(const value: variant): boolean;
begin
  if (value = Null) then Result := false
  else Result := boolean(value);
end;
//---------------------------------------------------------------------------
function StrToVar(const value: string): variant;
begin
  if (value = EmptyStr) then Result := Null
  else Result := value;
end;
//---------------------------------------------------------------------------
function GetFileDateTime(const FileName: string): TDateTime;
var
  intFileAge: LongInt;
begin
  intFileAge := FileAgeUTF8(FileName);
  if (intFileAge = -1) then
    Result := 0
  else
    Result := FileDateToDateTime(intFileAge)
end;
//---------------------------------------------------------------------------
procedure SetIndexFromObject(const cb: TComboBox; const value: string);
var i: integer;
begin
  with cb do
    begin
      for i := 0 to Items.Count - 1 do
        if (GetCBoxStr(cb, i) = value) then
          begin
            ItemIndex := i;
            exit;
          end;
      ItemIndex := -1;
    end;
end;
//---------------------------------------------------------------------------
procedure ListClientTypeGroup(const group: integer;
  const labelSurname, labelName, labelPathronimyc: TLabel;
  const edPathronimyc: TEdit);
begin
  // 1 - физ лицо, 2 - юр. лицо
  if (group = ind_person) then
    begin
      labelSurname.Caption      := SysToUTF8(cls_surname) + ':';
      labelName.Caption         := SysToUTF8(cls_name) + ':';
      labelPathronimyc.Visible  := true;
      edPathronimyc.Visible     := true;
    end
  else
    begin
      labelSurname.Caption      := SysToUTF8(cls_title) + ':';
      labelName.Caption         := SysToUTF8(cls_inn) + ':';
      labelPathronimyc.Visible  := false;
      edPathronimyc.Visible     := false;
    end;
end;
//---------------------------------------------------------------------------
function SetContainerIndex(const data_container: TCustomMyDataSet;
  const key_f, value: string): boolean;
var
   bmPos: TBookMark;
   bFound: Boolean;
begin
  result := false;
  // Поиск
  if (data_container = nil) then exit;
  with data_container do
    begin
      // if (FieldDefs.IndexOf(key_f) < 0) then exit;
      // Проверяю текущий ключ
      if (FieldByName(key_f).AsString = value) then
        begin
          result := true;
          exit;
        end;
      // Не равен. Ищу и устанавливаю.
      bFound := false;
      if (not Active) then Open();
      bmPos := GetBookmark();
      DisableControls();
      First();
      while (not EOF) do
        if (FieldByName(key_f).AsString = value) then
          begin
            result := true;
            bFound := true;
            break;
          end
        else Next();
     if (not bFound) then GotoBookMark(bmPos);
     FreeBookMark(bmPos);
     EnableControls;
  end;
end;
//---------------------------------------------------------------------------
function OpenURL(const aURL: string): Boolean;
{$IFDEF UNIX}
var
  Helper: string;
{$ENDIF}
begin
  Result := True;

  {$IFDEF WINDOWS}
  try
    ShellExecute(0, 'open', PChar(aURL), nil, nil, 0) ;
  except
    LogException();
    Result := false;
  end;
  {$ENDIF}

  //{$IFDEF LINUX}

  {$IFDEF UNIX}
  Helper := '';

  try
    if fpsystem('which xdg-open') = 0 then
      Helper := 'xdg-open'
    else if (FileExists('/etc/alternatives/x-www-browser')) then
      Helper := '/etc/alternatives/x-www-browser'
    else if (fpsystem('which firefox') = 0) then
      Helper := 'firefox'
    else if (fpsystem('which konqueror') = 0) then
      Helper := 'konqueror'
    else if (fpsystem('which opera') = 0) then
      Helper := 'opera'
    else if (fpsystem('which mozilla') = 0) then
       Helper := 'mozilla'
    else if (fpsystem('which safari') = 0) then
       Helper := 'safari'
    else if (fpsystem('which links') = 0) then
       Helper := 'links'
    else if (fpsystem('which lynx') = 0) then
       Helper := 'lynx';

    if (Helper <> '') then
      fpSystem(Helper + ' ' + aURL + '&')
    else
      Result := false;
  except
    LogException();
    Result := false;
  end;
  {$ENDIF}
end;
//---------------------------------------------------------------------------
function GetCBoxStr(cb: TCustomComboBox; const index: integer): string;
begin
  Result := EmptyStr;
  if ((cb = nil) or (index < 0) or (index >= cb.Items.Count))then exit;
  Result := (cb.Items.Objects[index] as TStringObject).StringValue;
end;
//---------------------------------------------------------------------------
procedure SetCBoxStr(cb: TCustomComboBox; const index: integer;
  const s: string);
begin
  if (cb = nil) then exit;
  (cb.Items.Objects[index] as TStringObject).StringValue := s;
end;
//---------------------------------------------------------------------------
procedure AddCBoxStr(cb: TCustomComboBox; const display_label, s: string);
begin
  if (cb = nil) then exit;
  cb.Items.AddObject(display_label, TStringObject.Create(s));
end;
//---------------------------------------------------------------------------
function IndexOfStrObject(cb: TCustomComboBox; const s: string): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to cb.Items.Count - 1
    do
      if ((cb.Items.Objects[i] as TStringObject).StringValue = s) then
        begin
          Result := i;
          break;
        end;
end;
//---------------------------------------------------------------------------
function IndexOfStrObject(cb: TCustomComboBox; so: TStringObject): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to cb.Items.Count - 1
    do
      if ((cb.Items.Objects[i] as TStringObject).StringValue = so.StringValue)
        then
          begin
            Result := i;
            break;
          end;

end;
//---------------------------------------------------------------------------
procedure HighligthControl(control: TControl; const color: TColor);
begin
  if (Highligther = nil) then
    Highligther := TControlHighlighter.Create(hl_interval);

  Highligther.Highlight(control, color)
end;
//---------------------------------------------------------------------------
procedure MinInTray();
type
  TFormState = record
    form: TForm;
    is_modal: boolean;
    tb_show: TShowInTaskbar;
  end;
  PFormState = ^TFormState;

var i: integer;
    fs: PFormState;

begin
  if (vis_forms_list = nil) then vis_forms_list := TList.Create;

  if (Application.MainForm.Visible) then
    begin
      for i := 0 to vis_forms_list.Count - 1 do
        Dispose(PFormState(vis_forms_list[i]));
      vis_forms_list.Clear();
      // Скрываю.
      for i := 0 to Screen.FormCount - 1 do
        begin
          if (not Screen.Forms[i].Visible) then continue;

          new(fs);
          with fs^ do
            begin
              try
                form := Screen.Forms[i];
                if (form <> nil) then
                with form do
                  begin
                    is_modal      := fsModal in FormState;
                    tb_show       := ShowInTaskBar;
                  end;
              except
              end;
            end;
          vis_forms_list.Add(fs);
          //Application.ProcessMessages();
      end;

      for i := vis_forms_list.Count - 1 downto 0 do
        with PFormState(vis_forms_list[i])^ do
          begin
            try
              if (form = nil) then continue;
              form.ShowInTaskBar := stNever;
              form.Hide();
            except
            end;
          end;
    end
  else
    begin
      // Показываю.
      if (vis_forms_list = nil) then Application.MainForm.ShowModal()
      else
        begin
          for i := vis_forms_list.Count - 1 downto 0 do
            if (vis_forms_list[i] <> nil) then
              with PFormState(vis_forms_list[i])^ do
                try
                  if (form = nil) then continue;
                  if (is_modal) then form.ShowModal()
                  else form.Show();
                  form.ShowInTaskBar := tb_show;
                  // Application.ProcessMessages;
                except
                end;
        end;
    end;
end;
//===========================================================================
constructor TStringObject.Create(const s: string);
begin
  FStringValue := s;
end;
//---------------------------------------------------------------------------
constructor TStringObject.Create(Source: TStringObject);
begin
  if (not (Source is TStringObject)) then
    raise EInvalidCast.Create('Pointer is not ' + Self.ClassName);
  FStringValue := Source.StringValue;
end;
//---------------------------------------------------------------------------
procedure TStringObject.Assign(Source: TStringObject);
begin
  if (not (Source is TStringObject)) then exit;
  FStringValue := Source.StringValue;
end;
//===========================================================================
constructor TDBListFiler.Create;
begin
  inherited;
  cbs := TList.Create;

end;
//---------------------------------------------------------------------------
destructor TDBListFiler.Destroy;
begin
  // Память, занятая строкой освобождается автоматически.
  // Здесь может быть случай, при закрытии программы, когда ComboBox уже
  // разрушен, а я пытаюсь удалить элементы из Objects. Возникнет RunTime Error.
  while (cbs.Count > 0) do ClearCb(TCustomComboBox(cbs.First), true);
  cbs.Free;
  inherited;
end;
//---------------------------------------------------------------------------
procedure TDBListFiler.ClearStringLists(cb: array of TCustomComboBox);
var i: integer;
begin
  for i := 0 to Length(cb) - 1 do ClearCb(cb[i]);
end;
//---------------------------------------------------------------------------
procedure TDBListFiler.AddCbToList(cb: array of TCustomComboBox);
var i, j: integer;
    // Existence Flag
    ef: boolean;
begin
  for i := 0 to Length(cb) - 1
    do
      begin
        ef := false;
        for j := 0 to cbs.Count - 1 do
          if (TCustomComboBox(cbs[j]) = cb[i]) then
            begin
            // Грёбаный Паскаль!
              ef := true;
              break;
            end;
        if (not ef) then cbs.Add(cb[i]);
      end;
end;
//---------------------------------------------------------------------------
procedure TDBListFiler.ClearCb(cb: TCustomComboBox; del_from_list: boolean);
// del_from_list используется только когда в cb сразу же добавляются элементы.
// Небольшая оптимизация.
// По идее, после очистки, cb всегда должен удаляться из списка.
var i, j: integer;
begin
  for i := 0 to cbs.Count - 1 do
    if (TCustomComboBox(cbs[i]) = cb) then
      begin
        for j := 0 to cb.Items.Count - 1 do
          if (cb.Items.Objects[j] <> nil) then
            begin
              (cb.Items.Objects[j] as TStringObject).Free;
              cb.Items.Objects[j] := nil;
            end;
        cb.Clear;
        if (del_from_list) then cbs.Delete(i);
        break;
      end;
end;
//---------------------------------------------------------------------------
procedure TDBListFiler.FillListFromDB(const id_field, display_field: string;
  query: TCustomMyDataSet; cb: array of TCustomComboBox);
var
    display_label, id: string;
    i, cb_count: integer;
begin
  cb_count := Length(cb);
  try
    for i := 0 to cb_count - 1 do
      begin
        // Вначале очищаю
        ClearCb(cb[i], false);
        cb[i].DoubleBuffered := true;
        cb[i].Items.BeginUpdate();
      end;
  with query do
    begin
      Open();
      First();
      while (not query.EOF) do
        begin
          id              := FieldByName(id_field).AsString;
          display_label   := FieldByName(display_field).AsString;
          // Предыдущий кретин-разработчик сделал поля идентификаторов в
          // нек. таблицах, типа varchar.
          for i := 0 to cb_count - 1 do AddCBoxStr(cb[i], display_label, id);
          Next();
        end;
    end;
  // Затем, добавляю в список.
  // !!!Внимание. Вероятны утечки, при ошибке.
  AddCbToList(cb);

  finally
    for i := 0 to cb_count - 1 do cb[i].Items.EndUpdate();
  end;

  try
    for i := 0 to cb_count - 1 do cb[i].ItemIndex := 0;
  except
    on E: Exception do LogException(E);
  end;
end;
//===========================================================================
constructor TIndexedStringList.Create;
begin
  inherited;
  FStrings   := TList.Create;
  FItemIndex := -1;
end;
//---------------------------------------------------------------------------
destructor TIndexedStringList.Destroy;
begin
  Clear();
  FStrings.Free;
  inherited Destroy;
end;
//---------------------------------------------------------------------------
function TIndexedStringList.GetCount(): integer;
begin
  result := FStrings.Count;
end;
//---------------------------------------------------------------------------
function TIndexedStringList.DoCompareText(const s1, s2: string): PtrInt;
begin
  result := CompareText(s1, s2);
end;
//---------------------------------------------------------------------------
function TIndexedStringList.IndexOfValue(const value: string): integer;
var
  s: string;
begin
  result := 0;
  while (result < FStrings.Count) do
    begin
      s  := TStringObject(FStrings[result]).StringValue;
      if (DoCompareText(value, s) = 0) then exit;
      inc(result);
    end;
  result := -1;
end;
//---------------------------------------------------------------------------
function TIndexedStringList.GetValue(const index: integer): string;
begin
  result := EmptyStr;
  if ((index >= FStrings.Count) or (index < 0)) then exit;
  result := TStringObject(FStrings.Items[index]).StringValue;
end;
//---------------------------------------------------------------------------
procedure TIndexedStringList.SetValue(const index: integer; const value: string);
begin
  if ((index >= FStrings.Count) or (index = -1)) then
    begin
      FStrings.Add(TStringObject.Create(value));
    end
  else
    begin
      TStringObject(FStrings[index]).Free;
      if (value = EmptyStr) then FStrings.Delete(index)
      else FStrings[index] := TStringObject.Create(value);
    end;
end;
//---------------------------------------------------------------------------
procedure TIndexedStringList.Clear();
var i: longint;
begin
  if (FStrings.Count = 0) then exit;
  for i := 0 to FStrings.Count - 1 do
    begin
      TStringObject(FStrings[i]).Free;
    end;
  FStrings.Clear();
  FStrings.Capacity := 0;
end;
//---------------------------------------------------------------------------
procedure TIndexedStringList.Delete(index: integer);
begin
  if ((index < 0) or (index >= FStrings.Count)) then exit;
  TStringObject(FStrings[index]).Free;
  FStrings.Delete(index);
end;
//---------------------------------------------------------------------------
procedure TIndexedStringList.SetIndex(const index: integer);
begin
  if (index = FItemIndex) then exit;
  if (index < 0) then FItemIndex := -1
  else if (index >= FStrings.Count) then FItemIndex := FStrings.Count - 1
  else FItemIndex := index;
end;
//---------------------------------------------------------------------------
function TIndexedStringList.GetCurItem: string;
begin
  result := GetValue(FItemIndex);
end;
//---------------------------------------------------------------------------
procedure TIndexedStringList.Assign(const source: TIndexedStringList);
var i: integer;
begin
  if (not (source is TIndexedStringList)) then exit;
  Clear();
  FStrings.Assign(source.FStrings);
  // Список только копирует указатели, а мне нужно скопировать объекты
  for i := 0 to FStrings.Count - 1
    do
      FStrings[i] := TStringObject.Create(TStringObject(source.FStrings[i]));
  FItemIndex := source.FItemIndex;
end;
//---------------------------------------------------------------------------
procedure TIndexedStringList.Add(const value: string);
begin
  FStrings.Add(TStringObject.Create(value));
end;
//===========================================================================
constructor TControlHighlighter.Create(const cinterval: word);
begin
  FTimer              := TTimer.Create(nil);
  FTimer.Enabled      := false;
  FTimer.Interval     := cinterval;
  FTimer.OnTimer      := @OnTimer;
  FTimer.OnStopTimer  := @OnStopTimer;
  FHlColor            := clAlert;
  FAutoFocus          := true;
end;
//---------------------------------------------------------------------------
destructor TControlHighlighter.Destroy;
begin
  FTimer.Free;
end;
//---------------------------------------------------------------------------
procedure TControlHighlighter.OnTimer(Sender: TObject);
begin
//  FControl.Color  := FOldColor;
  FTimer.Enabled  := false;
end;
//---------------------------------------------------------------------------
procedure TControlHighlighter.OnStopTimer(Sender: TObject);
begin
  FControl.Color := FOldColor;
end;
//---------------------------------------------------------------------------
function TControlHighlighter.GetInterval(): word;
begin
  Result := FTimer.Interval;
end;
//---------------------------------------------------------------------------
procedure TControlHighlighter.SetInterval(const cinterval: word);
begin
  // Проверка в таймере.
  FTimer.Interval := cinterval;
end;
//---------------------------------------------------------------------------
procedure TControlHighlighter.Highlight();
begin
  if (not FTimer.Enabled) then FOldColor := FControl.Color;
  FTimer.Enabled  := false;
  FControl.Color  := FHlColor;
  if (FAutoFocus and (FControl is TWinControl)) then
    TWinControl(FControl).SetFocus();
  FTimer.Enabled  := true;
end;
//---------------------------------------------------------------------------
procedure TControlHighlighter.Highlight(const ccolor: TColor);
begin
  FHlColor := ccolor;
  Highlight();
end;
//---------------------------------------------------------------------------
procedure TControlHighlighter.Highlight(ccontrol: TControl);
begin
  FControl := ccontrol;
  Highlight();
end;
//---------------------------------------------------------------------------
procedure TControlHighlighter.Highlight(ccontrol: TControl;
  const ccolor: TColor);
begin
  FHlColor        := ccolor;
  FControl        := ccontrol;
  Highlight();
end;
//===========================================================================
initialization
  DBListFiler     := TDBListFiler.Create;
  Highligther     := nil;
  vis_forms_list  := nil;
//---------------------------------------------------------------------------
finalization
  DBListFiler.Free;
  Highligther.Free;
  if (vis_forms_list <> nil) then
  while (vis_forms_list.Count > 0) do
    begin
//      Dispose(PFormState(vis_forms_list[0]));
      vis_forms_list.Delete(0);
    end;
  vis_forms_list.Free;
//---------------------------------------------------------------------------
end.
