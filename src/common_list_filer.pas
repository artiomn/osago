unit common_list_filer;

//
// Класс, заполняющий списки из базы.
//

// Заполняет списки, при запуске программы, чтобы ускорить загрузку.
// Также используется для перезаполнения списков, после изменения справочников.

{$I settings.inc}

interface

uses
  Classes, SysUtils,
  common_functions, data_unit, data_coefs,
  client_manager, car_manager, contracts_input, main_unit;

type TCommonListFiler = class(TObject)
private

public
  procedure FillClientTypeGroupLists();
  procedure FillClientTypeLists();
  procedure FillDocTypeLists();
  procedure FillSocialStateLists();
  procedure FillFamilyStateLists();
  procedure FillBonusMalusLists();
  procedure FillCarTypeLists();
  procedure FillCarPurposeLists();
  procedure FillCarMarkLists();
  procedure FillCountriesList();
public
  procedure FillAllLists();
end;
//---------------------------------------------------------------------------
var CommonListFiler: TCommonListFiler;

implementation
//---------------------------------------------------------------------------
procedure TCommonListFiler.FillClientTypeGroupLists();
begin
  DBListFiler.FillListFromDB('ID_CLIENT_TYPE_GROUP', 'CLIENT_TYPE_GROUP',
    dmData.myClientTypeGroup,
    [
      frmClientManager.cbSClientTypeGroup,
      frmCarManager.cbSClientTypeGroup,
      frmMain.cbSClientTypeGroup
    ]
  );
end;
//---------------------------------------------------------------------------
procedure  TCommonListFiler.FillClientTypeLists();
begin
  DBListFiler.FillListFromDB('ID_CLIENT_TYPE', 'CLIENT_TYPE',
    dmData.myClientTypes,
    [
      frmClientManager.cbClientType
    ]
  );
end;
//---------------------------------------------------------------------------
procedure TCommonListFiler.FillDocTypeLists();
begin
  DBListFiler.FillListFromDB('ID_TYPE_DOC', 'DOC_TYPE',
    dmData.myDocTypes,
    [
      frmClientManager.cbSDocType,
      frmClientManager.cbDocType,
      frmMain.cbSDocType
    ]
  );
end;
//---------------------------------------------------------------------------
procedure TCommonListFiler.FillSocialStateLists();
begin
  DBListFiler.FillListFromDB('ID_SEX', 'SEX_NAME',
    dmData.mySex,
    [frmClientManager.cbSocialState]
  );
end;
//---------------------------------------------------------------------------
procedure TCommonListFiler.FillFamilyStateLists();
begin
  DBListFiler.FillListFromDB('ID_FAMILY_STATE', 'FAMILY_STATE_NAME',
    dmData.myFamilyState, [frmClientManager.cbFamilyState]);
end;
//---------------------------------------------------------------------------
procedure TCommonListFiler.FillBonusMalusLists();
begin
  DBListFiler.FillListFromDB('ID_INSURANCE_CLASS', 'INSURANCE_CLASS',
    dmCoefs.myGetInsCoef_KBM,
    [
      frmMain.cbBonusMalus,
      frmClientManager.cbBonusMalus
    ]
 );
end;
//---------------------------------------------------------------------------
procedure TCommonListFiler.FillCarTypeLists();
begin
  DBListFiler.FillListFromDB('ID_CAR_TYPE', 'CAR_TYPE',
    dmData.myCarType, [frmCarManager.cbCarType]);
end;
//---------------------------------------------------------------------------
procedure TCommonListFiler.FillCarPurposeLists();
begin
  DBListFiler.FillListFromDB('ID_PURPOSE_TYPE', 'PURPOSE_TYPE',
    dmData.myPurposeType, [frmCarManager.cbPurposeType]);
end;
//---------------------------------------------------------------------------
procedure TCommonListFiler.FillCarMarkLists();
begin
  DBListFiler.FillListFromDB('ID_CARMARK', 'MARK',
    dmData.myCarMark, [frmCarManager.cbCarMark]);
end;
//---------------------------------------------------------------------------
procedure TCommonListFiler.FillCountriesList();
begin
  DBListFiler.FillListFromDB('ID_COUNTRY', 'NAME',
    dmData.myCountries, [frmClientManager.cbCountry]);
end;
//---------------------------------------------------------------------------
procedure TCommonListFiler.FillAllLists();
begin
  FillClientTypeGroupLists();
  FillClientTypeLists();
  FillDocTypeLists();
  FillSocialStateLists();
  FillFamilyStateLists();
  FillBonusMalusLists();
  FillCarTypeLists();
  FillCarPurposeLists();
  FillCarMarkLists();
  FillCountriesList();
end;
//---------------------------------------------------------------------------
initialization

CommonListFiler := TCommonListFiler.Create;

finalization

CommonListFiler.Free;

end.
