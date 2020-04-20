TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `ins_koefs_ko_ins` AFTER INSERT ON `ins_koefs_ko`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'ins_koefs_ko\',\n    CONCAT_WS(\';\', NEW.KO_LIMITED, NEW.KO_UNLIM), \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `ins_koefs_ko_upd` AFTER UPDATE ON `ins_koefs_ko`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'ins_koefs_ko\',\n    CONCAT_WS(\';\', NEW.KO_LIMITED, NEW.KO_UNLIM), \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `ins_koefs_ko_del` AFTER DELETE ON `ins_koefs_ko`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'ins_koefs_ko\',\n    CONCAT_WS(\';\', OLD.KO_LIMITED, OLD.KO_UNLIM), \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
