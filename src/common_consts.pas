unit common_consts;

//
// Общие константы.
//

{$I settings.inc}

interface
uses Graphics;
const
  // Физическое лицо.
  ind_person          = 1;
  // Юридическое лицо.
  legal_entity        = 2;
  // (1 кВт = 1,36 л. с.), 1 лошадиная сила = 735.49875 Ватта.
  // Л.С. в киловатты.
  ct_hp2kwt           = 0.73549875;
  // кВт в Л.С.
  ct_kwt2hp           = 1.3596216173039043234267903242528;
  // Цвет подсветки ошибок.
  clAlert             = TColor($9090E9);
  // Интервал подсветки в мс.
  hl_interval         = 550;
  // ID региона, по умолчанию (используется, при создании клиента).
  def_rgn_id          = 77;
  // Каталог с формами бланков.
  blanks_dir          = 'blanks';
  // Имя файла бланка полиса.
  blanks_polis        = 'polis.lrf';
  // Имя файла бланка заявления.
  blanks_receipt      = 'receipt.lrf';
  // Имя файла бланка отчёта по дате.
  blanks_rep_bydate   = 'rep_bydate.lrf';
  // Имя файла бланка общего отчёта.
  blanks_rep_general  = 'rep_general.lrf';
  // Символ прочерка, заполняющий пустые ячейки в договоре.
  blank_filer_sym = '-';
  // Строка прочерка, заполняющая пустые ячейки в договоре.
  blank_filer_str = ' ----- // ----- ';
  // Каталог для сохранения настроек пользователя в %USERPROFILE%/Application Data.
  settings_dir    = 'Artiom N./OSAGO';
  // E-mail.
  my_email        = 'mailto:artiomsoft@yandex.ru?subject=Комплекс ОСАГО';
  // Сайт.
  my_site         = 'http://www.artiomsoft.ru';
  // Расширение файла справки.
  man_ext        = '.pdf';
implementation

end.

