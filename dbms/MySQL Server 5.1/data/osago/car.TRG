TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `car_ins` AFTER INSERT ON `car`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'car\', NEW.ID_CAR, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `car_upd` AFTER UPDATE ON `car`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'car\', NEW.ID_CAR, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `car_del` AFTER DELETE ON `car`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'car\', OLD.ID_CAR, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
