TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `insurance_class_ins` AFTER INSERT ON `insurance_class`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'insurance_class\', NEW.ID_INSURANCE_CLASS, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `insurance_class_upd` AFTER UPDATE ON `insurance_class`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'insurance_class\', NEW.ID_INSURANCE_CLASS, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `insurance_class_del` AFTER DELETE ON `insurance_class`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'insurance_class\', OLD.ID_INSURANCE_CLASS, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
