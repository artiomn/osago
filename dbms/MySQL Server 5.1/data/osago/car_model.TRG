TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `car_model_ins` AFTER INSERT ON `car_model`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'carmark\', NEW.ID_CAR_MODEL, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `car_model_upd` AFTER UPDATE ON `car_model`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'carmark\', NEW.ID_CAR_MODEL, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `car_model_del` AFTER DELETE ON `car_model`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'car_model\', OLD.ID_CAR_MODEL, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
