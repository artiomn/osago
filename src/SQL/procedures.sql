use osago;

set names cp866;

delimiter ;;

/* Сценарий, создающий требуемые серверные процедуры.

    1. Ведение базы клиентов.
      а.) Добавить клиента. ClnAdd. Г3.
      б.) Изменить клиента. ClnChg. Г3.
      в.) Проверить существование клиента. ClnExists. Г3.
      г.) Удалить клиента. ClnDel. Заглушка. Г1.
      д.) Поиск. ClnSearch. Не реализовано. Г3.
      е.) Напомнить клиенту. ClnRemind. Г3.
    2. Ведение БД транспортных средств.
      а.) Добавить ТС. CarAdd. Г3.
      б.) Изменение. CarChg. Г3.
      в.) Проверить существование ТС. CarExists. Г3.
      г.) Удаление. CarDel. Заглушка. Г1.
      д.) Поиск. CarSearch. Не реализовано. Г3.
    3. Ведение БД договоров.
      а.) Добавление. ContAdd. Г3.
      б.) Изменение. ContChg. Г2.
      в.) Проверить существование договора. ContExists. Г3.
      г.) Пролонгация договора. ContProlong. Г3.
      д.) Замена договора. ContReplace. Г3.
      е.) Закрытие договора. ContClose. Г2.
      ж.) История договоров. ContHistory. Г3.
      з.) Удаление. ContDel. Г1.
      и.) Поиск. ContSearch. Не реализовано. Г3.
      к.) Резервирование пустого бланка. BlankReserve. Г3. Права на добавление.
      л.) Разрезервирование пустого бланка. BlankUnreserve. Г3.
        Права на добавление.
      м.) Добавление пустого бланка полиса. BlankAdd. Г2.
      н.) Порча бланка. BlankDamage. Г3.
    4. Работа с пользователями и группами.
      а.) Получить данные текущего пользователя. UserGetCurrent. Г3.
      б.) Сохранить настройки данного пользователя. UserSaveSettings. Г3.
      в.) Получить данные всех пользователей. UserGetAll. Г1.
      г.) Добавить пользователя. UserAdd. Г1.
      д.) Удалить пользователя. UserDel. Г1.
      е.) Изменить пользователя. UserChg. Г1.
      ж.) Добавить группу. GroupAdd. Заглушка. Г1.
      з.) Удалить группу. GroupDel. Заглушка. Г1.
      и.) Изменить группу. GroupChg. Заглушка. Г1.
    5. Общие процедуры.
      а.) Получение ID группы пользователя. GetGroupID. Г3.
      б.) Получение уникального ID пользователя. GetUserID. Г3.
      в.) Выполнить произвольный запрос. ExecQuery. Г1.

*/

/* Общая структура, команды создания процедур (помимо специальных):

DROP PROCEDURE IF EXISTS sp_name;

CREATE
DEFINER = 'root'@'%'
PROCEDURE sp_name([proc_parameter[,...]])
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: '
sproc: BEGIN

  call SetLastError('ERR_NO_ERROR');
END;

err_code равен 0, в случае удачного завершения.

*/


/*==============================================================*/
/* Procedure : InsKoefKVS_Get                                   */
/*==============================================================*/

DROP PROCEDURE IF EXISTS InsKoefKVS_Get;

CREATE
DEFINER = 'root'@'%'
PROCEDURE InsKoefKVS_Get(IN stage FLOAT, IN age FLOAT)
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'Получение коэффициента КВС'
BEGIN
  declare kvs_tgt_stage, kvs_tgt_age FLOAT;

  # Определяю корректные значения полей ключа, для данных age и stage.
  select
    ifnull(min(if(MAX_STAGE >= stage, MAX_STAGE, NULL)), max(MAX_STAGE)),
    ifnull(min(if(MAX_AGE >= age, MAX_AGE, NULL)), max(MAX_AGE))
    from ins_koefs_kvs into kvs_tgt_stage, kvs_tgt_age;
  # Получаю КВС.
  select KVS from ins_koefs_kvs where
    MAX_STAGE = kvs_tgt_stage and MAX_AGE = kvs_tgt_age;
END;

/*==============================================================*/
/* Procedure : SetLastError                                     */
/*==============================================================*/

DROP PROCEDURE IF EXISTS SetLastError;

CREATE
DEFINER = 'root'@'%'
PROCEDURE SetLastError(IN err_name CHAR(30))
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'Установка кода ошибки. Привилегии вызывающего.'
BEGIN
  declare e_code INT default NULL;
  select ERROR_CODE into e_code from error_info where ERROR_NAME = err_name;
  if (e_code is NULL) then
    select ERROR_CODE into e_code from error_info where
      ERROR_NAME = 'ERR_UNDEFINED_ERROR';
  end if;
  set @err_code := e_code;
END;

/*==============================================================*/
/* Function : GetLastError                                      */
/*==============================================================*/

DROP FUNCTION IF EXISTS GetLastError;

CREATE
DEFINER = 'root'@'%'
FUNCTION GetLastError()
RETURNS INT
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'Получение кода ошибки'
BEGIN
  declare ec INT default @err_code;
  call SetLastError('ERR_NO_ERROR');
  if (ec is NULL) then
    set ec := @err_code;
  end if;
  return ec;
END;

/*==============================================================*/
/* Function : DescribeError                                     */
/*==============================================================*/

DROP FUNCTION IF EXISTS DescribeError;

CREATE
DEFINER = 'root'@'%'
FUNCTION DescribeError(code INT)
RETURNS VARCHAR(255)
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'Получение описания ошибки'
BEGIN
  declare e_desc VARCHAR(255);
  select ERROR_DESCR into e_desc from error_info where ERROR_CODE = code;
  return e_desc;
END;

/*==============================================================*/
/* Procedure : GetCurUser                                       */
/*==============================================================*/

DROP PROCEDURE IF EXISTS GetCurUser;

CREATE
DEFINER = 'root'@'%'
PROCEDURE GetCurUser(OUT user_name CHAR(16), OUT host_name CHAR(60))
READS SQL DATA
SQL SECURITY DEFINER
COMMENT 'Получение текущего пользователя'
BEGIN
  select substring_index(user(),"@", 1),
    substring_index(user(),"@", -1) into user_name, host_name;
  #!!! Костыль.
  select Host into host_name from mysql.user where User = user_name;
END;

/*==============================================================*/
/* Function : GetCurUserFullname                                */
/*==============================================================*/

DROP FUNCTION IF EXISTS  GetCurUserFullname;

CREATE
DEFINER = 'root'@'%'
FUNCTION GetCurUserFullname()
RETURNS TEXT
READS SQL DATA
SQL SECURITY DEFINER
COMMENT 'Получение полного имени текущего пользователя. Служебная.'
BEGIN
  declare user_name CHAR(16);
  declare user_host CHAR(60);
  declare result TEXT;

  call GetCurUser(user_name, user_host);
  select concat_ws(' ', surname, name, pathronimyc) into result from user_data where
    User = user_name and Host = user_host;
  return result;
END;

/*==============================================================*/
/* Function : GetGroupID()                                      */
/*==============================================================*/

DROP FUNCTION IF EXISTS GetGroupID;

CREATE
DEFINER = 'root'@'%'
FUNCTION GetGroupID()
RETURNS INT
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'Получение ID группы текущего пользователя'
BEGIN
  declare user_name CHAR(16);
  declare user_host CHAR(60);
  declare user_group_id INT default -1;
  
  call GetCurUser(user_name, user_host);

  select ID_GROUP into user_group_id from user_data
    where User = user_name and Host = user_host;

  return user_group_id;
END;

/*==============================================================*/
/* Procedure : GetTableChange                                   */
/*==============================================================*/

DROP PROCEDURE IF EXISTS GetTableChange;

CREATE
DEFINER = 'root'@'%'
PROCEDURE GetTableChange()
SQL SECURITY DEFINER
COMMENT 'Получение таблицы обновлений.'
sproc: BEGIN
  # Компоненты Zeos некорректно работают с "вложенными" таблицами (subq).
  # Чтобы это обойти и сделана процедура.
  SELECT *
    FROM change_log
    JOIN (SELECT MAX(CLID) AS CLID FROM change_log
    GROUP BY TABLE_NAME, RECORD_ID, ACTION_TYPE) subq USING (CLID);
END;

#
# Tables updation fixer.
#

DROP PROCEDURE IF EXISTS FixTableChange;

CREATE
DEFINER = 'root'@'%'
PROCEDURE FixTableChange(
  IN v_table_name CHAR(64),
  IN v_record_key CHAR(255),
  IN v_action ENUM('i', 'u', 'd', 'a')
)
SQL SECURITY INVOKER
COMMENT 'Служебная. Фиксация обновлений таблиц. Вызывается в триггерах.'
sproc: BEGIN
  declare client_refresh_rate INT;

  insert into change_log(TABLE_NAME, RECORD_ID, ACTION_TYPE, USER_INSERTER)
    values(v_table_name, v_record_key, v_action,
      substring_index(user(), "@", 1));

  select (REFRESH_TIME + 1) * 2 from self_info into client_refresh_rate;
  # Очистка старых значений.
  delete from change_log
    where (UNIX_TIMESTAMP() - UNIX_TIMESTAMP(INSERT_TIME) >= client_refresh_rate);
END;

/*==============================================================*/
/* Triggers : base_sum                                          */
/*==============================================================*/

DROP TRIGGER IF EXISTS `base_sum_ins`;
DROP TRIGGER IF EXISTS `base_sum_upd`;
DROP TRIGGER IF EXISTS `base_sum_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `base_sum_ins` AFTER INSERT ON `base_sum`
FOR EACH ROW
BEGIN
  call FixTableChange('base_sum',
    CONCAT_WS(';', NEW.ID_CLIENT_TYPE_GROUP, NEW.ID_CAR_TYPE), 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `base_sum_upd` AFTER UPDATE ON `base_sum`
FOR EACH ROW
BEGIN
  call FixTableChange('base_sum',
    CONCAT_WS(';', NEW.ID_CLIENT_TYPE_GROUP, NEW.ID_CAR_TYPE), 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `base_sum_del` AFTER DELETE ON `base_sum`
FOR EACH ROW
BEGIN
  call FixTableChange('base_sum',
    CONCAT_WS(';', OLD.ID_CLIENT_TYPE_GROUP, OLD.ID_CAR_TYPE), 'd');
END;

/*==============================================================*/
/* Triggers : blanks_journal                                    */
/*==============================================================*/

DROP TRIGGER IF EXISTS `blanks_journal_ins`;
DROP TRIGGER IF EXISTS `blanks_journal_upd`;
DROP TRIGGER IF EXISTS `blanks_journal_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `blanks_journal_ins` AFTER INSERT ON `blanks_journal`
FOR EACH ROW
BEGIN
  call FixTableChange('blanks_journal',
    CONCAT_WS(';', NEW.ID_INSURANCE_COMPANY, NEW.DOG_SER, NEW.DOGNUMB), 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `blanks_journal_upd` AFTER UPDATE ON `blanks_journal`
FOR EACH ROW
BEGIN
  call FixTableChange('blanks_journal',
    CONCAT_WS(';', NEW.ID_INSURANCE_COMPANY, NEW.DOG_SER, NEW.DOGNUMB), 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `blanks_journal_del` AFTER DELETE ON `blanks_journal`
FOR EACH ROW
BEGIN
  call FixTableChange('blanks_journal',
    CONCAT_WS(';', OLD.ID_INSURANCE_COMPANY, OLD.DOG_SER, OLD.DOGNUMB), 'd');
END;

/*==============================================================*/
/* Triggers : bso_status                                        */
/*==============================================================*/

DROP TRIGGER IF EXISTS `bso_status_ins`;
DROP TRIGGER IF EXISTS `bso_status_upd`;
DROP TRIGGER IF EXISTS `bso_status_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `bso_status_ins` AFTER INSERT ON `bso_status`
FOR EACH ROW
BEGIN
  call FixTableChange('bso_status', NEW.ID_BSO_STATUS, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `bso_status_upd` AFTER UPDATE ON `bso_status`
FOR EACH ROW
BEGIN
  call FixTableChange('bso_status', NEW.ID_BSO_STATUS, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `bso_status_del` AFTER DELETE ON `bso_status`
FOR EACH ROW
BEGIN
  call FixTableChange('bso_status', OLD.ID_BSO_STATUS, 'd');
END;

/*==============================================================*/
/* Triggers : car                                               */
/*==============================================================*/

DROP TRIGGER IF EXISTS `car_ins`;
DROP TRIGGER IF EXISTS `car_upd`;
DROP TRIGGER IF EXISTS `car_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `car_ins` AFTER INSERT ON `car`
FOR EACH ROW
BEGIN
  call FixTableChange('car', NEW.ID_CAR, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `car_upd` AFTER UPDATE ON `car`
FOR EACH ROW
BEGIN
  call FixTableChange('car', NEW.ID_CAR, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `car_del` AFTER DELETE ON `car`
FOR EACH ROW
BEGIN
  call FixTableChange('car', OLD.ID_CAR, 'd');
END;

/*==============================================================*/
/* Triggers : car_type                                          */
/*==============================================================*/

DROP TRIGGER IF EXISTS `car_type_ins`;
DROP TRIGGER IF EXISTS `car_type_upd`;
DROP TRIGGER IF EXISTS `car_type_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `car_type_ins` AFTER INSERT ON `car_type`
FOR EACH ROW
BEGIN
  call FixTableChange('car_type', NEW.ID_CAR_TYPE, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `car_type_upd` AFTER UPDATE ON `car_type`
FOR EACH ROW
BEGIN
  call FixTableChange('car_type', NEW.ID_CAR_TYPE, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `car_type_del` AFTER DELETE ON `car_type`
FOR EACH ROW
BEGIN
  call FixTableChange('car_type', OLD.ID_CAR_TYPE, 'd');
END;

/*==============================================================*/
/* Triggers : carmark                                           */
/*==============================================================*/

DROP TRIGGER IF EXISTS `carmark_ins`;
DROP TRIGGER IF EXISTS `carmark_upd`;
DROP TRIGGER IF EXISTS `carmark_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `carmark_ins` AFTER INSERT ON `carmark`
FOR EACH ROW
BEGIN
  call FixTableChange('carmark', NEW.ID_CARMARK, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `carmark_upd` AFTER UPDATE ON `carmark`
FOR EACH ROW
BEGIN
  call FixTableChange('carmark', NEW.ID_CARMARK, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `carmark_del` AFTER DELETE ON `carmark`
FOR EACH ROW
BEGIN
  call FixTableChange('carmark', OLD.ID_CARMARK, 'd');
END;

/*==============================================================*/
/* Triggers : car_model                                         */
/*==============================================================*/

DROP TRIGGER IF EXISTS `car_model_ins`;
DROP TRIGGER IF EXISTS `car_model_upd`;
DROP TRIGGER IF EXISTS `car_model_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `car_model_ins` AFTER INSERT ON `car_model`
FOR EACH ROW
BEGIN
  call FixTableChange('carmark', NEW.ID_CAR_MODEL, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `car_model_upd` AFTER UPDATE ON `car_model`
FOR EACH ROW
BEGIN
  call FixTableChange('carmark', NEW.ID_CAR_MODEL, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `car_model_del` AFTER DELETE ON `car_model`
FOR EACH ROW
BEGIN
  call FixTableChange('car_model', OLD.ID_CAR_MODEL, 'd');
END;

/*==============================================================*/
/* Triggers : client                                            */
/*==============================================================*/

DROP TRIGGER IF EXISTS `client_ins`;
DROP TRIGGER IF EXISTS `client_upd`;
DROP TRIGGER IF EXISTS `client_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `client_ins` AFTER INSERT ON `client`
FOR EACH ROW
BEGIN
  call FixTableChange('client', NEW.ID_CLIENT, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `client_upd` AFTER UPDATE ON `client`
FOR EACH ROW
BEGIN
  call FixTableChange('client', NEW.ID_CLIENT, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `client_del` AFTER DELETE ON `client`
FOR EACH ROW
BEGIN
  call FixTableChange('client', OLD.ID_CLIENT, 'd');
END;

/*==============================================================*/
/* Triggers : client_type_group                                 */
/*==============================================================*/

DROP TRIGGER IF EXISTS `client_type_group_ins`;
DROP TRIGGER IF EXISTS `client_type_group_upd`;
DROP TRIGGER IF EXISTS `client_type_group_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `client_type_group_ins` AFTER INSERT ON `client_type_group`
FOR EACH ROW
BEGIN
  call FixTableChange('client_type_group', NEW.ID_CLIENT_TYPE_GROUP, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `client_type_group_upd` AFTER UPDATE ON `client_type_group`
FOR EACH ROW
BEGIN
  call FixTableChange('client_type_group', NEW.ID_CLIENT_TYPE_GROUP, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `client_type_group_del` AFTER DELETE ON `client_type_group`
FOR EACH ROW
BEGIN
  call FixTableChange('client_type_group', OLD.ID_CLIENT_TYPE_GROUP, 'd');
END;

/*==============================================================*/
/* Triggers : client_types                                      */
/*==============================================================*/

DROP TRIGGER IF EXISTS `client_types_ins`;
DROP TRIGGER IF EXISTS `client_types_upd`;
DROP TRIGGER IF EXISTS `client_types_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `client_types_ins` AFTER INSERT ON `client_types`
FOR EACH ROW
BEGIN
  call FixTableChange('client_types', NEW.ID_CLIENT_TYPE, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `client_types_upd` AFTER UPDATE ON `client_types`
FOR EACH ROW
BEGIN
  call FixTableChange('client_types', NEW.ID_CLIENT_TYPE, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `client_types_del` AFTER DELETE ON `client_types`
FOR EACH ROW
BEGIN
  call FixTableChange('client_types', OLD.ID_CLIENT_TYPE, 'd');
END;

/*==============================================================*/
/* Triggers : dogovor                                           */
/*==============================================================*/

DROP TRIGGER IF EXISTS `dogovor_ins`;
DROP TRIGGER IF EXISTS `dogovor_upd`;
DROP TRIGGER IF EXISTS `dogovor_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `dogovor_ins` AFTER INSERT ON `dogovor`
FOR EACH ROW
BEGIN
  call FixTableChange('dogovor', NEW.ID_DOGOVOR, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `dogovor_upd` AFTER UPDATE ON `dogovor`
FOR EACH ROW
BEGIN
  call FixTableChange('dogovor', NEW.ID_DOGOVOR, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `dogovor_del` AFTER DELETE ON `dogovor`
FOR EACH ROW
BEGIN
  call FixTableChange('dogovor', OLD.ID_DOGOVOR, 'd');
END;

/*==============================================================*/
/* Triggers : dogovor_history                                   */
/*==============================================================*/

DROP TRIGGER IF EXISTS `dogovor_history_ins`;
DROP TRIGGER IF EXISTS `dogovor_history_upd`;
DROP TRIGGER IF EXISTS `dogovor_history_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `dogovor_history_ins` AFTER INSERT ON `dogovor_history`
FOR EACH ROW
BEGIN
  call FixTableChange('dogovor_history', NEW.ID_DOGOVOR_HISTORY, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `dogovor_history_upd` AFTER UPDATE ON `dogovor_history`
FOR EACH ROW
BEGIN
  call FixTableChange('dogovor_history', NEW.ID_DOGOVOR_HISTORY, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `dogovor_history_del` AFTER DELETE ON `dogovor_history`
FOR EACH ROW
BEGIN
  call FixTableChange('dogovor_history', OLD.ID_DOGOVOR_HISTORY, 'd');
END;

/*==============================================================*/
/* Triggers : dogovor_state                                     */
/*==============================================================*/

DROP TRIGGER IF EXISTS `dogovor_state_ins`;
DROP TRIGGER IF EXISTS `dogovor_state_upd`;
DROP TRIGGER IF EXISTS `dogovor_state_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `dogovor_state_ins` AFTER INSERT ON `dogovor_state`
FOR EACH ROW
BEGIN
  call FixTableChange('dogovor_state', NEW.ID_DOGOVOR_STATE, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `dogovor_state_upd` AFTER UPDATE ON `dogovor_state`
FOR EACH ROW
BEGIN
  call FixTableChange('dogovor_state', NEW.ID_DOGOVOR_STATE, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `dogovor_state_del` AFTER DELETE ON `dogovor_state`
FOR EACH ROW
BEGIN
  call FixTableChange('dogovor_state', OLD.ID_DOGOVOR_STATE, 'd');
END;

/*==============================================================*/
/* Triggers : dogovor_type                                          */
/*==============================================================*/

DROP TRIGGER IF EXISTS `dogovor_type_ins`;
DROP TRIGGER IF EXISTS `dogovor_type_upd`;
DROP TRIGGER IF EXISTS `dogovor_type_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `dogovor_type_ins` AFTER INSERT ON `dogovor_type`
FOR EACH ROW
BEGIN
  call FixTableChange('dogovor_type', NEW.ID_DOGOVOR_TYPE, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `dogovor_type_upd` AFTER UPDATE ON `dogovor_type`
FOR EACH ROW
BEGIN
  call FixTableChange('dogovor_type', NEW.ID_DOGOVOR_TYPE, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `dogovor_type_del` AFTER DELETE ON `dogovor_type`
FOR EACH ROW
BEGIN
  call FixTableChange('dogovor_type', OLD.ID_DOGOVOR_TYPE, 'd');
END;

/*==============================================================*/
/* Triggers : family_state                                      */
/*==============================================================*/

DROP TRIGGER IF EXISTS `family_state_ins`;
DROP TRIGGER IF EXISTS `family_state_upd`;
DROP TRIGGER IF EXISTS `family_state_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `family_state_ins` AFTER INSERT ON `family_state`
FOR EACH ROW
BEGIN
  call FixTableChange('family_state', NEW.ID_FAMILY_STATE, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `family_state_upd` AFTER UPDATE ON `family_state`
FOR EACH ROW
BEGIN
  call FixTableChange('family_state', NEW.ID_FAMILY_STATE, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `family_state_del` AFTER DELETE ON `family_state`
FOR EACH ROW
BEGIN
  call FixTableChange('family_state', OLD.ID_FAMILY_STATE, 'd');
END;

/*==============================================================*/
/* Triggers : ins_koefs_km                                      */
/*==============================================================*/

DROP TRIGGER IF EXISTS `ins_koefs_km_ins`;
DROP TRIGGER IF EXISTS `ins_koefs_km_upd`;
DROP TRIGGER IF EXISTS `ins_koefs_km_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_km_ins` AFTER INSERT ON `ins_koefs_km`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_km', NEW.MAX_POWER, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_km_upd` AFTER UPDATE ON `ins_koefs_km`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_km', NEW.MAX_POWER, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_km_del` AFTER DELETE ON `ins_koefs_km`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_km', OLD.MAX_POWER, 'd');
END;

/*==============================================================*/
/* Triggers : ins_koefs_ko                                      */
/*==============================================================*/

DROP TRIGGER IF EXISTS `ins_koefs_ko_ins`;
DROP TRIGGER IF EXISTS `ins_koefs_ko_upd`;
DROP TRIGGER IF EXISTS `ins_koefs_ko_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_ko_ins` AFTER INSERT ON `ins_koefs_ko`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_ko',
    CONCAT_WS(';', NEW.KO_LIMITED, NEW.KO_UNLIM), 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_ko_upd` AFTER UPDATE ON `ins_koefs_ko`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_ko',
    CONCAT_WS(';', NEW.KO_LIMITED, NEW.KO_UNLIM), 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_ko_del` AFTER DELETE ON `ins_koefs_ko`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_ko',
    CONCAT_WS(';', OLD.KO_LIMITED, OLD.KO_UNLIM), 'd');
END;

/*==============================================================*/
/* Triggers : ins_koefs_kp                                      */
/*==============================================================*/

DROP TRIGGER IF EXISTS `ins_koefs_kp_ins`;
DROP TRIGGER IF EXISTS `ins_koefs_kp_upd`;
DROP TRIGGER IF EXISTS `ins_koefs_kp_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_kp_ins` AFTER INSERT ON `ins_koefs_kp`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_kp', NEW.PERIOD_INS, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_kp_upd` AFTER UPDATE ON `ins_koefs_kp`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_kp', NEW.PERIOD_INS, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_kp_del` AFTER DELETE ON `ins_koefs_kp`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_kp', OLD.PERIOD_INS, 'd');
END;

/*==============================================================*/
/* Triggers : ins_koefs_ks                                      */
/*==============================================================*/

DROP TRIGGER IF EXISTS `ins_koefs_ks_ins`;
DROP TRIGGER IF EXISTS `ins_koefs_ks_upd`;
DROP TRIGGER IF EXISTS `ins_koefs_ks_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_ks_ins` AFTER INSERT ON `ins_koefs_ks`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_ks', NEW.PERIOD_USE, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_ks_upd` AFTER UPDATE ON `ins_koefs_ks`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_ks', NEW.PERIOD_USE, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_ks_del` AFTER DELETE ON `ins_koefs_ks`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_ks', OLD.PERIOD_USE, 'd');
END;

/*==============================================================*/
/* Triggers : ins_koefs_kvs                                     */
/*==============================================================*/

DROP TRIGGER IF EXISTS `ins_koefs_kvs_ins`;
DROP TRIGGER IF EXISTS `ins_koefs_kvs_upd`;
DROP TRIGGER IF EXISTS `ins_koefs_kvs_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_kvs_ins` AFTER INSERT ON `ins_koefs_kvs`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_kvs',
    CONCAT_WS(';', NEW.MAX_STAGE, NEW.MAX_AGE), 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_kvs_upd` AFTER UPDATE ON `ins_koefs_kvs`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_kvs',
    CONCAT_WS(';', NEW.MAX_STAGE, NEW.MAX_AGE), 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_kvs_del` AFTER DELETE ON `ins_koefs_kvs`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_kvs',
    CONCAT_WS(';', OLD.MAX_STAGE, OLD.MAX_AGE), 'd');
END;

/*==============================================================*/
/* Triggers : ins_koefs_other                                   */
/*==============================================================*/

DROP TRIGGER IF EXISTS `ins_koefs_foreing_ins`;
DROP TRIGGER IF EXISTS `ins_koefs_foreing_upd`;
DROP TRIGGER IF EXISTS `ins_koefs_foreing_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_foreing_ins` AFTER INSERT ON `ins_koefs_foreing`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_foreing', '-', 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_foreing_upd` AFTER UPDATE ON `ins_koefs_foreing`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_foreing', '-', 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_foreing_del` AFTER DELETE ON `ins_koefs_foreing`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_foreing', '-', 'd');
END;

/*==============================================================*/
/* Triggers : ins_koefs_other                                   */
/*==============================================================*/

DROP TRIGGER IF EXISTS `ins_koefs_other_ins`;
DROP TRIGGER IF EXISTS `ins_koefs_other_upd`;
DROP TRIGGER IF EXISTS `ins_koefs_other_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_other_ins` AFTER INSERT ON `ins_koefs_other`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_other', '-', 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_other_upd` AFTER UPDATE ON `ins_koefs_other`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_other', '-', 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `ins_koefs_other_del` AFTER DELETE ON `ins_koefs_other`
FOR EACH ROW
BEGIN
  call FixTableChange('ins_koefs_other', '-', 'd');
END;

/*==============================================================*/
/* Triggers : insurance_class                                   */
/*==============================================================*/

DROP TRIGGER IF EXISTS `insurance_class_ins`;
DROP TRIGGER IF EXISTS `insurance_class_upd`;
DROP TRIGGER IF EXISTS `insurance_class_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `insurance_class_ins` AFTER INSERT ON `insurance_class`
FOR EACH ROW
BEGIN
  call FixTableChange('insurance_class', NEW.ID_INSURANCE_CLASS, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `insurance_class_upd` AFTER UPDATE ON `insurance_class`
FOR EACH ROW
BEGIN
  call FixTableChange('insurance_class', NEW.ID_INSURANCE_CLASS, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `insurance_class_del` AFTER DELETE ON `insurance_class`
FOR EACH ROW
BEGIN
  call FixTableChange('insurance_class', OLD.ID_INSURANCE_CLASS, 'd');
END;

/*==============================================================*/
/* Triggers : insurance_company                                 */
/*==============================================================*/

DROP TRIGGER IF EXISTS `insurance_company_ins`;
DROP TRIGGER IF EXISTS `insurance_company_upd`;
DROP TRIGGER IF EXISTS `insurance_company_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `insurance_company_ins` AFTER INSERT ON `insurance_company`
FOR EACH ROW
BEGIN
  call FixTableChange('insurance_company', NEW.ID_INSURANCE_COMPANY, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `insurance_company_upd` AFTER UPDATE ON `insurance_company`
FOR EACH ROW
BEGIN
  call FixTableChange('insurance_company', NEW.ID_INSURANCE_COMPANY, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `insurance_company_del` AFTER DELETE ON `insurance_company`
FOR EACH ROW
BEGIN
  call FixTableChange('insurance_company', OLD.ID_INSURANCE_COMPANY, 'd');
END;

/*==============================================================*/
/* Triggers : producter_type                                    */
/*==============================================================*/

DROP TRIGGER IF EXISTS `producter_type_ins`;
DROP TRIGGER IF EXISTS `producter_type_upd`;
DROP TRIGGER IF EXISTS `producter_type_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `producter_type_ins` AFTER INSERT ON `producter_type`
FOR EACH ROW
BEGIN
  call FixTableChange('producter_type', NEW.ID_PRODUCTER_TYPE, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `producter_type_upd` AFTER UPDATE ON `producter_type`
FOR EACH ROW
BEGIN
  call FixTableChange('producter_type', NEW.ID_PRODUCTER_TYPE, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `producter_type_del` AFTER DELETE ON `producter_type`
FOR EACH ROW
BEGIN
  call FixTableChange('producter_type', OLD.ID_PRODUCTER_TYPE, 'd');
END;

/*==============================================================*/
/* Triggers : purpose_type                                      */
/*==============================================================*/

DROP TRIGGER IF EXISTS `purpose_type_ins`;
DROP TRIGGER IF EXISTS `purpose_type_upd`;
DROP TRIGGER IF EXISTS `purpose_type_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `purpose_type_ins` AFTER INSERT ON `purpose_type`
FOR EACH ROW
BEGIN
  call FixTableChange('purpose_type', NEW.ID_PURPOSE_TYPE, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `purpose_type_upd` AFTER UPDATE ON `purpose_type`
FOR EACH ROW
BEGIN
  call FixTableChange('purpose_type', NEW.ID_PURPOSE_TYPE, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `purpose_type_del` AFTER DELETE ON `purpose_type`
FOR EACH ROW
BEGIN
  call FixTableChange('purpose_type', OLD.ID_PURPOSE_TYPE, 'd');
END;

/*==============================================================*/
/* Triggers : country                                           */
/*==============================================================*/

DROP TRIGGER IF EXISTS `country_ins`;
DROP TRIGGER IF EXISTS `country_upd`;
DROP TRIGGER IF EXISTS `country_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `country_ins` AFTER INSERT ON `country`
FOR EACH ROW
BEGIN
  call FixTableChange('country', NEW.ID_COUNTRY, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `country_upd` AFTER UPDATE ON `country`
FOR EACH ROW
BEGIN
  call FixTableChange('country', NEW.ID_COUNTRY, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `country_del` AFTER DELETE ON `country`
FOR EACH ROW
BEGIN
  call FixTableChange('country', OLD.ID_COUNTRY, 'd');
END;

/*==============================================================*/
/* Triggers : region                                            */
/*==============================================================*/

DROP TRIGGER IF EXISTS `region_ins`;
DROP TRIGGER IF EXISTS `region_upd`;
DROP TRIGGER IF EXISTS `region_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `region_ins` AFTER INSERT ON `region`
FOR EACH ROW
BEGIN
  call FixTableChange('region', NEW.ID_REGION, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `region_upd` AFTER UPDATE ON `region`
FOR EACH ROW
BEGIN
  call FixTableChange('region', NEW.ID_REGION, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `region_del` AFTER DELETE ON `region`
FOR EACH ROW
BEGIN
  call FixTableChange('region', OLD.ID_REGION, 'd');
END;

/*==============================================================*/
/* Triggers : city                                              */
/*==============================================================*/

DROP TRIGGER IF EXISTS `city_ins`;
DROP TRIGGER IF EXISTS `city_upd`;
DROP TRIGGER IF EXISTS `city_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `city_ins` AFTER INSERT ON `city`
FOR EACH ROW
BEGIN
  call FixTableChange('city', NEW.ID_CITY, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `city_upd` AFTER UPDATE ON `city`
FOR EACH ROW
BEGIN
  call FixTableChange('city', NEW.ID_CITY, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `city_del` AFTER DELETE ON `city`
FOR EACH ROW
BEGIN
  call FixTableChange('city', OLD.ID_CITY, 'd');
END;

/*==============================================================*/
/* Triggers : sex                                               */
/*==============================================================*/

DROP TRIGGER IF EXISTS `sex_ins`;
DROP TRIGGER IF EXISTS `sex_upd`;
DROP TRIGGER IF EXISTS `sex_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `sex_ins` AFTER INSERT ON `sex`
FOR EACH ROW
BEGIN
  call FixTableChange('sex', NEW.ID_SEX, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `sex_upd` AFTER UPDATE ON `sex`
FOR EACH ROW
BEGIN
  call FixTableChange('sex', NEW.ID_SEX, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `sex_del` AFTER DELETE ON `sex`
FOR EACH ROW
BEGIN
  call FixTableChange('sex', OLD.ID_SEX, 'd');
END;

/*==============================================================*/
/* Triggers : territory_use                                     */
/*==============================================================*/

DROP TRIGGER IF EXISTS `territory_use_ins`;
DROP TRIGGER IF EXISTS `territory_use_upd`;
DROP TRIGGER IF EXISTS `territory_use_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `territory_use_ins` AFTER INSERT ON `territory_use`
FOR EACH ROW
BEGIN
  call FixTableChange('territory_use', NEW.ID_TERRITORY_USE, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `territory_use_upd` AFTER UPDATE ON `territory_use`
FOR EACH ROW
BEGIN
  call FixTableChange('territory_use', NEW.ID_TERRITORY_USE, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `territory_use_del` AFTER DELETE ON `territory_use`
FOR EACH ROW
BEGIN
  call FixTableChange('territory_use', OLD.ID_TERRITORY_USE, 'd');
END;

/*==============================================================*/
/* Triggers : type_doc                                          */
/*==============================================================*/

DROP TRIGGER IF EXISTS `type_doc_ins`;
DROP TRIGGER IF EXISTS `type_doc_upd`;
DROP TRIGGER IF EXISTS `type_doc_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `type_doc_ins` AFTER INSERT ON `type_doc`
FOR EACH ROW
BEGIN
  call FixTableChange('type_doc', NEW.ID_TYPE_DOC, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `type_doc_upd` AFTER UPDATE ON `type_doc`
FOR EACH ROW
BEGIN
  call FixTableChange('type_doc', NEW.ID_TYPE_DOC, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `type_doc_del` AFTER DELETE ON `type_doc`
FOR EACH ROW
BEGIN
  call FixTableChange('type_doc', OLD.ID_TYPE_DOC, 'd');
END;

/*==============================================================*/
/* Triggers : valuta                                            */
/*==============================================================*/

DROP TRIGGER IF EXISTS `valuta_ins`;
DROP TRIGGER IF EXISTS `valuta_upd`;
DROP TRIGGER IF EXISTS `valuta_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `valuta_ins` AFTER INSERT ON `valuta`
FOR EACH ROW
BEGIN
  call FixTableChange('valuta', NEW.ID_VALUTA, 'i');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `valuta_upd` AFTER UPDATE ON `valuta`
FOR EACH ROW
BEGIN
  call FixTableChange('valuta', NEW.ID_VALUTA, 'u');
END;

CREATE
DEFINER = 'root'@'%'
TRIGGER `valuta_del` AFTER DELETE ON `valuta`
FOR EACH ROW
BEGIN
  call FixTableChange('valuta', OLD.ID_VALUTA, 'd');
END;

#
# Client routines.
#

/*==============================================================*/
/* Function : ClnExists()                                       */
/*==============================================================*/

DROP FUNCTION IF EXISTS ClnExists;

CREATE
DEFINER = 'root'@'%'
FUNCTION ClnExists(v_id_type_doc INT, v_doc_ser VARCHAR(10),
  v_doc_num VARCHAR(255))
RETURNS BOOL
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'Проверка существования клиента. Привилегии вызывающего.'
BEGIN
  declare result BOOL;
  select count(ID_CLIENT) != 0 from client where
    ID_TYPE_DOC = v_id_type_doc and
    DOC_SER = v_doc_ser and DOC_NUM = v_doc_num into result;
  return result;
END;

/*==============================================================*/
/* Procedure : ClnAdd()                                         */
/*==============================================================*/

DROP PROCEDURE IF EXISTS ClnAdd;

CREATE
DEFINER = 'root'@'%'
PROCEDURE ClnAdd(
  IN v_surname VARCHAR(255),
  IN v_name VARCHAR(255),
  IN v_middlename VARCHAR(255),
  IN v_birthday DATE,
  IN v_inn VARCHAR(50),
  IN v_id_type_doc INT,
  IN v_doc_ser VARCHAR(10),
  IN v_doc_num VARCHAR(255), 
  IN v_postindex VARCHAR(6),
  IN v_id_country INT,
  IN v_id_region INT,
  IN v_id_city INT,
  IN v_town VARCHAR(255),
  IN v_street VARCHAR(255),
  IN v_home VARCHAR(25),
  IN v_korpus VARCHAR(25),
  IN v_flat VARCHAR(25),
  IN v_home_phone VARCHAR(255),
  IN v_cell_phone VARCHAR(60),
  IN v_business_phone VARCHAR(60),
  IN v_id_sex INT,
  IN v_id_family_state INT,
  IN v_id_client_type INT,
  IN v_gross_violations BOOL,
  IN v_id_insurance_class INT,
  IN v_license_ser VARCHAR(20),
  IN v_license_no VARCHAR(20),
  IN v_start_driving_date DATE,
  IN v_comments TEXT,
  OUT v_cln_id VARCHAR(22)
)
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: пользователь.'
sproc: BEGIN
  declare cln_id VARCHAR(22);
  declare granted BOOL;
  # Дублирование ключа.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
    SET cln_id := CONVERT(cln_id, DECIMAL(23, 0)) + 1;

  # Проверяю полномочия.
  select ifnull(PRIV_CLN_ADD = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  # last_insert_id(expr) - не катит, т.к. тип expr - BIGINT.
  select ifnull(CONVERT(max(ID_CLIENT), DECIMAL(23, 0)) + 1, 0) into cln_id
    from client;

  repeat
    insert into client(ID_CLIENT, SURNAME, `NAME`, MIDDLENAME, BIRTHDAY,
      INN, DOC_SER, DOC_NUM, POSTINDEX, ID_COUNTRY, ID_REGION, ID_CITY,
      TOWN, STREET, HOME, KORPUS, FLAT, HOME_PHONE, CELL_PHONE,
      BUSINESS_PHONE, ID_SEX,
      ID_FAMILY_STATE, ID_CLIENT_TYPE, ID_TYPE_DOC, GROSS_VIOLATIONS,
      ID_INSURANCE_CLASS,
      LICENCE_SER, LICENCE_NO, START_DRIVING_DATE, COMMENTS,
      DATE_INSERT, USER_INSERT_NAME)
    values(cln_id, v_surname, v_name, v_middlename, v_birthday, v_inn,
      v_doc_ser, v_doc_num, v_postindex, v_id_country, v_id_region, v_id_city, 
      v_town, v_street, v_home, v_korpus, v_flat, v_home_phone, v_cell_phone,
      v_business_phone, v_id_sex, v_id_family_state, v_id_client_type,
      v_id_type_doc, v_gross_violations, v_id_insurance_class, v_license_ser,
      v_license_no, v_start_driving_date,
      v_comments, CURDATE(), GetCurUserFullname());
    # Проверяю был ли вставлен клиент.
    select ROW_COUNT() >= 1 into granted;
  until (granted)
  end repeat;

  set v_cln_id := cln_id;
  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : ClnChg()                                         */
/*==============================================================*/

DROP PROCEDURE IF EXISTS ClnChg;

CREATE DEFINER = 'root'@'%'
PROCEDURE ClnChg(
  IN v_id_client VARCHAR(22),
  IN v_surname VARCHAR(255),
  IN v_name VARCHAR(255),
  IN v_middlename VARCHAR(255),
  IN v_birthday DATE,
  IN v_inn VARCHAR(50),
  IN v_id_type_doc INT,
  IN v_doc_ser VARCHAR(10),
  IN v_doc_num VARCHAR(255), 
  IN v_postindex VARCHAR(6),
  IN v_id_country INT,
  IN v_id_region INT,
  IN v_id_city INT,
  IN v_town VARCHAR(255),
  IN v_street VARCHAR(255),
  IN v_home VARCHAR(25),
  IN v_korpus VARCHAR(25),
  IN v_flat VARCHAR(25),
  IN v_home_phone VARCHAR(255),
  IN v_cell_phone VARCHAR(60),
  IN v_business_phone VARCHAR(60),
  IN v_id_sex INT,
  IN v_id_family_state INT,
  IN v_id_client_type INT,
  IN v_gross_violations BOOL,
  IN v_id_insurance_class INT,
  IN v_license_ser VARCHAR(20),
  IN v_license_no VARCHAR(20),
  IN v_start_driving_date DATE,
  IN v_comments TEXT
)
  COMMENT 'Предположительные привилегии: пользователь.'
sproc: BEGIN
  declare granted BOOL;

  # Проверяю полномочия.
  select ifnull(PRIV_CLN_CHG = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;
  
  # Проверяю на существование.
  select count(ID_CLIENT) > 0 into granted from client where ID_CLIENT = v_id_client;
  if (not granted) then
    call SetLastError('ERR_ENTITY_NOT_EXISTS');
    leave sproc;
  end if;

  update CLIENT set
    SURNAME             = v_surname,
    NAME                = v_name,
    MIDDLENAME          = v_middlename,
    INN                 = v_inn,
    ID_TYPE_DOC         = v_id_type_doc,
    DOC_SER             = v_doc_ser,
    DOC_NUM             = v_doc_num,
    POSTINDEX           = v_postindex,
    BIRTHDAY            = v_birthday,
    ID_COUNTRY          = v_id_country,
    ID_REGION           = v_id_region,
    ID_CITY             = v_id_city,
    TOWN                = v_town,
    STREET              = v_street,
    HOME                = v_home,
    KORPUS              = v_korpus,
    FLAT                = v_flat,
    HOME_PHONE          = v_home_phone,
    CELL_PHONE          = v_cell_phone,
    BUSINESS_PHONE      = v_business_phone,
    ID_SEX              = v_id_sex,
    ID_FAMILY_STATE     = v_id_family_state,
    ID_CLIENT_TYPE      = v_id_client_type,
    GROSS_VIOLATIONS    = v_gross_violations,
    ID_INSURANCE_CLASS  = v_id_insurance_class,
    LICENCE_SER         = v_license_ser,
    LICENCE_NO          = v_license_no,
    COMMENTS            = v_comments,
    START_DRIVING_DATE  = v_start_driving_date,
    DATE_UPDATE         = CURDATE()
  where ID_CLIENT = v_id_client;
  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : ClnDel()                                         */
/*==============================================================*/

DROP PROCEDURE IF EXISTS ClnDel;

CREATE
DEFINER = 'root'@'%'
PROCEDURE ClnDel(v_id_client VARCHAR(22))
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: администратор.'
sproc: BEGIN
  declare granted BOOL;
  # Проверяю полномочия.
  select ifnull(PRIV_CLN_DEL = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;
  call SetLastError('ERR_FUNC_NOT_IMPLEMENTED');
END;

/*==============================================================*/
/* Procedure : ClnRemind()                                      */
/*==============================================================*/

DROP PROCEDURE IF EXISTS ClnRemind;

CREATE
DEFINER = 'root'@'%'
PROCEDURE ClnRemind(IN v_id_client VARCHAR(22), IN v_id_dogovor VARCHAR(22),
  IN v_last_pay BOOL)
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: пользователь.'
sproc: BEGIN
  # const
  declare id_opened INT default 1;
  declare id_close INT default 4;
  #
  declare granted BOOL;

  # Проверяю полномочия.
  select ifnull(PRIV_CLN_CHG = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  # Проверяю на существование.
  select count(ID_CLIENT) > 0 into granted from client where ID_CLIENT = v_id_client;
  if (not granted) then
    call SetLastError('ERR_ENTITY_NOT_EXISTS');
    leave sproc;
  end if;

  if (v_last_pay) then
  # Если платёж последний, договор закрывается, если он основной
  # (не пролонгирован и не заменён).
      update client set
        LAST_CALL_DATE       = CURDATE()
        #DATE_UPDATE         = CURDATE()
      where ID_CLIENT = v_id_client;

      update dogovor set
        ID_DOGOVOR_TYPE = id_close
      where ID_DOGOVOR = v_id_dogovor and ID_DOGOVOR_TYPE = id_opened;
  else
    update client set
      LAST_CALL_DATE       = CURDATE()
      #DATE_UPDATE         = CURDATE()
    where ID_CLIENT = v_id_client;
  end if;

  call SetLastError('ERR_NO_ERROR');
END;

#
# Car routines.
#

/*==============================================================*/
/* Function : CarExists()                                       */
/*==============================================================*/

DROP FUNCTION IF EXISTS CarExists;

CREATE
DEFINER = 'root'@'%'
FUNCTION CarExists(v_vin_num VARCHAR(255))
RETURNS BOOL
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'Проверка существования ТС. Привилегии вызывающего.'
BEGIN
  declare result BOOL;

  select count(ID_CAR) > 0 into result from car where VIN_NUM = v_vin_num;
  return result;
END;

/*==============================================================*/
/* Function : CarAdd()                                          */
/*==============================================================*/

DROP PROCEDURE IF EXISTS CarAdd;

CREATE
DEFINER = 'root'@'%'
PROCEDURE CarAdd(
  IN v_arenda BOOL,
  IN v_id_purpose_type INT,
  IN v_id_car_type INT,
  IN v_id_client VARCHAR(22),
  IN v_id_car_mark INT,
  IN v_car_model VARCHAR(255),
  IN v_vin_num VARCHAR(255),
  IN v_year_issue INT,
  IN v_power_kvt FLOAT,
  IN v_power_ls FLOAT,
  IN v_max_kg FLOAT,
  IN v_num_places INT,
  IN v_shassi VARCHAR(255),
  IN v_kusov VARCHAR(255),
  IN v_gos_num VARCHAR(255),
  IN v_pts_date DATE,
  IN v_pts_ser VARCHAR(255),
  IN v_pts_no VARCHAR(255),
  IN v_foreing BOOL,
  IN v_comments TEXT,
  OUT v_id_car VARCHAR(22)
)
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: пользователь.'
sproc: BEGIN
  declare granted BOOL;
  declare car_id VARCHAR(22);
  # Дублирование ключа.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
    SET car_id := CONVERT(car_id, DECIMAL(23, 0)) + 1;

  # Проверяю полномочия.
  select ifnull(PRIV_CAR_ADD = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  select ifnull(CONVERT(max(ID_CAR), DECIMAL(23, 0)) + 1, 0) into car_id
    from car;

  repeat
    insert into car(ID_CAR, CAR_MARK, CAR_MODEL, VIN_NUM, YEAR_ISSUE, POWER_KVT,
      POWER_LS, MAX_KG, NUM_PLACES, SHASSI, KUSOV, GOS_NUM, PTS_SER, PTS_NO,
      PTS_DATE, ARENDA, ID_PURPOSE_TYPE, ID_CAR_TYPE, ID_CLIENT, FOREING,
      COMMENTS, DATE_INSERT, USER_UPDATE_NAME)
    values(car_id, v_id_car_mark, v_car_model, v_vin_num, v_year_issue,
      v_power_kvt, v_power_ls, v_max_kg, v_num_places, v_shassi, v_kusov,
      v_gos_num, v_pts_ser, v_pts_no, v_pts_date, v_arenda, v_id_purpose_type,
      v_id_car_type, v_id_client, v_foreing, v_comments,
      CURDATE(), GetCurUserFullname());
    # Проверяю было ли вставлено ТС.
    select ROW_COUNT() >= 1 into granted;
  until (granted)
  end repeat;
  set v_id_car := car_id;
  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : CarChg()                                         */
/*==============================================================*/

DROP PROCEDURE IF EXISTS CarChg;

CREATE
DEFINER = 'root'@'%'
PROCEDURE CarChg(
  IN v_id_car VARCHAR(22),
  IN v_arenda BOOL,
  IN v_id_purpose_type INT,
  IN v_id_car_type INT,
  IN v_id_client VARCHAR(22),
  IN v_id_car_mark VARCHAR(255),
  IN v_car_model VARCHAR(255),
  IN v_vin_num VARCHAR(255),
  IN v_year_issue INT,
  IN v_power_kvt FLOAT,
  IN v_power_ls FLOAT,
  IN v_max_kg FLOAT,
  IN v_num_places INT,
  IN v_shassi VARCHAR(255),
  IN v_kusov VARCHAR(255),
  IN v_gos_num VARCHAR(255),
  IN v_pts_date DATE,
  IN v_pts_ser VARCHAR(255),
  IN v_pts_no VARCHAR(255),
  IN v_foreing BOOL,
  IN v_comments TEXT
)
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: пользователь.'
sproc: BEGIN
  declare granted BOOL;

  # Проверяю полномочия.
  select ifnull(PRIV_CAR_CHG = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;
  
  # Проверяю на существование.
  select count(ID_CAR) > 0 into granted from car where ID_CAR = v_id_car;
  if (not granted) then
    call SetLastError('ERR_ENTITY_NOT_EXISTS');
    leave sproc;
  end if;

  update car set
    CAR_MARK            = v_id_car_mark,
    CAR_MODEL           = v_car_model,
    VIN_NUM             = v_vin_num,
    YEAR_ISSUE          = v_year_issue,
    POWER_KVT           = v_power_kvt,
    POWER_LS            = v_power_ls,
    MAX_KG              = v_max_kg,
    NUM_PLACES          = v_num_places,
    SHASSI              = v_shassi,
    KUSOV               = v_kusov,
    GOS_NUM             = v_gos_num,
    PTS_SER             = v_pts_ser,
    PTS_NO              = v_pts_no,
    PTS_DATE            = v_pts_date,
    ARENDA              = v_arenda,
    ID_PURPOSE_TYPE     = v_id_purpose_type,
    ID_CAR_TYPE         = v_id_car_type,
    ID_CLIENT           = v_id_client,
    FOREING             = v_foreing,
    COMMENTS            = v_comments,
    DATE_UPDATE         = CURDATE(),
    USER_UPDATE_NAME    = GetCurUserFullname()
  where ID_CAR = v_id_car;
  call SetLastError('ERR_NO_ERROR');
END;


/*==============================================================*/
/* Procedure : CarDel()                                         */
/*==============================================================*/

DROP PROCEDURE IF EXISTS CarDel;

CREATE
DEFINER = 'root'@'%'
PROCEDURE CarDel(v_id_car VARCHAR(22))
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: администратор.'
sproc: BEGIN
  declare granted BOOL;

  # Проверяю полномочия
  select ifnull(PRIV_CAR_DEL = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;
  call SetLastError('ERR_FUNC_NOT_IMPLEMENTED');
END;

#
# Contract and blanks routines.
#

/*==============================================================*/
/* Function : BlankIsReserved                                   */
/*==============================================================*/

DROP FUNCTION IF EXISTS BlankIsReserved;

CREATE
DEFINER = 'root'@'%'
FUNCTION BlankIsReserved(
  v_id_ins_company INT,
  v_dog_ser VARCHAR(10), v_dog_num VARCHAR(25))
RETURNS BOOL
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'Проверка бланка на зарезервированность данным пользователем'
BEGIN
  declare user_name CHAR(16);
  declare user_host CHAR(60);
  declare result BOOL;

  call GetCurUser(user_name, user_host);

  select count(DOG_SER) > 0 into result from blanks_journal where
    ID_INSURANCE_COMPANY = v_id_ins_company
    and DOG_SER = v_dog_ser and DOGNUMB = v_dog_num
    and USER_RESERVER = user_name and HOST_RESERVER = user_host
    and ID_BSO_STATUS = 1;

  return result;
END;

/*==============================================================*/
/* Procedure : BlankAdd                                         */
/*==============================================================*/

DROP PROCEDURE IF EXISTS BlankAdd;

CREATE
DEFINER = 'root'@'%'
PROCEDURE BlankAdd(
  IN v_id_ins_company INT,
  IN v_dog_ser VARCHAR(10), IN v_dog_num VARCHAR(25))
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: доверенный пользователь.'
sproc: BEGIN
  declare granted BOOL;

  # Проверяю полномочия
  select ifnull(PRIV_BLANKS = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  insert into blanks_journal (DOG_SER, DOGNUMB, ID_INSURANCE_COMPANY,
    ID_BSO_STATUS, USER_RESERVER, HOST_RESERVER, DATE_INSERT)
  values(v_dog_ser, v_dog_num, v_id_ins_company, 1, NULL, NULL, CURDATE());

  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : BlankReserve                                     */
/*==============================================================*/

DROP PROCEDURE IF EXISTS BlankReserve;

CREATE
DEFINER = 'root'@'%'
PROCEDURE BlankReserve(
  IN v_id_ins_company INT,
  IN v_dog_ser VARCHAR(10), IN v_dog_num VARCHAR(25))
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: пользователь.'
sproc: BEGIN
  declare granted BOOL;
  declare user_name CHAR(16);
  declare user_host CHAR(60);

  # Проверяю полномочия.
  select ifnull(PRIV_CONT_ADD = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  # Проверяю наличие пустого незарезервированного бланка
  select count(DOG_SER) > 0 into granted from blanks_journal where
    DOG_SER = v_dog_ser and DOGNUMB = v_dog_num
    and ID_INSURANCE_COMPANY = v_id_ins_company
    and USER_RESERVER is NULL and HOST_RESERVER is NULL
    and ID_BSO_STATUS = 1;

  if (not granted) then
    call SetLastError('ERR_BLANK_USED');
    leave sproc;
  end if;

  select BLANK_MULTIRESERVE into granted from self_info;
  # Если не включено множественное резервирование бланков, разрезервирую
  # последний зарезервированный данным пользователем бланк (если есть такой).
  if (not granted) then
    call BlankUnreserve(NULL, NULL, NULL);
  end if;

  call GetCurUser(user_name, user_host);

  update blanks_journal set
    USER_RESERVER       = user_name,
    HOST_RESERVER       = user_host,
    DATE_UPDATE         = CURDATE()
  where
    DOG_SER = v_dog_ser and DOGNUMB = v_dog_num
    and ID_INSURANCE_COMPANY = v_id_ins_company;

  select ROW_COUNT() >= 1 into granted;
  if (not granted) then
    call SetLastError('ERR_CANNOT_RESERVE_BLANK');
    leave sproc;
  end if;

  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : BlankUnreserve                                   */
/*==============================================================*/

DROP PROCEDURE IF EXISTS BlankUnreserve;

CREATE
DEFINER = 'root'@'%'
PROCEDURE BlankUnreserve(
  IN v_id_ins_company INT,
  IN v_dog_ser VARCHAR(10), IN v_dog_num VARCHAR(25))
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: пользователь.'
sproc: BEGIN
  declare granted BOOL;
  declare user_name CHAR(16);
  declare user_host CHAR(60);
  # Данные для udpate ... where
  declare real_id_ins_company INT default v_id_ins_company;
  declare real_dog_ser VARCHAR(10) default v_dog_ser;
  declare real_dog_num VARCHAR(25) default v_dog_num;

  # Проверяю полномочия
  select ifnull(PRIV_CONT_ADD = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  call GetCurUser(user_name, user_host);

  # Проверяю наличие данного зарезервированного бланка.

  if (v_dog_ser is NULL or v_dog_num is NULL or v_id_ins_company is NULL) then
  # Если заданы NULL, то проверяю резервировал ли этот пользователь какие-либо
  # бланки, вообще. Выбираю самый новый.
    select count(DOG_SER) > 0, ID_INSURANCE_COMPANY, DOG_SER, DOGNUMB
      into granted, real_id_ins_company, real_dog_ser, real_dog_num
      from blanks_journal where 
      USER_RESERVER = user_name and HOST_RESERVER = user_host
      and ID_BSO_STATUS = 1
      order by DATE_UPDATE desc limit 1;
  else
    select BlankIsReserved(v_id_ins_company, v_dog_ser, v_dog_num) into granted;
  end if;

  if (not granted) then
    call SetLastError('ERR_NO_RESERVED_BLANK');
    leave sproc;
  end if;

  update blanks_journal set
    USER_RESERVER       = NULL,
    HOST_RESERVER       = NULL,
    DATE_UPDATE         = CURDATE()
  where
    DOG_SER = real_dog_ser and DOGNUMB = real_dog_num
    and ID_INSURANCE_COMPANY = real_id_ins_company;

  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : BlankDamage                                      */
/*==============================================================*/

DROP PROCEDURE IF EXISTS BlankDamage;

CREATE
DEFINER = 'root'@'%'
PROCEDURE BlankDamage(
  IN v_id_ins_company INT,
  IN v_dog_ser VARCHAR(10), IN v_dog_num VARCHAR(25))
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: пользователь.'
sproc: BEGIN
  declare granted BOOL;

  # Проверяю полномочия
  select
    ifnull(PRIV_CONT_ADD = true, false) or
    ifnull(PRIV_CONT_CHG = true, false) or
    ifnull(PRIV_CONT_PROLONG = true, false) or
    ifnull(PRIV_CONT_REPLACE = true, false) or
    ifnull(PRIV_BLANKS = true, false)
  from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;


  update blanks_journal set
    ID_BSO_STATUS       = 3,
    DATE_UPDATE         = CURDATE()
  where
    DOG_SER = v_dog_ser and DOGNUMB = v_dog_num
    and ID_INSURANCE_COMPANY = v_id_ins_company;

  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : DriverAdd()                                      */
/*==============================================================*/

DROP PROCEDURE IF EXISTS DriverAdd;

CREATE
DEFINER = 'root'@'%'
PROCEDURE DriverAdd(IN v_id_client VARCHAR(22))
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: пользователь.'
sproc: BEGIN
  declare granted BOOL;
  # Проверяю полномочия
  select ifnull(PRIV_CONT_ADD = true, false) or
    ifnull(PRIV_CONT_CHG = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  create temporary table if not exists drivers_in_contract
  (
    ID_CLIENT VARCHAR(22),
    primary key(ID_CLIENT)
    #foreign key drivers_in_contract(ID_CLIENT)
    #references client(ID_CLIENT)
    #on delete cascade on update cascade
  ) ENGINE=InnoDB;
  # Не MEMORY. Транзакции.
  # replace select * from drivers limit 0;

  insert into drivers_in_contract values(v_id_client);

  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : DriversClear                                     */
/*==============================================================*/

DROP PROCEDURE IF EXISTS DriversClear;

CREATE
DEFINER = 'root'@'%'
PROCEDURE DriversClear()
# Очищает список водителей.
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: пользователь.'
sproc: BEGIN
  declare granted BOOL;
  # Обработка отсутствия временной таблицы с водителями.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02'
    call SetLastError('ERR_NO_ERROR');

  # Проверяю полномочия.
  select ifnull(PRIV_CONT_ADD = true, false) or
    ifnull(PRIV_CONT_CHG = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  # truncate автоматически завершает транзакцию.
  delete from drivers_in_contract;

  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Function : ContExists()                                      */
/*==============================================================*/

DROP FUNCTION IF EXISTS ContExists;

CREATE
DEFINER = 'root'@'%'
FUNCTION ContExists(v_dog_ser VARCHAR(10), v_dog_num VARCHAR(25))
RETURNS BOOL
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'Проверка существования договора. Привилегии вызывающего.'
BEGIN
  declare result BOOL;
  select count(id_dogovor) != 0 into result from dogovor where
    DOG_SER = v_dog_ser and DOGNUMB = v_dog_num;
  return result;
END;

/*==============================================================*/
/* Function : GetNextIDDriver()                                 */
/*==============================================================*/

DROP FUNCTION IF EXISTS GetNextIDDriver;

CREATE
DEFINER = 'root'@'%'
FUNCTION GetNextIDDriver()
RETURNS VARCHAR(22)
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'Возвращает свободный ID водителя. Привилегии вызывающего.'
BEGIN
  declare result VARCHAR(22);
  select ifnull(CONVERT(max(ID_DRIVER), DECIMAL(23, 0)) + 1, 0) into result
    from drivers;
  return result;
END;

/*==============================================================*/
/* Function : CheckDates()                                      */
/*==============================================================*/

DROP FUNCTION IF EXISTS CheckDates;

CREATE
DEFINER = 'root'@'%'
FUNCTION CheckDates(
  v_creating_date DATETIME,
  v_date_start DATETIME,
  v_date_end DATE,
  v_start_use DATE,
  v_end_use DATE,
  v_start_use1 DATE,
  v_end_use1 DATE,
  v_start_use2 DATE,
  v_end_use2 DATE,
  v_date_write DATE,
  v_date_begin DATE
)
RETURNS BOOL
READS SQL DATA
SQL SECURITY INVOKER
COMMENT 'Проверяет корректность дат договора. Привилегии вызывающего.'
BEGIN
  # 1. Число конца страхования д.б. меньше на 1 день конца страхования.
  # 2. Периоды как угодно.
  # 3. При пролонгации, дата ставится на текущее+1 год.
  #   Пролонгация по договору не более одного года.
  # 4. Дата начала совпадает с началом периода (или меньше его).
  declare result BOOL;
  # Даты начала нельзя вводить задним числом.

  set result := (v_date_begin >= v_creating_date)
    and (v_date_start >= v_creating_date);
/*  set result := result and (v_date_start <= v_start_use);
  # Период не может быть больше срока действия.

  set result :=
    result and (v_date_start < v_date_end)
    and (v_start_use >= v_date_start)
    and (v_start_use < v_end_use)
    and (v_end_use <= v_date_end);*/

  return result;
END;

/*==============================================================*/
/* Procedure : __ContAdd()                                      */
/*==============================================================*/

DROP PROCEDURE IF EXISTS __ContAdd;

CREATE
DEFINER = 'root'@'%'
PROCEDURE __ContAdd(
  IN v_id_prev_dog VARCHAR(22),
  IN v_dog_ser VARCHAR(10),
  IN v_dog_numb VARCHAR(25),
  IN v_creating_date DATE,
  IN v_date_start DATETIME,
  IN v_date_end DATE,
  IN v_start_use DATE,
  IN v_end_use DATE,
  IN v_start_use1 DATE,
  IN v_end_use1 DATE,
  IN v_start_use2 DATE,
  IN v_end_use2 DATE,
  IN v_comment VARCHAR(255),
  IN v_id_client VARCHAR(22),
  IN v_id_insurance_company INT,
  IN v_transit BOOL,
  IN v_id_car VARCHAR(22),
  IN v_id_territory_use INT,
  IN v_ins_sum FLOAT,
  IN v_ins_prem FLOAT,
  IN v_koef_ter FLOAT,
  IN v_koef_bonus_malus FLOAT,
  IN v_koef_stag FLOAT,
  IN v_koef_unlimited FLOAT,
  IN v_koef_power FLOAT,
  IN v_koef_period_use FLOAT,
  IN v_koef_srok_ins FLOAT,
  IN v_koef_kn FLOAT,
  IN v_base_sum FLOAT,
  IN v_unlimited_drivers BOOL,
  IN v_date_write DATE,
  IN v_date_begin DATE,
  IN v_id_insurance_class INT,
  IN v_ticket_ser VARCHAR(10),
  IN v_ticket_num VARCHAR(25),
  IN v_ticket_date DATE,
  IN v_id_dog_type INT,
  OUT v_id_contract VARCHAR(22)
)
SQL SECURITY INVOKER
COMMENT 'Внутренняя процедура'
sproc: BEGIN
  # const
  declare state_accept INT default 2;
  declare bso_used INT default 2;
  #

  declare granted BOOL;
  declare i INT;
  declare ccln_id VARCHAR(22);
  declare ccont_id VARCHAR(22);
  # ID для обработчика дублированния ID, при вставке.
  # Вначале используется, как ID договора, затем, как ID водителей.
  declare h_id VARCHAR(22);
  # Обработка отсутствия временной таблицы с водителями.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET i := 0;
  # Дублирование ключа.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
    SET h_id := CONVERT(h_id, DECIMAL(23, 0)) + 1;

  #call GetCurUser(user_name, user_host);

  # Проверяю серию/номер на соответствие зарезервированным.
  # Выбираю неиспользованный бланк, с заданными номерами, зарезервированный
  # текущим пользователем.
  select BlankIsReserved(v_id_insurance_company, v_dog_ser, v_dog_numb)
    into granted;

  if (not granted) then
    call SetLastError('ERR_NO_RESERVED_BLANK');
    leave sproc;
  end if;

  #start transaction;

  select ifnull(CONVERT(max(ID_DOGOVOR), DECIMAL(23, 0)) + 1, 0) into h_id
    from dogovor;

  repeat
    insert into dogovor(ID_DOGOVOR, ID_PREV_DOG,
      DOG_SER, DOGNUMB,
      DATE_DOG_CREATE, DATE_START, DATE_END,
      START_USE, END_USE, START_USE1, END_USE1, START_USE2, END_USE2,
      `COMMENT`, ID_CLIENT, ID_DOGOVOR_TYPE, ID_INSURANCE_COMPANY, TRANSIT,
      ID_CAR, ID_TERRITORY_USE, INS_SUM, INS_PREM, KOEF_TER, KOEF_BONUSMALUS,
      KOEF_STAG, KOEF_UNLIMITED, KOEF_POWER, KOEF_PERIOD_USE, KOEF_SROK_INS,
      KOEF_KN, BASE_SUM, UNLIMITED_DRIVERS, DATE_WRITE, DATE_BEGIN,
      ID_INSURANCE_CLASS, TICKET_SER, TICKET_NUM, TICKET_DATE, DATE_INSERT,
      USER_INSERT_NAME)
    values(h_id, v_id_prev_dog, v_dog_ser, v_dog_numb,
      v_creating_date, v_date_start, v_date_end, v_start_use, v_end_use,
      v_start_use1, v_end_use1, v_start_use2, v_end_use2,
      v_comment, v_id_client, v_id_dog_type, v_id_insurance_company, v_transit,
      v_id_car, v_id_territory_use, v_ins_sum, v_ins_prem, v_koef_ter,
      v_koef_bonus_malus, v_koef_stag, v_koef_unlimited, v_koef_power,
      v_koef_period_use, v_koef_srok_ins, v_koef_kn, v_base_sum,
      v_unlimited_drivers, v_date_write, v_date_begin,
      v_id_insurance_class, v_ticket_ser, v_ticket_num, v_ticket_date,
      v_creating_date, GetCurUserFullname());
    # Проверяю было ли вставлен договор.
    select ROW_COUNT() >= 1 into granted;
  until (granted)
  end repeat;

  set ccont_id := h_id;

  # Перенос временного списка клиентов в список водителей по договору.
  # Если таблица отсутствует, HANDLER устанавливает i = 0.
  select COUNT(ID_CLIENT) into i from drivers_in_contract;
  while (i > 0) do
    select ID_CLIENT into ccln_id from drivers_in_contract
      order by ID_CLIENT asc limit 0, 1;

    set h_id := GetNextIDDriver();

    repeat
      insert into drivers(ID_DRIVER, ID_CAR, ID_CLIENT, ID_DOGOVOR, DATE_INSERT)
        values(h_id, v_id_car, ccln_id, ccont_id, v_creating_date);
      # Проверяю было ли вставлен водитель.
      select ROW_COUNT() >= 1 into granted;
    until (granted)
    end repeat;
    delete from drivers_in_contract where ID_CLIENT = ccln_id;
    set i := i - 1;
  end while;

  update blanks_journal set
    ID_BSO_STATUS = bso_used
  where
    DOG_SER = v_dog_ser and DOGNUMB = v_dog_numb
    and ID_INSURANCE_COMPANY = v_id_insurance_company;

  # Обновляю историю.

  select ifnull(CONVERT(max(ID_DOGOVOR_HISTORY), DECIMAL(23, 0)) + 1, 0)
    into h_id from dogovor_history;

  repeat
    insert into dogovor_history(ID_DOGOVOR_HISTORY, EVENT_DATE, ID_DOGOVOR,
      ID_DOGOVOR_STATE, DATE_INSERT)
    values(h_id, v_creating_date, ccont_id, state_accept, v_creating_date);
    select ROW_COUNT() >= 1 into granted;
  until (granted)
  end repeat;

  #commit;

  set v_id_contract := ccont_id;
  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : ContAdd()                                        */
/*==============================================================*/

DROP PROCEDURE IF EXISTS ContAdd;

CREATE
DEFINER = 'root'@'%'
PROCEDURE ContAdd(
  IN v_dog_ser VARCHAR(10),
  IN v_dog_numb VARCHAR(25),
  IN v_date_start DATETIME,
  IN v_date_end DATE,
  IN v_start_use DATE,
  IN v_end_use DATE,
  IN v_start_use1 DATE,
  IN v_end_use1 DATE,
  IN v_start_use2 DATE,
  IN v_end_use2 DATE,
  IN v_comment VARCHAR(255),
  IN v_id_client VARCHAR(22),
  IN v_id_insurance_company INT,
  IN v_transit BOOL,
  IN v_id_car VARCHAR(22),
  IN v_id_territory_use INT,
  IN v_ins_sum FLOAT,
  IN v_ins_prem FLOAT,
  IN v_koef_ter FLOAT,
  IN v_koef_bonus_malus FLOAT,
  IN v_koef_stag FLOAT,
  IN v_koef_unlimited FLOAT,
  IN v_koef_power FLOAT,
  IN v_koef_period_use FLOAT,
  IN v_koef_srok_ins FLOAT,
  IN v_koef_kn FLOAT,
  IN v_base_sum FLOAT,
  IN v_unlimited_drivers BOOL,
  IN v_date_write DATE,
  IN v_date_begin DATE,
  IN v_id_insurance_class INT,
  IN v_ticket_ser VARCHAR(10),
  IN v_ticket_num VARCHAR(25),
  IN v_ticket_date DATE,
  OUT v_id_contract VARCHAR(22)
)
SQL SECURITY DEFINER
COMMENT 'Привилегии: пользователь.'
sproc: BEGIN
  # const
  declare id_base INT default 1;
  #
  declare creating_date DATE default CURDATE();

  declare granted BOOL;
  declare ccont_id VARCHAR(22);

  # Проверяю полномочия.
  select ifnull(PRIV_CONT_ADD = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  # Если имеются права на изменение договора, проверка дат пропускается.
  select ifnull(PRIV_CONT_CHG = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    select CheckDates(creating_date, v_date_start, v_date_end, v_start_use,
      v_end_use, v_start_use1, v_end_use1, v_start_use2, v_end_use2,
      v_date_write, v_date_begin) into granted;
    if (not granted) then
      call SetLastError('ERR_DATES_INCORRECT');
      leave sproc;
    end if;
  end if;

  start transaction;

  call __ContAdd(
    NULL,
    v_dog_ser,
    v_dog_numb,
    creating_date,
    v_date_start,
    v_date_end,
    v_start_use,
    v_end_use,
    v_start_use1,
    v_end_use1,
    v_start_use2,
    v_end_use2,
    v_comment,
    v_id_client,
    v_id_insurance_company,
    v_transit,
    v_id_car,
    v_id_territory_use,
    v_ins_sum,
    v_ins_prem,
    v_koef_ter,
    v_koef_bonus_malus,
    v_koef_stag,
    v_koef_unlimited,
    v_koef_power,
    v_koef_period_use,
    v_koef_srok_ins,
    v_koef_kn,
    v_base_sum,
    v_unlimited_drivers,
    v_date_write,
    v_date_begin,
    v_id_insurance_class,
    v_ticket_ser,
    v_ticket_num,
    v_ticket_date,
    id_base,
    ccont_id
  );

  commit;

  set v_id_contract := ccont_id;
END;

/*==============================================================*/
/* Procedure : ContChg()                                        */
/*==============================================================*/

DROP PROCEDURE IF EXISTS ContChg;

CREATE
DEFINER = 'root'@'%'
PROCEDURE ContChg(
  IN v_id_dogovor VARCHAR(22),
  IN v_dog_ser VARCHAR(10),
  IN v_dog_numb VARCHAR(25),
  IN v_date_start DATETIME,
  IN v_date_end DATE,
  IN v_start_use DATE,
  IN v_end_use DATE,
  IN v_start_use1 DATE,
  IN v_end_use1 DATE,
  IN v_start_use2 DATE,
  IN v_end_use2 DATE,
  IN v_comment VARCHAR(255),
  IN v_id_client VARCHAR(22),
  IN v_id_insurance_company INT,
  IN v_transit BOOL,
  IN v_id_car VARCHAR(22),
  IN v_id_territory_use INT,
  IN v_ins_sum FLOAT,
  IN v_ins_prem FLOAT,
  IN v_koef_ter FLOAT,
  IN v_koef_bonus_malus FLOAT,
  IN v_koef_stag FLOAT,
  IN v_koef_unlimited FLOAT,
  IN v_koef_power FLOAT,
  IN v_koef_period_use FLOAT,
  IN v_koef_srok_ins FLOAT,
  IN v_koef_kn FLOAT,
  IN v_base_sum FLOAT,
  IN v_unlimited_drivers BOOL,
  IN v_date_write DATE,
  IN v_date_begin DATE,
  IN v_id_insurance_class INT,
  IN v_ticket_ser VARCHAR(10),
  IN v_ticket_num VARCHAR(25),
  IN v_ticket_date DATE
)
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: доверенный пользователь.'
sproc: BEGIN
  declare bso_used INT default 2;

  declare granted BOOL;
  declare i INT;
  declare ccln_id VARCHAR(22);
  declare drv_id VARCHAR(22);
  # Обработка отсутствия временной таблицы с водителями.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET i := 0;
  # Дублирование ключа, при вставке водителей.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
    SET drv_id := CONVERT(drv_id, DECIMAL(23, 0)) + 1;

  # Проверяю полномочия.
  select ifnull(PRIV_CONT_CHG = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;
  
  select count(ID_DOGOVOR) > 0 into granted from dogovor where ID_DOGOVOR = v_id_dogovor;
  if (not granted) then
    call SetLastError('ERR_ENTITY_NOT_EXISTS');
    leave sproc;
  end if;

  start transaction;

  update dogovor set
    DOG_SER                     = v_dog_ser,
    DOGNUMB                     = v_dog_numb,
#    DATE_DOG_CREATE             =,
    DATE_START                  = v_date_start,
    DATE_END                    = v_date_end,
    START_USE                   = v_start_use,
    END_USE                     = v_end_use,
    START_USE1                  = v_start_use1,
    END_USE1                    = v_end_use1,
    START_USE2                  = v_start_use2,
    END_USE2                    = v_end_use2,
    `COMMENT`                   = v_comment,
    ID_CLIENT                   = v_id_client,
#    ID_DOGOVOR_TYPE             =,
    ID_INSURANCE_COMPANY        = v_id_insurance_company,
    TRANSIT                     = v_transit,
    ID_CAR                      = v_id_car,
    ID_TERRITORY_USE            = v_id_territory_use,
    INS_SUM                     = v_ins_sum,
    INS_PREM                    = v_ins_prem,
    KOEF_TER                    = v_koef_ter,
    KOEF_BONUSMALUS             = v_koef_bonus_malus,
    KOEF_STAG                   = v_koef_stag,
    KOEF_UNLIMITED              = v_koef_unlimited,
    KOEF_POWER                  = v_koef_power,
    KOEF_PERIOD_USE             = v_koef_period_use,
    KOEF_SROK_INS               = v_koef_srok_ins,
    KOEF_KN                     = v_koef_kn,
    BASE_SUM                    = v_base_sum,
    UNLIMITED_DRIVERS           = v_unlimited_drivers,
    DATE_WRITE                  = v_date_write,
    DATE_BEGIN                  = v_date_begin,
    ID_INSURANCE_CLASS          = v_id_insurance_class,
    TICKET_SER                  = v_ticket_ser,
    TICKET_NUM                  = v_ticket_num,
    TICKET_DATE                 = v_ticket_date,
    USER_UPDATE_NAME            = GetCurUserFullname(),
    DATE_UPDATE                 = CURDATE()
  where ID_DOGOVOR = v_id_dogovor;

  # Временно использую упрощённый вариант:
  #   1. Удалить водителей по договору.
  #   2. Вставить водителей из списка.

  delete from drivers where id_dogovor = v_id_dogovor;
  
  select COUNT(ID_CLIENT) into i from drivers_in_contract;

  while (i > 0) do
    select ID_CLIENT into ccln_id from drivers_in_contract
      order by ID_CLIENT asc limit 0, 1;

    set drv_id := GetNextIDDriver();

    repeat
      insert into drivers(ID_DRIVER, ID_CAR, ID_CLIENT, ID_DOGOVOR, DATE_INSERT)
        values(drv_id, v_id_car, ccln_id, v_id_dogovor, CURDATE());
      # Проверяю был ли вставлен водитель.
      select ROW_COUNT() >= 1 into granted;
    until (granted)
    end repeat;
    delete from drivers_in_contract where ID_CLIENT = ccln_id;
    set i := i - 1;
  end while;

  update blanks_journal set
    ID_BSO_STATUS = bso_used
  where
    DOG_SER = v_dog_ser and DOGNUMB = v_dog_numb
    and ID_INSURANCE_COMPANY = v_id_insurance_company;

  /*update drivers set
    ID_CLIENT                   = ,
    ID_DOGOVOR                  = ,
    DATE_UPDATE                 = ,
  where ID_CLIENT = v_id_ and ID_DOGOVOR = and ID_CAR = ;*/

  commit;

  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : ContProlong()                                   */
/*==============================================================*/

DROP PROCEDURE IF EXISTS ContProlong;

CREATE
DEFINER = 'root'@'%'
PROCEDURE ContProlong(
  IN v_id_dogovor VARCHAR(22),
  IN v_dog_ser VARCHAR(10),
  IN v_dog_numb VARCHAR(25),
  IN v_start_use DATE,
  IN v_end_use DATE,
  IN v_start_use1 DATE,
  IN v_end_use1 DATE,
  IN v_start_use2 DATE,
  IN v_end_use2 DATE,
  IN v_comment VARCHAR(255),
  IN v_id_client VARCHAR(22),
  IN v_id_insurance_company INT,
  IN v_transit BOOL,
  IN v_id_car VARCHAR(22),
  IN v_id_territory_use INT,
  IN v_ins_sum FLOAT,
  IN v_ins_prem FLOAT,
  IN v_koef_ter FLOAT,
  IN v_koef_bonus_malus FLOAT,
  IN v_koef_stag FLOAT,
  IN v_koef_unlimited FLOAT,
  IN v_koef_power FLOAT,
  IN v_koef_period_use FLOAT,
  IN v_koef_srok_ins FLOAT,
  IN v_koef_kn FLOAT,
  IN v_base_sum FLOAT,
  IN v_unlimited_drivers BOOL,
  IN v_date_write DATE,
  IN v_date_begin DATE,
  IN v_id_insurance_class INT,
  IN v_ticket_ser VARCHAR(10),
  IN v_ticket_num VARCHAR(25),
  IN v_ticket_date DATE,
  OUT v_new_cont_id VARCHAR(22)
)
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: пользователь.'
sproc: BEGIN
  # const
  declare id_base INT default 1;
  declare id_prolong INT default 2;
  declare state_accept INT default 2;
  declare state_refresh INT default 4;
  declare bso_used INT default 2;
  #

  declare cdate_start DATETIME;
  declare cdate_end DATE;
  declare creating_date DATE default CURDATE();
  
  declare h_id VARCHAR(22);
  declare id_prlng_cnt_id VARCHAR(22);
  declare granted BOOL;

  DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
    SET h_id := CONVERT(h_id, DECIMAL(23, 0)) + 1;

  # Проверяю полномочия.
  select ifnull(PRIV_CONT_PROLONG = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  select count(ID_DOGOVOR) > 0 into granted from dogovor where ID_DOGOVOR = v_id_dogovor;
  if (not granted) then
    call SetLastError('ERR_ENTITY_NOT_EXISTS');
    leave sproc;
  end if;

  # Изменяю срок страхования. Плюс год от текущего числа.
  select ADDDATE(creating_date, INTERVAL 1 YEAR),
    ADDDATE(creating_date, INTERVAL 1 YEAR)
    into cdate_start, cdate_end;

  select CheckDates(creating_date, cdate_start, cdate_end, v_start_use,
    v_end_use, v_start_use1, v_end_use1, v_start_use2, v_end_use2,
    v_date_write, v_date_begin) into granted;

  if (not granted) then
    call SetLastError('ERR_DATES_INCORRECT');
    leave sproc;
  end if;

  start transaction;

  call __ContAdd(
    v_id_dogovor,
    v_dog_ser,
    v_dog_numb,
    creating_date,
    cdate_start,
    cdate_end,
    v_start_use, v_end_use,
    v_start_use1, v_end_use1,
    v_start_use2, v_end_use2,
    v_comment,
    v_id_client,
    v_id_insurance_company,
    v_transit,
    v_id_car,
    v_id_territory_use,
    v_ins_sum,
    v_ins_prem,
    v_koef_ter,
    v_koef_bonus_malus,
    v_koef_stag,
    v_koef_unlimited,
    v_koef_power,
    v_koef_period_use,
    v_koef_srok_ins,
    v_koef_kn,
    v_base_sum,
    v_unlimited_drivers,
    v_date_write,
    v_date_begin,
    v_id_insurance_class,
    v_ticket_ser,
    v_ticket_num,
    v_ticket_date,
    id_base,
    id_prlng_cnt_id
  );

  if (@err_code <> 0) then
    rollback;
    leave sproc;
  end if;

  # Обновляю историю предыдущего договора.
  select ifnull(CONVERT(max(ID_DOGOVOR_HISTORY), DECIMAL(23, 0)) + 1, 0)
    into h_id from dogovor_history;

  repeat
    insert into dogovor_history(ID_DOGOVOR_HISTORY, EVENT_DATE, ID_DOGOVOR,
      ID_DOGOVOR_STATE, DATE_INSERT)
    values(h_id, creating_date, v_id_dogovor, state_refresh, creating_date);
    select ROW_COUNT() >= 1 into granted;
  until (granted)
  end repeat;

  # Устанавливаю дату обновления и статус предыдущего договора.
  update dogovor set
    ID_DOGOVOR_TYPE             = id_prolong,
    USER_UPDATE_NAME            = GetCurUserFullname(),
    DATE_UPDATE                 = creating_date
  where ID_DOGOVOR = v_id_dogovor;

  commit;

  set v_new_cont_id := id_prlng_cnt_id;

  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : ContReplace()                                    */
/*==============================================================*/

DROP PROCEDURE IF EXISTS ContReplace;

CREATE
DEFINER = 'root'@'%'
PROCEDURE ContReplace(
  IN v_id_dogovor VARCHAR(22),
  IN v_dog_ser VARCHAR(10),
  IN v_dog_numb VARCHAR(25),
  IN v_start_use DATE,
  IN v_end_use DATE,
  IN v_start_use1 DATE,
  IN v_end_use1 DATE,
  IN v_start_use2 DATE,
  IN v_end_use2 DATE,
  IN v_comment VARCHAR(255),
  IN v_id_client VARCHAR(22),
  IN v_id_insurance_company INT,
  IN v_transit BOOL,
  IN v_id_car VARCHAR(22),
  IN v_id_territory_use INT,
  IN v_ins_sum FLOAT,
  IN v_ins_prem FLOAT,
  IN v_koef_ter FLOAT,
  IN v_koef_bonus_malus FLOAT,
  IN v_koef_stag FLOAT,
  IN v_koef_unlimited FLOAT,
  IN v_koef_power FLOAT,
  IN v_koef_period_use FLOAT,
  IN v_koef_srok_ins FLOAT,
  IN v_koef_kn FLOAT,
  IN v_base_sum FLOAT,
  IN v_unlimited_drivers BOOL,
  IN v_date_write DATE,
  IN v_date_begin DATE,
  IN v_id_insurance_class INT,
  IN v_ticket_ser VARCHAR(10),
  IN v_ticket_num VARCHAR(25),
  IN v_ticket_date DATE,
  OUT v_new_cont_id VARCHAR(22)
)
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: пользователь.'
sproc: BEGIN
  # const
  declare id_base INT default 1;
  declare id_replace INT default 3;
  declare state_accept INT default 2;
  declare state_refresh INT default 4;
  #

  declare granted BOOL;
  declare i INT;
  declare cdate_start DATETIME;
  declare cdate_end DATE;
  declare creating_date DATE default CURDATE();

  declare id_repl_cnt_id VARCHAR(22);

  # ID для обработчика дублирования ID, при вставке.
  # Вначале используется, как ID договора, затем, как ID водителей.
  declare h_id VARCHAR(22);

  DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
    SET h_id := CONVERT(h_id, DECIMAL(23, 0)) + 1;

  # Проверяю полномочия.
  select ifnull(PRIV_CONT_REPLACE = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  select count(ID_DOGOVOR) > 0 into granted from dogovor where ID_DOGOVOR = v_id_dogovor;
  if (not granted) then
    call SetLastError('ERR_ENTITY_NOT_EXISTS');
    leave sproc;
  end if;

  # Получаю срок страхования и дату создания.
  # При замене, срок действия полиса никогда не меняется.
  select DATE_START, DATE_END, DATE_DOG_CREATE
    into cdate_start, cdate_end, creating_date from dogovor
    where ID_DOGOVOR = v_id_dogovor;

  select CheckDates(creating_date, cdate_start, cdate_end, v_start_use,
    v_end_use, v_start_use1, v_end_use1, v_start_use2, v_end_use2,
    v_date_write, v_date_begin) into granted;

  if (not granted) then
    call SetLastError('ERR_DATES_INCORRECT');
    leave sproc;
  end if;

  start transaction;

  call __ContAdd(
    v_id_dogovor,
    v_dog_ser, v_dog_numb,
    creating_date,
    cdate_start,
    cdate_end,
    v_start_use, v_end_use,
    v_start_use1, v_end_use1,
    v_start_use2, v_end_use2,
    v_comment,
    v_id_client,
    v_id_insurance_company,
    v_transit,
    v_id_car,
    v_id_territory_use,
    v_ins_sum,
    v_ins_prem,
    v_koef_ter,
    v_koef_bonus_malus,
    v_koef_stag,
    v_koef_unlimited,
    v_koef_power,
    v_koef_period_use,
    v_koef_srok_ins,
    v_koef_kn,
    v_base_sum,
    v_unlimited_drivers,
    v_date_write,
    v_date_begin,
    v_id_insurance_class,
    v_ticket_ser,
    v_ticket_num,
    v_ticket_date,
    id_base,
    id_repl_cnt_id
  );

  if (@err_code <> 0) then
    rollback;
    leave sproc;
  end if;

  # Обновляю историю предыдущего договора.
  select ifnull(CONVERT(max(ID_DOGOVOR_HISTORY), DECIMAL(23, 0)) + 1, 0)
    into h_id from dogovor_history;

  repeat
    insert into dogovor_history(ID_DOGOVOR_HISTORY, EVENT_DATE, ID_DOGOVOR,
      ID_DOGOVOR_STATE, DATE_INSERT)
    values(h_id, creating_date, v_id_dogovor, state_refresh, creating_date);
    select ROW_COUNT() >= 1 into granted;
  until (granted)
  end repeat;

  # Устанавливаю дату обновления и состояние предыдущего договора.
  update dogovor set
    ID_DOGOVOR_TYPE             = id_replace,
    USER_UPDATE_NAME            = GetCurUserFullname(),
    DATE_UPDATE                 = creating_date
  where ID_DOGOVOR = v_id_dogovor;

  commit;

  set v_new_cont_id := id_repl_cnt_id;

  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : ContClose()                                      */
/*==============================================================*/

DROP PROCEDURE IF EXISTS ContClose;

CREATE
DEFINER = 'root'@'%'
PROCEDURE ContClose(IN v_id_dogovor VARCHAR(22))
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: доверенный пользователь.'
sproc: BEGIN
  # const
  declare id_close INT default 4;
  declare state_stopped INT default 3;
  #
  declare granted BOOL;
  declare h_id VARCHAR(22);
  declare cdate DATE default CURDATE();
  # Дублирование ключа.
  DECLARE CONTINUE HANDLER FOR SQLSTATE '23000'
    SET h_id := CONVERT(h_id, DECIMAL(23, 0)) + 1;

  # Проверяю полномочия.
  select ifnull(PRIV_CONT_CLOSE = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  # Проверяю существование договора.
  select COUNT(*) > 0 into granted from dogovor where ID_DOGOVOR = v_id_dogovor;
  if (not granted) then
    call SetLastError('ERR_ENTITY_NOT_EXISTS');
    leave sproc;
  end if;

  start transaction;

  update dogovor set
    USER_UPDATE_NAME            = GetCurUserFullname(),
    DATE_UPDATE                 = cdate,
    ID_DOGOVOR_TYPE             = id_close
  where ID_DOGOVOR = v_id_dogovor;

  # Обновляю историю данного договора.
  select ifnull(CONVERT(max(ID_DOGOVOR_HISTORY), DECIMAL(23, 0)) + 1, 0)
    into h_id from dogovor_history;

  repeat
    insert into dogovor_history(ID_DOGOVOR_HISTORY, EVENT_DATE, ID_DOGOVOR,
      ID_DOGOVOR_STATE, DATE_INSERT)
    values(h_id, cdate, v_id_dogovor, state_stopped, cdate);
    select ROW_COUNT() >= 1 into granted;
  until (granted)
  end repeat;

  commit;

  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : ContDel()                                        */
/*==============================================================*/

DROP PROCEDURE IF EXISTS ContDel;

CREATE
DEFINER = 'root'@'%'
PROCEDURE ContDel(IN v_id_dogovor VARCHAR(22))
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: администратор.'
sproc: BEGIN
  declare granted BOOL;

  # Проверяю полномочия.
  select ifnull(PRIV_CONT_DEL = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  # Проверяю существование договора.
  select COUNT(*) > 0 into granted from dogovor where ID_DOGOVOR = v_id_dogovor;
  if (not granted) then
    call SetLastError('ERR_ENTITY_NOT_EXISTS');
    leave sproc;
  end if;

  delete from dogovor where ID_DOGOVOR = v_id_dogovor;
  # Об удалении всего остального позаботится InnoDB.
  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : ContHistory                                      */
/*==============================================================*/

DROP PROCEDURE IF EXISTS ContHistory;

CREATE
DEFINER = 'root'@'%'
PROCEDURE ContHistory(IN v_id_dogovor VARCHAR(22))
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: пользователь.'
BEGIN
  declare id_prev_contract VARCHAR(22) default v_id_dogovor;
  declare is_exists BOOLEAN default FALSE;

  create temporary table if not exists contracts_history engine = MEMORY
    replace select ID_DOGOVOR from dogovor limit 0;
  # Очищаю предыдущую таблицу.
  delete from contracts_history;

  ins_cycle: repeat
    select ID_PREV_DOG into id_prev_contract from dogovor
      where ID_DOGOVOR = id_prev_contract;
    select count(ID_DOGOVOR) != 0 into is_exists from contracts_history where
      ID_DOGOVOR = id_prev_contract;
    # Проверяю существует ли договор с данным ID, вообще.
    select count(ID_DOGOVOR) = 0 or is_exists into is_exists from dogovor where
      ID_DOGOVOR = id_prev_contract;
    if (is_exists) then
      leave ins_cycle;
    end if;
    insert into contracts_history select ID_DOGOVOR from dogovor
      where ID_DOGOVOR = id_prev_contract;
  until ((id_prev_contract is NULL) or is_exists)
  end repeat;

  select
    dogovor.ID_DOGOVOR as CNT_ID_DOGOVOR,
    dogovor.DOG_SER as CNT_DOG_SER,
    dogovor.DOGNUMB as CNT_DOGNUMB,
    dogovor.DATE_DOG_CREATE as CNT_DATE_DOG_CREATE,
    dogovor.DATE_DOG_INPUT as CNT_DATE_DOG_INPUT,
    dogovor.DATE_START as CNT_DATE_START,
    dogovor.DATE_END as CNT_DATE_END,
    dogovor.START_USE as CNT_START_USE,
    dogovor.END_USE as CNT_END_USE,
    dogovor.START_USE1 as CNT_START_USE1,
    dogovor.END_USE1 as CNT_END_USE1,
    dogovor.START_USE2 as CNT_START_USE2,
    dogovor.END_USE2 as CNT_END_USE2,
    dogovor.ZNAK_SER as CNT_ZNAK_SER,
    dogovor.ZNAK_NO as CNT_ZNAK_NO,
    dogovor.COMMENT as CNT_COMMENT,
    dogovor.ID_CLIENT as CNT_ID_CLIENT,
    dogovor.ID_DOGOVOR_TYPE as CNT_ID_DOGOVOR_TYPE,
    dogovor.ID_INSURANCE_COMPANY as CNT_ID_INSURANCE_COMPANY,
    dogovor.TRANSIT as CNT_TRANSIT,
    dogovor.ID_CAR as CNT_ID_CAR,
    dogovor.ID_TERRITORY_USE as CNT_ID_TERRITORY_USE,
    dogovor.UNLIMITED_DRIVERS as CNT_UNLIMITED_DRIVERS,
    dogovor.INS_SUM as CNT_INS_SUM,
    dogovor.INS_PREM as CNT_INS_PREM,
    dogovor.KOEF_TER as CNT_KOEF_TER,
    dogovor.KOEF_BONUSMALUS as CNT_KOEF_BONUSMALUS,
    dogovor.KOEF_STAG as CNT_KOEF_STAG,
    dogovor.KOEF_UNLIMITED as CNT_KOEF_UNLIMITED,
    dogovor.KOEF_POWER as CNT_KOEF_POWER,
    dogovor.KOEF_PERIOD_USE as CNT_KOEF_PERIOD_USE,
    dogovor.KOEF_SROK_INS as CNT_KOEF_SROK_INS,
    dogovor.KOEF_KN as CNT_KOEF_KN,
    dogovor.BASE_SUM as CNT_BASE_SUM,
    dogovor.ID_INSURANCE_CLASS as CNT_ID_INSURANCE_CLASS,
    dogovor.DATE_WRITE as CNT_DATE_WRITE,
    dogovor.DATE_BEGIN as CNT_DATE_BEGIN,
    dogovor.ID_PREV_DOG as CNT_ID_PREV_DOG,
    dogovor.TICKET_SER as CNT_TICKET_SER,
    dogovor.TICKET_NUM as CNT_TICKET_NUM,
    dogovor.TICKET_DATE as CNT_TICKET_DATE,
    dogovor.DATE_INSERT as CNT_DATE_INSERT,
    dogovor.DATE_UPDATE as CNT_DATE_UPDATE,
    dogovor.USER_INSERT_NAME as CNT_USER_INSERT_NAME,
    dogovor.USER_UPDATE_NAME as CNT_USER_UPDATE_NAME,
    car.ID_CAR as CAR_ID_CAR,
    car.ARENDA as CAR_ARENDA,
    car.ID_PURPOSE_TYPE as CAR_ID_PURPOSE_TYPE,
    car.ID_CAR_TYPE as CAR_ID_CAR_TYPE,
    car.ID_PRODUCTER_TYPE as CAR_ID_PRODUCTER_TYPE,
    car.ID_CLIENT as CAR_ID_CLIENT,
    car.PTS_DATE as CAR_PTS_DATE,
    car.DATE_INSERT as CAR_DATE_INSERT,
    car.CAR_MARK as CAR_CAR_MARK,
    car.DATE_UPDATE as CAR_DATE_UPDATE,
    car.CAR_MODEL as CAR_CAR_MODEL,
    car.VIN_NUM as CAR_VIN_NUM,
    car.YEAR_ISSUE as CAR_YEAR_ISSUE,
    car.POWER_KVT as CAR_POWER_KVT,
    car.POWER_LS as CAR_POWER_LS,
    car.MAX_KG as CAR_MAX_KG,
    car.NUM_PLACES as CAR_NUM_PLACES,
    car.SHASSI as CAR_SHASSI,
    car.KUSOV as CAR_KUSOV,
    car.GOS_NUM as CAR_GOS_NUM,
    car.PTS_SER as CAR_PTS_SER,
    car.PTS_NO as CAR_PTS_NO,
    car.FOREING as CAR_FOREING,
    car.COMMENTS as CAR_COMMENTS,
    car.USER_INSERT_NAME as CAR_USER_INSERT_NAME,
    car.USER_UPDATE_NAME as CAR_USER_UPDATE_NAME,
    client.ID_CLIENT as CLN_ID_CLIENT,
    client.SURNAME as CLN_SURNAME,
    client.NAME as CLN_NAME,
    client.MIDDLENAME as CLN_MIDDLENAME,
    client.INN as CLN_INN,
    client.DOC_SER as CLN_DOC_SER,
    client.POSTINDEX as CLN_POSTINDEX,
    client.BIRTHDAY as CLN_BIRTHDAY,
    client.ID_CITY as CLN_ID_CITY,
    client.ID_REGION as CLN_ID_REGION,
    client.ID_COUNTRY as CLN_ID_COUNTRY,
    client.TOWN as CLN_TOWN,
    client.STREET as CLN_STREET,
    client.HOME as CLN_HOME,
    client.KORPUS as CLN_KORPUS,
    client.FLAT as CLN_FLAT,
    client.HOME_PHONE as CLN_HOME_PHONE,
    client.DOC_NUM as CLN_DOC_NUM,
    client.ID_SEX as CLN_ID_SEX,
    client.ID_FAMILY_STATE as CLN_ID_FAMILY_STATE,
    client.ID_CLIENT_TYPE as CLN_ID_CLIENT_TYPE,
    client.ID_TYPE_DOC as CLN_ID_TYPE_DOC,
    client.GROSS_VIOLATIONS as CLN_GROSS_VIOLATIONS,
    client.ID_INSURANCE_CLASS as CLN_ID_INSURANCE_CLASS,
    client.LICENCE_SER as CLN_LICENCE_SER,
    client.LICENCE_NO as CLN_LICENCE_NO,
    client.START_DRIVING_DATE as CLN_START_DRIVING_DATE,
    client.DATE_INSERT as CLN_DATE_INSERT,
    client.DATE_UPDATE as CLN_DATE_UPDATE,
    client.WRITER_NAME as CLN_WRITER_NAME,
    client.ID_TYPE_LOSSED as CLN_ID_TYPE_LOSSED,
    client.CELL_PHONE as CLN_CELL_PHONE,
    client.BUSINESS_PHONE as CLN_BUSINESS_PHONE,
    client.LAST_CALL_DATE as CLN_LAST_CALL_DATE,
    client.COMMENTS as CLN_COMMENTS,
    client.USER_INSERT_NAME as CLN_USER_INSERT_NAME,
    client.USER_UPDATE_NAME as CLN_USER_UPDATE_NAME,
    CONCAT_WS(" ", DOG_SER, DOGNUMB) as FULL_NUM,
    CONCAT_WS(" ", carmark.MARK, car.CAR_MODEL) as FULL_MODEL,
    CONCAT_WS(" ", client.surname, client.name, client.middlename)
    as FULL_NAME,
    CONCAT_WS(", ",
      if(client.town = '', null, client.town),
      if(client.street = '', null, client.street),
      if(client.home = '', null, client.home),
      if(client.korpus = '', null, client.korpus),
      if(client.flat = '', null, client.flat))
    as FULL_ADDRESS
    #dogovor_state.DOGOVOR_STATE as HIST_STATE,
    #dh.EVENT_DATE as HIST_EVENT

    # from dogovor_history dh
    from contracts_history ch
    #join  ch on dh.ID_DOGOVOR = ch.ID_DOGOVOR
    #join dogovor_state on dogovor_state.ID_DOGOVOR_STATE = dh.ID_DOGOVOR_STATE
    join dogovor on dogovor.ID_DOGOVOR = ch.ID_DOGOVOR
    join client on dogovor.ID_CLIENT = client.ID_CLIENT
    join car on dogovor.ID_CAR = car.ID_CAR
    join car_type on car.ID_CAR_TYPE = car_type.ID_CAR_TYPE
    join carmark on car.CAR_MARK = carmark.ID_CARMARK;
#    order by CNT_DATE_START desc;

  call SetLastError('ERR_NO_ERROR');
END;

/*CREATE
DEFINER = 'root'@'%'
PROCEDURE ContHistory(IN v_id_dogovor VARCHAR(22), OUT err_code TINYINT)
SQL SECURITY INVOKER
COMMENT 'Предположительные привилегии: пользователь.'
BEGIN
  declare id_prev_contract VARCHAR(22) default v_id_dogovor;
  declare pr_query TEXT default  'select * from dogovor where ID_DOGOVOR in (';
  set err_code := 1;
  
  repeat
    select ID_PREV_DOG into id_prev_contract from dogovor
      where ID_DOGOVOR = id_prev_contract;
    if (id_prev_contract is not NULL) then
      select concat(pr_query, '''', id_prev_contract, ''', ') into pr_query;
    end if;
  until ((id_prev_contract is NULL) or
    id_prev_contract = v_id_dogovor)
  end repeat;
  select concat(trim(trailing ', ' from pr_query), ');') into pr_query;

  set @rpq = pr_query;
  prepare r_que from @rpq;
  execute r_que;
  # debug
  #select @rpq;
  set err_code := 0;
END;*/

#
# User and group routines.
#

/*==============================================================*/
/* Procedure : GrantPrivs()                                     */
/*==============================================================*/

DROP PROCEDURE IF EXISTS GrantPrivs;

CREATE
DEFINER = 'root'@'%'
PROCEDURE GrantPrivs(
  IN v_user_name CHAR(16),
  IN v_user_host CHAR(60),  
  IN v_table_name VARCHAR(255),
  IN v_privs VARCHAR(255)
)
SQL SECURITY INVOKER
COMMENT 'Внутренняя. Заносит права в БД mysql.'
sproc: BEGIN
  # Сделано это для того, чтобы использовать в триггере. GRANT делает commit.

  insert into mysql.tables_priv(Host, Db, User, Table_name, Grantor,
    Timestamp, Table_priv)
  values(v_user_host, 'osago', v_user_name, v_table_name, current_user(), now(),
    v_privs)
  on duplicate key update
    Grantor    = current_user(),
    Timestamp  = now(),
    Table_priv = v_privs;
END;

/*==============================================================*/
/* Procedure : InfosPrivsSet                                    */
/*==============================================================*/

DROP PROCEDURE IF EXISTS InfosPrivsSet;

CREATE
DEFINER = 'root'@'%'
PROCEDURE InfosPrivsSet(
  IN v_user_name CHAR(16),
  IN v_user_host CHAR(60),
  IN v_granted_ie BOOL,
  IN v_set_all_privs BOOL
)
SQL SECURITY INVOKER
COMMENT 'Внутренняя. Устанавливает корректные права.'
sproc: BEGIN
  declare full_user CHAR(80);

  select CONCAT('''', v_user_name, '''@''', v_user_host, '''') into full_user;

  if (v_set_all_privs) then
  # Установить все права.
    call GrantPrivs(v_user_name, v_user_host, 'blanks_journal', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'bso_status', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'bso_type', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'car', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'change_log', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'client', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'client_type_group', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'dogovor', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'dogovor_history', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'dogovor_state', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'dogovor_type', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'drivers', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'error_info', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'producter_type', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'self_info', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'user_groups', 'Select');
  end if;

  if (v_granted_ie) then
  # Разрешено изменение.
    call GrantPrivs(v_user_name, v_user_host, 'base_sum',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'car_type',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'carmark',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'car_model',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'client_types',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'city',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'country',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'family_state',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'geo_groups',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_foreing',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_km',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_ko',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_kp',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_ks',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_kvs',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_other',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'ins_formula',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'ins_formula_conf',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'ins_formula_type',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'insurance_class',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'insurance_company',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'purpose_type',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'region',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'sex',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'territory_use',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'type_doc',
      'Select,Insert,Update,Delete');
    call GrantPrivs(v_user_name, v_user_host, 'valuta',
      'Select,Insert,Update,Delete');

    #GRANT
    #   INSERT, UPDATE, DELETE ON TABLE osago.bso_status
    #TO full_user;
    #GRANT
    #   INSERT, UPDATE, DELETE ON TABLE osago.bso_type
    #TO full_user;
    #GRANT
    #   INSERT, UPDATE, DELETE ON TABLE osago.client_type_group
    #TO full_user;
    #GRANT
    #   INSERT, UPDATE, DELETE ON TABLE osago.dogovor_state
    #TO full_user;
    #GRANT
    #   INSERT, UPDATE, DELETE ON TABLE osago.dogovor_type
    #TO full_user;
    #GRANT
    #   INSERT, UPDATE, DELETE ON TABLE osago.guilty_type
    #TO full_user;
    #GRANT
    #   INSERT, UPDATE, DELETE ON TABLE osago.producter_type
    #TO full_user;
  else
  # Запрещено изменение справочников.
    #REVOKE
    #   INSERT, UPDATE, DELETE ON TABLE osago.bso_status
    #FROM full_user;
    #REVOKE
    #   INSERT, UPDATE, DELETE ON TABLE osago.bso_type
    #FROM full_user;
    #REVOKE
    #   INSERT, UPDATE, DELETE ON TABLE osago.client_type_group
    #FROM full_user;
    #REVOKE
    #   INSERT, UPDATE, DELETE ON TABLE osago.dogovor_state
    #FROM full_user;
    #REVOKE
    #   INSERT, UPDATE, DELETE ON TABLE osago.dogovor_type
    #FROM full_user;
    #REVOKE
    #   INSERT, UPDATE, DELETE ON TABLE osago.guilty_type
    #FROM full_user;
    #REVOKE
    #   INSERT, UPDATE, DELETE ON TABLE osago.producter_type
    #FROM full_user;
    #delete from mysql.tables_priv where
    #  Host = v_user_host and User = v_user_name
    #  and Db = 'osago' and Table_name = 'base_sum';
    call GrantPrivs(v_user_name, v_user_host, 'base_sum', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'car_type', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'carmark', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'car_model', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'city', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'country', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'client_types', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'family_state', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'geo_groups', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_foreing', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_km', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_ko', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_kp', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_ks', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_kvs', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'ins_koefs_other', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'ins_formula', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'ins_formula_conf', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'ins_formula_type', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'insurance_class', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'insurance_company', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'purpose_type', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'region', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'sex', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'territory_use', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'type_doc', 'Select');
    call GrantPrivs(v_user_name, v_user_host, 'valuta', 'Select');
  end if;
  #if (v_granted_us) then
  # Разрешено чтение таблиц пользователей.
  #  call GrantPrivs(v_user_name, v_user_host, 'user_data', 'Select');
  #  call GrantPrivs(v_user_name, v_user_host, 'user_settings', 'Select');
  #else
  # Запрещено чтение таблиц пользователей.
  #  call GrantPrivs(v_user_name, v_user_host, 'user_data', '');
  #  call GrantPrivs(v_user_name, v_user_host, 'user_settings', '');
  #end if;
END;

/*==============================================================*/
/* Trigger : user_groups_upd                                    */
/*==============================================================*/

DROP TRIGGER IF EXISTS `user_groups_upd`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `user_groups_upd` AFTER UPDATE ON `user_groups`
FOR EACH ROW
BEGIN
  declare granted_ie BOOL;
  declare cuser CHAR(16);
  declare chost CHAR(60);
  declare i int;
  select
    ifnull(NEW.PRIV_INFOS_EDIT = true, false) into granted_ie
  from user_groups
    where ID_GROUP = NEW.ID_GROUP;

  # Обновляю права пользователей.
  create temporary table if not exists users_in_group
  (
    User CHAR(16),
    Host CHAR(60),
    primary key(User, Host)
  ) ENGINE=MEMORY;

  delete from users_in_group;

  insert into users_in_group(User, Host)
    select User, Host from user_data where ID_GROUP = NEW.ID_GROUP;

  select COUNT(User) into i from users_in_group;
  while (i > 0) do
    select User, Host into cuser, chost from users_in_group
      order by User asc limit 0, 1;
    call InfosPrivsSet(cuser, chost, granted_ie, false);
    delete from users_in_group where User = cuser and Host = chost;
    set i := i - 1;
  end while;
END;

/*==============================================================*/
/* Trigger : user_data_upd                                      */
/*==============================================================*/

DROP TRIGGER IF EXISTS `user_data_upd`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `user_data_upd` AFTER UPDATE ON `user_data`
FOR EACH ROW
BEGIN
  declare granted_ie BOOL;
  declare cuser CHAR(16);
  declare chost CHAR(60);

  # Проверяю полномочия.
  select ifnull(PRIV_INFOS_EDIT = true, false) from user_groups
    where ID_GROUP = NEW.ID_GROUP into granted_ie;

  select NEW.User, NEW.Host into cuser, chost;

  # Обновляю права пользователя.
  call InfosPrivsSet(cuser, chost, granted_ie, false);

  # Таблица обновлений.
  call FixTableChange('user_data',
    CONCAT_WS(';', NEW.Host, NEW.User), 'u');
END;

/*==============================================================*/
/* Trigger : user_data_add                                      */
/*==============================================================*/

DROP TRIGGER IF EXISTS `user_data_add`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `user_data_add` AFTER INSERT ON `user_data`
FOR EACH ROW
BEGIN
  declare granted_ie BOOL;
  declare cuser CHAR(16);
  declare chost CHAR(60);

  # Проверяю полномочия.
  select ifnull(PRIV_INFOS_EDIT = true, false) from user_groups
    where ID_GROUP = NEW.ID_GROUP into granted_ie;

  select NEW.User, NEW.Host into cuser, chost;

  # Обновляю права пользователя.
  call InfosPrivsSet(cuser, chost, granted_ie, true);

  # Таблица обновлений.
  call FixTableChange('user_data',
    CONCAT_WS(';', NEW.Host, NEW.User), 'i');
END;

/*==============================================================*/
/* Triggers : user_data_del                                     */
/*==============================================================*/

DROP TRIGGER IF EXISTS `user_data_del`;

CREATE
DEFINER = 'root'@'%'
TRIGGER `user_data_del` AFTER DELETE ON `user_data`
FOR EACH ROW
BEGIN
  call FixTableChange('user_data',
    CONCAT_WS(';', OLD.Host, OLD.User), 'd');
END;

/*==============================================================*/
/* Procedure : UserAdd()                                        */
/*==============================================================*/

DROP PROCEDURE IF EXISTS UserAdd;

CREATE
DEFINER = 'root'@'%'
PROCEDURE UserAdd(
  IN v_user_name CHAR(16),
  IN v_user_host CHAR(60),
  IN v_password VARCHAR(255),
  IN v_surname VARCHAR(80),
  IN v_name VARCHAR(80),
  IN v_pathr VARCHAR(80),
  IN v_address VARCHAR(255),
  IN v_home_phone VARCHAR(255),
  IN v_cell_phone VARCHAR(255),
  IN v_id_group INT,
  IN v_comments VARCHAR(255)
)
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: администратор.'
sproc: BEGIN
  declare granted BOOL;
  declare full_user CHAR(80);
  # Ограничения.
  declare mqph, muph, mcph, muc INT;

  # Проверяю полномочия.
  select ifnull(PRIV_USER_ADD = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  if ((v_user_host is NULL) or (v_user_name is NULL) or (v_password is NULL)
      or (v_user_host = '') or (v_user_name = '') or (v_password = '')) then
    call SetLastError('ERR_USER_DATA_INCORRECT');
    leave sproc;
  end if;

  select CONCAT('''', v_user_name, '''@''', v_user_host, '''') into full_user;

  # Создаю пользователя.
  select CONCAT('CREATE USER ', full_user, ' IDENTIFIED BY ''',
    v_password, ''';') into @__cu;
  PREPARE cu from @__cu;
  set @__cu := NULL;
  EXECUTE cu;
  DEALLOCATE PREPARE cu;

  # Определяю права СУБД.
  set @__cu := CONCAT('GRANT EXECUTE ON osago.* TO ', full_user);
  PREPARE cu from @__cu;
  set @__cu := NULL;
  EXECUTE cu;
  DEALLOCATE PREPARE cu;

  # Выбираю ограничения.
  select MAX_QUERIES_PER_HOUR, MAX_UPDATES_PER_HOUR, MAX_CONNECTIONS_PER_HOUR,
    MAX_USER_CONNECTIONS into mqph, muph, mcph, muc
  from self_info;

  # Ограничения.
  select CONCAT('GRANT USAGE ON *.* TO ', full_user,
    ' WITH MAX_QUERIES_PER_HOUR ', mqph,
    ' MAX_UPDATES_PER_HOUR ', muph,
    ' MAX_CONNECTIONS_PER_HOUR ', mcph,
    ' MAX_USER_CONNECTIONS ', muc) into @__gu;
  
  PREPARE gu from @__gu;
  set @__gu := NULL;
  EXECUTE gu;
  DEALLOCATE PREPARE gu;

  start transaction;

  # Права нового пользователя устанавливает триггер.
  # call InfosPrivsSet(v_user_name, v_user_host, granted, true);

  # Заношу контактную информацию.
  insert into user_data(User, Host, SURNAME, NAME, PATHRONIMYC, ADDRESS,
    HOME_PHONE, CELL_PHONE, ID_GROUP, COMMENTS)
  values(v_user_name, v_user_host, v_surname, v_name, v_pathr, v_address,
    v_home_phone, v_cell_phone, v_id_group, v_comments);
  # Изначальные настройки.
  insert into user_settings(User, Host, FIRST_RUN)
  values(v_user_name, v_user_host, true);

  commit;

  FLUSH PRIVILEGES;

  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : UserDel()                                        */
/*==============================================================*/

DROP PROCEDURE IF EXISTS UserDel;

CREATE
DEFINER = 'root'@'%'
PROCEDURE UserDel(
  IN v_user_name CHAR(16),
  IN v_user_host CHAR(60)
)
READS SQL DATA
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: администратор.'
sproc: BEGIN
  declare granted BOOL;
  declare full_user CHAR(80);

  select ifnull(PRIV_USER_DEL = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  # Процедура позволяет удалять только пользователей данной программы.

  select count(User) > 0 into granted from user_data where
    User = v_user_name and Host = v_user_host;
  if (not granted) then
    call SetLastError('ERR_USER_NOT_EXISTS');
    leave sproc;
  end if;

  select CONCAT('''', v_user_name, '''@''', v_user_host, '''') into full_user;

  # Из user_settings InnoDB удалит автоматически.
  delete from user_data where User = v_user_name and Host = v_user_host;
  # set @__cu := CONCAT('REVOKE ALL PRIVILEGES, GRANT OPTION FROM ', full_user, ';');
  # Замена REVOKE, который не поддерживается.
  delete from mysql.columns_priv where Host = v_user_host and User = v_user_name;
  delete from mysql.db where Host = v_user_host and User = v_user_name;
  delete from mysql.procs_priv where Host = v_user_host and User = v_user_name;
  delete from mysql.tables_priv where Host = v_user_host and User = v_user_name;

  set @__cu := CONCAT('DROP USER ', full_user, ';');
  PREPARE cu from @__cu;
  set @__cu := NULL;
  EXECUTE cu;
  DEALLOCATE PREPARE cu;

  FLUSH PRIVILEGES;
END;

/*==============================================================*/
/* Procedure : UserChg()                                        */
/*==============================================================*/

DROP PROCEDURE IF EXISTS UserChg;

CREATE
DEFINER = 'root'@'%'
PROCEDURE UserChg(
  IN v_old_user_name CHAR(16),
  IN v_old_user_host CHAR(60),
  IN v_new_user_name CHAR(16),
  IN v_new_user_host CHAR(60),
  IN v_password VARCHAR(255),
  IN v_surname VARCHAR(80),
  IN v_name VARCHAR(80),
  IN v_pathr VARCHAR(80),
  IN v_address VARCHAR(255),
  IN v_home_phone VARCHAR(255),
  IN v_cell_phone VARCHAR(255),
  IN v_id_group INT,
  IN v_comments VARCHAR(255)
)
READS SQL DATA
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: администратор.'
sproc: BEGIN
  declare granted BOOL;
  declare full_old_user, full_new_user CHAR(80);
  # Ограничения.
  declare mqph, muph, mcph, muc INT;

  select ifnull(PRIV_USER_CHG = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  select count(User) > 0 into granted from user_data where
    User = v_old_user_name and Host = v_old_user_host;
  if (not granted) then
    call SetLastError('ERR_USER_NOT_EXISTS');
    leave sproc;
  end if;

  select CONCAT('''', v_old_user_name, '''@''', v_old_user_host, '''')
    into full_old_user;
  select CONCAT('''', v_new_user_name, '''@''', v_new_user_host, '''')
    into full_new_user;

  # Переименовываю пользователя.
  if (full_new_user <> full_old_user) then
    select CONCAT('RENAME USER ', full_old_user, ' TO ',
      full_new_user, ';') into @__cu;
    PREPARE cu from @__cu;
    set @__cu := NULL;
    EXECUTE cu;
    DEALLOCATE PREPARE cu;
  end if;

  # Меняю пароль.
  if (v_password is not NULL) then
    select CONCAT('SET PASSWORD FOR ', full_new_user, ' = PASSWORD(''',
      v_password, ''');') into @__cu;
      PREPARE cu from @__cu;
      set @__cu := NULL;
      EXECUTE cu;
      DEALLOCATE PREPARE cu;
  end if;

  # Выбираю ограничения.
  select MAX_QUERIES_PER_HOUR, MAX_UPDATES_PER_HOUR, MAX_CONNECTIONS_PER_HOUR,
    MAX_USER_CONNECTIONS into mqph, muph, mcph, muc
  from self_info;

  # Ограничения.
  select CONCAT('GRANT USAGE ON *.* TO ', full_new_user,
    ' WITH MAX_QUERIES_PER_HOUR ', mqph,
    ' MAX_UPDATES_PER_HOUR ', muph,
    ' MAX_CONNECTIONS_PER_HOUR ', mcph,
    ' MAX_USER_CONNECTIONS ', muc) into @__gu;

  PREPARE gu from @__gu;
  set @__gu := NULL;
  EXECUTE gu;
  DEALLOCATE PREPARE gu;

  # Изменяю контактную информацию.
  # Права изменятся автоматически - в триггере.
  update user_data set
    User        = v_new_user_name,
    Host        = v_new_user_host,
    SURNAME     = v_surname,
    NAME        = v_name,
    PATHRONIMYC = v_pathr,
    ADDRESS     = v_address,
    HOME_PHONE  = v_home_phone,
    CELL_PHONE  = v_cell_phone,
    ID_GROUP    = v_id_group,
    COMMENTS    = v_comments
  where User = v_old_user_name and Host = v_old_user_host;

  FLUSH PRIVILEGES;

  call SetLastError('ERR_NO_ERROR');
END;

/*==============================================================*/
/* Procedure : UserGetAll()                                     */
/*==============================================================*/

DROP PROCEDURE IF EXISTS UserGetAll;

CREATE
DEFINER = 'root'@'%'
PROCEDURE UserGetAll()
READS SQL DATA
SQL SECURITY DEFINER
COMMENT 'Получение данных текущего пользователя. Все пользователи.'
sproc: BEGIN
  declare granted BOOL;

  select ifnull(PRIV_USER_CHG = true, false) or
    ifnull(PRIV_USER_DEL = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;

  select ud.*, ug.GROUP_NAME,
    us.MW_WIDTH,
    us.MW_HEIGHT,
    us.MW_LEFT,
    us.MW_TOP,
    us.MW_STATE,
    us.USE_HELPER,
    us.FIRST_RUN
  from user_data ud
    left join user_settings us on us.User = ud.User and us.Host = ud.Host
    join user_groups ug on ud.ID_GROUP = ug.ID_GROUP;
END;

/*==============================================================*/
/* Procedure : UserGetCurrent()                                 */
/*==============================================================*/

DROP PROCEDURE IF EXISTS UserGetCurrent;

CREATE
DEFINER = 'root'@'%'
PROCEDURE UserGetCurrent()
READS SQL DATA
SQL SECURITY DEFINER
COMMENT 'Получение данных текущего пользователя. Все пользователи.'
sproc: BEGIN
  declare user_name CHAR(16);
  declare user_host CHAR(60);

  call GetCurUser(user_name, user_host);
  select ud.*,
    us.MW_WIDTH,
    us.MW_HEIGHT,
    us.MW_LEFT,
    us.MW_TOP,
    us.MW_STATE,
    us.USE_HELPER,
    us.FIRST_RUN
    from user_data ud left join user_settings us
    on us.User = ud.User and us.Host = ud.Host
    where
    ud.User = user_name and ud.Host = user_host;
END;

/*==============================================================*/
/* Procedure : UserSaveSettings()                               */
/*==============================================================*/

DROP PROCEDURE IF EXISTS UserSaveSettings;

CREATE
DEFINER = 'root'@'%'
PROCEDURE UserSaveSettings(
  IN v_mw_width INT,
  IN v_mw_height INT,
  IN v_mw_left INT,
  IN v_mw_top INT,
  IN v_mw_state BOOL,
  IN v_use_helper BOOL,
  IN v_first_run BOOL
)
READS SQL DATA
SQL SECURITY DEFINER
COMMENT 'Сохранение настроек текущего пользователя. Все пользователи.'
BEGIN
  declare user_name CHAR(16);
  declare user_host CHAR(60);

  call GetCurUser(user_name, user_host);

  insert into user_settings(User, Host, MW_WIDTH, MW_HEIGHT, MW_LEFT, MW_TOP,
    MW_STATE, USE_HELPER, FIRST_RUN)
  values(user_name, user_host, v_mw_width, v_mw_height, v_mw_left,
    v_mw_top, v_mw_state, v_use_helper, v_first_run)
  on duplicate key update
    MW_WIDTH    = v_mw_width,
    MW_HEIGHT   = v_mw_height,
    MW_LEFT     = v_mw_left,
    MW_TOP      = v_mw_top,
    MW_STATE    = v_mw_state,
    USE_HELPER  = v_use_helper,
    FIRST_RUN   = v_first_run;
END;

/*==============================================================*/
/* Procedure : GroupAdd()                                       */
/*==============================================================*/

DROP PROCEDURE IF EXISTS GroupAdd;

CREATE
DEFINER = 'root'@'%'
PROCEDURE GroupAdd(
  IN v_group_name VARCHAR(255),
  IN v_group_descr VARCHAR(255),
  IN v_priv_cln_add BOOL,
  IN v_priv_cln_chg BOOL,
  IN v_priv_cln_del BOOL,
  IN v_priv_car_add BOOL,
  IN v_priv_car_chg BOOL,
  IN v_priv_car_del BOOL,
  IN v_priv_cont_add BOOL,
  IN v_priv_cont_chg BOOL,
  IN v_priv_cont_del BOOL,
  IN v_priv_cont_prolong BOOL,
  IN v_priv_cont_replace BOOL,
  IN v_priv_cont_close BOOL,
  IN v_priv_user_add BOOL,
  IN v_priv_user_chg BOOL,
  IN v_priv_user_del BOOL,
  IN v_priv_group_add BOOL,
  IN v_priv_group_chg BOOL,
  IN v_priv_group_del BOOL,
  IN v_priv_blanks BOOL,
  IN v_priv_infos_edit BOOL,
  OUT v_id_group TINYINT
)
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: администратор.'
sproc: BEGIN
  declare granted BOOL;

  # Проверяю полномочия
  select ifnull(PRIV_GROUP_ADD = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;
  call SetLastError('ERR_FUNC_NOT_IMPLEMENTED');
END;

/*==============================================================*/
/* Procedure : GroupDel()                                       */
/*==============================================================*/

DROP PROCEDURE IF EXISTS GroupDel;

CREATE
DEFINER = 'root'@'%'
PROCEDURE GroupDel(
  IN v_id_group TINYINT
)
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: администратор.'
sproc: BEGIN
  declare granted BOOL;

  # Проверяю полномочия
  select ifnull(PRIV_GROUP_ADD = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;
  call SetLastError('ERR_FUNC_NOT_IMPLEMENTED');
END;

/*==============================================================*/
/* Procedure : GroupChg()                                       */
/*==============================================================*/

DROP PROCEDURE IF EXISTS GroupChg;

CREATE
DEFINER = 'root'@'%'
PROCEDURE GroupChg(
  IN v_id_group TINYINT,
  IN v_group_name VARCHAR(255),
  IN v_group_descr VARCHAR(255),
  IN v_priv_cln_add BOOL,
  IN v_priv_cln_chg BOOL,
  IN v_priv_cln_del BOOL,
  IN v_priv_car_add BOOL,
  IN v_priv_car_chg BOOL,
  IN v_priv_car_del BOOL,
  IN v_priv_cont_add BOOL,
  IN v_priv_cont_chg BOOL,
  IN v_priv_cont_del BOOL,
  IN v_priv_cont_prolong BOOL,
  IN v_priv_cont_replace BOOL,
  IN v_priv_cont_close BOOL,
  IN v_priv_user_add BOOL,
  IN v_priv_user_chg BOOL,
  IN v_priv_user_del BOOL,
  IN v_priv_group_add BOOL,
  IN v_priv_group_chg BOOL,
  IN v_priv_group_del BOOL,
  IN v_priv_blanks BOOL,
  IN v_priv_infos_edit BOOL
)
SQL SECURITY DEFINER
COMMENT 'Предположительные привилегии: администратор.'
sproc: BEGIN
  declare granted BOOL;

  # Проверяю полномочия
  select ifnull(PRIV_GROUP_ADD = true, false) from user_groups
    where ID_GROUP = GetGroupID() into granted;
  if (not granted) then
    call SetLastError('ERR_NOT_ENOUGH_RIGHTS');
    leave sproc;
  end if;
  call SetLastError('ERR_FUNC_NOT_IMPLEMENTED');
END;

;;

delimiter ;

# EOF.