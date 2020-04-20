TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `territory_use_ins` AFTER INSERT ON `territory_use`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'territory_use\', NEW.ID_TERRITORY_USE, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `territory_use_upd` AFTER UPDATE ON `territory_use`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'territory_use\', NEW.ID_TERRITORY_USE, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `territory_use_del` AFTER DELETE ON `territory_use`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'territory_use\', OLD.ID_TERRITORY_USE, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
