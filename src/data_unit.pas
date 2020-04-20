unit data_unit;

//
// Основной модуль данных.
//

{$I settings.inc}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Dialogs,
  MyAccess, MyBuilderClient, MyDacVcl, ZSysUtils, MemData,
  variants, strings_l10n, common_consts, logger, DBAccess;

type

  TActionType = (atExec, atInsert, atUpdate, atDelete);

  { TdmData }

  TdmData = class(TDataModule)
    datasrcCarmark: TMyDataSource;
    datasrcGeoGroups: TMyDataSource;
    datasrcCurUser: TMyDataSource;
    datasrcCar: TMyDataSource;
    datasrcAllUsers: TMyDataSource;
    datasrcChangeLog: TMyDataSource;
    datasrcAlerter: TMyDataSource;
    datasrcRegiones: TMyDataSource;
    datasrcCT: TMyDataSource;
    datasrcCTG: TMyDataSource;
    datasrcFamilyState: TMyDataSource;
    datasrcCountries: TMyDataSource;
    datasrcCities: TMyDataSource;
    datasrcTypeDoc: TMyDataSource;
    datasrcGroups: TMyDataSource;
    datasrcValuta: TMyDataSource;
    datasrcFreeBlanks: TMyDataSource;
    datasrcIns_company: TMyDataSource;
    datasrcGetBlankData: TMyDataSource;
    datasrcSex: TMyDataSource;
    datasrcMatchedClns: TMyDataSource;
    datasrcClient: TMyDataSource;
    datasrcDriver: TMyDataSource;
    datasrcSearchClient: TMyDataSource;
    datasrcSearchCar: TMyDataSource;
    datasrcContractHistory: TMyDataSource;
    datasrcContract: TMyDataSource;
    datasrcCOH: TMyDataSource;
    datasrcSearchContract: TMyDataSource;
    datasrcPuproseType: TMyDataSource;
    datasrcCarmodels: TMyDataSource;
    myAlerterCAR_ARENDA: TBooleanField;
    myAlerterCAR_CAR_MARK: TStringField;
    myAlerterCAR_CAR_MODEL: TStringField;
    myAlerterCAR_COMMENTS: TStringField;
    myAlerterCAR_DATE_INSERT: TDateField;
    myAlerterCAR_DATE_UPDATE: TDateField;
    myAlerterCAR_FOREING: TBooleanField;
    myAlerterCAR_GOS_NUM: TStringField;
    myAlerterCAR_ID_CAR: TStringField;
    myAlerterCAR_ID_CAR_TYPE: TLongintField;
    myAlerterCAR_ID_CLIENT: TStringField;
    myAlerterCAR_ID_PRODUCTER_TYPE: TFloatField;
    myAlerterCAR_ID_PURPOSE_TYPE: TLongintField;
    myAlerterCAR_KUSOV: TStringField;
    myAlerterCAR_MAX_KG: TFloatField;
    myAlerterCAR_NUM_PLACES: TLongintField;
    myAlerterCAR_POWER_KVT: TFloatField;
    myAlerterCAR_POWER_LS: TFloatField;
    myAlerterCAR_PTS_DATE: TDateField;
    myAlerterCAR_PTS_NO: TStringField;
    myAlerterCAR_PTS_SER: TStringField;
    myAlerterCAR_SHASSI: TStringField;
    myAlerterCAR_USER_INSERT_NAME: TStringField;
    myAlerterCAR_USER_UPDATE_NAME: TStringField;
    myAlerterCAR_VIN_NUM: TStringField;
    myAlerterCAR_YEAR_ISSUE: TLongintField;
    myAlerterCLN_BIRTHDAY: TDateField;
    myAlerterCLN_BUSINESS_PHONE: TStringField;
    myAlerterCLN_CELL_PHONE: TStringField;
    myAlerterCLN_COMMENTS: TStringField;
    myAlerterCLN_DATE_INSERT: TDateField;
    myAlerterCLN_DATE_UPDATE: TDateField;
    myAlerterCLN_DOC_NUM: TStringField;
    myAlerterCLN_DOC_SER: TStringField;
    myAlerterCLN_FLAT: TStringField;
    myAlerterCLN_GROSS_VIOLATIONS: TBooleanField;
    myAlerterCLN_HOME: TStringField;
    myAlerterCLN_HOME_PHONE: TStringField;
    myAlerterCLN_ID_CITY: TLargeintField;
    myAlerterCLN_ID_CLIENT: TStringField;
    myAlerterCLN_ID_CLIENT_TYPE: TLongintField;
    myAlerterCLN_ID_COUNTRY: TLargeintField;
    myAlerterCLN_ID_FAMILY_STATE: TLongintField;
    myAlerterCLN_ID_INSURANCE_CLASS: TLongintField;
    myAlerterCLN_ID_REGION: TLargeintField;
    myAlerterCLN_ID_SEX: TLongintField;
    myAlerterCLN_ID_TYPE_DOC: TLongintField;
    myAlerterCLN_ID_TYPE_LOSSED: TLongintField;
    myAlerterCLN_INN: TStringField;
    myAlerterCLN_KORPUS: TStringField;
    myAlerterCLN_LAST_CALL_DATE: TDateField;
    myAlerterCLN_LICENCE_NO: TStringField;
    myAlerterCLN_LICENCE_SER: TStringField;
    myAlerterCLN_MIDDLENAME: TStringField;
    myAlerterCLN_NAME: TStringField;
    myAlerterCLN_POSTINDEX: TStringField;
    myAlerterCLN_START_DRIVING_DATE: TDateField;
    myAlerterCLN_STREET: TStringField;
    myAlerterCLN_SURNAME: TStringField;
    myAlerterCLN_TOWN: TStringField;
    myAlerterCLN_USER_INSERT_NAME: TStringField;
    myAlerterCLN_USER_UPDATE_NAME: TStringField;
    myAlerterCLN_WRITER_NAME: TStringField;
    myAlerterCNT_BASE_SUM: TFloatField;
    myAlerterCNT_COMMENT: TStringField;
    myAlerterCNT_DATE_BEGIN: TDateField;
    myAlerterCNT_DATE_DOG_CREATE: TDateField;
    myAlerterCNT_DATE_DOG_INPUT: TDateField;
    myAlerterCNT_DATE_END: TDateField;
    myAlerterCNT_DATE_INSERT: TDateField;
    myAlerterCNT_DATE_START: TDateTimeField;
    myAlerterCNT_DATE_UPDATE: TDateField;
    myAlerterCNT_DATE_WRITE: TDateField;
    myAlerterCNT_DOGNUMB: TStringField;
    myAlerterCNT_DOG_SER: TStringField;
    myAlerterCNT_END_USE: TDateField;
    myAlerterCNT_END_USE1: TDateField;
    myAlerterCNT_END_USE2: TDateField;
    myAlerterCNT_ID_CAR: TStringField;
    myAlerterCNT_ID_CLIENT: TStringField;
    myAlerterCNT_ID_DOGOVOR: TStringField;
    myAlerterCNT_ID_DOGOVOR_TYPE: TLongintField;
    myAlerterCNT_ID_INSURANCE_CLASS: TLongintField;
    myAlerterCNT_ID_INSURANCE_COMPANY: TLongintField;
    myAlerterCNT_ID_PREV_DOG: TStringField;
    myAlerterCNT_ID_TERRITORY_USE: TLongintField;
    myAlerterCNT_INS_PREM: TFloatField;
    myAlerterCNT_INS_SUM: TFloatField;
    myAlerterCNT_KOEF_BONUSMALUS: TFloatField;
    myAlerterCNT_KOEF_KN: TFloatField;
    myAlerterCNT_KOEF_PERIOD_USE: TFloatField;
    myAlerterCNT_KOEF_POWER: TFloatField;
    myAlerterCNT_KOEF_SROK_INS: TFloatField;
    myAlerterCNT_KOEF_STAG: TFloatField;
    myAlerterCNT_KOEF_TER: TFloatField;
    myAlerterCNT_KOEF_UNLIMITED: TFloatField;
    myAlerterCNT_START_USE: TDateField;
    myAlerterCNT_START_USE1: TDateField;
    myAlerterCNT_START_USE2: TDateField;
    myAlerterCNT_TICKET_DATE: TDateField;
    myAlerterCNT_TICKET_NUM: TStringField;
    myAlerterCNT_TICKET_SER: TStringField;
    myAlerterCNT_TRANSIT: TBooleanField;
    myAlerterCNT_UNLIMITED_DRIVERS: TBooleanField;
    myAlerterCNT_USER_INSERT_NAME: TStringField;
    myAlerterCNT_USER_UPDATE_NAME: TStringField;
    myAlerterCNT_ZNAK_NO: TStringField;
    myAlerterCNT_ZNAK_SER: TStringField;
    myAlerterFULL_ADDRESS: TStringField;
    myAlerterFULL_MODEL: TStringField;
    myAlerterFULL_NAME: TStringField;
    myAlerterFULL_NUM: TStringField;
    myCar: TMyQuery;
    myCarCAR_ARENDA: TBooleanField;
    myCarCAR_CAR_MARK: TStringField;
    myCarCAR_CAR_MODEL: TStringField;
    myCarCAR_COMMENTS: TStringField;
    myCarCAR_DATE_INSERT: TDateField;
    myCarCAR_DATE_UPDATE: TDateField;
    myCarCAR_FOREING: TBooleanField;
    myCarCAR_GOS_NUM: TStringField;
    myCarCAR_ID_CAR: TStringField;
    myCarCAR_ID_CAR_TYPE: TLongintField;
    myCarCAR_ID_CLIENT: TStringField;
    myCarCAR_ID_PRODUCTER_TYPE: TFloatField;
    myCarCAR_ID_PURPOSE_TYPE: TLongintField;
    myCarCAR_KUSOV: TStringField;
    myCarCAR_MAX_KG: TFloatField;
    myCarCAR_NUM_PLACES: TLongintField;
    myCarCAR_POWER_KVT: TFloatField;
    myCarCAR_POWER_LS: TFloatField;
    myCarCAR_PTS_DATE: TDateField;
    myCarCAR_PTS_NO: TStringField;
    myCarCAR_PTS_SER: TStringField;
    myCarCAR_SHASSI: TStringField;
    myCarCAR_USER_INSERT_NAME: TStringField;
    myCarCAR_USER_UPDATE_NAME: TStringField;
    myCarCAR_VIN_NUM: TStringField;
    myCarCAR_YEAR_ISSUE: TLongintField;
    myCarCLN_BIRTHDAY: TDateField;
    myCarCLN_BUSINESS_PHONE: TStringField;
    myCarCLN_CELL_PHONE: TStringField;
    myCarCLN_COMMENTS: TStringField;
    myCarCLN_DATE_INSERT: TDateField;
    myCarCLN_DATE_UPDATE: TDateField;
    myCarCLN_DOC_NUM: TStringField;
    myCarCLN_DOC_SER: TStringField;
    myCarCLN_FLAT: TStringField;
    myCarCLN_GROSS_VIOLATIONS: TBooleanField;
    myCarCLN_HOME: TStringField;
    myCarCLN_HOME_PHONE: TStringField;
    myCarCLN_ID_CITY: TLargeintField;
    myCarCLN_ID_CLIENT: TStringField;
    myCarCLN_ID_CLIENT_TYPE: TLongintField;
    myCarCLN_ID_COUNTRY: TLargeintField;
    myCarCLN_ID_FAMILY_STATE: TLongintField;
    myCarCLN_ID_INSURANCE_CLASS: TLongintField;
    myCarCLN_ID_REGION: TLargeintField;
    myCarCLN_ID_SEX: TLongintField;
    myCarCLN_ID_TYPE_DOC: TLongintField;
    myCarCLN_ID_TYPE_LOSSED: TLongintField;
    myCarCLN_INN: TStringField;
    myCarCLN_KORPUS: TStringField;
    myCarCLN_LAST_CALL_DATE: TDateField;
    myCarCLN_LICENCE_NO: TStringField;
    myCarCLN_LICENCE_SER: TStringField;
    myCarCLN_MIDDLENAME: TStringField;
    myCarCLN_NAME: TStringField;
    myCarCLN_POSTINDEX: TStringField;
    myCarCLN_START_DRIVING_DATE: TDateField;
    myCarCLN_STREET: TStringField;
    myCarCLN_SURNAME: TStringField;
    myCarCLN_TOWN: TStringField;
    myCarCLN_USER_INSERT_NAME: TStringField;
    myCarCLN_USER_UPDATE_NAME: TStringField;
    myCarCLN_WRITER_NAME: TStringField;
    myCarFULL_DATA: TStringField;
    myCarMark: TMyQuery;
    myCarMarkID_CARMARK1: TLongintField;
    myCarMarkMARK1: TStringField;
    myCarModelsID_CARMARK: TLongintField;
    myCarModelsID_CAR_MODEL: TLargeintField;
    myCarModelsMARK2: TStringField;
    myCarModelsMODEL: TStringField;
    mycAddCntParams: TMyCommand;
    myContractCNT_TICKET_DATE: TDateField;
    myContractCNT_TICKET_NUM: TStringField;
    myContractCNT_TICKET_SER: TStringField;
    myContractHistoryCLN_LAST_CALL_DATE: TDateField;
    myContractHistoryCNT_TICKET_DATE: TDateField;
    myContractHistoryCNT_TICKET_NUM: TStringField;
    myContractHistoryCNT_TICKET_SER: TStringField;
    myContractHistoryFULL_ADDRESS: TStringField;
    myContractHistoryFULL_NAME: TStringField;
    myContractOpersHistoryCLN_LAST_CALL_DATE: TDateField;
    myContractOpersHistoryCNT_TICKET_DATE: TDateField;
    myContractOpersHistoryCNT_TICKET_NUM: TStringField;
    myContractOpersHistoryCNT_TICKET_SER: TStringField;
    myGetCarModels: TMyQuery;
    myCitiesGEO_GROUP: TLongintField;
    myCitiesNAME1_2: TStringField;
    myCitiesNAME1_3: TStringField;
    myCity: TMyQuery;
    myCitiesID_CITY: TLargeintField;
    myCitiesID_COUNTRY: TLargeintField;
    myCitiesID_REGION: TLargeintField;
    myCitiesNAME: TStringField;
    myCitiesNAME1_1: TStringField;
    myClientCLN_LAST_CALL_DATE: TDateField;
    myContractCLN_LAST_CALL_DATE: TDateField;
    myContractHistoryCAR_ARENDA: TBooleanField;
    myContractHistoryCAR_ARENDA1: TBooleanField;
    myContractHistoryCAR_CAR_MARK: TStringField;
    myContractHistoryCAR_CAR_MARK1: TStringField;
    myContractHistoryCAR_CAR_MODEL: TStringField;
    myContractHistoryCAR_CAR_MODEL1: TStringField;
    myContractHistoryCAR_COMMENTS: TStringField;
    myContractHistoryCAR_COMMENTS1: TStringField;
    myContractHistoryCAR_DATE_INSERT: TDateField;
    myContractHistoryCAR_DATE_INSERT1: TDateField;
    myContractHistoryCAR_DATE_UPDATE: TDateField;
    myContractHistoryCAR_DATE_UPDATE1: TDateField;
    myContractHistoryCAR_FOREING: TBooleanField;
    myContractHistoryCAR_FOREING1: TBooleanField;
    myContractHistoryCAR_GOS_NUM: TStringField;
    myContractHistoryCAR_GOS_NUM1: TStringField;
    myContractHistoryCAR_ID_CAR: TStringField;
    myContractHistoryCAR_ID_CAR1: TStringField;
    myContractHistoryCAR_ID_CAR_TYPE: TLongintField;
    myContractHistoryCAR_ID_CAR_TYPE1: TLongintField;
    myContractHistoryCAR_ID_CLIENT: TStringField;
    myContractHistoryCAR_ID_CLIENT1: TStringField;
    myContractHistoryCAR_ID_PRODUCTER_TYPE: TFloatField;
    myContractHistoryCAR_ID_PRODUCTER_TYPE1: TFloatField;
    myContractHistoryCAR_ID_PURPOSE_TYPE: TLongintField;
    myContractHistoryCAR_ID_PURPOSE_TYPE1: TLongintField;
    myContractHistoryCAR_KUSOV: TStringField;
    myContractHistoryCAR_KUSOV1: TStringField;
    myContractHistoryCAR_MAX_KG: TFloatField;
    myContractHistoryCAR_MAX_KG1: TFloatField;
    myContractHistoryCAR_NUM_PLACES: TLongintField;
    myContractHistoryCAR_NUM_PLACES1: TLongintField;
    myContractHistoryCAR_POWER_KVT: TFloatField;
    myContractHistoryCAR_POWER_KVT1: TFloatField;
    myContractHistoryCAR_POWER_LS: TFloatField;
    myContractHistoryCAR_POWER_LS1: TFloatField;
    myContractHistoryCAR_PTS_DATE: TDateField;
    myContractHistoryCAR_PTS_DATE1: TDateField;
    myContractHistoryCAR_PTS_NO: TStringField;
    myContractHistoryCAR_PTS_NO1: TStringField;
    myContractHistoryCAR_PTS_SER: TStringField;
    myContractHistoryCAR_PTS_SER1: TStringField;
    myContractHistoryCAR_SHASSI: TStringField;
    myContractHistoryCAR_SHASSI1: TStringField;
    myContractHistoryCAR_USER_INSERT_NAME: TStringField;
    myContractHistoryCAR_USER_INSERT_NAME1: TStringField;
    myContractHistoryCAR_USER_UPDATE_NAME: TStringField;
    myContractHistoryCAR_USER_UPDATE_NAME1: TStringField;
    myContractHistoryCAR_VIN_NUM: TStringField;
    myContractHistoryCAR_VIN_NUM1: TStringField;
    myContractHistoryCAR_YEAR_ISSUE: TLongintField;
    myContractHistoryCAR_YEAR_ISSUE1: TLongintField;
    myContractHistoryCLN_BIRTHDAY: TDateField;
    myContractHistoryCLN_BIRTHDAY1: TDateField;
    myContractHistoryCLN_BUSINESS_PHONE: TStringField;
    myContractHistoryCLN_BUSINESS_PHONE1: TStringField;
    myContractHistoryCLN_CELL_PHONE: TStringField;
    myContractHistoryCLN_CELL_PHONE1: TStringField;
    myContractHistoryCLN_COMMENTS: TStringField;
    myContractHistoryCLN_COMMENTS1: TStringField;
    myContractHistoryCLN_DATE_INSERT: TDateField;
    myContractHistoryCLN_DATE_INSERT1: TDateField;
    myContractHistoryCLN_DATE_UPDATE: TDateField;
    myContractHistoryCLN_DATE_UPDATE1: TDateField;
    myContractHistoryCLN_DOC_NUM: TStringField;
    myContractHistoryCLN_DOC_NUM1: TStringField;
    myContractHistoryCLN_DOC_SER: TStringField;
    myContractHistoryCLN_DOC_SER1: TStringField;
    myContractHistoryCLN_FLAT: TStringField;
    myContractHistoryCLN_FLAT1: TStringField;
    myContractHistoryCLN_GROSS_VIOLATIONS: TBooleanField;
    myContractHistoryCLN_GROSS_VIOLATIONS1: TBooleanField;
    myContractHistoryCLN_HOME: TStringField;
    myContractHistoryCLN_HOME1: TStringField;
    myContractHistoryCLN_HOME_PHONE: TStringField;
    myContractHistoryCLN_HOME_PHONE1: TStringField;
    myContractHistoryCLN_ID_CITY: TLargeintField;
    myContractHistoryCLN_ID_CITY1: TLargeintField;
    myContractHistoryCLN_ID_CLIENT: TStringField;
    myContractHistoryCLN_ID_CLIENT1: TStringField;
    myContractHistoryCLN_ID_CLIENT_TYPE: TLongintField;
    myContractHistoryCLN_ID_CLIENT_TYPE1: TLongintField;
    myContractHistoryCLN_ID_COUNTRY: TLargeintField;
    myContractHistoryCLN_ID_COUNTRY1: TLargeintField;
    myContractHistoryCLN_ID_FAMILY_STATE: TLongintField;
    myContractHistoryCLN_ID_FAMILY_STATE1: TLongintField;
    myContractHistoryCLN_ID_INSURANCE_CLASS: TLongintField;
    myContractHistoryCLN_ID_INSURANCE_CLASS1: TLongintField;
    myContractHistoryCLN_ID_REGION: TLargeintField;
    myContractHistoryCLN_ID_REGION1: TLargeintField;
    myContractHistoryCLN_ID_SEX: TLongintField;
    myContractHistoryCLN_ID_SEX1: TLongintField;
    myContractHistoryCLN_ID_TYPE_DOC: TLongintField;
    myContractHistoryCLN_ID_TYPE_DOC1: TLongintField;
    myContractHistoryCLN_ID_TYPE_LOSSED: TLongintField;
    myContractHistoryCLN_ID_TYPE_LOSSED1: TLongintField;
    myContractHistoryCLN_INN: TStringField;
    myContractHistoryCLN_INN1: TStringField;
    myContractHistoryCLN_KORPUS: TStringField;
    myContractHistoryCLN_KORPUS1: TStringField;
    myContractHistoryCLN_LICENCE_NO: TStringField;
    myContractHistoryCLN_LICENCE_NO1: TStringField;
    myContractHistoryCLN_LICENCE_SER: TStringField;
    myContractHistoryCLN_LICENCE_SER1: TStringField;
    myContractHistoryCLN_MIDDLENAME: TStringField;
    myContractHistoryCLN_MIDDLENAME1: TStringField;
    myContractHistoryCLN_NAME: TStringField;
    myContractHistoryCLN_NAME1: TStringField;
    myContractHistoryCLN_POSTINDEX: TStringField;
    myContractHistoryCLN_POSTINDEX1: TStringField;
    myContractHistoryCLN_START_DRIVING_DATE: TDateField;
    myContractHistoryCLN_START_DRIVING_DATE1: TDateField;
    myContractHistoryCLN_STREET: TStringField;
    myContractHistoryCLN_STREET1: TStringField;
    myContractHistoryCLN_SURNAME: TStringField;
    myContractHistoryCLN_SURNAME1: TStringField;
    myContractHistoryCLN_TOWN: TStringField;
    myContractHistoryCLN_TOWN1: TStringField;
    myContractHistoryCLN_USER_INSERT_NAME: TStringField;
    myContractHistoryCLN_USER_INSERT_NAME1: TStringField;
    myContractHistoryCLN_USER_UPDATE_NAME: TStringField;
    myContractHistoryCLN_USER_UPDATE_NAME1: TStringField;
    myContractHistoryCLN_WRITER_NAME: TStringField;
    myContractHistoryCLN_WRITER_NAME1: TStringField;
    myContractHistoryCNT_BASE_SUM: TFloatField;
    myContractHistoryCNT_BASE_SUM1: TFloatField;
    myContractHistoryCNT_COMMENT: TStringField;
    myContractHistoryCNT_COMMENT1: TStringField;
    myContractHistoryCNT_DATE_BEGIN: TDateField;
    myContractHistoryCNT_DATE_BEGIN1: TDateField;
    myContractHistoryCNT_DATE_DOG_CREATE: TDateField;
    myContractHistoryCNT_DATE_DOG_CREATE1: TDateField;
    myContractHistoryCNT_DATE_DOG_INPUT: TDateField;
    myContractHistoryCNT_DATE_DOG_INPUT1: TDateField;
    myContractHistoryCNT_DATE_END: TDateField;
    myContractHistoryCNT_DATE_END1: TDateField;
    myContractHistoryCNT_DATE_INSERT: TDateField;
    myContractHistoryCNT_DATE_INSERT1: TDateField;
    myContractHistoryCNT_DATE_START: TDateTimeField;
    myContractHistoryCNT_DATE_START1: TDateTimeField;
    myContractHistoryCNT_DATE_UPDATE: TDateField;
    myContractHistoryCNT_DATE_UPDATE1: TDateField;
    myContractHistoryCNT_DATE_WRITE: TDateField;
    myContractHistoryCNT_DATE_WRITE1: TDateField;
    myContractHistoryCNT_DOGNUMB: TStringField;
    myContractHistoryCNT_DOGNUMB1: TStringField;
    myContractHistoryCNT_DOG_SER: TStringField;
    myContractHistoryCNT_DOG_SER1: TStringField;
    myContractHistoryCNT_END_USE: TDateField;
    myContractHistoryCNT_END_USE1: TDateField;
    myContractHistoryCNT_END_USE2: TDateField;
    myContractHistoryCNT_END_USE3: TDateField;
    myContractHistoryCNT_END_USE4: TDateField;
    myContractHistoryCNT_END_USE5: TDateField;
    myContractHistoryCNT_ID_CAR: TStringField;
    myContractHistoryCNT_ID_CAR1: TStringField;
    myContractHistoryCNT_ID_CLIENT: TStringField;
    myContractHistoryCNT_ID_CLIENT1: TStringField;
    myContractHistoryCNT_ID_DOGOVOR: TStringField;
    myContractHistoryCNT_ID_DOGOVOR1: TStringField;
    myContractHistoryCNT_ID_DOGOVOR_TYPE: TLongintField;
    myContractHistoryCNT_ID_DOGOVOR_TYPE1: TLongintField;
    myContractHistoryCNT_ID_INSURANCE_CLASS: TLongintField;
    myContractHistoryCNT_ID_INSURANCE_CLASS1: TLongintField;
    myContractHistoryCNT_ID_INSURANCE_COMPANY: TLongintField;
    myContractHistoryCNT_ID_INSURANCE_COMPANY1: TLongintField;
    myContractHistoryCNT_ID_PREV_DOG: TStringField;
    myContractHistoryCNT_ID_PREV_DOG1: TStringField;
    myContractHistoryCNT_ID_TERRITORY_USE: TLongintField;
    myContractHistoryCNT_ID_TERRITORY_USE1: TLongintField;
    myContractHistoryCNT_INS_PREM: TFloatField;
    myContractHistoryCNT_INS_PREM1: TFloatField;
    myContractHistoryCNT_INS_SUM: TFloatField;
    myContractHistoryCNT_INS_SUM1: TFloatField;
    myContractHistoryCNT_KOEF_BONUSMALUS: TFloatField;
    myContractHistoryCNT_KOEF_BONUSMALUS1: TFloatField;
    myContractHistoryCNT_KOEF_KN: TFloatField;
    myContractHistoryCNT_KOEF_KN1: TFloatField;
    myContractHistoryCNT_KOEF_PERIOD_USE: TFloatField;
    myContractHistoryCNT_KOEF_PERIOD_USE1: TFloatField;
    myContractHistoryCNT_KOEF_POWER: TFloatField;
    myContractHistoryCNT_KOEF_POWER1: TFloatField;
    myContractHistoryCNT_KOEF_SROK_INS: TFloatField;
    myContractHistoryCNT_KOEF_SROK_INS1: TFloatField;
    myContractHistoryCNT_KOEF_STAG: TFloatField;
    myContractHistoryCNT_KOEF_STAG1: TFloatField;
    myContractHistoryCNT_KOEF_TER: TFloatField;
    myContractHistoryCNT_KOEF_TER1: TFloatField;
    myContractHistoryCNT_KOEF_UNLIMITED: TFloatField;
    myContractHistoryCNT_KOEF_UNLIMITED1: TFloatField;
    myContractHistoryCNT_START_USE: TDateField;
    myContractHistoryCNT_START_USE1: TDateField;
    myContractHistoryCNT_START_USE2: TDateField;
    myContractHistoryCNT_START_USE3: TDateField;
    myContractHistoryCNT_START_USE4: TDateField;
    myContractHistoryCNT_START_USE5: TDateField;
    myContractHistoryCNT_TRANSIT: TBooleanField;
    myContractHistoryCNT_TRANSIT1: TBooleanField;
    myContractHistoryCNT_UNLIMITED_DRIVERS: TBooleanField;
    myContractHistoryCNT_UNLIMITED_DRIVERS1: TBooleanField;
    myContractHistoryCNT_USER_INSERT_NAME: TStringField;
    myContractHistoryCNT_USER_INSERT_NAME1: TStringField;
    myContractHistoryCNT_USER_UPDATE_NAME: TStringField;
    myContractHistoryCNT_USER_UPDATE_NAME1: TStringField;
    myContractHistoryCNT_ZNAK_NO: TStringField;
    myContractHistoryCNT_ZNAK_NO1: TStringField;
    myContractHistoryCNT_ZNAK_SER: TStringField;
    myContractHistoryCNT_ZNAK_SER1: TStringField;
    myContractHistoryFULL_ADDRESS1: TStringField;
    myContractHistoryFULL_MODEL: TStringField;
    myContractHistoryFULL_MODEL1: TStringField;
    myContractHistoryFULL_NAME1: TStringField;
    myContractHistoryFULL_NUM: TStringField;
    myContractHistoryFULL_NUM1: TStringField;
    myContractHistoryHIST_EVENT1: TDateField;
    myContractHistoryHIST_STATE1: TStringField;
    myContractOpersHistoryCAR_ARENDA: TBooleanField;
    myContractOpersHistoryCAR_CAR_MARK: TStringField;
    myContractOpersHistoryCAR_CAR_MODEL: TStringField;
    myContractOpersHistoryCAR_COMMENTS: TStringField;
    myContractOpersHistoryCAR_DATE_INSERT: TDateField;
    myContractOpersHistoryCAR_DATE_UPDATE: TDateField;
    myContractOpersHistoryCAR_FOREING: TBooleanField;
    myContractOpersHistoryCAR_GOS_NUM: TStringField;
    myContractOpersHistoryCAR_ID_CAR: TStringField;
    myContractOpersHistoryCAR_ID_CAR_TYPE: TLongintField;
    myContractOpersHistoryCAR_ID_CLIENT: TStringField;
    myContractOpersHistoryCAR_ID_PRODUCTER_TYPE: TFloatField;
    myContractOpersHistoryCAR_ID_PURPOSE_TYPE: TLongintField;
    myContractOpersHistoryCAR_KUSOV: TStringField;
    myContractOpersHistoryCAR_MAX_KG: TFloatField;
    myContractOpersHistoryCAR_NUM_PLACES: TLongintField;
    myContractOpersHistoryCAR_POWER_KVT: TFloatField;
    myContractOpersHistoryCAR_POWER_LS: TFloatField;
    myContractOpersHistoryCAR_PTS_DATE: TDateField;
    myContractOpersHistoryCAR_PTS_NO: TStringField;
    myContractOpersHistoryCAR_PTS_SER: TStringField;
    myContractOpersHistoryCAR_SHASSI: TStringField;
    myContractOpersHistoryCAR_USER_INSERT_NAME: TStringField;
    myContractOpersHistoryCAR_USER_UPDATE_NAME: TStringField;
    myContractOpersHistoryCAR_VIN_NUM: TStringField;
    myContractOpersHistoryCAR_YEAR_ISSUE: TLongintField;
    myContractOpersHistoryCLN_BIRTHDAY: TDateField;
    myContractOpersHistoryCLN_BUSINESS_PHONE: TStringField;
    myContractOpersHistoryCLN_CELL_PHONE: TStringField;
    myContractOpersHistoryCLN_COMMENTS: TStringField;
    myContractOpersHistoryCLN_DATE_INSERT: TDateField;
    myContractOpersHistoryCLN_DATE_UPDATE: TDateField;
    myContractOpersHistoryCLN_DOC_NUM: TStringField;
    myContractOpersHistoryCLN_DOC_SER: TStringField;
    myContractOpersHistoryCLN_FLAT: TStringField;
    myContractOpersHistoryCLN_GROSS_VIOLATIONS: TBooleanField;
    myContractOpersHistoryCLN_HOME: TStringField;
    myContractOpersHistoryCLN_HOME_PHONE: TStringField;
    myContractOpersHistoryCLN_ID_CITY: TLargeintField;
    myContractOpersHistoryCLN_ID_CLIENT: TStringField;
    myContractOpersHistoryCLN_ID_CLIENT_TYPE: TLongintField;
    myContractOpersHistoryCLN_ID_COUNTRY: TLargeintField;
    myContractOpersHistoryCLN_ID_FAMILY_STATE: TLongintField;
    myContractOpersHistoryCLN_ID_INSURANCE_CLASS: TLongintField;
    myContractOpersHistoryCLN_ID_REGION: TLargeintField;
    myContractOpersHistoryCLN_ID_SEX: TLongintField;
    myContractOpersHistoryCLN_ID_TYPE_DOC: TLongintField;
    myContractOpersHistoryCLN_ID_TYPE_LOSSED: TLongintField;
    myContractOpersHistoryCLN_INN: TStringField;
    myContractOpersHistoryCLN_KORPUS: TStringField;
    myContractOpersHistoryCLN_LICENCE_NO: TStringField;
    myContractOpersHistoryCLN_LICENCE_SER: TStringField;
    myContractOpersHistoryCLN_MIDDLENAME: TStringField;
    myContractOpersHistoryCLN_NAME: TStringField;
    myContractOpersHistoryCLN_POSTINDEX: TStringField;
    myContractOpersHistoryCLN_START_DRIVING_DATE: TDateField;
    myContractOpersHistoryCLN_STREET: TStringField;
    myContractOpersHistoryCLN_SURNAME: TStringField;
    myContractOpersHistoryCLN_TOWN: TStringField;
    myContractOpersHistoryCLN_USER_INSERT_NAME: TStringField;
    myContractOpersHistoryCLN_USER_UPDATE_NAME: TStringField;
    myContractOpersHistoryCLN_WRITER_NAME: TStringField;
    myContractOpersHistoryCNT_BASE_SUM: TFloatField;
    myContractOpersHistoryCNT_COMMENT: TStringField;
    myContractOpersHistoryCNT_DATE_BEGIN: TDateField;
    myContractOpersHistoryCNT_DATE_DOG_CREATE: TDateField;
    myContractOpersHistoryCNT_DATE_DOG_INPUT: TDateField;
    myContractOpersHistoryCNT_DATE_END: TDateField;
    myContractOpersHistoryCNT_DATE_INSERT: TDateField;
    myContractOpersHistoryCNT_DATE_START: TDateTimeField;
    myContractOpersHistoryCNT_DATE_UPDATE: TDateField;
    myContractOpersHistoryCNT_DATE_WRITE: TDateField;
    myContractOpersHistoryCNT_DOGNUMB: TStringField;
    myContractOpersHistoryCNT_DOG_SER: TStringField;
    myContractOpersHistoryCNT_END_USE: TDateField;
    myContractOpersHistoryCNT_END_USE1: TDateField;
    myContractOpersHistoryCNT_END_USE2: TDateField;
    myContractOpersHistoryCNT_ID_CAR: TStringField;
    myContractOpersHistoryCNT_ID_CLIENT: TStringField;
    myContractOpersHistoryCNT_ID_DOGOVOR: TStringField;
    myContractOpersHistoryCNT_ID_DOGOVOR_TYPE: TLongintField;
    myContractOpersHistoryCNT_ID_INSURANCE_CLASS: TLongintField;
    myContractOpersHistoryCNT_ID_INSURANCE_COMPANY: TLongintField;
    myContractOpersHistoryCNT_ID_PREV_DOG: TStringField;
    myContractOpersHistoryCNT_ID_TERRITORY_USE: TLongintField;
    myContractOpersHistoryCNT_INS_PREM: TFloatField;
    myContractOpersHistoryCNT_INS_SUM: TFloatField;
    myContractOpersHistoryCNT_KOEF_BONUSMALUS: TFloatField;
    myContractOpersHistoryCNT_KOEF_KN: TFloatField;
    myContractOpersHistoryCNT_KOEF_PERIOD_USE: TFloatField;
    myContractOpersHistoryCNT_KOEF_POWER: TFloatField;
    myContractOpersHistoryCNT_KOEF_SROK_INS: TFloatField;
    myContractOpersHistoryCNT_KOEF_STAG: TFloatField;
    myContractOpersHistoryCNT_KOEF_TER: TFloatField;
    myContractOpersHistoryCNT_KOEF_UNLIMITED: TFloatField;
    myContractOpersHistoryCNT_START_USE: TDateField;
    myContractOpersHistoryCNT_START_USE1: TDateField;
    myContractOpersHistoryCNT_START_USE2: TDateField;
    myContractOpersHistoryCNT_TRANSIT: TBooleanField;
    myContractOpersHistoryCNT_UNLIMITED_DRIVERS: TBooleanField;
    myContractOpersHistoryCNT_USER_INSERT_NAME: TStringField;
    myContractOpersHistoryCNT_USER_UPDATE_NAME: TStringField;
    myContractOpersHistoryCNT_ZNAK_NO: TStringField;
    myContractOpersHistoryCNT_ZNAK_SER: TStringField;
    myContractOpersHistoryFULL_ADDRESS: TStringField;
    myContractOpersHistoryFULL_MODEL: TStringField;
    myContractOpersHistoryFULL_NAME: TStringField;
    myContractOpersHistoryFULL_NUM: TStringField;
    myContractOpersHistoryHIST_EVENT: TDateField;
    myContractOpersHistoryHIST_STATE: TStringField;
    myGeoGroups: TMyQuery;
    myClientCLN_BIRTHDAY: TDateField;
    myClientCLN_BUSINESS_PHONE: TStringField;
    myClientCLN_CELL_PHONE: TStringField;
    myClientCLN_COMMENTS: TStringField;
    myClientCLN_DATE_INSERT: TDateField;
    myClientCLN_DATE_UPDATE: TDateField;
    myClientCLN_DOC_NUM: TStringField;
    myClientCLN_DOC_SER: TStringField;
    myClientCLN_FLAT: TStringField;
    myClientCLN_GROSS_VIOLATIONS: TBooleanField;
    myClientCLN_HOME: TStringField;
    myClientCLN_HOME_PHONE: TStringField;
    myClientCLN_ID_CITY: TLargeintField;
    myClientCLN_ID_CLIENT: TStringField;
    myClientCLN_ID_CLIENT_TYPE: TLongintField;
    myClientCLN_ID_COUNTRY: TLargeintField;
    myClientCLN_ID_FAMILY_STATE: TLongintField;
    myClientCLN_ID_INSURANCE_CLASS: TLongintField;
    myClientCLN_ID_REGION: TLargeintField;
    myClientCLN_ID_SEX: TLongintField;
    myClientCLN_ID_TYPE_DOC: TLongintField;
    myClientCLN_ID_TYPE_LOSSED: TLongintField;
    myClientCLN_INN: TStringField;
    myClientCLN_KORPUS: TStringField;
    myClientCLN_LICENCE_NO: TStringField;
    myClientCLN_LICENCE_SER: TStringField;
    myClientCLN_MIDDLENAME: TStringField;
    myClientCLN_NAME: TStringField;
    myClientCLN_POSTINDEX: TStringField;
    myClientCLN_START_DRIVING_DATE: TDateField;
    myClientCLN_STREET: TStringField;
    myClientCLN_SURNAME: TStringField;
    myClientCLN_TOWN: TStringField;
    myClientCLN_USER_INSERT_NAME: TStringField;
    myClientCLN_USER_UPDATE_NAME: TStringField;
    myClientCLN_WRITER_NAME: TStringField;
    myClientFULL_ADDRESS: TStringField;
    myClientFULL_NAME: TStringField;
    myClientTypeCLIENT_TYPE: TStringField;
    myClientTypeCLIENT_TYPE_GROUP: TStringField;
    myContractCLN_GROSS_VIOLATIONS: TBooleanField;
    myContractCLN_ID_CITY: TLargeintField;
    myContractCLN_ID_COUNTRY: TLargeintField;
    myContractCLN_ID_REGION: TLargeintField;
    myCountriesID_COUNTRY: TLargeintField;
    myCountriesNAME: TStringField;
    myGeoGroupsGEO_GROUP: TLargeintField;
    myGeoGroupsNAME: TStringField;
    myGetAllUsersGROUP_NAME: TStringField;
    myClnRemind: TMyStoredProc;
    myGetInsCoefs_BSCAR_TYPE: TStringField;
    myClientTypeID_CLIENT_TYPE: TLongintField;
    myClientTypeID_CLIENT_TYPE_GROUP: TFloatField;
    myClientTypesCLIENT_TYPE: TStringField;
    myClientTypesCLIENT_TYPE_GROUP1: TStringField;
    myClientTypesID_CLIENT_TYPE: TLongintField;
    myClientTypesID_CLIENT_TYPE_GROUP: TFloatField;
    myconnAddContract: TMyConnection;
    myContractCAR_ARENDA: TBooleanField;
    myContractCAR_CAR_MARK: TStringField;
    myContractCAR_CAR_MODEL: TStringField;
    myContractCAR_COMMENTS: TStringField;
    myContractCAR_DATE_INSERT: TDateField;
    myContractCAR_DATE_UPDATE: TDateField;
    myContractCAR_FOREING: TBooleanField;
    myContractCAR_GOS_NUM: TStringField;
    myContractCAR_ID_CAR: TStringField;
    myContractCAR_ID_CAR_TYPE: TLongintField;
    myContractCAR_ID_CLIENT: TStringField;
    myContractCAR_ID_PRODUCTER_TYPE: TFloatField;
    myContractCAR_ID_PURPOSE_TYPE: TLongintField;
    myContractCAR_KUSOV: TStringField;
    myContractCAR_MAX_KG: TFloatField;
    myContractCAR_NUM_PLACES: TLongintField;
    myContractCAR_POWER_KVT: TFloatField;
    myContractCAR_POWER_LS: TFloatField;
    myContractCAR_PTS_DATE: TDateField;
    myContractCAR_PTS_NO: TStringField;
    myContractCAR_PTS_SER: TStringField;
    myContractCAR_SHASSI: TStringField;
    myContractCAR_USER_INSERT_NAME: TStringField;
    myContractCAR_USER_UPDATE_NAME: TStringField;
    myContractCAR_VIN_NUM: TStringField;
    myContractCAR_YEAR_ISSUE: TLongintField;
    myContractCLN_BIRTHDAY: TDateField;
    myContractCLN_BUSINESS_PHONE: TStringField;
    myContractCLN_CELL_PHONE: TStringField;
    myContractCLN_COMMENTS: TStringField;
    myContractCLN_DATE_INSERT: TDateField;
    myContractCLN_DATE_UPDATE: TDateField;
    myContractCLN_DOC_NUM: TStringField;
    myContractCLN_DOC_SER: TStringField;
    myContractCLN_FLAT: TStringField;
    myContractCLN_HOME: TStringField;
    myContractCLN_HOME_PHONE: TStringField;
    myContractCLN_ID_CLIENT: TStringField;
    myContractCLN_ID_CLIENT_TYPE: TLongintField;
    myContractCLN_ID_FAMILY_STATE: TLongintField;
    myContractCLN_ID_INSURANCE_CLASS: TLongintField;
    myContractCLN_ID_SEX: TLongintField;
    myContractCLN_ID_TYPE_DOC: TLongintField;
    myContractCLN_ID_TYPE_LOSSED: TLongintField;
    myContractCLN_INN: TStringField;
    myContractCLN_KORPUS: TStringField;
    myContractCLN_LICENCE_NO: TStringField;
    myContractCLN_LICENCE_SER: TStringField;
    myContractCLN_MIDDLENAME: TStringField;
    myContractCLN_NAME: TStringField;
    myContractCLN_POSTINDEX: TStringField;
    myContractCLN_START_DRIVING_DATE: TDateField;
    myContractCLN_STREET: TStringField;
    myContractCLN_SURNAME: TStringField;
    myContractCLN_TOWN: TStringField;
    myContractCLN_USER_INSERT_NAME: TStringField;
    myContractCLN_USER_UPDATE_NAME: TStringField;
    myContractCLN_WRITER_NAME: TStringField;
    myContractCNT_BASE_SUM: TFloatField;
    myContractCNT_COMMENT: TStringField;
    myContractCNT_DATE_BEGIN: TDateField;
    myContractCNT_DATE_DOG_CREATE: TDateField;
    myContractCNT_DATE_DOG_INPUT: TDateField;
    myContractCNT_DATE_END: TDateField;
    myContractCNT_DATE_INSERT: TDateField;
    myContractCNT_DATE_START: TDateTimeField;
    myContractCNT_DATE_UPDATE: TDateField;
    myContractCNT_DATE_WRITE: TDateField;
    myContractCNT_DOGNUMB: TStringField;
    myContractCNT_DOG_SER: TStringField;
    myContractCNT_END_USE: TDateField;
    myContractCNT_END_USE1: TDateField;
    myContractCNT_END_USE2: TDateField;
    myContractCNT_ID_CAR: TStringField;
    myContractCNT_ID_CLIENT: TStringField;
    myContractCNT_ID_DOGOVOR: TStringField;
    myContractCNT_ID_DOGOVOR_TYPE: TLongintField;
    myContractCNT_ID_INSURANCE_CLASS: TLongintField;
    myContractCNT_ID_INSURANCE_COMPANY: TLongintField;
    myContractCNT_ID_PREV_DOG: TStringField;
    myContractCNT_ID_TERRITORY_USE: TLongintField;
    myContractCNT_INS_PREM: TFloatField;
    myContractCNT_INS_SUM: TFloatField;
    myContractCNT_KOEF_BONUSMALUS: TFloatField;
    myContractCNT_KOEF_KN: TFloatField;
    myContractCNT_KOEF_PERIOD_USE: TFloatField;
    myContractCNT_KOEF_POWER: TFloatField;
    myContractCNT_KOEF_SROK_INS: TFloatField;
    myContractCNT_KOEF_STAG: TFloatField;
    myContractCNT_KOEF_TER: TFloatField;
    myContractCNT_KOEF_UNLIMITED: TFloatField;
    myContractCNT_START_USE: TDateField;
    myContractCNT_START_USE1: TDateField;
    myContractCNT_START_USE2: TDateField;
    myContractCNT_TRANSIT: TBooleanField;
    myContractCNT_UNLIMITED_DRIVERS: TBooleanField;
    myContractCNT_USER_INSERT_NAME: TStringField;
    myContractCNT_USER_UPDATE_NAME: TStringField;
    myContractCNT_ZNAK_NO: TStringField;
    myContractCNT_ZNAK_SER: TStringField;
    myContractFULL_ADDRESS: TStringField;
    myContractFULL_NAME: TStringField;
    myDocTypesDOC_TYPE: TStringField;
    myDocTypesID_TYPE_DOC: TLongintField;
    myFamilyStateFAMILY_STATE_NAME: TStringField;
    myFamilyStateID_FAMILY_STATE: TLongintField;
    myFreeBlanks: TMyQuery;
    myContractHistory: TMyStoredProc;
    myCarType: TMyQuery;
    myAlerter: TMyQuery;
    myInsCompaniesTICKET_BODY: TMemoField;
    myProcBlankDamage: TMyStoredProc;
    myProcCarMain: TMyQuery;
    myProcClnMain: TMyQuery;
    myProcGroupMain: TMyQuery;
    myProcUserMain: TMyQuery;
    myCountries: TMyQuery;
    myCities: TMyQuery;
    myRegion: TMyQuery;
    myRegionesID_COUNTRY: TLargeintField;
    myRegionesID_REGION: TLargeintField;
    myRegionesNAME: TStringField;
    myRegionesNAME1_1: TStringField;
    mySearchCar1CAR_ARENDA: TBooleanField;
    mySearchCar1CAR_CAR_MARK: TStringField;
    mySearchCar1CAR_CAR_MODEL: TStringField;
    mySearchCar1CAR_COMMENTS: TStringField;
    mySearchCar1CAR_DATE_INSERT: TDateField;
    mySearchCar1CAR_DATE_UPDATE: TDateField;
    mySearchCar1CAR_FOREING: TBooleanField;
    mySearchCar1CAR_GOS_NUM: TStringField;
    mySearchCar1CAR_ID_CAR: TStringField;
    mySearchCar1CAR_ID_CAR_TYPE: TLongintField;
    mySearchCar1CAR_ID_CLIENT: TStringField;
    mySearchCar1CAR_ID_PRODUCTER_TYPE: TFloatField;
    mySearchCar1CAR_ID_PURPOSE_TYPE: TLongintField;
    mySearchCar1CAR_KUSOV: TStringField;
    mySearchCar1CAR_MAX_KG: TFloatField;
    mySearchCar1CAR_NUM_PLACES: TLongintField;
    mySearchCar1CAR_POWER_KVT: TFloatField;
    mySearchCar1CAR_POWER_LS: TFloatField;
    mySearchCar1CAR_PTS_DATE: TDateField;
    mySearchCar1CAR_PTS_NO: TStringField;
    mySearchCar1CAR_PTS_SER: TStringField;
    mySearchCar1CAR_SHASSI: TStringField;
    mySearchCar1CAR_USER_INSERT_NAME: TStringField;
    mySearchCar1CAR_USER_UPDATE_NAME: TStringField;
    mySearchCar1CAR_VIN_NUM: TStringField;
    mySearchCar1CAR_YEAR_ISSUE: TLongintField;
    mySearchCar1CLN_BIRTHDAY: TDateField;
    mySearchCar1CLN_BUSINESS_PHONE: TStringField;
    mySearchCar1CLN_CELL_PHONE: TStringField;
    mySearchCar1CLN_COMMENTS: TStringField;
    mySearchCar1CLN_DATE_INSERT: TDateField;
    mySearchCar1CLN_DATE_UPDATE: TDateField;
    mySearchCar1CLN_DOC_NUM: TStringField;
    mySearchCar1CLN_DOC_SER: TStringField;
    mySearchCar1CLN_FLAT: TStringField;
    mySearchCar1CLN_GROSS_VIOLATIONS: TBooleanField;
    mySearchCar1CLN_HOME: TStringField;
    mySearchCar1CLN_HOME_PHONE: TStringField;
    mySearchCar1CLN_ID_CITY: TLargeintField;
    mySearchCar1CLN_ID_CLIENT: TStringField;
    mySearchCar1CLN_ID_CLIENT_TYPE: TLongintField;
    mySearchCar1CLN_ID_COUNTRY: TLargeintField;
    mySearchCar1CLN_ID_FAMILY_STATE: TLongintField;
    mySearchCar1CLN_ID_INSURANCE_CLASS: TLongintField;
    mySearchCar1CLN_ID_REGION: TLargeintField;
    mySearchCar1CLN_ID_SEX: TLongintField;
    mySearchCar1CLN_ID_TYPE_DOC: TLongintField;
    mySearchCar1CLN_ID_TYPE_LOSSED: TLongintField;
    mySearchCar1CLN_INN: TStringField;
    mySearchCar1CLN_KORPUS: TStringField;
    mySearchCar1CLN_LICENCE_NO: TStringField;
    mySearchCar1CLN_LICENCE_SER: TStringField;
    mySearchCar1CLN_MIDDLENAME: TStringField;
    mySearchCar1CLN_NAME: TStringField;
    mySearchCar1CLN_POSTINDEX: TStringField;
    mySearchCar1CLN_START_DRIVING_DATE: TDateField;
    mySearchCar1CLN_STREET: TStringField;
    mySearchCar1CLN_SURNAME: TStringField;
    mySearchCar1CLN_TOWN: TStringField;
    mySearchCar1CLN_USER_INSERT_NAME: TStringField;
    mySearchCar1CLN_USER_UPDATE_NAME: TStringField;
    mySearchCar1CLN_WRITER_NAME: TStringField;
    mySearchCar1CNT_BASE_SUM: TFloatField;
    mySearchCar1CNT_COMMENT: TStringField;
    mySearchCar1CNT_DATE_BEGIN: TDateField;
    mySearchCar1CNT_DATE_DOG_CREATE: TDateField;
    mySearchCar1CNT_DATE_DOG_INPUT: TDateField;
    mySearchCar1CNT_DATE_END: TDateField;
    mySearchCar1CNT_DATE_INSERT: TDateField;
    mySearchCar1CNT_DATE_START: TDateTimeField;
    mySearchCar1CNT_DATE_UPDATE: TDateField;
    mySearchCar1CNT_DATE_WRITE: TDateField;
    mySearchCar1CNT_DOGNUMB: TStringField;
    mySearchCar1CNT_DOG_SER: TStringField;
    mySearchCar1CNT_END_USE: TDateField;
    mySearchCar1CNT_END_USE1: TDateField;
    mySearchCar1CNT_END_USE2: TDateField;
    mySearchCar1CNT_ID_CAR: TStringField;
    mySearchCar1CNT_ID_CLIENT: TStringField;
    mySearchCar1CNT_ID_DOGOVOR: TStringField;
    mySearchCar1CNT_ID_DOGOVOR_TYPE: TLongintField;
    mySearchCar1CNT_ID_INSURANCE_CLASS: TLongintField;
    mySearchCar1CNT_ID_INSURANCE_COMPANY: TLongintField;
    mySearchCar1CNT_ID_PREV_DOG: TStringField;
    mySearchCar1CNT_ID_TERRITORY_USE: TLongintField;
    mySearchCar1CNT_INS_PREM: TFloatField;
    mySearchCar1CNT_INS_SUM: TFloatField;
    mySearchCar1CNT_KOEF_BONUSMALUS: TFloatField;
    mySearchCar1CNT_KOEF_KN: TFloatField;
    mySearchCar1CNT_KOEF_PERIOD_USE: TFloatField;
    mySearchCar1CNT_KOEF_POWER: TFloatField;
    mySearchCar1CNT_KOEF_SROK_INS: TFloatField;
    mySearchCar1CNT_KOEF_STAG: TFloatField;
    mySearchCar1CNT_KOEF_TER: TFloatField;
    mySearchCar1CNT_KOEF_UNLIMITED: TFloatField;
    mySearchCar1CNT_START_USE: TDateField;
    mySearchCar1CNT_START_USE1: TDateField;
    mySearchCar1CNT_START_USE2: TDateField;
    mySearchCar1CNT_TRANSIT: TBooleanField;
    mySearchCar1CNT_UNLIMITED_DRIVERS: TBooleanField;
    mySearchCar1CNT_USER_INSERT_NAME: TStringField;
    mySearchCar1CNT_USER_UPDATE_NAME: TStringField;
    mySearchCar1CNT_ZNAK_NO: TStringField;
    mySearchCar1CNT_ZNAK_SER: TStringField;
    mySearchCar1FULL_ADDRESS: TStringField;
    mySearchCar1FULL_MODEL: TStringField;
    mySearchCar1FULL_NAME: TStringField;
    mySearchCar1FULL_NUM: TStringField;
    mySearchCar1HIST_EVENT: TDateField;
    mySearchCar1HIST_STATE: TStringField;
    mySearchCarCLN_GROSS_VIOLATIONS: TBooleanField;
    mySearchCarCLN_ID_CITY: TLargeintField;
    mySearchCarCLN_ID_COUNTRY: TLargeintField;
    mySearchCarCLN_ID_REGION: TLargeintField;
    mySearchCarCLN_LAST_CALL_DATE: TDateField;
    mySearchClientCLN_GROSS_VIOLATIONS: TBooleanField;
    mySearchClientCLN_ID_CITY: TLargeintField;
    mySearchClientCLN_ID_COUNTRY: TLargeintField;
    mySearchClientCLN_ID_REGION: TLargeintField;
    mySearchClientCLN_LAST_CALL_DATE: TDateField;
    mySearchContractCLN_GROSS_VIOLATIONS: TBooleanField;
    mySearchContractCLN_ID_CITY: TLargeintField;
    mySearchContractCLN_ID_COUNTRY: TLargeintField;
    mySearchContractCLN_ID_REGION: TLargeintField;
    mySearchContractCLN_LAST_CALL_DATE: TDateField;
    mySearchContractCNT_TICKET_DATE: TDateField;
    mySearchContractCNT_TICKET_NUM: TStringField;
    mySearchContractCNT_TICKET_SER: TStringField;
    MyTable1ID_CAR_TYPE: TLongintField;
    MyTable1ID_CLIENT_TYPE_GROUP: TLongintField;
    MyTable1ID_FORMULA: TLargeintField;
    MyTable1OWNER_TYPE: TStringField;
    mytbClientTypeGroupCLIENT_TYPE_GROUP: TStringField;
    mytbClientTypeGroupID_CLIENT_TYPE_GROUP: TLongintField;
    myGetUserFullName: TMyQuery;
    myProcContReplace: TMyQuery;
    myGetAllUsersADDRESS: TStringField;
    myGetAllUsersADDRESS2: TStringField;
    myGetAllUsersCELL_PHONE: TStringField;
    myGetAllUsersCELL_PHONE2: TStringField;
    myGetAllUsersCOMMENTS: TStringField;
    myGetAllUsersCOMMENTS2: TStringField;
    myGetAllUsersFIRST_RUN: TBooleanField;
    myGetAllUsersFIRST_RUN2: TBooleanField;
    myGetAllUsersGROUP_NAME2: TStringField;
    myGetAllUsersHOME_PHONE: TStringField;
    myGetAllUsersHOME_PHONE2: TStringField;
    myGetAllUsersHost: TStringField;
    myGetAllUsersHost2: TStringField;
    myGetAllUsersID_GROUP: TSmallintField;
    myGetAllUsersID_GROUP2: TSmallintField;
    myGetAllUsersMW_HEIGHT: TLongintField;
    myGetAllUsersMW_HEIGHT2: TLongintField;
    myGetAllUsersMW_LEFT: TLongintField;
    myGetAllUsersMW_LEFT2: TLongintField;
    myGetAllUsersMW_STATE: TBooleanField;
    myGetAllUsersMW_STATE2: TBooleanField;
    myGetAllUsersMW_TOP: TLongintField;
    myGetAllUsersMW_TOP2: TLongintField;
    myGetAllUsersMW_WIDTH: TLongintField;
    myGetAllUsersMW_WIDTH2: TLongintField;
    myGetAllUsersNAME: TStringField;
    myGetAllUsersNAME2: TStringField;
    myGetAllUsersPATHRONIMYC: TStringField;
    myGetAllUsersPATHRONIMYC2: TStringField;
    myGetAllUsersSURNAME: TStringField;
    myGetAllUsersSURNAME2: TStringField;
    myGetAllUsersUser: TStringField;
    myGetAllUsersUser2: TStringField;
    myGetAllUsersUSE_HELPER: TBooleanField;
    myGetAllUsersUSE_HELPER2: TBooleanField;
    myGetAllUsers: TMyQuery;
    myGetCurUserInfo: TMyStoredProc;
    myLastInsIDliid: TBlobField;
    myProcContClose: TMyStoredProc;
    myProcContProlong: TMyQuery;
    myProcContMain: TMyQuery;
    myProcDrvsClear: TMyStoredProc;
    myProcDrvAdd: TMyStoredProc;
    myGetChangeLog: TMyStoredProc;
    myGetCurUser: TMyStoredProc;
    mySaveCurUserSettings: TMyStoredProc;
    myProcBlankAdd: TMyStoredProc;
    myProcBlankReserve: TMyStoredProc;
    myProcBlankUnreserve: TMyStoredProc;
    mySearchCarCAR_ARENDA: TBooleanField;
    mySearchCarCAR_CAR_MARK: TStringField;
    mySearchCarCAR_CAR_MODEL: TStringField;
    mySearchCarCAR_COMMENTS: TStringField;
    mySearchCarCAR_DATE_INSERT: TDateField;
    mySearchCarCAR_DATE_UPDATE: TDateField;
    mySearchCarCAR_FOREING: TBooleanField;
    mySearchCarCAR_GOS_NUM: TStringField;
    mySearchCarCAR_ID_CAR: TStringField;
    mySearchCarCAR_ID_CAR_TYPE: TLongintField;
    mySearchCarCAR_ID_CLIENT: TStringField;
    mySearchCarCAR_ID_PRODUCTER_TYPE: TFloatField;
    mySearchCarCAR_ID_PURPOSE_TYPE: TLongintField;
    mySearchCarCAR_KUSOV: TStringField;
    mySearchCarCAR_MAX_KG: TFloatField;
    mySearchCarCAR_NUM_PLACES: TLongintField;
    mySearchCarCAR_POWER_KVT: TFloatField;
    mySearchCarCAR_POWER_LS: TFloatField;
    mySearchCarCAR_PTS_DATE: TDateField;
    mySearchCarCAR_PTS_NO: TStringField;
    mySearchCarCAR_PTS_SER: TStringField;
    mySearchCarCAR_SHASSI: TStringField;
    mySearchCarCAR_USER_INSERT_NAME: TStringField;
    mySearchCarCAR_USER_UPDATE_NAME: TStringField;
    mySearchCarCAR_VIN_NUM: TStringField;
    mySearchCarCAR_YEAR_ISSUE: TLongintField;
    mySearchCarCLN_BIRTHDAY: TDateField;
    mySearchCarCLN_BUSINESS_PHONE: TStringField;
    mySearchCarCLN_CELL_PHONE: TStringField;
    mySearchCarCLN_COMMENTS: TStringField;
    mySearchCarCLN_DATE_INSERT: TDateField;
    mySearchCarCLN_DATE_UPDATE: TDateField;
    mySearchCarCLN_DOC_NUM: TStringField;
    mySearchCarCLN_DOC_SER: TStringField;
    mySearchCarCLN_FLAT: TStringField;
    mySearchCarCLN_HOME: TStringField;
    mySearchCarCLN_HOME_PHONE: TStringField;
    mySearchCarCLN_ID_CLIENT: TStringField;
    mySearchCarCLN_ID_CLIENT_TYPE: TLongintField;
    mySearchCarCLN_ID_FAMILY_STATE: TLongintField;
    mySearchCarCLN_ID_INSURANCE_CLASS: TLongintField;
    mySearchCarCLN_ID_SEX: TLongintField;
    mySearchCarCLN_ID_TYPE_DOC: TLongintField;
    mySearchCarCLN_ID_TYPE_LOSSED: TLongintField;
    mySearchCarCLN_INN: TStringField;
    mySearchCarCLN_KORPUS: TStringField;
    mySearchCarCLN_LICENCE_NO: TStringField;
    mySearchCarCLN_LICENCE_SER: TStringField;
    mySearchCarCLN_MIDDLENAME: TStringField;
    mySearchCarCLN_NAME: TStringField;
    mySearchCarCLN_POSTINDEX: TStringField;
    mySearchCarCLN_START_DRIVING_DATE: TDateField;
    mySearchCarCLN_STREET: TStringField;
    mySearchCarCLN_SURNAME: TStringField;
    mySearchCarCLN_TOWN: TStringField;
    mySearchCarCLN_USER_INSERT_NAME: TStringField;
    mySearchCarCLN_USER_UPDATE_NAME: TStringField;
    mySearchCarCLN_WRITER_NAME: TStringField;
    mySearchCarFULL_ADDRESS: TStringField;
    mySearchCarFULL_NAME: TStringField;
    mySearchClientCLN_BIRTHDAY: TDateField;
    mySearchClientCLN_BUSINESS_PHONE: TStringField;
    mySearchClientCLN_CELL_PHONE: TStringField;
    mySearchClientCLN_COMMENTS: TStringField;
    mySearchClientCLN_DATE_INSERT: TDateField;
    mySearchClientCLN_DATE_UPDATE: TDateField;
    mySearchClientCLN_DOC_NUM: TStringField;
    mySearchClientCLN_DOC_SER: TStringField;
    mySearchClientCLN_FLAT: TStringField;
    mySearchClientCLN_HOME: TStringField;
    mySearchClientCLN_HOME_PHONE: TStringField;
    mySearchClientCLN_ID_CLIENT: TStringField;
    mySearchClientCLN_ID_CLIENT_TYPE: TLongintField;
    mySearchClientCLN_ID_FAMILY_STATE: TLongintField;
    mySearchClientCLN_ID_INSURANCE_CLASS: TLongintField;
    mySearchClientCLN_ID_SEX: TLongintField;
    mySearchClientCLN_ID_TYPE_DOC: TLongintField;
    mySearchClientCLN_ID_TYPE_LOSSED: TLongintField;
    mySearchClientCLN_INN: TStringField;
    mySearchClientCLN_KORPUS: TStringField;
    mySearchClientCLN_LICENCE_NO: TStringField;
    mySearchClientCLN_LICENCE_SER: TStringField;
    mySearchClientCLN_MIDDLENAME: TStringField;
    mySearchClientCLN_NAME: TStringField;
    mySearchClientCLN_POSTINDEX: TStringField;
    mySearchClientCLN_START_DRIVING_DATE: TDateField;
    mySearchClientCLN_STREET: TStringField;
    mySearchClientCLN_SURNAME: TStringField;
    mySearchClientCLN_TOWN: TStringField;
    mySearchClientCLN_USER_INSERT_NAME: TStringField;
    mySearchClientCLN_USER_UPDATE_NAME: TStringField;
    mySearchClientCLN_WRITER_NAME: TStringField;
    mySearchContractCAR_ARENDA: TBooleanField;
    mySearchContractCAR_CAR_MARK: TStringField;
    mySearchContractCAR_CAR_MODEL: TStringField;
    mySearchContractCAR_COMMENTS: TStringField;
    mySearchContractCAR_DATE_INSERT: TDateField;
    mySearchContractCAR_DATE_UPDATE: TDateField;
    mySearchContractCAR_FOREING: TBooleanField;
    mySearchContractCAR_GOS_NUM: TStringField;
    mySearchContractCAR_ID_CAR: TStringField;
    mySearchContractCAR_ID_CAR_TYPE: TLongintField;
    mySearchContractCAR_ID_CLIENT: TStringField;
    mySearchContractCAR_ID_PRODUCTER_TYPE: TFloatField;
    mySearchContractCAR_ID_PURPOSE_TYPE: TLongintField;
    mySearchContractCAR_KUSOV: TStringField;
    mySearchContractCAR_MAX_KG: TFloatField;
    mySearchContractCAR_NUM_PLACES: TLongintField;
    mySearchContractCAR_POWER_KVT: TFloatField;
    mySearchContractCAR_POWER_LS: TFloatField;
    mySearchContractCAR_PTS_DATE: TDateField;
    mySearchContractCAR_PTS_NO: TStringField;
    mySearchContractCAR_PTS_SER: TStringField;
    mySearchContractCAR_SHASSI: TStringField;
    mySearchContractCAR_USER_INSERT_NAME: TStringField;
    mySearchContractCAR_USER_UPDATE_NAME: TStringField;
    mySearchContractCAR_VIN_NUM: TStringField;
    mySearchContractCAR_YEAR_ISSUE: TLongintField;
    mySearchContractCLN_BIRTHDAY: TDateField;
    mySearchContractCLN_BUSINESS_PHONE: TStringField;
    mySearchContractCLN_CELL_PHONE: TStringField;
    mySearchContractCLN_COMMENTS: TStringField;
    mySearchContractCLN_DATE_INSERT: TDateField;
    mySearchContractCLN_DATE_UPDATE: TDateField;
    mySearchContractCLN_DOC_NUM: TStringField;
    mySearchContractCLN_DOC_SER: TStringField;
    mySearchContractCLN_FLAT: TStringField;
    mySearchContractCLN_HOME: TStringField;
    mySearchContractCLN_HOME_PHONE: TStringField;
    mySearchContractCLN_ID_CLIENT: TStringField;
    mySearchContractCLN_ID_CLIENT_TYPE: TLongintField;
    mySearchContractCLN_ID_FAMILY_STATE: TLongintField;
    mySearchContractCLN_ID_INSURANCE_CLASS: TLongintField;
    mySearchContractCLN_ID_SEX: TLongintField;
    mySearchContractCLN_ID_TYPE_DOC: TLongintField;
    mySearchContractCLN_ID_TYPE_LOSSED: TLongintField;
    mySearchContractCLN_INN: TStringField;
    mySearchContractCLN_KORPUS: TStringField;
    mySearchContractCLN_LICENCE_NO: TStringField;
    mySearchContractCLN_LICENCE_SER: TStringField;
    mySearchContractCLN_MIDDLENAME: TStringField;
    mySearchContractCLN_NAME: TStringField;
    mySearchContractCLN_POSTINDEX: TStringField;
    mySearchContractCLN_START_DRIVING_DATE: TDateField;
    mySearchContractCLN_STREET: TStringField;
    mySearchContractCLN_SURNAME: TStringField;
    mySearchContractCLN_TOWN: TStringField;
    mySearchContractCLN_USER_INSERT_NAME: TStringField;
    mySearchContractCLN_USER_UPDATE_NAME: TStringField;
    mySearchContractCLN_WRITER_NAME: TStringField;
    mySearchContractCNT_BASE_SUM: TFloatField;
    mySearchContractCNT_COMMENT: TStringField;
    mySearchContractCNT_DATE_BEGIN: TDateField;
    mySearchContractCNT_DATE_DOG_CREATE: TDateField;
    mySearchContractCNT_DATE_DOG_INPUT: TDateField;
    mySearchContractCNT_DATE_END: TDateField;
    mySearchContractCNT_DATE_INSERT: TDateField;
    mySearchContractCNT_DATE_START: TDateTimeField;
    mySearchContractCNT_DATE_UPDATE: TDateField;
    mySearchContractCNT_DATE_WRITE: TDateField;
    mySearchContractCNT_DOGNUMB: TStringField;
    mySearchContractCNT_DOG_SER: TStringField;
    mySearchContractCNT_END_USE: TDateField;
    mySearchContractCNT_END_USE1: TDateField;
    mySearchContractCNT_END_USE2: TDateField;
    mySearchContractCNT_ID_CAR: TStringField;
    mySearchContractCNT_ID_CLIENT: TStringField;
    mySearchContractCNT_ID_DOGOVOR: TStringField;
    mySearchContractCNT_ID_DOGOVOR_TYPE: TLongintField;
    mySearchContractCNT_ID_INSURANCE_CLASS: TLongintField;
    mySearchContractCNT_ID_INSURANCE_COMPANY: TLongintField;
    mySearchContractCNT_ID_PREV_DOG: TStringField;
    mySearchContractCNT_ID_TERRITORY_USE: TLongintField;
    mySearchContractCNT_INS_PREM: TFloatField;
    mySearchContractCNT_INS_SUM: TFloatField;
    mySearchContractCNT_KOEF_BONUSMALUS: TFloatField;
    mySearchContractCNT_KOEF_KN: TFloatField;
    mySearchContractCNT_KOEF_PERIOD_USE: TFloatField;
    mySearchContractCNT_KOEF_POWER: TFloatField;
    mySearchContractCNT_KOEF_SROK_INS: TFloatField;
    mySearchContractCNT_KOEF_STAG: TFloatField;
    mySearchContractCNT_KOEF_TER: TFloatField;
    mySearchContractCNT_KOEF_UNLIMITED: TFloatField;
    mySearchContractCNT_START_USE: TDateField;
    mySearchContractCNT_START_USE1: TDateField;
    mySearchContractCNT_START_USE2: TDateField;
    mySearchContractCNT_TRANSIT: TBooleanField;
    mySearchContractCNT_UNLIMITED_DRIVERS: TBooleanField;
    mySearchContractCNT_USER_INSERT_NAME: TStringField;
    mySearchContractCNT_USER_UPDATE_NAME: TStringField;
    mySearchContractCNT_ZNAK_NO: TStringField;
    mySearchContractCNT_ZNAK_SER: TStringField;
    mytbCarTypeCAR_TYPE: TStringField;
    mytbCarTypeID_CAR_TYPE: TLongintField;
    mytbSelf_info: TMyTable;
    myValuta: TMyQuery;
    myRegiones: TMyQuery;
    myClientTypeGroup: TMyQuery;
    myFamilyState: TMyQuery;
    myDocTypes: TMyQuery;
    myClientTypes: TMyQuery;
    myGetGroups: TMyQuery;
    myInsCompanies: TMyQuery;
    myGetBlankData: TMyQuery;
    myInsCompaniesADDRESS: TStringField;
    myInsCompaniesCOMMENTS: TStringField;
    myInsCompaniesFAX: TStringField;
    myInsCompaniesID_INSURANCE_COMPANY: TLongintField;
    myInsCompaniesINSURANCE_COMPANY: TStringField;
    myInsCompaniesPHONE: TStringField;
    mySex: TMyQuery;
    myMatchedClients: TMyQuery;
    myClient: TMyQuery;
    myCarTypeCAR_TYPE: TStringField;
    myCarTypeID_CAR_TYPE: TLongintField;
    myContract: TMyQuery;
    myconnMain: TMyConnection;
    datasrcCartype: TMyDataSource;
    myDrivers: TMyQuery;
    mySearchCar: TMyQuery;
    mySearchCarFULL_MODEL: TStringField;
    mySearchCarFULL_PTS: TStringField;
    mySearchClientFULL_ADDRESS: TStringField;
    mySearchClientFULL_DOC: TStringField;
    mySearchClientFULL_NAME: TStringField;
    mySearchContract: TMyQuery;
    myContractHistoryDOGNUMB: TStringField;
    myContractHistoryDOGOVOR_STATE: TStringField;
    myContractHistoryDOG_SER: TStringField;
    myContractHistoryEVENT_DATE: TDateField;
    myContractOpersHistory: TMyQuery;
    mySearchClient: TMyQuery;
    myPurposeType: TMyQuery;
    myCarModels: TMyQuery;
    myPurposeTypeID_PURPOSE_TYPE: TLongintField;
    myPurposeTypePURPOSE_TYPE: TStringField;
    mySearchContractFULL_ADDRESS: TStringField;
    mySearchContractFULL_MODEL: TStringField;
    mySearchContractFULL_NAME: TStringField;
    mySearchContractFULL_NUM: TStringField;
    mySexid_sex: TLongintField;
    mySexSEX_NAME: TStringField;
    myGetErrorCode: TMyQuery;
    myLastInsID: TMyQuery;
    myValutaID_VALUTA: TLongintField;
    myValutaID_VALUTA1: TLongintField;
    myValutaVALUTA_NAME: TStringField;
    myValutaVALUTA_NAME1: TStringField;
    procedure myCarModelsBeforeOpen(DataSet: TDataSet);
    procedure myCitiesBeforeOpen(DataSet: TDataSet);
    procedure myClientTypesBeforeOpen(DataSet: TDataSet);
    procedure myconnAddContractAfterConnect(Sender: TObject);
    procedure myconnMainAfterConnect(Sender: TObject);
    procedure myconnMainAfterDisconnect(Sender: TObject);
    procedure myconnsError(Sender: TObject; E: EDAError; var Fail: boolean);
    procedure myRegionesBeforeOpen(DataSet: TDataSet);
  private
    FOnDBError: TDAConnectionErrorEvent;
  private
    function GetConditionDelim(const use_and: boolean): string;
    // Возвращает разделитель, если строка не пуста
    function GCDIfNotEmpty(const use_and: boolean; const s: string): string;
  public
    // Обновляет Alerter, если такой ID в нём содержится.
    procedure CheckAlerter(const cln_id: variant; const cnt_id: variant;
      const force: boolean = false);
    function RemindClient(const cln_id: variant; const cnt_id: variant;
      const last_pay: boolean): boolean;
  public
    // Заменяет SQL на Insert/Update/Delete SQL, в зависимости от типа действия.
    function SQLAction(sql_comp: TMyQuery; const action_type: TActionType): TMyQuery;
  public
    function GetLastInsertID(): variant;
    function GetErrCode(const conn: TCustomConnection): integer;
    procedure GetCurUser(out user_host, user_name: string);
    function GetCurUser(): string;
    function GetCurUserFullName(): string;
    function GetAllUsers(): TDataSource;
    function GetCurUserInfo(): TDataSource;
    function SelfInfo(): TDataSet;
  public
    function ClearDriversList(): boolean;
    function AddDriver(const cln_id: variant): boolean;
  public
    function GetCarByID(const car_id: string): TDataSource;
    function GetClientByID(const cln_id: string): TDataSource;
    function GetContByID(const cnt_id: string): TDataSource;
    function GetContractHistory(const cnt_id: string): TDataSource;
    function GetPreparedChangeLog(): TDataSource;
    function GetDriversByContID(const cnt_id: string): TDataSource;
    function GetMatchedClients(const cln_id: string): TDataSource;
    function GetFreeBlanks(const ins_cmp_id, host, user: string): TDataSource;
  public
    // surname - фамилия для физ. лица или название для юридического
    // name также является inn для юр. лица (проверка по client_type_group)
    procedure FindClient(const surname, cname, pathronimyc, doc_ser, doc_num,
      license_ser, license_num, client_type_group, doc_type,
      town, street, home, corpus, flat: string;
      use_and: boolean = false);
    procedure FindCar(const cln_surname, cln_name, cln_pathronimyc,
      cln_license_ser, cln_license_num, client_type_group: string;
      const vin, chassi_num, kusov_num, reg_num, pts_ser, pts_num, pts_date,
      id_carmark: string; use_and: boolean);
    procedure FindContract(const cln_surname, cln_name, cln_pathronimyc,
      cln_license_ser, cln_license_num, client_type_group: string;
      const cln_doc_ser, cln_doc_num, cln_doc_type: string;
      const car_vin, car_chassi_num, car_kusov_num, car_reg_num: string;
      const polis_ser, polis_num: string; use_and: boolean);
  public
    procedure SetConnectionParams(const host_name, host_port, db_name, login,
      pasw: string);
  public
    property OnDBError: TDAConnectionErrorEvent read FOnDBError write FOnDBError;
  end; 

var
  dmData: TdmData;

implementation

const
  sc_car_fields = 'car.ARENDA as CAR_ARENDA, ' +
    'car.ID_CAR as CAR_ID_CAR, ' +
    'car.ID_PURPOSE_TYPE as CAR_ID_PURPOSE_TYPE, ' +
    'car.ID_CAR_TYPE as CAR_ID_CAR_TYPE, ' +
    'car.ID_PRODUCTER_TYPE as CAR_ID_PRODUCTER_TYPE, ' +
    'car.ID_CLIENT as CAR_ID_CLIENT, ' +
    'car.PTS_DATE as CAR_PTS_DATE, ' +
    'car.DATE_INSERT as CAR_DATE_INSERT, ' +
    'car.CAR_MARK as CAR_CAR_MARK, ' +
    'car.DATE_UPDATE as CAR_DATE_UPDATE, ' +
    'car.CAR_MODEL as CAR_CAR_MODEL, ' +
    'car.VIN_NUM as CAR_VIN_NUM, ' +
    'car.YEAR_ISSUE as CAR_YEAR_ISSUE, ' +
    'car.POWER_KVT as CAR_POWER_KVT, ' +
    'car.POWER_LS as CAR_POWER_LS, ' +
    'car.MAX_KG as CAR_MAX_KG, ' +
    'car.NUM_PLACES as CAR_NUM_PLACES, ' +
    'car.SHASSI as CAR_SHASSI, ' +
    'car.KUSOV as CAR_KUSOV, ' +
    'car.GOS_NUM as CAR_GOS_NUM, ' +
    'car.PTS_SER as CAR_PTS_SER, ' +
    'car.PTS_NO as CAR_PTS_NO, ' +
    'car.FOREING as CAR_FOREING, ' +
    'car.COMMENTS as CAR_COMMENTS, ' +
    'car.USER_INSERT_NAME as CAR_USER_INSERT_NAME, ' +
    'car.USER_UPDATE_NAME as CAR_USER_UPDATE_NAME ';

  sc_cln_fields = 'client.ID_CLIENT as CLN_ID_CLIENT, ' +
    'client.SURNAME as CLN_SURNAME, ' +
    'client.NAME as CLN_NAME, ' +
    'client.MIDDLENAME as CLN_MIDDLENAME, ' +
    'client.INN as CLN_INN, ' +
    'client.DOC_SER as CLN_DOC_SER, ' +
    'client.POSTINDEX as CLN_POSTINDEX, ' +
    'client.BIRTHDAY as CLN_BIRTHDAY, ' +
    'client.ID_CITY as CLN_ID_CITY, ' +
    'client.ID_REGION as CLN_ID_REGION, ' +
    'client.ID_COUNTRY as CLN_ID_COUNTRY, ' +
    'client.TOWN as CLN_TOWN, ' +
    'client.STREET as CLN_STREET, ' +
    'client.HOME as CLN_HOME, ' +
    'client.KORPUS as CLN_KORPUS, ' +
    'client.FLAT as CLN_FLAT, ' +
    'client.HOME_PHONE as CLN_HOME_PHONE, ' +
    'client.DOC_NUM as CLN_DOC_NUM, ' +
    'client.ID_SEX as CLN_ID_SEX, ' +
    'client.ID_FAMILY_STATE as CLN_ID_FAMILY_STATE, ' +
    'client.ID_CLIENT_TYPE as CLN_ID_CLIENT_TYPE, ' +
    'client.ID_TYPE_DOC as CLN_ID_TYPE_DOC, ' +
    'client.GROSS_VIOLATIONS as CLN_GROSS_VIOLATIONS, ' +
    'client.ID_INSURANCE_CLASS as CLN_ID_INSURANCE_CLASS, ' +
    'client.LICENCE_SER as CLN_LICENCE_SER, ' +
    'client.LICENCE_NO as CLN_LICENCE_NO, ' +
    'client.START_DRIVING_DATE as CLN_START_DRIVING_DATE, ' +
    'client.DATE_INSERT as CLN_DATE_INSERT, ' +
    'client.DATE_UPDATE as CLN_DATE_UPDATE, ' +
    'client.WRITER_NAME as CLN_WRITER_NAME, ' +
    'client.ID_TYPE_LOSSED as CLN_ID_TYPE_LOSSED, ' +
    'client.CELL_PHONE as CLN_CELL_PHONE, ' +
    'client.BUSINESS_PHONE as CLN_BUSINESS_PHONE, ' +
    'client.LAST_CALL_DATE as CLN_LAST_CALL_DATE, ' +
    'client.COMMENTS as CLN_COMMENTS, ' +
    'client.USER_INSERT_NAME as CLN_USER_INSERT_NAME, ' +
    'client.USER_UPDATE_NAME as CLN_USER_UPDATE_NAME ';

  sc_cnt_fields = 'dogovor.ID_DOGOVOR as CNT_ID_DOGOVOR, ' +
    'dogovor.DOG_SER as CNT_DOG_SER, ' +
    'dogovor.DOGNUMB as CNT_DOGNUMB, ' +
    'dogovor.DATE_DOG_CREATE as CNT_DATE_DOG_CREATE, ' +
    'dogovor.DATE_DOG_INPUT as CNT_DATE_DOG_INPUT, ' +
    'dogovor.DATE_START as CNT_DATE_START, ' +
    'dogovor.DATE_END as CNT_DATE_END, ' +
    'dogovor.START_USE as CNT_START_USE, ' +
    'dogovor.END_USE as CNT_END_USE, ' +
    'dogovor.START_USE1 as CNT_START_USE1, ' +
    'dogovor.END_USE1 as CNT_END_USE1, ' +
    'dogovor.START_USE2 as CNT_START_USE2, ' +
    'dogovor.END_USE2 as CNT_END_USE2, ' +
    'dogovor.ZNAK_SER as CNT_ZNAK_SER, ' +
    'dogovor.ZNAK_NO as CNT_ZNAK_NO, ' +
    'dogovor.COMMENT as CNT_COMMENT, ' +
    'dogovor.ID_CLIENT as CNT_ID_CLIENT, ' +
    'dogovor.ID_DOGOVOR_TYPE as CNT_ID_DOGOVOR_TYPE, ' +
    'dogovor.ID_INSURANCE_COMPANY as CNT_ID_INSURANCE_COMPANY, ' +
    'dogovor.TRANSIT as CNT_TRANSIT, ' +
    'dogovor.ID_CAR as CNT_ID_CAR, ' +
    'dogovor.ID_TERRITORY_USE as CNT_ID_TERRITORY_USE, ' +
    'dogovor.UNLIMITED_DRIVERS as CNT_UNLIMITED_DRIVERS, ' +
    'dogovor.INS_SUM as CNT_INS_SUM, ' +
    'dogovor.INS_PREM as CNT_INS_PREM, ' +
    'dogovor.KOEF_TER as CNT_KOEF_TER, ' +
    'dogovor.KOEF_BONUSMALUS as CNT_KOEF_BONUSMALUS, ' +
    'dogovor.KOEF_STAG as CNT_KOEF_STAG, ' +
    'dogovor.KOEF_UNLIMITED as CNT_KOEF_UNLIMITED, ' +
    'dogovor.KOEF_POWER as CNT_KOEF_POWER, ' +
    'dogovor.KOEF_PERIOD_USE as CNT_KOEF_PERIOD_USE, ' +
    'dogovor.KOEF_SROK_INS as CNT_KOEF_SROK_INS, ' +
    'dogovor.KOEF_KN as CNT_KOEF_KN, ' +
    'dogovor.BASE_SUM as CNT_BASE_SUM, ' +
    'dogovor.ID_INSURANCE_CLASS as CNT_ID_INSURANCE_CLASS, ' +
    'dogovor.DATE_WRITE as CNT_DATE_WRITE, ' +
    'dogovor.DATE_BEGIN as CNT_DATE_BEGIN, ' +
    'dogovor.ID_PREV_DOG as CNT_ID_PREV_DOG, ' +
    'dogovor.TICKET_SER as CNT_TICKET_SER, ' +
    'dogovor.TICKET_NUM as CNT_TICKET_NUM, ' +
    'dogovor.TICKET_DATE as CNT_TICKET_DATE, ' +
    'dogovor.DATE_INSERT as CNT_DATE_INSERT, ' +
    'dogovor.DATE_UPDATE as CNT_DATE_UPDATE, ' +
    'dogovor.USER_INSERT_NAME as CNT_USER_INSERT_NAME, ' +
    'dogovor.USER_UPDATE_NAME as CNT_USER_UPDATE_NAME ';

  sc_full_address =
    'CONCAT_WS(", ", ' +
    'if(client.town = '''', null, client.town), ' +
    'if(client.street = '''', null, client.street), ' +
    'if(client.home = '''', null, client.home), ' +
    'if(client.korpus = '''', null, client.korpus), ' +
    'if(client.flat = '''', null, client.flat)) ' +
    'as FULL_ADDRESS ';
  sc_full_name =
    'CONCAT_WS(" ", client.surname, client.name, client.middlename) ' +
    'as FULL_NAME ';

procedure TdmData.myconnMainAfterConnect(Sender: TObject);
begin
  myClientTypes.Open();
  myCarType.Open();
  myCarModels.Open();
  mySex.Open();
  myInsCompanies.Open();
  myDocTypes.Open();
  myFamilyState.Open();
  myClientTypeGroup.Open();
  myAlerter.Open();
  myconnAddContract.Connect();
end;
//---------------------------------------------------------------------------
procedure TdmData.myconnAddContractAfterConnect(Sender: TObject);
begin
  mycAddCntParams.Execute;
end;
//---------------------------------------------------------------------------
procedure TdmData.myconnMainAfterDisconnect(Sender: TObject);
begin
  myconnAddContract.Disconnect();
  myconnAddContract.Assign(myconnMain);
end;
//---------------------------------------------------------------------------
procedure TdmData.myconnsError(Sender: TObject; E: EDAError;
  var Fail: boolean);
begin
  Fail := E.IsFatalError;
  if (Assigned(FOnDBError)) then FOnDBError(Sender, E, Fail);
end;
//---------------------------------------------------------------------------
procedure TdmData.SetConnectionParams(const host_name, host_port, db_name, login, pasw: string);
begin
  with myconnMain do
    begin
      Disconnect();
      Server    := host_name;
      Port      := StrToInt(host_port);
      Database  := db_name;
      Username  := login;
      Password  := pasw;
    end;
  myconnAddContract.Assign(myconnMain);
end;
//---------------------------------------------------------------------------
procedure TdmData.myClientTypesBeforeOpen(DataSet: TDataSet);
begin
  // Источник для lookup поля должен быть включен перед активацией
  // набора данных
  with (DataSet.FieldByName('FL_CLIENT_TYPE_GROUP').LookupDataSet) do
    begin
      Open();
      First();
    end;
end;
//---------------------------------------------------------------------------
procedure TdmData.myRegionesBeforeOpen(DataSet: TDataSet);
begin
  with (DataSet.FieldByName('FL_COUNTRY').LookupDataSet) do
    begin
      Open();
      First();
    end;
end;
//---------------------------------------------------------------------------
procedure TdmData.myCitiesBeforeOpen(DataSet: TDataSet);
begin
  with (DataSet) do
    begin
      // Зависит от порядка. Глючит. Тварь.
      FieldByName('FL_REGION').LookupDataSet.Open();
      FieldByName('FL_REGION').LookupDataSet.First();
      FieldByName('FL_GEO_GROUP').LookupDataSet.Open();
      FieldByName('FL_GEO_GROUP').LookupDataSet.First();
      FieldByName('FL_COUNTRY').LookupDataSet.Open();
      FieldByName('FL_COUNTRY').LookupDataSet.First();
    end;
end;
//---------------------------------------------------------------------------
procedure TdmData.myCarModelsBeforeOpen(DataSet: TDataSet);
begin
  with (DataSet) do
    begin
      FieldByName('FL_CARMARK').LookupDataSet.Open();
      FieldByName('FL_CARMARK').LookupDataSet.First();
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetCarByID(const car_id: string): TDataSource;
begin
  Result := datasrcCar;
  with myCar do
    begin
      Close();
      ParamByName('car_id').AsString := car_id;
      Open();
      First();
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetClientByID(const cln_id: string): TDataSource;
begin
  Result := datasrcClient;
  with myClient do
    begin
      Close();
      ParamByName('client_id').AsString := cln_id;
      Open();
      First();
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetContByID(const cnt_id: string): TDataSource;
begin
  Result := datasrcContract;
  with myContract do
    begin
      Close();
      ParamByName('dog_id').AsString := cnt_id;
      Open();
      First();
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetContractHistory(const cnt_id: string): TDataSource;
begin
  Result := datasrcContractHistory;
  with myContractHistory do
    begin
      Close();
      ParamByName('v_id_dogovor').AsString := cnt_id;
      Open();
      First();
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetPreparedChangeLog(): TDataSource;
begin
  Result := datasrcChangeLog;
  with myGetChangeLog do
    begin
      Close();
      Open();
      First();
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetDriversByContID(const cnt_id: string): TDataSource;
begin
  Result := datasrcDriver;
  with myDrivers do
    begin
      Close();
      ParamByName('contract_id').AsString := cnt_id;
      Open();
      First();
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetMatchedClients(const cln_id: string): TDataSource;
begin
  Result := datasrcMatchedClns;
  with myMatchedClients do
    begin
      Close();
      ParamByName('cln_id').AsString := cln_id;
      Open();
      First();
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetFreeBlanks(const ins_cmp_id, host, user: string): TDataSource;
begin
  Result := datasrcFreeBlanks;
  with (myFreeBlanks) do
    begin
      Close();
      ParamByName('id_ins_comp').AsString := ins_cmp_id;
      ParamByName('host').AsString        := host;
      ParamByName('user').AsString        := user;
      Open();
      First();
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetConditionDelim(const use_and: boolean): string;
begin
  if (use_and) then result := ' and '
  else result := ' or ';
end;
//---------------------------------------------------------------------------
function TdmData.GCDIfNotEmpty(const use_and: boolean; const s: string): string;
begin
  if (s = EmptyStr) then result := EmptyStr
  else result := GetConditionDelim(use_and);
end;
//---------------------------------------------------------------------------
procedure TdmData.CheckAlerter(const cln_id: variant; const cnt_id: variant;
  const force: boolean);
begin
  with myAlerter do
    begin
      if (not Active) then
        begin
          Open();
          exit;
        end;
      if (force or
          Locate('CLN_ID_CLIENT', VarArrayOf([cln_id]), []) or
          Locate('CNT_ID_DOGOVOR', VarArrayOf([cnt_id]), [])) then
        begin
          Close();
          Open();
        end;
    end;
end;
//---------------------------------------------------------------------------
function TdmData.RemindClient(const cln_id: variant; const cnt_id: variant;
  const last_pay: boolean): boolean;
begin
  with myClnRemind do
    begin
      ParamByName('v_id_client').AsString   := VarToStr(cln_id);
      ParamByName('v_id_dogovor').AsString  := VarToStr(cnt_id);
      ParamByName('v_last_pay').AsBoolean   := last_pay;
      ExecProc();
      Result := GetErrCode(Connection) = 0;
    end;
end;
//---------------------------------------------------------------------------
function TdmData.SQLAction(sql_comp: TMyQuery; const action_type: TActionType):
  TMyQuery;
begin
  Result := sql_comp;
  if (Result = nil) then exit;
  case action_type of
    atExec: ;
    atInsert: sql_comp.SQL.Assign(sql_comp.SQLInsert);
    atUpdate: sql_comp.SQL.Assign(sql_comp.SQLUpdate);
    atDelete: sql_comp.SQL.Assign(sql_comp.SQLDelete);
  end;
end;
//---------------------------------------------------------------------------
function TdmData.GetLastInsertID(): variant;
begin
  with myLastInsID do
    begin
      Close();
      Open();
      // Полагаю, что хранится результат в переменной @ent_ins_id, куда я его
      // сохраняю в запросах.
      Result := FieldByName('liid').AsVariant;
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetErrCode(const conn: TCustomConnection): integer;
begin
  // Во всех вызовах процедур я помещаю код возврата в переменную err_code.
  with myGetErrorCode do
    begin
      Close();
      Connection := conn as TMyConnection;
      Open();
      Result := FieldByName('error_code').AsInteger;
    end;
end;
//---------------------------------------------------------------------------
procedure TdmData.GetCurUser(out user_host, user_name: string);
begin
  with myGetCurUser do
    begin
      Active    := true;
      user_host := FieldByName('@host_name').AsString;
      user_name := FieldByName('@user_name').AsString;
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetCurUser(): string;
var uh: string;
begin
  GetCurUser(uh, Result);
end;
//---------------------------------------------------------------------------
function TdmData.GetCurUserFullName(): string;
begin
  with myGetUserFullName do
    begin
      //Close();
      Open();
      Result := FieldByName('FullName').AsString;
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetAllUsers(): TDataSource;
begin
  Result := datasrcAllUsers;
  with myGetAllUsers do
    begin
      Close();
      // SQL.Text := 'call UserGetAll();';
      // SQL.Text := 'select * from all_users;';
      try
        Open();
        First();
      except
        LogException('TdmData.GetAllUsers:');
      end;
    end;
end;
//---------------------------------------------------------------------------
function TdmData.GetCurUserInfo(): TDataSource;
begin
  Result := datasrcCurUser;
  with myGetCurUserInfo do
    begin
      Close();
      Open();
    end;
end;
//---------------------------------------------------------------------------
function TdmData.SelfInfo(): TDataSet;
begin
  Result := mytbSelf_info;
  with mytbSelf_info do
    begin
      Active := true;
      Refresh();
    end;
end;
//---------------------------------------------------------------------------
function TdmData.ClearDriversList(): boolean;
begin
  myProcDrvsClear.ExecProc;
  Result := GetErrCode(myProcDrvsClear.Connection) = 0;
end;
//---------------------------------------------------------------------------
function TdmData.AddDriver(const cln_id: variant): boolean;
begin
  myProcDrvAdd.ParamByName('v_id_client').AsString := VarToStr(cln_id);
  myProcDrvAdd.Execute();
  Result := GetErrCode(myProcDrvAdd.Connection) = 0;
end;
//---------------------------------------------------------------------------
procedure TdmData.FindClient(const surname, cname, pathronimyc, doc_ser,
  doc_num, license_ser, license_num, client_type_group, doc_type,
  town, street, home, corpus, flat: string;
  use_and: boolean);
var tmp_str: string;
    // Флаг взводится тогда, когда нужен разделитель между условиями запроса
    q_before: boolean;
begin
  // select *
  // from client
  // join insurance_class
  // on client.ID_INSURANCE_CLASS = insurance_class.ID_INSURANCE_CLASS
  // join client_types on client_types.ID_CLIENT_TYPE_GROUP = ...
  //  and client_types.ID_CLIENT_TYPE = client.ID_CLIENT_TYPE
  // where SURNAME like ...
  // and/or ((DOC_SER like ... ) and ID_TYPE_DOC = ...)
  // and/or TOWN like ...
  // order by CLN_SURNAME asc;

  tmp_str  := EmptyStr;
  q_before := false;
  with mySearchClient do
    begin
      Close();
      SQL.Clear();
      // Формирую основной запрос на поиск
      SQL.Clear();
      SQL.Add('select ' + sc_cln_fields +
        ', CONCAT_WS(" ", DOC_SER, DOC_NUM) as FULL_DOC, ' +
        sc_full_name + ', ' + sc_full_address +
        #13'from client left join insurance_class on ' +
        'client.ID_INSURANCE_CLASS = insurance_class.ID_INSURANCE_CLASS ');

      SQL.Add(Format('join client_types on ' +
        'client_types.ID_CLIENT_TYPE_GROUP = %s ' +
        'and client_types.ID_CLIENT_TYPE = client.ID_CLIENT_TYPE ',
        [EncodeCString(client_type_group)])
      );

      SQL.Add('where ');

      if (surname <> EmptyStr) then tmp_str := 'SURNAME like ''%' +
        EncodeCString(surname) + '%'' ';
      // Группа задана жёстко. 1 - физ лицо. 2 - юр. лицо.
      if (client_type_group = IntToStr(ind_person)) then
        begin
          if (cname <> EmptyStr) then tmp_str := tmp_str +
            GCDIfNotEmpty(use_and, tmp_str) + 'NAME like ''%' +
            EncodeCString(cname) + '%'' ';
          if (pathronimyc <> EmptyStr) then tmp_str := tmp_str +
            GCDIfNotEmpty(use_and, tmp_str) + 'MIDDLENAME like ''%' +
            EncodeCString(pathronimyc) + '%'' ';
          FieldByName('FULL_NAME').DisplayLabel := SysToUtf8(cls_surname);
          FieldByName('CLN_INN').Visible        := false;
        end
      else
        begin
          if (cname <> EmptyStr) then tmp_str := tmp_str +
            GCDIfNotEmpty(use_and, tmp_str) + 'INN like ''%' +
            EncodeCString(cname) + '%'' ';
          FieldByName('FULL_NAME').DisplayLabel := SysToUtf8(cls_title);
          FieldByName('CLN_INN').Visible        := true;
        end;
      // ((surname like ... or name like .. or ...)
      // and (client_types.ID_CLIENT_TYPE_GROUP = :client_type_group
      // and client_types.ID_CLIENT_TYPE = client.ID_CLIENT_TYPE))
      if (tmp_str <> EmptyStr) then
        begin
          SQL.Add(Format('(%s) ', [tmp_str]));
          tmp_str   := EmptyStr;
          q_before  := true;
        end;

      if (doc_ser <> EmptyStr) then tmp_str := 'DOC_SER like ''%' +
        EncodeCString(doc_ser) + '%'' ';
      if (doc_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'DOC_NUM like ''%' +
        EncodeCString(doc_num) + '%'' ';

      // or ((doc_ser like ... or doc_num like) and ID_TYPE_DOC = ...)
      if (tmp_str <> EmptyStr) then
        begin
          if (q_before) then SQL.Add(GetConditionDelim(use_and));
          SQL.Add(Format('((%s) and ID_TYPE_DOC = %s) ', [tmp_str,
            EncodeCString(doc_type)]));
          tmp_str   := EmptyStr;
          q_before  := true;
        end;

      if (license_ser <> EmptyStr) then tmp_str := 'LICENCE_SER like ''%' +
        EncodeCString(license_ser) + '%'' ';
      if (license_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'LICENCE_NO like ''%' +
        EncodeCString(license_num) + '%'' ';

      // or (license_ser like ... or license_no like)
      if (tmp_str <> EmptyStr) then
        begin
          if (q_before) then SQL.Add(GetConditionDelim(use_and));
          SQL.Add(Format('(%s) ', [tmp_str]));
          tmp_str   := EmptyStr;
          q_before  := true;
        end;

      if (town <> EmptyStr) then tmp_str := 'TOWN like ''%' +
        EncodeCString(town) + '%'' ';
      if (street <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'STREET like ''%' +
        EncodeCString(street) + '%'' ';
      if (home <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'HOME like ''%' +
        EncodeCString(home) + '%'' ';
      if (corpus <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'KORPUS like ''%' +
        EncodeCString(corpus) + '%'' ';
      if (flat <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'FLAT like ''%' +
        EncodeCString(flat) + '%'' ';

      // or (town like ... or street like or ...)
      if (tmp_str <> EmptyStr) then
        begin
          if (q_before) then SQL.Add(GetConditionDelim(use_and));
          SQL.Add(Format('(%s) ', [tmp_str]));
          tmp_str   := EmptyStr;
          q_before  := true;
        end;

      SQL.Add('order by CLN_SURNAME asc');
      {$IFDEF DEBUG}
      logger.Debug('data_unit.FindClient: '#13 + SQL.Text);
      {$ENDIF}
      // Запрос пустой
      if (not q_before) then SQL.Clear()
      else Open();
    end;
end;
//---------------------------------------------------------------------------
procedure TdmData.FindCar(const cln_surname, cln_name, cln_pathronimyc,
  cln_license_ser, cln_license_num, client_type_group: string;
  const vin, chassi_num, kusov_num, reg_num, pts_ser, pts_num, pts_date,
  id_carmark: string; use_and: boolean);
var tmp_str: string;
    // Флаг взводится тогда, когда нужен разделитель между условиями запроса
    q_before: boolean;
    client_query: TStringList;
begin
  // Алгоритм поиска:
  //   1.) Выбрать из таблицы client ID_CLIENT для клиентов с нужными данными.
  //   2.) Выбрать из таблицы car все столбцы в которых ID_CLIENT и/или другие
  //     данные совпадают с заданными.
  // Условие 1:
  //   select car.ID_CAR, car.ID_CLIENT from car join client
  //   on (car.ID_CLIENT = client.ID_CLIENT) and (SURNAME like '%ав%'
  //   and/or LICENCE_SER like cln_license_ser ... )
  //   join client_types on (client_types.ID_CLIENT_TYPE_GROUP = ... and
  //   client_types.ID_CLIENT_TYPE = client.ID_CLIENT_TYPE)
  //
  // Условие 2:
  //   select car.ID_CAR, car.ID_CLIENT from car where
  //     vin like ... and/or chassi_num like ... and/or ...
  //     and/or car.ID_CLIENT in (Запрос 2);
  //
  // Запрос 1:
  //   select * from
  //   (
  //    Условие 1
  //    union
  //    Условие 2
  //   ) subq
  //   join car on car.ID_CAR = subq.ID_CAR
  //   join client on client.ID_CLIENT = subq.ID_CLIENT
  //   join carmark on car.CAR_MARK = carmark.ID_CARMARK
  //   join car_type on car.ID_CAR_TYPE = car_type.ID_CAR_TYPE
  //   join purpose_type on car.ID_PURPOSE_TYPE = purpose_type.ID_PURPOSE_TYPE;
  tmp_str      := EmptyStr;
  q_before     := false;
  client_query := TStringList.Create;
  try
  with mySearchCar do
    begin
      // Формирую запрос на поиск в таблице клиентов
      client_query.Add('select car.ID_CAR, car.ID_CLIENT from car '#13 +
        'join client on (car.ID_CLIENT = client.ID_CLIENT) and (');
      if (cln_surname <> EmptyStr) then
        tmp_str := 'SURNAME like ''%' + EncodeCString(cln_surname) + '%'' ';
      // Группа задана жёстко. 1 - физ лицо. 2 - юр. лицо.
      if (client_type_group = IntToStr(ind_person)) then
        begin
          if (cln_name <> EmptyStr) then tmp_str := tmp_str +
            GCDIfNotEmpty(use_and, tmp_str) + 'NAME like ''%' +
            EncodeCString(cln_name) + '%'' ';
          if (cln_pathronimyc <> EmptyStr) then tmp_str := tmp_str +
            GCDIfNotEmpty(use_and, tmp_str) + 'MIDDLENAME like ''%' +
            EncodeCString(cln_pathronimyc) + '%'' ';
        end
      else
        begin
          if (cln_name <> EmptyStr) then tmp_str := tmp_str +
            GCDIfNotEmpty(use_and, tmp_str) + 'INN like ''%' +
            EncodeCString(cln_name) + '%'' ';
        end;

      // ((surname like ... or name like .. or ...)
      if (tmp_str <> EmptyStr) then
        begin
          if (q_before) then client_query.Add(GCDIfNotEmpty(use_and, tmp_str));
          client_query.Add(Format('%s ', [tmp_str]));
          tmp_str   := EmptyStr;
          q_before  := true;
        end;

      if (cln_license_ser <> EmptyStr) then
        tmp_str := 'LICENCE_SER like ''%' +
        EncodeCString(cln_license_ser) + '%'' ';
      if (cln_license_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'LICENCE_NO like ''%' +
        EncodeCString(cln_license_num) + '%'' ';

      // or (license_ser like ... or license_no like)
      if (tmp_str <> EmptyStr) then
        begin
          if (q_before) then client_query.Add(GCDIfNotEmpty(use_and, tmp_str));
          client_query.Add(Format('%s ', [tmp_str]));
          tmp_str   := EmptyStr;
          q_before  := true;
        end;

      // join client_types on client_types.ID_CLIENT_TYPE_GROUP = ...
      // and client_types.ID_CLIENT_TYPE = client.ID_CLIENT_TYPE
      if (q_before) then
        begin
          client_query.Add(
            Format(') join client_types on ' +
              'client_types.ID_CLIENT_TYPE_GROUP = %s ' +
              'and client_types.ID_CLIENT_TYPE = client.ID_CLIENT_TYPE ',
            [EncodeCString(client_type_group)])
          );
          tmp_str   := EmptyStr;
          q_before  := true;
        end;

      // Клиентский запрос пуст
      if (not q_before) then client_query.Clear();

      // Формирую основной запрос на поиск
      tmp_str  := EmptyStr;
      q_before := false;
      Close();
      SQL.Clear();
      SQL.Add('select ' + sc_car_fields + ', ' + sc_cln_fields +
        ', CONCAT_WS(" ", carmark.MARK, car.CAR_MODEL) ' +
        'as FULL_MODEL, CONCAT_WS(" ", PTS_SER, PTS_NO) as FULL_PTS, ' +
        sc_full_name + ', ' + sc_full_address +
        'from ');

      if (vin <> EmptyStr) then tmp_str := 'VIN_NUM like ''%' +
        EncodeCString(vin) + '%'' ';
      if (chassi_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'SHASSI like ''%' +
        EncodeCString(chassi_num) + '%'' ';
      if (kusov_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'KUSOV like ''%' +
        EncodeCString(kusov_num) + '%'' ';
      if (reg_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'GOS_NUM like ''%' +
        EncodeCString(reg_num) + '%'' ';
      if (pts_ser <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'PTS_SER like ''%' +
        EncodeCString(pts_ser) + '%'' ';
      if (pts_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'PTS_NO like ''%' +
        EncodeCString(pts_num) + '%'' ';
      if (pts_date <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'PTS_DATE like ''%' +
        EncodeCString(pts_date) + '%'' ';

      // Определяю запрос по наличию или отсутствию условий.
      if ((client_query.Count > 0) or (tmp_str <> EmptyStr)) then
        begin
          // Есть условия.
          q_before := false;
          SQL.Add('(');
          if (client_query.Count > 0) then
            begin
              SQL.AddStrings(client_query);
              q_before := true;
            end;
          if (tmp_str <> EmptyStr) then
            begin
              if (q_before) then SQL.Add('union ');
              SQL.Add('select car.ID_CAR, car.ID_CLIENT from car where ');
              SQL.Add(Format('%s ', [tmp_str]));
              tmp_str   := EmptyStr;
              q_before  := true;
            end;
          SQL.Add(') subq ');
        end
      else q_before := false;

      if (q_before) then
        SQL.Add('join car on car.ID_CAR = subq.ID_CAR '#13 +
          'join client on client.ID_CLIENT = subq.ID_CLIENT '#13 +
          'join carmark on car.CAR_MARK = carmark.ID_CARMARK '#13 +
          'join car_type on car.ID_CAR_TYPE = car_type.ID_CAR_TYPE '#13 +
          'join purpose_type on car.ID_PURPOSE_TYPE = purpose_type.ID_PURPOSE_TYPE '#13);

      {$IFDEF DEBUG}
      logger.Debug('data_unit.FindCar: '#13 + SQL.Text);
      {$ENDIF}
      // Запрос пустой
      if (not q_before) then SQL.Clear()
      else Open();
    end;
  finally
    client_query.Free;
  end;
end;
//---------------------------------------------------------------------------
procedure TdmData.FindContract(const cln_surname, cln_name, cln_pathronimyc,
  cln_license_ser, cln_license_num, client_type_group: string;
  const cln_doc_ser, cln_doc_num, cln_doc_type: string;
  const car_vin, car_chassi_num, car_kusov_num, car_reg_num: string;
  const polis_ser, polis_num: string; use_and: boolean);
var tmp_str: string;
    // Флаг взводится тогда, когда нужен разделитель между условиями запроса
    q_before: boolean;
    // Сюда сохраняется запрос из таблицы client
    client_query: TStringList;
    // из таблицы car
    car_query: TStringList;
begin
  // Алгоритм поиска:
  //   1.) Выбрать из таблицы client ID_CLIENT для клиентов с нужными данными.
  //   2.) Выбрать из таблицы car ID_CAR для ТС с нужными данными.
  //   3.) Выбрать из таблицы dogvor все столбцы в которых ID_CLIENT, ID_CAR
  //     и/или другие данные совпадают с заданными.
  // Условие 1:
  //  select
  //    dogovor.ID_DOGOVOR as CNT_ID,
  //    dogovor.ID_CAR as CAR_ID,
  //    dogovor.ID_CLIENT as CLN_ID
  //    from dogovor
  //      join client on (dogovor.ID_CLIENT = client.ID_CLIENT) and
  //        (SURNAME like '%Иванов%' or/and ...)
  //        join client_types on client_types.ID_CLIENT_TYPE_GROUP = ...
  //        and client_types.ID_CLIENT_TYPE = client.ID_CLIENT_TYPE
  //
  // Условие 2:
  //   select
  //   dogovor.ID_DOGOVOR as CNT_ID,
  //   dogovor.ID_CAR as CAR_ID,
  //   dogovor.ID_CLIENT as CLN_ID
  //   from dogovor
  //     join car on (dogovor.ID_CAR = car.ID_CAR) and
  //     (vin like ... and/or chassi_num like ... and/or ... )
  //
  // Условие 3:
  //   select
  //   dogovor.ID_DOGOVOR as CNT_ID,
  //   dogovor.ID_CAR as CAR_ID,
  //   dogovor.ID_CLIENT as CLN_ID
  //   from dogovor where dogovor.DOGNUMB like ... and/or ...
  //
  // Запрос 3:
  //   select *
  //     from
  //        (Условие 1
  //         union
  //         Условие 2
  //         union
  //         Условие 3)
  //     subq
  //     join dogovor on dogovor.ID_DOGOVOR = subq.CNT_ID
  //     join car on car.ID_CAR = subq.CAR_ID
  //     join client on client.ID_CLIENT = subq.CLN_ID
  //     join car_type on car.ID_CAR_TYPE = car_type.ID_CAR_TYPE
  //     join carmark on carmark.ID_CARMARK = car.CAR_MARK;
  tmp_str      := EmptyStr;
  q_before     := false;
  car_query    := nil;
  client_query := TStringList.Create;
  try
  car_query    := TStringList.Create;

  with mySearchContract do
    begin
      // Формирую запрос на поиск в таблице клиентов.
      client_query.Add('select dogovor.ID_DOGOVOR as CNT_ID, ' +
        'dogovor.ID_CAR as CAR_ID, dogovor.ID_CLIENT as CLN_ID ' +
        'from dogovor join client on ' +
        '(dogovor.ID_CLIENT = client.ID_CLIENT) and (');

      if (cln_surname <> EmptyStr) then
        tmp_str := 'SURNAME like ''%' + EncodeCString(cln_surname) + '%'' ';
      // Группа задана жёстко. 1 - физ лицо. 2 - юр. лицо.
      if (client_type_group = IntToStr(ind_person)) then
        begin
          if (cln_name <> EmptyStr) then tmp_str := tmp_str +
            GCDIfNotEmpty(use_and, tmp_str) + 'NAME like ''%' +
            EncodeCString(cln_name) + '%'' ';
          if (cln_pathronimyc <> EmptyStr) then tmp_str := tmp_str +
            GCDIfNotEmpty(use_and, tmp_str) + 'MIDDLENAME like ''%' +
            EncodeCString(cln_pathronimyc) + '%'' ';
        end
      else
        begin
          if (cln_name <> EmptyStr) then tmp_str := tmp_str +
            GCDIfNotEmpty(use_and, tmp_str) + 'INN like ''%' +
            EncodeCString(cln_name) + '%'' ';
        end;

      // ((surname like ... or name like .. or ...)
      if (tmp_str <> EmptyStr) then
        begin
          if (q_before) then client_query.Add(GCDIfNotEmpty(use_and, tmp_str));
          client_query.Add(Format('%s ', [tmp_str]));
          tmp_str   := EmptyStr;
          q_before  := true;
        end;

      if (cln_license_ser <> EmptyStr) then
        tmp_str := 'LICENCE_SER like ''%' +
        EncodeCString(cln_license_ser) + '%'' ';
      if (cln_license_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'LICENCE_NO like ''%' +
        EncodeCString(cln_license_num) + '%'' ';

      // or (license_ser like ... or license_no like)
      if (tmp_str <> EmptyStr) then
        begin
          if (q_before) then client_query.Add(GCDIfNotEmpty(use_and, tmp_str));
          client_query.Add(Format('%s ', [tmp_str]));
          tmp_str   := EmptyStr;
          q_before  := true;
        end;

      if (cln_doc_ser <> EmptyStr) then tmp_str := 'DOC_SER like ''%' +
        EncodeCString(cln_doc_ser) + '%'' ';
      if (cln_doc_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'DOC_NUM like ''%' +
        EncodeCString(cln_doc_num) + '%'' ';

      // or ((doc_ser like ... or doc_num like) and ID_TYPE_DOC = ...)
      if (tmp_str <> EmptyStr) then
        begin
          if (q_before) then client_query.Add(GetConditionDelim(use_and));
          client_query.Add(Format('((%s) and ID_TYPE_DOC = %s) ',
            [tmp_str, EncodeCString(cln_doc_type)]));
          tmp_str   := EmptyStr;
          q_before  := true;
        end;

      // join client_types on client_types.ID_CLIENT_TYPE_GROUP = ...
      // and client_types.ID_CLIENT_TYPE = client.ID_CLIENT_TYPE
      if (q_before) then
        begin
          client_query.Add(
            Format(') join client_types on ' +
              'client_types.ID_CLIENT_TYPE_GROUP = %s ' +
              'and client_types.ID_CLIENT_TYPE = client.ID_CLIENT_TYPE ',
            [EncodeCString(client_type_group)])
          );
          tmp_str   := EmptyStr;
          q_before  := true;
        end;

      // Клиентский запрос пуст
      if (not q_before) then client_query.Clear();

      // Формирую запрос к таблице car
      tmp_str  := EmptyStr;
      q_before := false;
      car_query.Add('select dogovor.ID_DOGOVOR as CNT_ID, ' +
        'dogovor.ID_CAR as CAR_ID, dogovor.ID_CLIENT as CLN_ID from dogovor ' +
        'join car on (dogovor.ID_CAR = car.ID_CAR) and (');

      if (car_vin <> EmptyStr) then tmp_str := 'VIN_NUM like ''%' +
        EncodeCString(car_vin) + '%'' ';
      if (car_chassi_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'SHASSI like ''' +
        EncodeCString(car_chassi_num) + '%'' ';
      if (car_kusov_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'KUSOV like ''' +
        EncodeCString(car_kusov_num) + '%'' ';
      if (car_reg_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'GOS_NUM like ''' +
        EncodeCString(car_reg_num) + '%'' ';

      // (VIN_NUM like ... or/and SHASSI like)
      if (tmp_str <> EmptyStr) then
        begin
          car_query.Add(Format('%s) ', [tmp_str]));
          tmp_str   := EmptyStr;
          q_before  := true;
        end;
      // Запрос 2 пуст
      if (not q_before) then car_query.Clear();

      // Формирую основной запрос на поиск
      tmp_str  := EmptyStr;
      q_before := false;
      Close();
      SQL.Clear();
      SQL.Add('select  ' + sc_cnt_fields + ', '#13 + sc_car_fields + ', '#13 +
        sc_cln_fields + ', CONCAT_WS(" ", DOG_SER, DOGNUMB) as FULL_NUM, ' +
        'CONCAT_WS(" ", carmark.MARK, car.CAR_MODEL) as FULL_MODEL, ' +
        sc_full_name + ', ' + sc_full_address +
        #13'from ');

      // Начало условия основного запроса.
//        '(dogovor.ID_DOGOVOR_TYPE = dogovor_type.ID_DOGOVOR_TYPE) and ');

      if (polis_ser <> EmptyStr) then tmp_str :=
        'DOG_SER like ''%' +
        EncodeCString(polis_ser) + '%'' ';
      if (polis_num <> EmptyStr) then tmp_str := tmp_str +
        GCDIfNotEmpty(use_and, tmp_str) + 'DOGNUMB like ''%' +
        EncodeCString(polis_num) + '%'' ';

      // Определяю запрос по наличию или отсутствию условий.
      if ((client_query.Count > 0) or (car_query.Count > 0) or
          (tmp_str <> EmptyStr)) then
        begin
          // Есть условия.
          q_before := false;
          SQL.Add('(');
          if (client_query.Count > 0) then
            begin
              SQL.AddStrings(client_query);
              q_before := true;
            end;
          if (car_query.Count > 0) then
            begin
              if (q_before) then SQL.Add('union ');
              SQL.AddStrings(car_query);
              q_before := true;
            end;
          if (tmp_str <> EmptyStr) then
            begin
              if (q_before) then SQL.Add('union ');
              SQL.Add('select dogovor.ID_DOGOVOR as CNT_ID, ' +
                'dogovor.ID_CAR as CAR_ID, dogovor.ID_CLIENT as CLN_ID ' +
                'from dogovor where ');
              SQL.Add(Format('%s ', [tmp_str]));
              tmp_str   := EmptyStr;
              q_before  := true;
            end;

          SQL.Add(') subq ');
        end
      else q_before := false;

      if (q_before) then
        SQL.Add('join dogovor on dogovor.ID_DOGOVOR = subq.CNT_ID '#13 +
          'join car on car.ID_CAR = subq.CAR_ID '#13 +
          'join client on client.ID_CLIENT = subq.CLN_ID '#13 +
          'join car_type on car.ID_CAR_TYPE = car_type.ID_CAR_TYPE '#13 +
          'join carmark on carmark.ID_CARMARK = car.CAR_MARK ');{#13 +
          'order by CNT_ID_CLIENT, CNT_DATE_START ');}

      {$IFDEF DEBUG}
      logger.Debug('data_unit.FindContract: '#13 + SQL.Text);
      {$ENDIF}
      // Запрос пустой.
      if (not q_before) then SQL.Clear()
      else Open();
    end;
  finally
    client_query.Free;
    car_query.Free;
  end;
end;
//---------------------------------------------------------------------------
initialization
  {$I data_unit.lrs}

end.

