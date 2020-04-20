unit info_manager;

//
// Модуль, реализующий менеджер справочников.
//

{$I settings.inc}

interface

uses
  SysUtils, Types, Classes, Variants, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DBCtrls, Grids, DBGrids,
  Buttons, db, strings_l10n, data_unit, data_coefs, LResources,
  update_dispatcher, orm_user;

type

  { TfrmInfoManager }

  TfrmInfoManager = class(TForm)
    cbCatalogs: TComboBox;
    dbgridCatalog: TDBGrid;
    dbnavCatalog: TDBNavigator;
    gbCatalog: TGroupBox;
    Label1: TLabel;
    pnMain: TPanel;
    pnHead: TPanel;
    sbarMain: TStatusBar;
    pnBottom: TPanel;
    sbtnCancel: TSpeedButton;
    procedure cbCatalogsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbtnPanelClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure InfoWasUpdated(const table_name: string;
      const user_updater: string); virtual;
  end;

var
  frmInfoManager: TfrmInfoManager;

implementation

//---------------------------------------------------------------------------
procedure TfrmInfoManager.sbtnPanelClick(Sender: TObject);
begin
   Close();
end;
//---------------------------------------------------------------------------
procedure TfrmInfoManager.FormCreate(Sender: TObject);
begin
  with dmData, dmCoefs, cbCatalogs do begin
    // Названия страховых компаний.
    AddItem(AnsiToUTF8(info_mgr_tblnm_icmps), datasrcIns_company);
    // Страны.
    AddItem(AnsiToUTF8(info_mgr_tblnm_cntrs), datasrcCountries);
    // Регионы.
    AddItem(AnsiToUTF8(info_mgr_tblnm_rgns), datasrcRegiones);
    // Города.
    AddItem(AnsiToUTF8(info_mgr_tblnm_cities), datasrcCities);
    // Социальный статус
    AddItem(AnsiToUTF8(info_mgr_tblnm_socst), datasrcSex);
    // Семейное положение
    AddItem(AnsiToUTF8(info_mgr_tblnm_famst), datasrcFamilyState);
    // Типы клиентов.
    AddItem(AnsiToUTF8(info_mgr_tblnm_clntp), datasrcCT);
    // Тип удостоверения личности
    AddItem(AnsiToUTF8(info_mgr_tblnm_lictp), datasrcTypeDoc);
    // Марка ТС.
    AddItem(AnsiToUTF8(info_mgr_tblnm_carmk), datasrcCarmark);
    // Модель ТС.
    AddItem(AnsiToUTF8(info_mgr_tblnm_carml), datasrcCarmodels);
    // Тип ТС
    AddItem(AnsiToUTF8(info_mgr_tblnm_cartp), datasrcCartype);
    // Цель использования ТС
    AddItem(AnsiToUTF8(info_mgr_tblnm_usetg), datasrcPuproseType);
    // Группы коэффициентов.
    AddItem(AnsiToUTF8(info_mgr_tblnm_csgrp), datasrcGeoGroups);
    // Базовая ставка
    AddItem(AnsiToUTF8(info_mgr_tblnm_basesum), datasrcCBaseSum);
    // Класс страхования (КБМ).
    AddItem(AnsiToUTF8(info_mgr_tblnm_ckbm), datasrcInsuranceClass);
    // Коэф. КВС.
    AddItem(AnsiToUTF8(info_mgr_tblnm_ckvs), datasrcCKVS);
    // Коэф. КМ.
    AddItem(AnsiToUTF8(info_mgr_tblnm_ckm), datasrcCKM);
    // Коэф. КО.
    AddItem(AnsiToUTF8(info_mgr_tblnm_cko), datasrcCKO);
    // Коэф. КП.
    AddItem(AnsiToUTF8(info_mgr_tblnm_ckp), datasrcCKP);
    // Коэф. КС.
    AddItem(AnsiToUTF8(info_mgr_tblnm_cks), datasrcCKS);
    // Коэф. КТ.
    AddItem(AnsiToUTF8(info_mgr_tblnm_ckt), datasrcCKT);
    // Коэффициенты для иностранных граждан.
    AddItem(AnsiToUTF8(info_mgr_tblnm_cfrng), datasrcCsForeing);
    // Другие коэффициенты.
    AddItem(AnsiToUTF8(info_mgr_tblnm_cother), datasrcCOther);
    // Страховые формулы.
    AddItem(AnsiToUTF8(info_mgr_tblnm_iform), datasrcInsFormula);
    // Порядок применения формул.
    AddItem(AnsiToUTF8(info_mgr_tblnm_formc), datasrcInsFormulaConf);
  end;
  cbCatalogs.ItemIndex := 0;
  cbCatalogs.OnChange(cbCatalogs);
end;
//---------------------------------------------------------------------------
procedure TfrmInfoManager.cbCatalogsChange(Sender: TObject);
begin
  with cbCatalogs do
    begin
      dbnavCatalog.DataSource  := Items.Objects[ItemIndex] as TDatasource;
      with dbnavCatalog.DataSource.DataSet do
        if (not Active) then
          begin
            Open();
            dbnavCatalog.DataSource.DataSet.First();
          end;
      dbgridCatalog.DataSource := dbnavCatalog.DataSource;
    end;
end;
//---------------------------------------------------------------------------
procedure TfrmInfoManager.InfoWasUpdated(const table_name: string;
  const user_updater: string);
var i: integer;
begin
  // Выполняю действия только, если менеджер видим.
  if (Visible) then
    begin
      if (user_updater = CurrentUser.User) then exit;
      for i := 0 to cbCatalogs.Items.Count - 1 do
        begin
          with (cbCatalogs.Items.Objects[i] as TDataSource) do
            DataSet.Close;
        end;
      dbgridCatalog.DataSource.DataSet.Open();
    end;
end;
//---------------------------------------------------------------------------
initialization
  {$i info_manager.lrs}

end.
