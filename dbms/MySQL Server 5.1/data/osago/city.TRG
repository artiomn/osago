TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `city_ins` AFTER INSERT ON `city`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'city\', NEW.ID_CITY, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `city_upd` AFTER UPDATE ON `city`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'city\', NEW.ID_CITY, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `city_del` AFTER DELETE ON `city`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'city\', OLD.ID_CITY, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
