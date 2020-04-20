TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `sex_ins` AFTER INSERT ON `sex`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'sex\', NEW.ID_SEX, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `sex_upd` AFTER UPDATE ON `sex`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'sex\', NEW.ID_SEX, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `sex_del` AFTER DELETE ON `sex`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'sex\', OLD.ID_SEX, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
