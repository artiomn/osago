use osago;

set names cp866;

/*!40014 SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0 */;

/* Сценарий, изменяющий структуру БД на уровне таблиц.
Действия сценария:
  1.) Создать таблицы:
    1. base_sum.
    2. user_data.
    3. user_settings.
    4. user_groups.
    5. blanks_journal.
    6. ins_koefs_ko.
    7. ins_koefs_kvs.
    8. ins_koefs_km.
    9. ins_koefs_kp
    10. ins_koefs_ks.
    11. ins_koefs_foreing.
    12. ins_koefs_other.
    13. ins_formula.
    14. ins_formula_type.
    15. ins_formula_conf.
    16. city.
    17. country.
    18. region.
    19. geo_groups.
    20. car_model.
    21. self_info.
    22. error_info.
  2.) Изменить таблицы:
    1. territory_use.
      а.) +Коэффициент. TERRITORY_KOEF.
      б.) +Группа регионов. GEO_GROUP.
      в.) +ID типа трансп. средства. ID_CAR_TYPE.
    2. dogovor_type.
      а.) +Цвет подсветки статуса. TYPE_COLOR.
    3. dogovor.
      а.) +ID предыдущего договора. ID_PREV_DOG.
      б.) Сменить название KOEF_PIZDEC на KOEF_KN.
      в.) +Начало второго доп. периода. START_USE2.
      г.) +Конец второго доп. периода. END_USE2.
    4. insurance_company.
      а.) +Адрес. ADDRESS.
      б.) +Телефон. PHONE.
      в.) +Факс. FAX.
      г.) +Комментарии. COMMENTS.
      д.) +Квитанция. TICKET_BODY.
    5. client.
      а.) +Комментарий. COMMENTS.
      б.) Переимен. PHONE в HOME_PHONE.
      в.) +Сотовый. CELL_PHONE.
      г.) +Рабочий. BUSINESS_PHONE.
      д.) +Флаг грубых нарушений. GROSS_VIOLATIONS.
      е.) +ID страны.
      ж.) +ID региона.
      з.) +ID города.
      и.) +Дата последнего звонка.
    6. car.
      а.) +Комментарий. COMMENTS.
    7. Добавить в client, dogovor, car поля:
      USER_INSERT_NAME VARCHAR(255), USER_UPDATE_NAME VARCHAR(255).
  3.) Сменить движок на InnoDB. Ввести внешние ключи там, где это необходимо.
*/

# Вывожу понтовые сообщения.

select 'CREATING' as tables;

/*==============================================================*/
/* Table : geo_groups                                           */
/*==============================================================*/

# Названия групп. Для удобства редактирования.
# Ещё сюда ссылаются внешние ключи InnoDB и lookup-поля клиента.

CREATE TABLE IF NOT EXISTS geo_groups (
  GEO_GROUP INT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  NAME VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (GEO_GROUP)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci
AUTO_INCREMENT=0;

/*==============================================================*/
/* Table : car_model                                            */
/*==============================================================*/

# ALTER TABLE carmark ENGINE = InnoDB;

# Внешние ключи далее.

CREATE TABLE IF NOT EXISTS car_model (
  ID_CAR_MODEL INT UNSIGNED AUTO_INCREMENT,
  ID_CARMARK INT,
  MODEL VARCHAR(255),
  PRIMARY KEY (ID_CAR_MODEL)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci
AUTO_INCREMENT=0;

/*==============================================================*/
/* Table : base_sum                                             */
/*==============================================================*/

create table if not exists base_sum
(
   ID_CLIENT_TYPE_GROUP          INT,
   ID_CAR_TYPE                   INT,
   BASE                          FLOAT,
   primary key (ID_CLIENT_TYPE_GROUP, ID_CAR_TYPE)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : user_groups                                          */
/*==============================================================*/

create table if not exists user_groups
(
   ID_GROUP                      TINYINT AUTO_INCREMENT NOT NULL,
   GROUP_NAME                    VARCHAR(255),
   GROUP_DESCR                   VARCHAR(255),
   PRIV_BLANKS                   BOOL,
   PRIV_CAR_ADD                  BOOL,
   PRIV_CAR_CHG                  BOOL,
   PRIV_CAR_DEL                  BOOL,
   PRIV_CLN_ADD                  BOOL,
   PRIV_CLN_CHG                  BOOL,
   PRIV_CLN_DEL                  BOOL,
   PRIV_CONT_ADD                 BOOL,
   PRIV_CONT_CHG                 BOOL,
   PRIV_CONT_DEL                 BOOL,
   PRIV_CONT_PROLONG             BOOL,
   PRIV_CONT_REPLACE             BOOL,
   PRIV_CONT_CLOSE               BOOL,
   PRIV_USER_ADD                 BOOL,
   PRIV_USER_CHG                 BOOL,
   PRIV_USER_DEL                 BOOL,
   PRIV_GROUP_ADD                BOOL,
   PRIV_GROUP_CHG                BOOL,
   PRIV_GROUP_DEL                BOOL,
   PRIV_INFOS_EDIT               BOOL,
   primary key(ID_GROUP)
   #unique key(ID_GROUP)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : user_data                                            */
/*==============================================================*/
# Не пашет установка кодировки
# User CHARACTER SET utf8 COLLATE utf8_bin,
# Host CHARACTER SET utf8 COLLATE utf8_bin,
create table if not exists user_data
(
   User                          CHAR(16) NOT NULL,
   Host                          CHAR(60) NOT NULL,
   SURNAME                       VARCHAR(80),
   NAME                          VARCHAR(80),
   PATHRONIMYC                   VARCHAR(80),
   ADDRESS                       VARCHAR(255),
   HOME_PHONE                    VARCHAR(255),
   CELL_PHONE                    VARCHAR(255),
   ID_GROUP                      TINYINT,
   COMMENTS                      VARCHAR(255),
   primary key(User, Host),
   foreign key(ID_GROUP) references user_groups(ID_GROUP)
   on delete restrict on update cascade
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : user_settings                                        */
/*==============================================================*/

# CHARACTER SET utf8 COLLATE utf8_bin,
# CHARACTER SET utf8 COLLATE utf8_bin,
create table if not exists user_settings
(
   User                          CHAR(16) NOT NULL,
   Host                          CHAR(60) NOT NULL,
   MW_WIDTH                      INT,
   MW_HEIGHT                     INT,
   MW_LEFT                       INT,
   MW_TOP                        INT,
   MW_STATE                      BOOL,
   USE_HELPER                    BOOL,
   FIRST_RUN                     BOOL,
   primary key(User, Host),
   foreign key(User, Host) references user_data(User, Host)
   on delete cascade on update cascade
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : ins_koefs_ko                                         */
/*==============================================================*/

create table if not exists ins_koefs_ko
(
   KO_LIMITED                    FLOAT,
   KO_UNLIM                      FLOAT
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : ins_koefs_kvs                                        */
/*==============================================================*/

create table if not exists ins_koefs_kvs
(
   MAX_STAGE                     FLOAT,
   MAX_AGE                       FLOAT,
   KVS                           FLOAT,
   primary key (MAX_STAGE, MAX_AGE)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : ins_koefs_km                                         */
/*==============================================================*/

create table if not exists ins_koefs_km
(
   ID_CAR_TYPE                   INT,
   MAX_POWER                     FLOAT,
   KM                            FLOAT,
   primary key (ID_CAR_TYPE, MAX_POWER)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : ins_koefs_kp                                         */
/*==============================================================*/

create table if not exists ins_koefs_kp
(
   PERIOD_INS                    FLOAT,
   KP                            FLOAT,
   primary key (PERIOD_INS)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : ins_koefs_ks                                         */
/*==============================================================*/

create table if not exists ins_koefs_ks
(
   PERIOD_USE                    FLOAT,
   KS                            FLOAT,
   primary key (PERIOD_USE)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : ins_koefs_foreing                                    */
/*==============================================================*/

create table if not exists ins_koefs_foreing
(
   GEO_GROUP                     INT UNSIGNED,
   ID_CLIENT_TYPE_GROUP          INT,
   KO                            FLOAT,
   KVS                           FLOAT,
   KBM                           FLOAT,
   PRIMARY KEY(GEO_GROUP, ID_CLIENT_TYPE_GROUP),
   foreign key(GEO_GROUP) references geo_groups(GEO_GROUP)
   on delete restrict on update cascade
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : ins_koefs_other                                      */
/*==============================================================*/

create table if not exists ins_koefs_other
(
   KN                            FLOAT,
   KP_TRANSIT                    FLOAT
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : ins_formula                                          */
/*==============================================================*/

create table if not exists ins_formula
(
  ID_FORMULA INT(8) UNSIGNED AUTO_INCREMENT,
  FORMULA VARCHAR(255),
  DESCR VARCHAR(255),
  INDEX iformula(FORMULA),
  PRIMARY KEY(ID_FORMULA)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : ins_formula_type                                     */
/*==============================================================*/

create table if not exists ins_formula_type
(
  ID_INS_FORMULA_TYPE INT(3) UNSIGNED AUTO_INCREMENT,
  TRANSIT BOOL NOT NULL,
  FOREING BOOL NOT NULL,
  NAME VARCHAR(255),
  PRIMARY KEY(ID_INS_FORMULA_TYPE),
  UNIQUE KEY(TRANSIT, FOREING)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : ins_formula_conf                                     */
/*==============================================================*/

create table if not exists ins_formula_conf
(
  ID_INS_FORMULA_TYPE INT(3) UNSIGNED,
  ID_CAR_TYPE INT,
  ID_CLIENT_TYPE_GROUP INT,
  ID_FORMULA INT(8) UNSIGNED,
  PRIMARY KEY(ID_INS_FORMULA_TYPE, ID_CAR_TYPE, ID_CLIENT_TYPE_GROUP),
  foreign key(ID_INS_FORMULA_TYPE)
  references ins_formula_type(ID_INS_FORMULA_TYPE)
  on delete restrict on update cascade,
  foreign key(ID_FORMULA) references ins_formula(ID_FORMULA)
  on delete restrict on update cascade
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : self_info                                            */
/*==============================================================*/

create table if not exists self_info
(
   DB_SUB_VERSION                TINYINT UNSIGNED,
   DB_MAJOR_VERSION              TINYINT  UNSIGNED,
   CLIENT_VERSION                FLOAT,
   BLANK_MULTIRESERVE            BOOL DEFAULT FALSE,
   MAX_QUERIES_PER_HOUR          INT DEFAULT 0,
   MAX_UPDATES_PER_HOUR          INT DEFAULT 0,
   MAX_CONNECTIONS_PER_HOUR      INT DEFAULT 0,
   MAX_USER_CONNECTIONS          INT DEFAULT 0,
   REFRESH_TIME                  INT DEFAULT 3
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : error_info                                           */
/*==============================================================*/

create table if not exists error_info
(
   ERROR_CODE                    INT,
   ERROR_NAME                    CHAR(30),
   ERROR_DESCR                   VARCHAR(255),
   primary key(ERROR_CODE),
   unique (ERROR_NAME)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : change_log                                           */
/*==============================================================*/

create table if not exists change_log
(
   CLID                          INT AUTO_INCREMENT,
   TABLE_NAME                    CHAR(64),
   RECORD_ID                     CHAR(255),
   ACTION_TYPE                   ENUM('i', 'u', 'd', 'a'),
   INSERT_TIME                   TIMESTAMP
                                 DEFAULT CURRENT_TIMESTAMP
                                 ON UPDATE CURRENT_TIMESTAMP,
   USER_INSERTER                 CHAR(16),
   primary key(CLID)
)
ENGINE=MEMORY
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : blanks_journal                                       */
/*==============================================================*/

create table if not exists blanks_journal
(
   ID_INSURANCE_COMPANY          INT NOT NULL default 0,
   DOG_SER                       VARCHAR(10) NOT NULL,
   DOGNUMB                       VARCHAR(25) NOT NULL,
   ID_BSO_STATUS                 VARCHAR(22),
   USER_RESERVER                 CHAR(16) default NULL,
   HOST_RESERVER                 CHAR(22) default NULL,
   DATE_INSERT                   DATE,
   DATE_UPDATE                   DATE,
   primary key (ID_INSURANCE_COMPANY, DOG_SER, DOGNUMB),
   key (USER_RESERVER, HOST_RESERVER)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : city                                                 */
/*==============================================================*/

CREATE TABLE IF NOT EXISTS city
(
  ID_CITY INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  ID_REGION INT(10) UNSIGNED NOT NULL,
  ID_COUNTRY INT(8) UNSIGNED NOT NULL,
  NAME VARCHAR(255) DEFAULT NULL,
  GEO_GROUP INT(8) UNSIGNED,
  PRIMARY KEY  (ID_CITY),
  KEY ID_REGION (ID_REGION),
  KEY ID_COUNTRY (ID_COUNTRY),
  KEY GEO_GROUP (GEO_GROUP),
  foreign key(GEO_GROUP) references geo_groups(GEO_GROUP)
  on delete restrict on update cascade
)
ENGINE=InnoDB
CHARACTER SET=cp1251 COLLATE cp1251_general_ci
AUTO_INCREMENT=17590;

/*==============================================================*/
/* Table : region                                               */
/*==============================================================*/

CREATE TABLE IF NOT EXISTS region (
  ID_REGION INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  ID_COUNTRY INT(8) UNSIGNED NOT NULL,
  NAME VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY  (ID_REGION),
  KEY ID_COUNTRY (ID_COUNTRY)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci
AUTO_INCREMENT=1612;

/*==============================================================*/
/* Table : country                                              */
/*==============================================================*/

CREATE TABLE IF NOT EXISTS country (
  ID_COUNTRY INT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  NAME VARCHAR(50) NOT NULL,
  PRIMARY KEY (ID_COUNTRY)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci
AUTO_INCREMENT=219;

# Сообщение

select 'RESTRUCTURE' as tables;

/*==============================================================*/
/* Table : territory_use                                        */
/*==============================================================*/

truncate territory_use;

alter table territory_use
ADD TERRITORY_KOEF FLOAT,
ADD GEO_GROUP INT UNSIGNED after ID_TERRITORY_USE,
ADD ID_CAR_TYPE INT after ID_TERRITORY_USE,
ADD UNIQUE KEY(ID_CAR_TYPE, GEO_GROUP),
MODIFY ID_TERRITORY_USE INT AUTO_INCREMENT,
COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : dogovor_type                                         */
/*==============================================================*/

alter table dogovor_type
ADD TYPE_COLOR INT,
COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : dogovor                                              */
/*==============================================================*/

alter table dogovor
ADD (ID_PREV_DOG VARCHAR(22) default NULL,
START_USE2 DATE, END_USE2 DATE,
TICKET_SER VARCHAR(10), TICKET_NUM VARCHAR(25), TICKET_DATE DATE,
USER_INSERT_NAME VARCHAR(255), USER_UPDATE_NAME VARCHAR(255)),
CHANGE KOEF_PIZDEC KOEF_KN FLOAT,
MODIFY ID_INSURANCE_COMPANY INT,
MODIFY ID_DOGOVOR_TYPE INT,
MODIFY ID_TERRITORY_USE INT,
MODIFY TRANSIT BOOL,
MODIFY UNLIMITED_DRIVERS BOOL,
DROP COLUMN ID_AGENT,
DROP COLUMN ID_AGENT_WRITE,
DROP COLUMN PROLONG,
DROP COLUMN DOGNUM_VOLUNTAR,
DROP COLUMN ID_INS_COMP_VOLUNTAR,
DROP COLUMN ID_DEPARTMENT,
DROP COLUMN EXPORT_1C,
DROP COLUMN EXPORT_AIS,
DROP COLUMN IMPORT_DATE,
COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : drivers                                              */
/*==============================================================*/

alter table drivers
DROP COLUMN IMPORT_DATE,
COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : dogovor_history                                      */
/*==============================================================*/

alter table dogovor_history
MODIFY ID_DOGOVOR_STATE INT,
MODIFY EVENT_DATE DATE,
COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : insurance_company                                    */
/*==============================================================*/

alter table insurance_company AUTO_INCREMENT = 93,
ADD (ADDRESS VARCHAR(255), PHONE VARCHAR(60), FAX VARCHAR(60),
  COMMENTS VARCHAR(255), TICKET_BODY BLOB),
CHANGE iNSURANCE_COMPANY INSURANCE_COMPANY VARCHAR(255),
MODIFY ID_INSURANCE_COMPANY INT AUTO_INCREMENT,
COLLATE cp1251_general_ci;
update insurance_company set ID_INSURANCE_COMPANY = 0
where ID_INSURANCE_COMPANY = 93;

/*==============================================================*/
/* Table : client                                               */
/*==============================================================*/

alter table client
ADD (GROSS_VIOLATIONS BOOL DEFAULT FALSE, CELL_PHONE VARCHAR(60),
  BUSINESS_PHONE VARCHAR(60),
  LAST_CALL_DATE DATE,
  ID_CITY INT(10) UNSIGNED,
  ID_REGION INT(10) UNSIGNED,
  ID_COUNTRY INT(8) UNSIGNED,
  COMMENTS VARCHAR(255),
USER_INSERT_NAME VARCHAR(255), USER_UPDATE_NAME VARCHAR(255)),
CHANGE PHONE HOME_PHONE VARCHAR(255),
MODIFY ID_FAMILY_STATE INT,
MODIFY ID_SEX INT,
MODIFY ID_CLIENT_TYPE INT,
MODIFY ID_TYPE_DOC INT,
MODIFY ID_INSURANCE_CLASS INT,
#DROP COLUMN WRITER_NAME,
DROP COLUMN WRITER_DOVER,
DROP COLUMN IMPORT_DATE,
COLLATE cp1251_general_ci;

/*==============================================================*/
/* Table : car                                                  */
/*==============================================================*/

alter table car
ADD (USER_INSERT_NAME VARCHAR(255), USER_UPDATE_NAME VARCHAR(255),
  COMMENTS VARCHAR(255)),
MODIFY ARENDA BOOL,
MODIFY ID_PURPOSE_TYPE INT,
MODIFY ID_CAR_TYPE INT,
MODIFY YEAR_ISSUE INT(5),
MODIFY NUM_PLACES INT,
MODIFY FOREING BOOL,
DROP COLUMN IMPORT_DATE,
DROP COLUMN PROPERTY,
COLLATE cp1251_general_ci;

#
# Удаление ненужных таблиц
#

# Сообщение
select 'DROP unused' as tables;

DROP TABLE IF EXISTS accident_place;
DROP TABLE IF EXISTS accouting;
DROP TABLE IF EXISTS accouting_detail;
DROP TABLE IF EXISTS act_detail;
DROP TABLE IF EXISTS agent;
DROP TABLE IF EXISTS bso_journal;
DROP TABLE IF EXISTS circumstance;
DROP TABLE IF EXISTS config;
DROP TABLE IF EXISTS config_schet;
DROP TABLE IF EXISTS crash_place;
DROP TABLE IF EXISTS department_types;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS device_type;
DROP TABLE IF EXISTS dogovor_oper;
DROP TABLE IF EXISTS export_1c;
DROP TABLE IF EXISTS export_ais;
DROP TABLE IF EXISTS export_config;
DROP TABLE IF EXISTS failure_type;
DROP TABLE IF EXISTS gibdd_request;
DROP TABLE IF EXISTS guilty_type;
DROP TABLE IF EXISTS incident_types;
DROP TABLE IF EXISTS inspection_certificate;
DROP TABLE IF EXISTS insurance_act;
DROP TABLE IF EXISTS loss;
DROP TABLE IF EXISTS loss_car;
DROP TABLE IF EXISTS pay_type;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS payment_type;
DROP TABLE IF EXISTS protocol;
DROP TABLE IF EXISTS regiones;
DROP TABLE IF EXISTS suffering_face;
DROP TABLE IF EXISTS type_lossed;
DROP TABLE IF EXISTS witness;
DROP TABLE IF EXISTS user_role;
DROP TABLE IF EXISTS users;

#
# Изменение полей на корректные типы и прочая корректировка
#

alter table family_state auto_increment = 5;
alter table family_state modify ID_FAMILY_STATE INT auto_increment;
update family_state set id_family_state = 0 where id_family_state = 5;

alter table sex auto_increment = 11;
alter table sex modify ID_SEX int auto_increment;
update sex set id_sex = 0 where id_sex = 11;

alter table type_doc auto_increment = 11;
alter table type_doc modify ID_TYPE_DOC INT auto_increment;
update type_doc set id_type_doc = 0 where id_type_doc = 11;

alter table client_types auto_increment 15;
alter table client_types modify ID_CLIENT_TYPE INT auto_increment;
update client_types set ID_CLIENT_TYPE = 0 where ID_CLIENT_TYPE = 15;

alter table insurance_class auto_increment = 16;
alter table insurance_class modify ID_INSURANCE_CLASS INT auto_increment;
update insurance_class set ID_INSURANCE_CLASS = 0 where ID_INSURANCE_CLASS = 16;

alter table client_type_group auto_increment = 3;
alter table client_type_group modify ID_CLIENT_TYPE_GROUP INT auto_increment;

update carmark set ID_CARMARK = 51 where ID_CARMARK = 0;
alter table carmark auto_increment = 50;
alter table carmark modify ID_CARMARK INT auto_increment;
update carmark set ID_CARMARK = 0 where ID_CARMARK = 51;

alter table car_type auto_increment = 14;
alter table car_type modify ID_CAR_TYPE INT auto_increment;
update car_type set ID_CAR_TYPE = 0 where ID_CAR_TYPE = 14;

alter table purpose_type auto_increment = 11;
alter table purpose_type modify ID_PURPOSE_TYPE INT auto_increment;
update purpose_type set ID_PURPOSE_TYPE = 0 where ID_PURPOSE_TYPE = 11;

alter table dogovor_state auto_increment = 5;
alter table dogovor_state modify ID_DOGOVOR_STATE INT auto_increment;

/*==============================================================*/
/* Table : bso_status                                           */
/*==============================================================*/

# Truncate дохнет.

drop table bso_status;
CREATE TABLE bso_status (
  ID_BSO_STATUS VARCHAR(22),
  BSO_STATUS VARCHAR(255),
  primary key (ID_BSO_STATUS)
)
ENGINE=INNODB
#ROW_FORMAT=DYNAMIC
CHARACTER SET cp1251 COLLATE cp1251_general_ci;

#
# Оптимизация
#

# Сообщение
select 'OPTIMIZING' as tables;

OPTIMIZE TABLE bso_status;
OPTIMIZE TABLE bso_type;
OPTIMIZE TABLE car;
OPTIMIZE TABLE carmark;
OPTIMIZE TABLE car_type;
OPTIMIZE TABLE client;
OPTIMIZE TABLE client_types;
OPTIMIZE TABLE dogovor;
OPTIMIZE TABLE dogovor_history;
OPTIMIZE TABLE dogovor_state;
OPTIMIZE TABLE dogovor_type;
OPTIMIZE TABLE drivers;
OPTIMIZE TABLE family_state;
OPTIMIZE TABLE insurance_company;
OPTIMIZE TABLE insurance_class;
OPTIMIZE TABLE producter_type;
OPTIMIZE TABLE purpose_type;
OPTIMIZE TABLE sex;
OPTIMIZE TABLE territory_use;
OPTIMIZE TABLE type_doc;

# Сообщение
select 'CONVERTING to: InnoDB' as tables;

#
# Преобразование в InnoDB
#

ALTER TABLE bso_status          ENGINE = InnoDB;
ALTER TABLE bso_type            ENGINE = InnoDB;
ALTER TABLE client              ENGINE = InnoDB;
ALTER TABLE client_type_group   ENGINE = InnoDB;
ALTER TABLE client_types        ENGINE = InnoDB;
ALTER TABLE car                 ENGINE = InnoDB;
ALTER TABLE carmark             ENGINE = InnoDB;
ALTER TABLE car_type            ENGINE = InnoDB;
ALTER TABLE dogovor             ENGINE = InnoDB;
ALTER TABLE dogovor_history     ENGINE = InnoDB;
ALTER TABLE dogovor_state       ENGINE = InnoDB;
ALTER TABLE dogovor_type        ENGINE = InnoDB;
ALTER TABLE family_state        ENGINE = InnoDB;
ALTER TABLE drivers             ENGINE = InnoDB;
ALTER TABLE insurance_class     ENGINE = InnoDB;
ALTER TABLE insurance_company   ENGINE = InnoDB;
ALTER TABLE producter_type      ENGINE = InnoDB;
ALTER TABLE purpose_type        ENGINE = InnoDB;
ALTER TABLE sex                 ENGINE = InnoDB;
ALTER TABLE type_doc            ENGINE = InnoDB;
ALTER TABLE territory_use       ENGINE = InnoDB;
ALTER TABLE valuta              ENGINE = InnoDB;

#
# Создание индексов.
#

# Сообщение
select 'INDEXES CREATING' as tables;

# Клиент.

DROP INDEX I_CL_NAME ON client;
DROP INDEX I_CL_SURNAME ON client;
DROP INDEX XIF1CLIENT ON client;
DROP INDEX XIF2CLIENT ON client;
DROP INDEX XIF3CLIENT ON client;
DROP INDEX XIF5CLIENT ON client;
DROP INDEX XIF6CLIENT ON client;

CREATE INDEX i_surname ON client(SURNAME);
CREATE INDEX i_name ON client(NAME);
CREATE INDEX i_pathr ON client(MIDDLENAME);
CREATE INDEX i_inn ON client(INN);
CREATE INDEX i_cln_type ON client(ID_CLIENT_TYPE);
CREATE INDEX i_ins_class ON client(ID_INSURANCE_CLASS);
CREATE INDEX i_doc_ser ON client(DOC_SER);
CREATE INDEX i_doc_num ON client(DOC_NUM);
CREATE INDEX i_doc_type ON client(ID_TYPE_DOC);
CREATE INDEX i_lic_ser ON client(LICENCE_SER);
CREATE INDEX i_lic_num ON client(LICENCE_NO);
CREATE INDEX i_town ON client(TOWN);
CREATE INDEX i_street ON client(STREET);
CREATE INDEX i_home ON client(HOME, KORPUS);
CREATE INDEX i_flat ON client(FLAT);

# ТС.

DROP INDEX XIF17CAR ON car;
DROP INDEX XIF18CAR ON car;
DROP INDEX XIF20CAR ON car;
DROP INDEX XIF21CAR ON car;

CREATE INDEX i_car_type ON car(ID_CAR_TYPE);
CREATE INDEX i_puprose_type ON car(ID_PURPOSE_TYPE);
CREATE INDEX i_client ON car(ID_CLIENT);
CREATE INDEX i_vin ON car(VIN_NUM);
CREATE INDEX i_shassi ON car(SHASSI);
CREATE INDEX i_kusov ON car(KUSOV);
CREATE INDEX i_gos_num ON car(GOS_NUM);
CREATE INDEX i_pts_ser ON car(PTS_SER);
CREATE INDEX i_pts_num ON car(PTS_NO);
CREATE INDEX i_pts_date ON car(PTS_DATE);

# Договор.

DROP INDEX XIF11DOGOVOR ON dogovor;
DROP INDEX XIF19DOGOVOR ON dogovor;
DROP INDEX XIF25DOGOVOR ON dogovor;
DROP INDEX XIF7DOGOVOR ON dogovor;
DROP INDEX XIF9DOGOVOR ON dogovor;

CREATE INDEX i_ins_company ON dogovor(ID_INSURANCE_COMPANY);
CREATE INDEX i_car ON dogovor(ID_CAR);
CREATE INDEX i_terr_use ON dogovor(ID_TERRITORY_USE);
CREATE INDEX i_dogovor_type ON dogovor(ID_DOGOVOR_TYPE);
CREATE INDEX i_dog_ser ON dogovor(DOG_SER);
CREATE INDEX i_dog_num ON dogovor(DOGNUMB);

#
# Создание внешних ключей.
#

# Сообщение
select 'FOREIGN KEYS CREATING' as tables;

alter table blanks_journal
add foreign key blanks_journal(ID_INSURANCE_COMPANY)
references insurance_company(ID_INSURANCE_COMPANY)
on delete set NULL on update cascade;

alter table car
add foreign key car(ID_CAR_TYPE)
references car_type(ID_CAR_TYPE)
on delete restrict on update cascade;

alter table car_model
add foreign key(ID_CARMARK)
references carmark(ID_CARMARK)
on delete cascade on update cascade;

alter table client
add foreign key client(ID_INSURANCE_CLASS)
references insurance_class(ID_INSURANCE_CLASS)
on delete set NULL on update cascade,
add foreign key client(ID_REGION)
references region(ID_REGION)
on delete set NULL on update cascade;

alter table dogovor
add foreign key dogovor(ID_CLIENT)
references client(ID_CLIENT)
on delete cascade on update cascade,
add foreign key dogovor(ID_CAR)
references car(ID_CAR)
on delete cascade on update cascade,
add foreign key dogovor(ID_INSURANCE_COMPANY)
references insurance_company(ID_INSURANCE_COMPANY)
on delete set NULL on update cascade;

alter table dogovor_history
add foreign key dogovor_history(ID_DOGOVOR)
references dogovor(ID_DOGOVOR)
on delete cascade on update cascade;

alter table drivers
add foreign key drivers(ID_CAR)
references car(ID_CAR)
on delete cascade on update cascade,
add foreign key drivers(ID_CLIENT)
references client(ID_CLIENT)
on delete cascade on update cascade,
add foreign key drivers(ID_DOGOVOR)
references dogovor(ID_DOGOVOR)
on delete cascade on update cascade;

alter table territory_use
add foreign key(GEO_GROUP) references geo_groups(GEO_GROUP)
on delete restrict on update cascade;

#
# Создаю монитор InnoDB.
#

# Сообщение
#select 'CREATING MONITOR' as InnoDB;

#create table innodb_monitor (int a) engine = innodb;

FLUSH PRIVILEGES;
FLUSH TABLES;

/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;

# EOF.