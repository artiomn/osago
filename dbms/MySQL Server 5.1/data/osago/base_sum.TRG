TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `base_sum_ins` AFTER INSERT ON `base_sum`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'base_sum\',\n    CONCAT_WS(\';\', NEW.ID_CLIENT_TYPE_GROUP, NEW.ID_CAR_TYPE), \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `base_sum_upd` AFTER UPDATE ON `base_sum`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'base_sum\',\n    CONCAT_WS(\';\', NEW.ID_CLIENT_TYPE_GROUP, NEW.ID_CAR_TYPE), \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `base_sum_del` AFTER DELETE ON `base_sum`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'base_sum\',\n    CONCAT_WS(\';\', OLD.ID_CLIENT_TYPE_GROUP, OLD.ID_CAR_TYPE), \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
