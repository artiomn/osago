TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `insurance_company_ins` AFTER INSERT ON `insurance_company`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'insurance_company\', NEW.ID_INSURANCE_COMPANY, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `insurance_company_upd` AFTER UPDATE ON `insurance_company`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'insurance_company\', NEW.ID_INSURANCE_COMPANY, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `insurance_company_del` AFTER DELETE ON `insurance_company`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'insurance_company\', OLD.ID_INSURANCE_COMPANY, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
