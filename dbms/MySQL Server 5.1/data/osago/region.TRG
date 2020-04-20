TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `region_ins` AFTER INSERT ON `region`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'region\', NEW.ID_REGION, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `region_upd` AFTER UPDATE ON `region`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'region\', NEW.ID_REGION, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `region_del` AFTER DELETE ON `region`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'region\', OLD.ID_REGION, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
