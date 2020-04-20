program osago_new;

{$I settings.inc}

uses
{$ifdef unix}
  cthreads,
  cmem,
{$endif}
  Forms, Controls, LResources,
  Interfaces, Dialogs,
  logger,
  main_unit in 'main_unit.pas' {frmMain},
  data_unit in 'data_unit.pas' {dmData: TDataModule},
  data_coefs in 'data_coefs.pas',
  car_manager in 'car_manager.pas' {frmCarManager},
  client_manager in 'client_manager.pas' {frmClientManager},
  strings_l10n in 'strings_l10n.pas',
  common_list_filer, common_consts,
  waiter_unit, common_functions, reports_unit,
  blank_contracts, phone_input, orm_abstract, orm_car, orm_client, orm_contract,
  orm_infos_inscompany, orm_user, orm_group, update_dispatcher,
  login_unit;

{$IFDEF WINDOWS}{$R osago_new.rc}{$ENDIF}

begin
  {$I osago_new.lrs}
  Application.Title := AnsiToUtf8('Страхование Автогражданской ответственности');
  Application.OnException := @MainLog.OnExceptionLog;
  Debug('Initializing...');
  Application.Initialize;
  Debug('Creating dmData.');
  Application.CreateForm(TdmData, dmData);
  Debug('Creating dmCoefs.');
  Application.CreateForm(TdmCoefs, dmCoefs);
  Debug('Creating dmReports.');
  Application.CreateForm(TdmReports, dmReports);
  frmLogin  := nil;
  Debug('Creating Login form.');
  frmLogin  := TfrmLogin.Create(nil);
  try
  if (frmLogin.ShowModal() = mrCancel) then
    begin
      Application.Terminate();
    end
  else
    begin
      with frmLogin do
        dmData.SetConnectionParams(edHostName.Text, edPort.Text,
        edDBName.Text, edLogin.Text, edPassword.Text);
      dmData.myconnMain.Connect();
      GroupsCollection  := TEntityesCollection.Create(TGroupEntity);
      LoadGroups();
      CurrentUser             := TUserEntity.Create(nil);
      CurrentUser.DataSource  := dmData.GetCurUserInfo();
      if (not CurrentUser.DB_Load()) then exit;
      Debug('Creating main form.');
      Application.CreateForm(TfrmMain, frmMain);
      // Application.CreateForm(TfrmWaiter, frmWaiter);
      Debug('Creating client manager.');
      Application.CreateForm(TfrmClientManager, frmClientManager);
      Debug('Creating car manager.');
      Application.CreateForm(TfrmCarManager, frmCarManager);
      Debug('Creating frmBlankContracts.');
      Application.CreateForm(TfrmBlankContracts, frmBlankContracts);
      Debug('Creating frmInputPhone.');
      // Нельзя создавать с пом. CreateForm. Иначе попадёт в Screen.Forms.
      // При сворачивании в трэй, она исчезает, когда происходит потеря фокуса.
      // Но Visible остаётся true. При восстановлении -
      // исключение "невозможно установить фокус" (т.к. формы нет).
      frmInputPhone := TfrmInputPhone.Create(frmMain);
      Debug('List filling.');
      CommonListFiler.FillAllLists();
   end;
  finally
    frmLogin.Free;
    frmLogin := nil;
  end;
  Debug('Run...');
  if (not Application.Terminated) then Application.Run;
  frmInputPhone.Free;
  Debug('Terminated...');
  DestroyLog();
end.
