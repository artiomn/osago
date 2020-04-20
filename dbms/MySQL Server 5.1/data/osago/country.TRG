TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `country_ins` AFTER INSERT ON `country`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'country\', NEW.ID_COUNTRY, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `country_upd` AFTER UPDATE ON `country`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'country\', NEW.ID_COUNTRY, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `country_del` AFTER DELETE ON `country`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'country\', OLD.ID_COUNTRY, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
