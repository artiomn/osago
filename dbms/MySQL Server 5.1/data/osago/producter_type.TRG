TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `producter_type_ins` AFTER INSERT ON `producter_type`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'producter_type\', NEW.ID_PRODUCTER_TYPE, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `producter_type_upd` AFTER UPDATE ON `producter_type`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'producter_type\', NEW.ID_PRODUCTER_TYPE, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `producter_type_del` AFTER DELETE ON `producter_type`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'producter_type\', OLD.ID_PRODUCTER_TYPE, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
