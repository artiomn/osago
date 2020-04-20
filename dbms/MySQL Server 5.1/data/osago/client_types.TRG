TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `client_types_ins` AFTER INSERT ON `client_types`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'client_types\', NEW.ID_CLIENT_TYPE, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `client_types_upd` AFTER UPDATE ON `client_types`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'client_types\', NEW.ID_CLIENT_TYPE, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `client_types_del` AFTER DELETE ON `client_types`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'client_types\', OLD.ID_CLIENT_TYPE, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
