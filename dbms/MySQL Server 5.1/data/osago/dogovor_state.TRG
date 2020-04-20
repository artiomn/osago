TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `dogovor_state_ins` AFTER INSERT ON `dogovor_state`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'dogovor_state\', NEW.ID_DOGOVOR_STATE, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `dogovor_state_upd` AFTER UPDATE ON `dogovor_state`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'dogovor_state\', NEW.ID_DOGOVOR_STATE, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `dogovor_state_del` AFTER DELETE ON `dogovor_state`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'dogovor_state\', OLD.ID_DOGOVOR_STATE, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
