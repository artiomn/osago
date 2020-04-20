TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `ins_koefs_kp_ins` AFTER INSERT ON `ins_koefs_kp`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'ins_koefs_kp\', NEW.PERIOD_INS, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `ins_koefs_kp_upd` AFTER UPDATE ON `ins_koefs_kp`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'ins_koefs_kp\', NEW.PERIOD_INS, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `ins_koefs_kp_del` AFTER DELETE ON `ins_koefs_kp`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'ins_koefs_kp\', OLD.PERIOD_INS, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
