TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `carmark_ins` AFTER INSERT ON `carmark`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'carmark\', NEW.ID_CARMARK, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `carmark_upd` AFTER UPDATE ON `carmark`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'carmark\', NEW.ID_CARMARK, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `carmark_del` AFTER DELETE ON `carmark`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'carmark\', OLD.ID_CARMARK, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
