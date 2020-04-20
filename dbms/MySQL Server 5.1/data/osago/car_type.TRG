TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `car_type_ins` AFTER INSERT ON `car_type`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'car_type\', NEW.ID_CAR_TYPE, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `car_type_upd` AFTER UPDATE ON `car_type`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'car_type\', NEW.ID_CAR_TYPE, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `car_type_del` AFTER DELETE ON `car_type`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'car_type\', OLD.ID_CAR_TYPE, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
