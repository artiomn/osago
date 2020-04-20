TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `bso_status_ins` AFTER INSERT ON `bso_status`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'bso_status\', NEW.ID_BSO_STATUS, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `bso_status_upd` AFTER UPDATE ON `bso_status`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'bso_status\', NEW.ID_BSO_STATUS, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `bso_status_del` AFTER DELETE ON `bso_status`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'bso_status\', OLD.ID_BSO_STATUS, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
