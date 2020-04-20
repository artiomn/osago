TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `user_groups_upd` AFTER UPDATE ON `user_groups`\nFOR EACH ROW\nBEGIN\n  declare granted_ie BOOL;\n  declare cuser CHAR(16);\n  declare chost CHAR(60);\n  declare i int;\n  select\n    ifnull(NEW.PRIV_INFOS_EDIT = true, false) into granted_ie\n  from user_groups\n    where ID_GROUP = NEW.ID_GROUP;\n\n  \n  create temporary table if not exists users_in_group\n  (\n    User CHAR(16),\n    Host CHAR(60),\n    primary key(User, Host)\n  ) ENGINE=MEMORY;\n\n  delete from users_in_group;\n\n  insert into users_in_group(User, Host)\n    select User, Host from user_data where ID_GROUP = NEW.ID_GROUP;\n\n  select COUNT(User) into i from users_in_group;\n  while (i > 0) do\n    select User, Host into cuser, chost from users_in_group\n      order by User asc limit 0, 1;\n    call InfosPrivsSet(cuser, chost, granted_ie, false);\n    delete from users_in_group where User = cuser and Host = chost;\n    set i := i - 1;\n  end while;\nEND'
sql_modes=1344274432
definers='root@%'
client_cs_names='cp866'
connection_cl_names='cp866_general_ci'
db_cl_names='cp1251_general_ci'
