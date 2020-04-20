TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `blanks_journal_ins` AFTER INSERT ON `blanks_journal`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'blanks_journal\',\n    CONCAT_WS(\';\', NEW.ID_INSURANCE_COMPANY, NEW.DOG_SER, NEW.DOGNUMB), \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `blanks_journal_upd` AFTER UPDATE ON `blanks_journal`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'blanks_journal\',\n    CONCAT_WS(\';\', NEW.ID_INSURANCE_COMPANY, NEW.DOG_SER, NEW.DOGNUMB), \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `blanks_journal_del` AFTER DELETE ON `blanks_journal`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'blanks_journal\',\n    CONCAT_WS(\';\', OLD.ID_INSURANCE_COMPANY, OLD.DOG_SER, OLD.DOGNUMB), \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
