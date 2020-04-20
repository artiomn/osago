TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `dogovor_ins` AFTER INSERT ON `dogovor`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'dogovor\', NEW.ID_DOGOVOR, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `dogovor_upd` AFTER UPDATE ON `dogovor`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'dogovor\', NEW.ID_DOGOVOR, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `dogovor_del` AFTER DELETE ON `dogovor`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'dogovor\', OLD.ID_DOGOVOR, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
