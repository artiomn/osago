use osago;

set names cp866;

# �� ������ ������.
drop user 'admin'@'%';

/*==============================================================*/
/* Table : user_data                                            */
/*==============================================================*/

# User
# Host
# SURNAME
# NAME
# PATHRONIMYC
# ADDRESS
# HOME_PHONE
# CELL_PHONE
# ID_GROUP
# COMMENTS

call UserAdd(
  'admin',
  '%',
  'readyforuse',
  '�',
  '�������',
  '�',
  NULL,
  NULL,
  '8-123-456-78-91',
  1,
  '�������������'
);
