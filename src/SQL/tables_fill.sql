use osago;

set names cp866;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0 */;

# ВНАЧАЛЕ - ПРОВЕРИТЬ!!! select count(*).

update dogovor set
  start_use1 = NULL,
  end_use1   = NULL
where (start_use1 < MAKEDATE(1990, 1)) or (end_use1 < MAKEDATE(1990, 1));

update dogovor set
  date_write = date_begin
where (date_write < MAKEDATE(1990, 1)) or (date_write = NULL);

# Страна - Россия.
update client
set id_country = 1
where not (country <> '' and
country not like 'Яр%' and
country not like 'ЯО%' and
country not like 'МО%' and
country not like '%Мос%' and
country not like 'Туль%' and
country not like 'Влади%' and
country not like 'Ряз%' and
country not like 'Иван%' and
country not like 'Арханг%' and
country not like 'Костром%' and
country not like 'Косром%' and
country not like 'Новгород%' and
country not like 'Нижегор%' and
country not like 'Орлов%' and
country not like 'Росси%' and
country not like 'Волг%' and
country not like '%Карелия%' and
country not like 'Мурманск%' and
country not like '%красно%' and
country not like 'Волог%' and
country not like 'Самарс%' and
country not like 'Свердл%' and
country not like 'Севаст%'and
country not like 'Смол%' and
country not like 'Ставро%' and
country not like 'Тюмен%' and
country not like 'Калуж%' and
country not like 'Воронеж%' and
country not like '%Адыге%' and
country not like 'Ленин%' and
country not like 'Петер%' and
country not like 'Пензе%' and
country not like 'Оренбург%' and
country not like 'Калинин%' and
country not like '%Коми%' and
country not like 'Курск%' and
country not like 'Липецк%' and
country not like 'Тамбо%' and
country not like 'Томбо%' and
country not like 'Хабар%' and
country not like 'Твер%' and
country not like 'Белгор%' and
country not like 'Белогор%' and
country not like 'Ульян%' and
country not like 'Астрах%' and
country not like 'Саха%' and
country not like 'Ростов%' and
country not like 'Иркутс%' and
country not like 'Брянск%' and
country not like 'Приморск%' and
country not like '%Ненецк%' and
country not like 'Удмурт%' and
country not like 'Удмур%' and
country not like 'Ямал%' and
country not like 'Чечен%' and
country not like 'Russ%' and
country not like 'Сарат%');

# Регион - Ярославская область.
update client
set
id_region = 77
where
(region like 'Яр%' or
region like 'ЯО%' or
region like 'Zhjc%' or
region like 'ZJ%' or
region like 'Рыб%' or
region like 'Тута%' or
region like '%Некрасов%' or
region like 'Некр.%' or
region like 'Переслав%' or
region like 'Рост%' or
region like 'Ротовс%' or
region like 'Гаврилов%' or
region like 'Любим%' or
region like 'Некоуз%' or
region like 'Фрунз%' or
region like 'Большесел%' or
region like 'Городищ%' or
region like 'Мышкин%' or
region like '%Углич%' or
region like '%Углеч%' or
region like 'Борисо%' or
region like 'Бльшесел%' or
region like 'Данил%' or
region like 'Леваш%' or
region like 'Гаврил%' or
region like 'Гов.-Ямск%' or
region like 'Г-Ямск%' or
region like 'Иван%' or
region like 'Пошехон%' or
region like 'Тунош%' or
region like '%Брейт%' or
region = '')
and id_country = 1;

# Город - Ярославль.
update client
set id_city = 2532
where
(
  (town = '' and (region like '%Ярос%' or region = ''))  or 
  (region like 'Ярославль' and (town like '%Ярос%' or town = '')) or
  (town like '%Ярос%' and town not like '%Ярославка%')
)
and id_region = 77;

INSERT INTO dogovor_type VALUES (4, 'Закрыт', NULL);

INSERT INTO bso_status VALUES 
  ('1', 'Не использован'),
  ('2', 'Использован (выдан)'),
  ('3', 'Испорчен'),
  ('4', 'Украден'),
  ('5', 'Утерян');

/*==============================================================*/
/* Table : geo_groups                                           */
/*==============================================================*/

# GEO_GROUP, NAME
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (1,
  'Города из 6-го списка (Абакан, Азов, Ярцево...)');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (2, 'Город Москва');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (3, 'Город Санкт-Петербург');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (4, 'Московская область');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (5, 'Ленинградская область и др. города');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (6, 'Крупные города (1-й список)');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (7, 'Иностранное государство');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (8, 'Прочие регионы РФ');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (9, 'Адыгея, Коми, Пермский край и т.д.');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (10, 'Карачаево-Черкесская, Саха и т.д.');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (11, 'Башкортостан, Марий Эл, Краснодарский край и т.д.');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (12, 'Алтай, Ингушетия и т.д.');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (13, 'Бурятия, Калмыкия и т.д.');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (14, 'Северная Осетия, Тува и т.д.');
INSERT INTO geo_groups (GEO_GROUP, NAME) VALUES (15, 'Дагестан, Чечня и т.д.');

/*==============================================================*/
/* Table : base_sum                                             */
/*==============================================================*/

# ID_CLIENT_TYPE_GROUP: 1 - физ. лицо, 2 - юр. лицо.
INSERT INTO base_sum VALUES (1, 0, 1980);
INSERT INTO base_sum VALUES (2, 0, 2375);
INSERT INTO base_sum VALUES (1, 1, 395);
INSERT INTO base_sum VALUES (2, 1, 395);
INSERT INTO base_sum VALUES (1, 2, 2965);
INSERT INTO base_sum VALUES (2, 2, 2965);
INSERT INTO base_sum VALUES (1, 3, 2025);
INSERT INTO base_sum VALUES (2, 3, 2025);
INSERT INTO base_sum VALUES (1, 4, 3240);
INSERT INTO base_sum VALUES (2, 4, 3240);
INSERT INTO base_sum VALUES (1, 5, 810);
INSERT INTO base_sum VALUES (2, 5, 810);
INSERT INTO base_sum VALUES (1, 6, 1620);
INSERT INTO base_sum VALUES (2, 6, 1620);
INSERT INTO base_sum VALUES (1, 7, 2025);
INSERT INTO base_sum VALUES (2, 7, 2025);
INSERT INTO base_sum VALUES (1, 8, 1620);
INSERT INTO base_sum VALUES (2, 8, 1620);
INSERT INTO base_sum VALUES (1, 9, 1010);
INSERT INTO base_sum VALUES (2, 9, 1010);
INSERT INTO base_sum VALUES (1, 10, 1215);
INSERT INTO base_sum VALUES (2, 10, 1215);
INSERT INTO base_sum VALUES (1, 11, 305);
INSERT INTO base_sum VALUES (2, 11, 305);
INSERT INTO base_sum VALUES (1, 12, 1215);
INSERT INTO base_sum VALUES (2, 12, 1215);
INSERT INTO base_sum VALUES (1, 13, 2965);
INSERT INTO base_sum VALUES (2, 13, 2965);

/*==============================================================*/
/* Table : ins_koefs_ko                                         */
/*==============================================================*/

# KO_LIMITED, KO_UNLIM
INSERT INTO ins_koefs_ko VALUES (1, 1.7);

/*==============================================================*/
/* Table : ins_koefs_kvs                                        */
/*==============================================================*/

# MAX_STAGE, MAX_AGE, KVS
INSERT INTO ins_koefs_kvs VALUES (2, 22, 1.7);
INSERT INTO ins_koefs_kvs VALUES (3, 22, 1.5);
INSERT INTO ins_koefs_kvs VALUES (2, 23, 1.3);
INSERT INTO ins_koefs_kvs VALUES (3, 23, 1.0);

/*==============================================================*/
/* Table : ins_koefs_km                                         */
/*==============================================================*/

# ID_CAR_TYPE, MAX_POWER, KM

INSERT INTO ins_koefs_km VALUES (0, 50, 0.6);
INSERT INTO ins_koefs_km VALUES (0, 70, 0.9);
INSERT INTO ins_koefs_km VALUES (0, 100, 1.0);
INSERT INTO ins_koefs_km VALUES (0, 120, 1.2);
INSERT INTO ins_koefs_km VALUES (0, 150, 1.4);
INSERT INTO ins_koefs_km VALUES (0, 160, 1.6);

/*==============================================================*/
/* Table : ins_koefs_kp                                         */
/*==============================================================*/

# PERIOD_INS в месяцах, KP

INSERT INTO ins_koefs_kp VALUES (0.5, 0.2);
INSERT INTO ins_koefs_kp VALUES (1, 0.3);
INSERT INTO ins_koefs_kp VALUES (2, 0.4);
INSERT INTO ins_koefs_kp VALUES (3, 0.5);
INSERT INTO ins_koefs_kp VALUES (4, 0.6);
INSERT INTO ins_koefs_kp VALUES (5, 0.65);
INSERT INTO ins_koefs_kp VALUES (6, 0.7);
INSERT INTO ins_koefs_kp VALUES (7, 0.8);
INSERT INTO ins_koefs_kp VALUES (8, 0.9);
INSERT INTO ins_koefs_kp VALUES (9, 0.95);
INSERT INTO ins_koefs_kp VALUES (10, 1);

/*==============================================================*/
/* Table : ins_koefs_ks                                         */
/*==============================================================*/

# PERIOD_USE в месяцах, KS

INSERT INTO ins_koefs_ks VALUES (3, 0.4);
INSERT INTO ins_koefs_ks VALUES (4, 0.5);
INSERT INTO ins_koefs_ks VALUES (5, 0.6);
INSERT INTO ins_koefs_ks VALUES (6, 0.7);
INSERT INTO ins_koefs_ks VALUES (7, 0.8);
INSERT INTO ins_koefs_ks VALUES (8, 0.9);
INSERT INTO ins_koefs_ks VALUES (9, 0.95);
INSERT INTO ins_koefs_ks VALUES (10, 1.0);

/*==============================================================*/
/* Table : ins_koefs_foreing                                    */
/*==============================================================*/

# GEO_GROUP, ID_CLIENT_TYPE_GROUP, KO, KVS, KBM

# Иностранное гос-во.
INSERT INTO ins_koefs_foreing VALUES (7, 1, 1, 1.5, 1);
INSERT INTO ins_koefs_foreing VALUES (7, 2, 1.7, 1, 1);

/*==============================================================*/
/* Table : ins_koefs_other                                      */
/*==============================================================*/

# KN, KP_TRANSIT

INSERT INTO ins_koefs_other VALUES (1.5, 0.2);

/*==============================================================*/
/* Table : ins_formula                                          */
/*==============================================================*/

# ID_FORMULA, FORMULA, DESCR
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(1, 'ТБ * КТ * КБМ * КВС * КО * КМ * КС * КН', 'Физ. лица; "B"; РФ');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(2, 'ТБ * КТ * КБМ * КВС * КО * КС * КН', 'Физ. лица; "A", "C", "D"; РФ');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(3, 'ТБ * КТ * КС', 'Физ. лица; Прицепы; РФ');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(4, 'ТБ * КВС * КО * КМ * КП', 'Физ. лица; "B"; Транзит');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(5, 'ТБ * КВС * КО * КП', 'Физ. лица; "A", "C", "D"; Транзит');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(6, 'ТБ * КП', 'Физ. лица; Прицепы; Транзит');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(7, 'ТБ * КТ * КБМ * КВС * КО * КМ * КП * КН', 'Физ. лица; "B"; Иностр.');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(8, 'ТБ * КТ * КБМ * КВС * КО * КП * КН', 'Физ. лица; "A", "C", "D"; Иностр.');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(9, 'ТБ * КТ * КП', 'Физ. лица; Прицепы; Иностр.');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(10, 'ТБ * КТ * КБМ * КО * КМ * КН', 'Юр. лица; "B"; РФ');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(11, 'ТБ * КТ * КБМ * КО * КН', 'Юр. лица; "A", "C", "D"; РФ');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(12, 'ТБ * КТ * КС', 'Юр. лица; Прицепы; РФ');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(13, 'ТБ * КО * КМ * КП', 'Юр. лица; "B"; Транзит');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(14, 'ТБ * КО * КП', 'Юр. лица; "A", "C", "D"; Транзит');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(15, 'ТБ * КП', 'Юр. лица; Прицепы; Транзит');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(16, 'ТБ * КТ * КБМ * КО * КМ * КП * КН', 'Юр. лица; "B"; Иностр.');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(17, 'ТБ * КТ * КБМ * КО * КП * КН', 'Юр. лица; "A", "C", "D"; Иностр.');
INSERT INTO ins_formula (ID_FORMULA, FORMULA, DESCR)
VALUES(18, 'ТБ * КТ * КП', 'Юр. лица; Прицепы; Иностр.');

/*==============================================================*/
/* Table : ins_formula_type                                     */
/*==============================================================*/

# ID_INS_FORMULA_TYPE, TRANSIT, FOREING, NAME
INSERT INTO ins_formula_type (ID_INS_FORMULA_TYPE, TRANSIT, FOREING, NAME)
VALUES(1, false, false, 'РФ. Кроме транзита.');
INSERT INTO ins_formula_type (ID_INS_FORMULA_TYPE, TRANSIT, FOREING, NAME)
VALUES(2, true, false, 'РФ. Транзит.');
INSERT INTO ins_formula_type (ID_INS_FORMULA_TYPE, TRANSIT, FOREING, NAME)
VALUES(3, false, true, 'Иностранцы. Кроме транзита.');
INSERT INTO ins_formula_type (ID_INS_FORMULA_TYPE, TRANSIT, FOREING, NAME)
VALUES(4, true, true, 'Иностранцы. Транзит.');

/*==============================================================*/
/* Table : ins_formula_conf                                     */
/*==============================================================*/

# ID_INS_FORMULA_TYPE, ID_CAR_TYPE, ID_CLIENT_TYPE_GROUP, ID_FORMULA

#
# 1. Зарегистрированы в РФ. Кроме транзита.
#

# Физ. лица.

# B.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 0, 1, 1);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 2, 1, 1);

# A, C, D и т.д..
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 3, 1, 2);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 4, 1, 2);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 6, 1, 2);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 7, 1, 2);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 8, 1, 2);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 9, 1, 2);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 10, 1, 2);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 12, 1, 2);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 13, 1, 2);

# Прицепы.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 1, 1, 3);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 5, 1, 3);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 11, 1, 3);

# Юр. лица.

# B.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 0, 2, 10);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 2, 2, 10);

# A, C, D и т.д..
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 3, 2, 11);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 4, 2, 11);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 6, 2, 11);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 7, 2, 11);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 8, 2, 11);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 9, 2, 11);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 10, 2, 11);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 12, 2, 11);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 13, 2, 11);

# Прицепы.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 1, 2, 12);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 5, 2, 12);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(1, 11, 2, 12);

#
# 2. Зарегистрированы в РФ. Транзит.
#

# Физ. лица.

# B.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 0, 1, 4);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 2, 1, 4);

# A, C, D и т.д..
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 3, 1, 5);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 4, 1, 5);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 6, 1, 5);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 7, 1, 5);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 8, 1, 5);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 9, 1, 5);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 10, 1, 5);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 12, 1, 5);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 13, 1, 5);

# Прицепы.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 1, 1, 6);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 5, 1, 6);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 11, 1, 6);

# Юр. лица.

# B.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 0, 2, 13);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 2, 2, 13);

# A, C, D и т.д..
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 3, 2, 14);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 4, 2, 14);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 6, 2, 14);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 7, 2, 14);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 8, 2, 14);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 9, 2, 14);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 10, 2, 14);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 12, 2, 14);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 13, 2, 14);

# Прицепы.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 1, 2, 15);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 5, 2, 15);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(2, 11, 2, 15);

#
# 3. Иностранцы. Кроме транзита.
#

# Физ. лица.

# B.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 0, 1, 7);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 2, 1, 7);

# A, C, D и т.д..
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 3, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 4, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 6, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 7, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 8, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 9, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 10, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 12, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 13, 1, 8);

# Прицепы.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 1, 1, 9);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 5, 1, 9);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 11, 1, 9);

# Юр. лица.

# B.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 0, 2, 16);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 2, 2, 16);

# A, C, D и т.д..
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 3, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 4, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 6, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 7, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 8, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 9, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 10, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 12, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 13, 2, 17);

# Прицепы.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 1, 2, 18);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 5, 2, 18);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(3, 11, 2, 18);

#
# 4. Иностранцы. Транзит.
#

# Физ. лица.

# B.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 0, 1, 7);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 2, 1, 7);

# A, C, D и т.д..
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 3, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 4, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 6, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 7, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 8, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 9, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 10, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 12, 1, 8);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 13, 1, 8);

# Прицепы.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 1, 1, 9);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 5, 1, 9);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 11, 1, 9);

# Юр. лица.

# B.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 0, 2, 16);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 2, 2, 16);

# A, C, D и т.д..
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 3, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 4, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 6, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 7, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 8, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 9, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 10, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 12, 2, 17);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 13, 2, 17);

# Прицепы.
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 1, 2, 18);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 5, 2, 18);
INSERT INTO ins_formula_conf (ID_INS_FORMULA_TYPE, ID_CAR_TYPE,
  ID_CLIENT_TYPE_GROUP, ID_FORMULA)
VALUES(4, 11, 2, 18);

/*==============================================================*/
/* Table : self_info                                            */
/*==============================================================*/

# DB_SUB_VERSION, DB_MAJOR_VERSION, CLIENT_VERSION,
# BLANK_MULTIRESERVE,
# MAX_QUERIES_PER_HOUR, MAX_UPDATES_PER_HOUR, MAX_CONNECTIONS_PER_HOUR,
# MAX_USER_CONNECTIONS,
# REFRESH_TIME

INSERT INTO self_info VALUES(1, 0, 0.1, false, 0, 0, 0, 0, 3);

/*==============================================================*/
/* Table : territory_use                                        */
/*==============================================================*/

# 10 - Трактор, 11 - Прицеп к трактору
# На всякий случай, сделаю для всех типов ТС отдельно.

# Разные города, для которых коэф. КТ = 1. Самый большой список.

INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 1, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 1, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 1, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 1, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 1, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 1, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 1, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 1, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 1, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 1, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 1, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 1, 1.0);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 1, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 1, 0.8);

# Зе москоу.

INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 2, 2.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 2, 2.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 2, 2.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 2, 2.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 2, 2.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 2, 2.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 2, 2.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 2, 2.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 2, 2.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 2, 2.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 2, 2.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 2, 2.0);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 2, 1.2);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 2, 1.2);

# Санкт-Пидерсбрюг.

INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 3, 1.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 3, 1.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 3, 1.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 3, 1.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 3, 1.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 3, 1.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 3, 1.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 3, 1.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 3, 1.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 3, 1.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 3, 1.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 3, 1.8);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 3, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 3, 1.0);

# Подмосковская область.

INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 4, 1.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 4, 1.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 4, 1.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 4, 1.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 4, 1.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 4, 1.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 4, 1.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 4, 1.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 4, 1.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 4, 1.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 4, 1.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 4, 1.7);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 4, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 4, 1.0);

# Ленингадская область, Архангельск, Казань, Кемерово, и т.д..

INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 5, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 5, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 5, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 5, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 5, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 5, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 5, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 5, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 5, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 5, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 5, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 5, 1.6);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 5, 1.0);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 5, 1.0);

# Крупные города (1-й список).

INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 6, 1.3);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 6, 1.3);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 6, 1.3);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 6, 1.3);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 6, 1.3);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 6, 1.3);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 6, 1.3);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 6, 1.3);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 6, 1.3);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 6, 1.3);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 6, 1.3);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 6, 1.3);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 6, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 6, 0.8);

# Иностранное государство. Коэф. КТ = 1.6.

INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 7, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 7, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 7, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 7, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 7, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 7, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 7, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 7, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 7, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 7, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 7, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 7, 1.6);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 7, 1.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 7, 1.6);

# Прочие регионы РФ. Коэф. КТ = 0.5.

INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 8, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 8, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 8, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 8, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 8, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 8, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 8, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 8, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 8, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 8, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 8, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 8, 0.5);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 8, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 8, 0.5);

# Республика Адыгея, Республика Коми, Пермский край,
# Архангельская область (включая Ненецкий автономный округ), Мурманская область.
# КТ = 0.85
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 9, 0.85);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 9, 0.85);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 9, 0.85);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 9, 0.85);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 9, 0.85);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 9, 0.85);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 9, 0.85);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 9, 0.85);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 9, 0.85);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 9, 0.85);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 9, 0.85);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 9, 0.85);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 9, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 9, 0.5);

# Карачаево-Черкесская Республика, Республика Саха (Якутия),
# Республика Татарстан, Вологодская область, Кемеровская область,
# Костромская область, Тюменская область (включая Ханты-Мансийский автономный
# округ - Югру, Ямало-Ненецкий автономный округ), Челябинская область.
# КТ = 0.8
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 10, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 10, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 10, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 10, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 10, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 10, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 10, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 10, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 10, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 10, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 10, 0.8);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 10, 0.8);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 10, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 10, 0.5);

# Республика Башкортостан, Республика Марий Эл, Краснодарский край,
# Владимирская область, Ивановская область, Магаданская область,
# Нижегородская область, Новосибирская область, Сахалинская область,
# Свердловская область.
# КТ = 0.75
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 11, 0.75);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 11, 0.75);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 11, 0.75);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 11, 0.75);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 11, 0.75);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 11, 0.75);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 11, 0.75);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 11, 0.75);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 11, 0.75);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 11, 0.75);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 11, 0.75);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 11, 0.75);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 11, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 11, 0.5);

# Республика Алтай, Республика Ингушетия, Кабардино-Балкарская Республика,
# Республика Карелия, Республика Мордовия, Удмуртская Республика,
# Чувашская Республика, Красноярский край, Кировская область,
# Курганская область, Омская область, Оренбургская область, Самарская область,
# Томская область, Ульяновская область, Ярославская область.
# КТ = 0.7
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 12, 0.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 12, 0.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 12, 0.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 12, 0.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 12, 0.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 12, 0.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 12, 0.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 12, 0.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 12, 0.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 12, 0.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 12, 0.7);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 12, 0.7);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 12, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 12, 0.5);

# Республика Бурятия, Республика Калмыкия, Камчатский край,
# Ставропольский край, Хабаровский край, Астраханская область,
# Белгородская область, Иркутская область, Калужская область,
# Новгородская область, Ростовская область, Рязанская область,
# Тамбовская область, Тверская область, Тульская область.
# КТ = 0.65
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 13, 0.65);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 13, 0.65);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 13, 0.65);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 13, 0.65);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 13, 0.65);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 13, 0.65);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 13, 0.65);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 13, 0.65);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 13, 0.65);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 13, 0.65);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 13, 0.65);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 13, 0.65);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 13, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 13, 0.5);

# Республика Северная Осетия - Алания, Республика Тыва, Республика Хакасия,
# Алтайский край, Приморский край, Амурская область, Брянская область,
# Волгоградская область, Калининградская область, Липецкая область,
# Орловская область, Пензенская область, Саратовская область.
# КТ = 0.6
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 14, 0.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 14, 0.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 14, 0.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 14, 0.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 14, 0.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 14, 0.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 14, 0.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 14, 0.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 14, 0.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 14, 0.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 14, 0.6);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 14, 0.6);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 14, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 14, 0.5);

# Республика Дагестан, Чеченская Республика, Забайкальский край,
# Воронежская область, Курская область, Псковская область, Смоленская область,
# Еврейская автономная область, Чукотский автономный округ.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (0, 15, 0.55);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (1, 15, 0.55);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (2, 15, 0.55);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (3, 15, 0.55);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (4, 15, 0.55);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (5, 15, 0.55);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (6, 15, 0.55);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (7, 15, 0.55);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (8, 15, 0.55);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (9, 15, 0.55);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (12, 15, 0.55);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (13, 15, 0.55);
# Трактора и прицепы к ним.
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (10, 15, 0.5);
INSERT INTO territory_use (ID_CAR_TYPE, GEO_GROUP, TERRITORY_KOEF)
VALUES (11, 15, 0.5);

/*==============================================================*/
/* Table : insurance_class                                      */
/*==============================================================*/

UPDATE insurance_class
SET KOEF = 2.45
WHERE ID_INSURANCE_CLASS = 1;
UPDATE insurance_class
SET KOEF = 2.3
WHERE ID_INSURANCE_CLASS = 2;
UPDATE insurance_class
SET KOEF = 1.55
WHERE ID_INSURANCE_CLASS = 3;
UPDATE insurance_class
SET KOEF = 1.3
WHERE ID_INSURANCE_CLASS = 4;
UPDATE insurance_class
SET KOEF = 1
WHERE ID_INSURANCE_CLASS = 5;
UPDATE insurance_class
SET KOEF = 0.95
WHERE ID_INSURANCE_CLASS = 6;
UPDATE insurance_class
SET KOEF = 0.9
WHERE ID_INSURANCE_CLASS = 7;
UPDATE insurance_class
SET KOEF = 0.85
WHERE ID_INSURANCE_CLASS = 8;
UPDATE insurance_class
SET KOEF = 0.8
WHERE ID_INSURANCE_CLASS = 9;
UPDATE insurance_class
SET KOEF = 0.75
WHERE ID_INSURANCE_CLASS = 10;
UPDATE insurance_class
SET KOEF = 0.7
WHERE ID_INSURANCE_CLASS = 11;
UPDATE insurance_class
SET KOEF = 0.65
WHERE ID_INSURANCE_CLASS = 12;
UPDATE insurance_class
SET KOEF = 0.6
WHERE ID_INSURANCE_CLASS = 13;
UPDATE insurance_class
SET KOEF = 0.55
WHERE ID_INSURANCE_CLASS = 14;
UPDATE insurance_class
SET KOEF = 0.5
WHERE ID_INSURANCE_CLASS = 15;

/*==============================================================*/
/* Table : user_groups                                          */
/*==============================================================*/

INSERT INTO user_groups(GROUP_NAME, GROUP_DESCR,
PRIV_CLN_ADD, PRIV_CLN_CHG, PRIV_CLN_DEL, PRIV_CAR_ADD, PRIV_CAR_CHG,
PRIV_CAR_DEL, PRIV_CONT_ADD, PRIV_CONT_CHG, PRIV_CONT_DEL, PRIV_CONT_PROLONG,
PRIV_CONT_REPLACE, PRIV_CONT_CLOSE, PRIV_USER_ADD, PRIV_USER_CHG, PRIV_USER_DEL,
PRIV_GROUP_ADD, PRIV_GROUP_CHG, PRIV_GROUP_DEL, PRIV_BLANKS, PRIV_INFOS_EDIT)
VALUES ('Администраторы', 'Пользователи с максимальными привилегиями',
true, true, true, true, true,
true, true, true, true, true,
true, true, true, true, true,
true, true, true, true, true);

INSERT INTO user_groups(GROUP_NAME, GROUP_DESCR,
PRIV_CLN_ADD, PRIV_CLN_CHG, PRIV_CLN_DEL, PRIV_CAR_ADD, PRIV_CAR_CHG,
PRIV_CAR_DEL, PRIV_CONT_ADD, PRIV_CONT_CHG, PRIV_CONT_DEL, PRIV_CONT_PROLONG,
PRIV_CONT_REPLACE, PRIV_CONT_CLOSE, PRIV_USER_ADD, PRIV_USER_CHG, PRIV_USER_DEL,
PRIV_GROUP_ADD, PRIV_GROUP_CHG, PRIV_GROUP_DEL, PRIV_BLANKS, PRIV_INFOS_EDIT)
VALUES ('Опытные пользователи', 'Пользователи с повышенными привилегиями',
true, true, false, true, true,
false, true, true, false, true,
true, true, false, false, false,
false, false, false, true, false);

INSERT INTO user_groups(GROUP_NAME, GROUP_DESCR,
PRIV_CLN_ADD, PRIV_CLN_CHG, PRIV_CLN_DEL, PRIV_CAR_ADD, PRIV_CAR_CHG,
PRIV_CAR_DEL, PRIV_CONT_ADD, PRIV_CONT_CHG, PRIV_CONT_DEL, PRIV_CONT_PROLONG,
PRIV_CONT_REPLACE, PRIV_CONT_CLOSE, PRIV_USER_ADD, PRIV_USER_CHG, PRIV_USER_DEL,
PRIV_GROUP_ADD, PRIV_GROUP_CHG, PRIV_GROUP_DEL, PRIV_BLANKS, PRIV_INFOS_EDIT)
VALUES ('Пользователи', 'Обычные пользователи',
true, true, false, true, true,
false, true, false, false, true,
true, false, false, false, false,
false, false, false, false, false);

INSERT INTO user_groups(GROUP_NAME, GROUP_DESCR,
PRIV_CLN_ADD, PRIV_CLN_CHG, PRIV_CLN_DEL, PRIV_CAR_ADD, PRIV_CAR_CHG,
PRIV_CAR_DEL, PRIV_CONT_ADD, PRIV_CONT_CHG, PRIV_CONT_DEL, PRIV_CONT_PROLONG,
PRIV_CONT_REPLACE, PRIV_CONT_CLOSE, PRIV_USER_ADD, PRIV_USER_CHG, PRIV_USER_DEL,
PRIV_GROUP_ADD, PRIV_GROUP_CHG, PRIV_GROUP_DEL, PRIV_BLANKS, PRIV_INFOS_EDIT)
VALUES ('Только для чтения', 'Минимальные права. Разрешён только просмотр БД',
false, false, false, false, false,
false, false, false, false, false,
false, false, false, false, false,
false, false, false, false, false);

/*==============================================================*/
/* Table : user_settings                                        */
/*==============================================================*/

# User
# Host
# MW_WIDTH
# MW_HEIGHT
# MW_LEFT
# MW_TOP
# MW_STATE
# USE_HELPER
#INSERT INTO user_settings VALUES('root', '%', 100, 100, 100, 100, 0, 1);

/*==============================================================*/
/* Table : error_info                                           */
/*==============================================================*/

# ERROR_CODE, ERROR_NAME, ERROR_DESCR

INSERT INTO error_info VALUES(0, 'ERR_NO_ERROR', 'Нет ошибки');
INSERT INTO error_info VALUES(1, 'ERR_NO_RESULT',
  'Нет ошибки, но результат неизвестен');
INSERT INTO error_info VALUES(2, 'ERR_COMMON_ERROR', 'Общая ошибка');
INSERT INTO error_info VALUES(3, 'ERR_NOT_ENOUGH_RIGHTS', 'Недостаточно прав');
INSERT INTO error_info VALUES(4, 'ERR_UNDEFINED_ERROR',
  'Неопределённая ошибка. Устанавливается, если константа ошибки неизвестна функции SetLastError');
INSERT INTO error_info VALUES(5, 'ERR_FUNC_NOT_IMPLEMENTED',
  'Данная функция ещё не реализована');
INSERT INTO error_info VALUES(6, 'ERR_ENTITY_NOT_EXISTS',
  'Сущности с такими данными не существует');

INSERT INTO error_info VALUES(30, 'ERR_NO_FREEBLANK',
  'Не существует запрошенного свободного пустого бланка');
INSERT INTO error_info VALUES(31, 'ERR_BLANK_USED',
  'Запрошенный бланк уже используется');
INSERT INTO error_info VALUES(32, 'ERR_NO_RESERVED_BLANK',
  'Бланк не был зарезервирован');
INSERT INTO error_info VALUES(33, 'ERR_CANNOT_RESERVE_BLANK',
  'Не удалось зарезервировать данный бланк');
INSERT INTO error_info VALUES(34, 'ERR_BLANKS_RESERVED_ERR1',
  'Зарезервировано');
INSERT INTO error_info VALUES(35, 'ERR_BLANKS_RESERVED_ERR2',
  'Зарезервировано');
INSERT INTO error_info VALUES(36, 'ERR_DATES_INCORRECT',
  'Переданы неправильные значения дат');
INSERT INTO error_info VALUES(40, 'ERR_USER_NOT_EXISTS',
  'Такого пользователя не существует');
INSERT INTO error_info VALUES(41, 'ERR_USER_DATA_INCORRECT',
  'Данные пользователя неверны');
INSERT INTO error_info VALUES(42, 'ERR_USER_EXISTS',
  'Пользователь уже существет в системе');

/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;

FLUSH TABLES;

# EOF.