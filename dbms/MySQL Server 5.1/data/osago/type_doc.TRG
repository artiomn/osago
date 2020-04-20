TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`%` TRIGGER `type_doc_ins` AFTER INSERT ON `type_doc`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'type_doc\', NEW.ID_TYPE_DOC, \'i\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `type_doc_upd` AFTER UPDATE ON `type_doc`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'type_doc\', NEW.ID_TYPE_DOC, \'u\');\nEND' 'CREATE DEFINER=`root`@`%` TRIGGER `type_doc_del` AFTER DELETE ON `type_doc`\nFOR EACH ROW\nBEGIN\n  call FixTableChange(\'type_doc\', OLD.ID_TYPE_DOC, \'d\');\nEND'
sql_modes=1344274432 1344274432 1344274432
definers='root@%' 'root@%' 'root@%'
client_cs_names='cp866' 'cp866' 'cp866'
connection_cl_names='cp866_general_ci' 'cp866_general_ci' 'cp866_general_ci'
db_cl_names='cp1251_general_ci' 'cp1251_general_ci' 'cp1251_general_ci'
