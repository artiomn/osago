TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `dogovor_history_ins` AFTER INSERT ON `dogovor_history`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'dogovor_history\', NEW.ID_DOGOVOR_HISTORY, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `dogovor_history_upd` AFTER UPDATE ON `dogovor_history`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'dogovor_history\', NEW.ID_DOGOVOR_HISTORY, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `dogovor_history_del` AFTER DELETE ON `dogovor_history`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'dogovor_history\', OLD.ID_DOGOVOR_HISTORY, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
