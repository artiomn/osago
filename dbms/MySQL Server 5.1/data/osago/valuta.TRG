TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `valuta_ins` AFTER INSERT ON `valuta`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'valuta\', NEW.ID_VALUTA, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `valuta_upd` AFTER UPDATE ON `valuta`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'valuta\', NEW.ID_VALUTA, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `valuta_del` AFTER DELETE ON `valuta`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'valuta\', OLD.ID_VALUTA, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
