unit strings_l10n;

//
// ������������ ������.
//

{$I settings.inc}

interface

  resourcestring
    // ����� ������.
    cls_name              = '���';
    cls_surname           = '�������';
    cls_pathronimyc       = '��������';
    cls_inn               = '���';
    cls_series            = '�����';
    cls_number            = '�';
    cls_get_date          = '�����';
    cls_title             = '��������';
    cls_address           = '�����';
    cls_phone             = '�������';
    cls_fax               = '����';
    cls_comment           = '�����������';
    cls_info              = '����������';
    cls_warning           = '��������!';
    cls_error             = '������';
    cls_yes               = '��';
    cls_no                = '���';
    cls_cancel            = '������';
    cls_periods           = '�������';
    cls_sure_q            = '�� ������ ����������?';
    cls_lossdata_q        = '������ ���� ��������!'#13 +
      '��� ��������� ����� ��������.'#13;
    cls_data_commit_q     = '������ � ���� ������ ����� ��������. ' +
      '������� �� ������ "��" �������� ������ � ����.'#13;
    cls_noentity_msg      = '������ � ����� ID �� ����������!';
    cls_data_refresh_q    = '������ ���� �������� ������ �������������.'#13 +
      '�������� ������ (��������� ����� ��������)?';
    cls_setts_svg_err_msg   = '�� ������� ��������� ��������� ������������';
    cls_ticket_svg_err_msg  = '�� ������� ��������� ���������';
    // ������� ���� + �������� ���������.
    mw_cal_title            = ' �������� ��������, ������� �';
    mw_reconn_msg           = '���������� ���� ��������. ����������������?';
    //
    contract_mgr_ConView        = ' �������� ���������� � ��������';
    contract_mgr_ConChange      = ' �������������� ��������';
    contract_mgr_ConNew         = ' ���������� ������ ��������';
    contract_mgr_ConProlong     = ' ����������� ��������';
    contract_mgr_ConReplace     = ' ������ ��������';
    contract_mgr_ConSearch      = ' ����� ���������';
    contract_mgr_msg_InsCalcErr = '������ ������� ��������� ������: ';
    contract_mgr_koef_bs        = '������ ������� ������';
    contract_mgr_koef_kt        = '������������ �����������';
    contract_mgr_koef_kbm       = '����������� �����-����� (���)';
    contract_mgr_koef_kvs       = '���';
    contract_mgr_koef_ko        = '��';
    contract_mgr_koef_km        = '��';
    contract_mgr_koef_ks        = '��';
    contract_mgr_koef_kp        = '��';
    contract_mgr_koef_kn        = '��';
    contract_mgr_msg_InputIncor = '����� �����������';
    contract_mgr_msg_db_chg_err = '��������� ������, ��� ������ ��������.'#13 +
      '���������� ������ �� �����������.';
    contract_mgr_msg_bl_sel_err = '�� ������� ������� �����!';
    contract_mgr_msg_bl_err     = '�� ������ �����';
    contract_mgr_msg_car_err    = '�� ������� ������������ ��������';
    contract_mgr_msg_ph_err     = '�� ������ ������������';
    contract_mgr_msg_drvs_err   = '�� ������� ��������';
    contract_mgr_msg_kbm_err    = '����� ����������� ���������� �����������';
    contract_mgr_nm_KWT         = ' ���';
    contract_mgr_nm_HP          = ' �.�.';
    contract_mgr_msg_cclosed    = '������� ��� ������';
    contract_mgr_no_nums_msg    = '������ �� �� ���� �������.'#13;
    contract_mgr_prev_prem      = '������ �� ����������� ��������: ';
    // �������� ��.
    car_mgr_CarView             = ' �������� ���������� � ��';
    car_mgr_CarChange           = ' �������������� ���������� � ��';
    car_mgr_CarNew              = ' ���������� ������ ��';
    car_mgr_CarSearch           = ' ����� ������������ �������';
    car_mgr_no_owner_err        = '�� ������ �������� ������������� ��������';
    car_mgr_msg_db_chg_err      = '��������� ������, ��� ������ ���������� ' +
      '� ������������ ��������.'#13'���������� ������ �� �����������.';
    // �������� ��������.
    cln_mgr_ClientView          = ' �������� ���������� � �������';
    cln_mgr_ClientChange        = ' �������������� ���������� � �������';
    cln_mgr_ClientNew           = ' ���������� ������ �������';
    cln_mgr_ClientSearch        = ' ����� ��������';
    cln_mgr_BirthDate           = '���� ��������:';
    cln_mgr_RegDate             = '���� �����������:';
    cln_mgr_msg_db_chg_err      = '��������� ������, ��� ������ ���������� ' +
      '� �������.'#13'���������� ������ �� �����������.';
    cln_mgr_msg_no_phone        = '�� ���� ������� �� ������ �������� ��� ' +
      '�������.'#13;
    // �������� ������������.
    info_mgr_tblnm_cntrs    = '������';
    info_mgr_tblnm_rgns     = '�������';
    info_mgr_tblnm_cities   = '������';
    info_mgr_tblnm_csgrp    = '������ �������������';
    info_mgr_tblnm_tkoef    = '��������������� �����������';
    info_mgr_tblnm_icmps    = '��������� ��������';
    info_mgr_tblnm_socst    = '���������� ������';
    info_mgr_tblnm_famst    = '�������� ���������';
    info_mgr_tblnm_clntp    = '���� ��������';
    info_mgr_tblnm_lictp    = '��� ������������� ��������';
    info_mgr_tblnm_carmk    = '����� ��';
    info_mgr_tblnm_carml    = '������ ��';
    info_mgr_tblnm_cartp    = '���� ��';
    info_mgr_tblnm_usetg    = '���� ������������� ��';
    info_mgr_tblnm_basesum  = '������� ������';
    info_mgr_tblnm_ckbm     = '����� ����������� (���)';
    info_mgr_tblnm_ckvs     = '����������� ���';
    info_mgr_tblnm_ckm      = '����������� ��';
    info_mgr_tblnm_cko      = '����������� ��';
    info_mgr_tblnm_ckp      = '����������� ��';
    info_mgr_tblnm_cks      = '����������� ��';
    info_mgr_tblnm_ckt      = '����������� ��';
    info_mgr_tblnm_cfrng    = '������������ ��� �����������';
    info_mgr_tblnm_cother   = '������ ������������';
    info_mgr_tblnm_iform    = '��������� �������';
    info_mgr_tblnm_formc    = '������� ���������� ������';
    // �������� �������������.
    user_mgr_UserChange     = ' �������������� ���������� � ������������';
    user_mgr_UserNew        = ' ���������� ������ ������������';
    user_mgr_UserView       = ' �������� ������ ������������';
    user_mgr_UserSearch     = ' ����� �������������';
    user_mgr_msg_db_chg_err = '��������� ������, ��� ������ ���������� ' +
      '� ������������.'#13'���������� ������ �� �����������.';
    user_mgr_del_confirm    = '�������� ������������ "%s" ����������.'#13;
    user_mgr_del_err        = '������������ �� ������� �������.';
    user_mgr_msg_it_psw_err = '������ �� ���������!';
    // ���� ������ �������.
    cont_input_err_range    = '����������� ����� ������� ������� �� ' +
      '���������� �������!';
    cont_input_err_input    = '�� ������� ������ ������';
    // ����� ������� ������.
    blank_sel_inscmp_hdr    = '�������� ';

    // ������ �������.
    rep_new_blank_msg   = '����� �� ��� ������.'#13 +
      '����� ������ ����� �����.';
    rep_new_ps_blank_msg   = '����� ������ �� ��� ������.'#13 +
      '����� ������ ����� �����.';
    rep_new_rt_blank_msg   = '����� ��������� �� ��� ������.'#13 +
      '����� ������ ����� �����.';
    rep_export_err         = '�� ����� �������� ��������� ������.';
    // ������ ��������� ������.
    insp_calc_err_nocomma  = '��������� ������� � ������� %d';
    insp_calc_err_nolbrkt  = '��������� "(" � ������� %d';
    insp_calc_err_norbrkt  = '��������� ")" � ������� %d';
    insp_calc_err_nolexpr  = '��������� ��������� � ������� %d';
    insp_calc_err_symbol   = '����������� ������ "%s" � ������� %d';
    insp_calc_err_var      = '���������� "%s" �� ���������';
    insp_calc_err_nofunc   = '������� %s � ������� %d �� ����������.';
    insp_calc_err_argcnt   = '������� %s �������� �������� ����� ����������.';
    insp_calc_err_argmax   =
      '����� ���������� ��������� ��������� ���������� (���. %d).';
    insp_calc_err_ariph    = '�������������� ������.';
    insp_get_car_own_err   = '������� ������� ������ ��������� ��';
    insp_get_ph_err        = '������� ������� ������ ������������';

implementation

uses gettext, translations;

const lng_dir = 'languages';

procedure TranslateResStrings;
var
  Lang, FallbackLang: string;
begin
  // in unit gettext.
  GetLanguageIDs(Lang, FallbackLang);
  TranslateUnitResourceStrings('LCLStrConsts',
    lng_dir + DirectorySeparator + 'lclstrconsts.%s.po', Lang, FallbackLang);
  TranslateUnitResourceStrings('Lr_const',
    lng_dir + DirectorySeparator + 'lr_const.%s.po', Lang, FallbackLang);
  TranslateUnitResourceStrings('strings_l10n',
    lng_dir + DirectorySeparator + 'strings.%s.po', Lang, FallbackLang);
end;

initialization
  TranslateResStrings();

end.
