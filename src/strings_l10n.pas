unit strings_l10n;

//
// Локализуемые строки.
//

{$I settings.inc}

interface

  resourcestring
    // Общие строки.
    cls_name              = 'Имя';
    cls_surname           = 'Фамилия';
    cls_pathronimyc       = 'Отчество';
    cls_inn               = 'ИНН';
    cls_series            = 'Серия';
    cls_number            = '№';
    cls_get_date          = 'Выдан';
    cls_title             = 'Название';
    cls_address           = 'Адрес';
    cls_phone             = 'Телефон';
    cls_fax               = 'Факс';
    cls_comment           = 'Комментарии';
    cls_info              = 'Информация';
    cls_warning           = 'Внимание!';
    cls_error             = 'Ошибка';
    cls_yes               = 'Да';
    cls_no                = 'Нет';
    cls_cancel            = 'Отмена';
    cls_periods           = 'Периоды';
    cls_sure_q            = 'Вы хотите продолжить?';
    cls_lossdata_q        = 'Данные были изменены!'#13 +
      'Все изменения будут потеряны.'#13;
    cls_data_commit_q     = 'Данные в базе данных будут изменены. ' +
      'Нажатие на кнопку "Да" сохранит данные в базе.'#13;
    cls_noentity_msg      = 'Записи с таким ID не существует!';
    cls_data_refresh_q    = 'Данные были изменены другим пользователем.'#13 +
      'Обновить данные (изменения будут потеряны)?';
    cls_setts_svg_err_msg   = 'Не удалось сохранить настройки пользователя';
    cls_ticket_svg_err_msg  = 'Не удалось сохранить квитанцию';
    // Главное окно + Менеджер договоров.
    mw_cal_title            = ' Показать договора, начиная с';
    mw_reconn_msg           = 'Соединение было потеряно. Переподключиться?';
    //
    contract_mgr_ConView        = ' Просмотр информации о договоре';
    contract_mgr_ConChange      = ' Редактирование договора';
    contract_mgr_ConNew         = ' Добавление нового договора';
    contract_mgr_ConProlong     = ' Пролонгация договора';
    contract_mgr_ConReplace     = ' Замена договора';
    contract_mgr_ConSearch      = ' Поиск договоров';
    contract_mgr_msg_InsCalcErr = 'Ошибка расчёта страховой премии: ';
    contract_mgr_koef_bs        = 'Размер базовой ставки';
    contract_mgr_koef_kt        = 'Региональный коэффициент';
    contract_mgr_koef_kbm       = 'Коэффициент бонус-малус (КБМ)';
    contract_mgr_koef_kvs       = 'КВС';
    contract_mgr_koef_ko        = 'КО';
    contract_mgr_koef_km        = 'КМ';
    contract_mgr_koef_ks        = 'КС';
    contract_mgr_koef_kp        = 'КП';
    contract_mgr_koef_kn        = 'КН';
    contract_mgr_msg_InputIncor = 'введён некорректно';
    contract_mgr_msg_db_chg_err = 'Произошла ошибка, при записи договора.'#13 +
      'Обновление данных не произведено.';
    contract_mgr_msg_bl_sel_err = 'Не удалось выбрать бланк!';
    contract_mgr_msg_bl_err     = 'Не выбран бланк';
    contract_mgr_msg_car_err    = 'Не выбрано транспортное средство';
    contract_mgr_msg_ph_err     = 'Не выбран страхователь';
    contract_mgr_msg_drvs_err   = 'Не выбраны водители';
    contract_mgr_msg_kbm_err    = 'Класс страхования установлен некорректно';
    contract_mgr_nm_KWT         = ' КВт';
    contract_mgr_nm_HP          = ' л.с.';
    contract_mgr_msg_cclosed    = 'Договор был закрыт';
    contract_mgr_no_nums_msg    = 'Номера ТС не были внесены.'#13;
    contract_mgr_prev_prem      = 'Премия по предыдущему договору: ';
    // Менеджер ТС.
    car_mgr_CarView             = ' Просмотр информации о ТС';
    car_mgr_CarChange           = ' Редактирование информации о ТС';
    car_mgr_CarNew              = ' Добавление нового ТС';
    car_mgr_CarSearch           = ' Поиск транспортных средств';
    car_mgr_no_owner_err        = 'Не выбран владелец транспортного средства';
    car_mgr_msg_db_chg_err      = 'Произошла ошибка, при записи информации ' +
      'о транспортном средстве.'#13'Обновление данных не произведено.';
    // Менеджер клиентов.
    cln_mgr_ClientView          = ' Просмотр информации о клиенте';
    cln_mgr_ClientChange        = ' Редактирование информации о клиенте';
    cln_mgr_ClientNew           = ' Добавление нового клиента';
    cln_mgr_ClientSearch        = ' Поиск клиентов';
    cln_mgr_BirthDate           = 'Дата рождения:';
    cln_mgr_RegDate             = 'Дата регистрации:';
    cln_mgr_msg_db_chg_err      = 'Произошла ошибка, при записи информации ' +
      'о клиенте.'#13'Обновление данных не произведено.';
    cln_mgr_msg_no_phone        = 'Не было введено ни одного телефона для ' +
      'клиента.'#13;
    // Менеджер справочников.
    info_mgr_tblnm_cntrs    = 'Страны';
    info_mgr_tblnm_rgns     = 'Регионы';
    info_mgr_tblnm_cities   = 'Города';
    info_mgr_tblnm_csgrp    = 'Группы коэффициентов';
    info_mgr_tblnm_tkoef    = 'Территориальные коэфициенты';
    info_mgr_tblnm_icmps    = 'Страховые компании';
    info_mgr_tblnm_socst    = 'Социальный статус';
    info_mgr_tblnm_famst    = 'Семейное положение';
    info_mgr_tblnm_clntp    = 'Типы клиентов';
    info_mgr_tblnm_lictp    = 'Тип удостоверения личности';
    info_mgr_tblnm_carmk    = 'Марки ТС';
    info_mgr_tblnm_carml    = 'Модели ТС';
    info_mgr_tblnm_cartp    = 'Типы ТС';
    info_mgr_tblnm_usetg    = 'Цели использования ТС';
    info_mgr_tblnm_basesum  = 'Базовая ставка';
    info_mgr_tblnm_ckbm     = 'Класс страхования (КБМ)';
    info_mgr_tblnm_ckvs     = 'Коэффициент КВС';
    info_mgr_tblnm_ckm      = 'Коэффициент КМ';
    info_mgr_tblnm_cko      = 'Коэффициент КО';
    info_mgr_tblnm_ckp      = 'Коэффициент КП';
    info_mgr_tblnm_cks      = 'Коэффициент КС';
    info_mgr_tblnm_ckt      = 'Коэффициент КТ';
    info_mgr_tblnm_cfrng    = 'Коэффициенты для иностранцев';
    info_mgr_tblnm_cother   = 'Другие коэффициенты';
    info_mgr_tblnm_iform    = 'Страховые формулы';
    info_mgr_tblnm_formc    = 'Порядок применения формул';
    // Менеджер пользователей.
    user_mgr_UserChange     = ' Редактирование информации о пользователе';
    user_mgr_UserNew        = ' Добавление нового пользователя';
    user_mgr_UserView       = ' Просмотр данных пользователя';
    user_mgr_UserSearch     = ' Поиск пользователей';
    user_mgr_msg_db_chg_err = 'Произошла ошибка, при записи информации ' +
      'о пользователе.'#13'Обновление данных не произведено.';
    user_mgr_del_confirm    = 'Удаление пользователя "%s" необратимо.'#13;
    user_mgr_del_err        = 'Пользователя не удалось удалить.';
    user_mgr_msg_it_psw_err = 'Пароли не совпадают!';
    // Ввод пустых бланков.
    cont_input_err_range    = 'Запрошенное число полисов выходит за ' +
      'допустимые пределы!';
    cont_input_err_input    = 'Не удалось ввести бланки';
    // Выбор пустого бланка.
    blank_sel_inscmp_hdr    = 'Компании ';

    // Модуль отчётов.
    rep_new_blank_msg   = 'Бланк не был найден.'#13 +
      'Будет создан новый бланк.';
    rep_new_ps_blank_msg   = 'Бланк полиса не был найден.'#13 +
      'Будет создан новый бланк.';
    rep_new_rt_blank_msg   = 'Бланк заявления не был найден.'#13 +
      'Будет создан новый бланк.';
    rep_export_err         = 'Во время экспорта произошла ошибка.';
    // Расчёт страховой премии.
    insp_calc_err_nocomma  = 'Ожидается запятая в позиции %d';
    insp_calc_err_nolbrkt  = 'Ожидается "(" в позиции %d';
    insp_calc_err_norbrkt  = 'Ожидается ")" в позиции %d';
    insp_calc_err_nolexpr  = 'Ожидается выражение в позиции %d';
    insp_calc_err_symbol   = 'Неизвестный символ "%s" в позиции %d';
    insp_calc_err_var      = 'Переменная "%s" не объявлена';
    insp_calc_err_nofunc   = 'Функции %s в позиции %d не существует.';
    insp_calc_err_argcnt   = 'Функции %s передано неверное число аргументов.';
    insp_calc_err_argmax   =
      'Число аргументов превышает предельно допустимое (стр. %d).';
    insp_calc_err_ariph    = 'Вычислительная ошибка.';
    insp_get_car_own_err   = 'Неверно внесены данные владельца ТС';
    insp_get_ph_err        = 'Неверно внесены данные страхователя';

implementation

uses gettext, translations;

const lng_dir = 'languages';

procedure TranslateResStrings;
var
  Lang, FallbackLang: string;
begin
  // in unit gettext.
  GetLanguageIDs(Lang, FallbackLang);
  TranslateUnitResourceStrings('LCLStrConsts',
    lng_dir + DirectorySeparator + 'lclstrconsts.%s.po', Lang, FallbackLang);
  TranslateUnitResourceStrings('Lr_const',
    lng_dir + DirectorySeparator + 'lr_const.%s.po', Lang, FallbackLang);
  TranslateUnitResourceStrings('strings_l10n',
    lng_dir + DirectorySeparator + 'strings.%s.po', Lang, FallbackLang);
end;

initialization
  TranslateResStrings();

end.
