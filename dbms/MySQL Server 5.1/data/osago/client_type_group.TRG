TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `client_type_group_ins` AFTER INSERT ON `client_type_group`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'client_type_group\', NEW.ID_CLIENT_TYPE_GROUP, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `client_type_group_upd` AFTER UPDATE ON `client_type_group`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'client_type_group\', NEW.ID_CLIENT_TYPE_GROUP, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `client_type_group_del` AFTER DELETE ON `client_type_group`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'client_type_group\', OLD.ID_CLIENT_TYPE_GROUP, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
