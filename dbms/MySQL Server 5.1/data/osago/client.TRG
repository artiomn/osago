TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `client_ins` AFTER INSERT ON `client`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'client\', NEW.ID_CLIENT, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `client_upd` AFTER UPDATE ON `client`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'client\', NEW.ID_CLIENT, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `client_del` AFTER DELETE ON `client`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'client\', OLD.ID_CLIENT, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
