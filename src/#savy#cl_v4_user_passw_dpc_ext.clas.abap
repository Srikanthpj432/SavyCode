class /SAVY/CL_V4_USER_PASSW_DPC_EXT definition
  public
  inheriting from /SAVY/CL_V4_USER_PASSW_DPC
  create public .

public section.

  methods /IWBEP/IF_V4_DP_ADVANCED~UPDATE_ENTITY
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_PASSW_DPC_EXT IMPLEMENTATION.


  method /IWBEP/IF_V4_DP_ADVANCED~UPDATE_ENTITY.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_V4_DP_ADVANCED~UPDATE_ENTITY
*  EXPORTING
*    IO_REQUEST  =
*    IO_RESPONSE =
*    .
**  CATCH /iwbep/cx_gateway.
**ENDTRY.


  DATA ls_pass        TYPE /savy/cl_user_password_mpc=>ts_usernewpassword.
  DATA ls_pwd         TYPE bapipwd.
  DATA ls_pwdx        TYPE bapipwdx.
  DATA lv_username    TYPE bapibname-bapibname.
  DATA lt_return      TYPE TABLE OF bapiret2.
  DATA lr_applog      TYPE REF TO /savy/cl_app_log.
  DATA lv_msgtext     TYPE string.
  DATA lx_exception   TYPE REF TO cx_root.
  DATA ls_mesg        TYPE bal_s_msg.

  CONSTANTS: lc_subrc_success TYPE sy-subrc VALUE 0,
             lc_user_unlocked TYPE usr02-uflag VALUE '0'.

  " Initialize application log
  TRY.
      CREATE OBJECT lr_applog.
      ls_mesg-msgty = 'I'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '001'.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
    CATCH cx_sy_create_object_error.
      MESSAGE i002(/savy/messages).
      RETURN.
  ENDTRY.

  " Check authorization
  AUTHORITY-CHECK OBJECT '/SAVY/USER'
    ID '/SAVY/USER' FIELD sy-uname
    ID 'ACTVT'      FIELD '01'.

  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
      EXPORTING
        http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-forbidden.
  ENDIF.

  " Read request body
  TRY.
      io_request->get_busi_data(
        IMPORTING
          es_busi_data = ls_pass ).

      lv_username = ls_pass-username.
      TRANSLATE lv_username TO UPPER CASE.

      ls_mesg-msgty = 'I'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '046'.
      ls_mesg-msgv1 = lv_username.
      lr_applog->msg_add_log( im_msg = ls_mesg ).

    CATCH cx_root INTO lx_exception.
      lv_msgtext = lx_exception->get_text( ).
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '006'.
      ls_mesg-msgv1 = lv_msgtext.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
      lr_applog->save_to_db( ).

      RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
        EXPORTING
          http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
  ENDTRY.

  ls_pass-version = /savy/cl_app_log=>gv_version.

  ls_mesg-msgty = 'I'.
  ls_mesg-msgid = '/SAVY/MESSAGES'.
  ls_mesg-msgno = '007'.
  ls_mesg-msgv1 = ls_pass-version.
  lr_applog->msg_add_log( im_msg = ls_mesg ).

  " Input validation
  IF lv_username IS INITIAL.
    ls_mesg-msgty = 'E'.
    ls_mesg-msgid = '/SAVY/MESSAGES'.
    ls_mesg-msgno = '008'.
    lr_applog->msg_add_log( im_msg = ls_mesg ).
    lr_applog->save_to_db( ).

    RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
      EXPORTING
        http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
  ENDIF.

  " Check if user exists and is unlocked
  TRY.
      SELECT SINGLE @abap_true
        FROM usr02
        WHERE bname = @lv_username
          AND uflag = @lc_user_unlocked
        INTO @DATA(lv_user_exists).

      IF sy-subrc <> lc_subrc_success.
        ls_mesg-msgty = 'E'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '021'.
        ls_mesg-msgv1 = lv_username.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
        lr_applog->save_to_db( ).

        RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
          EXPORTING
            http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
      ENDIF.

      ls_mesg-msgty = 'S'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '010'.
      ls_mesg-msgv1 = lv_username.
      lr_applog->msg_add_log( im_msg = ls_mesg ).

    CATCH cx_sy_open_sql_db INTO lx_exception.
      lv_msgtext = lx_exception->get_text( ).
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '011'.
      ls_mesg-msgv1 = lv_username.
      ls_mesg-msgv2 = lv_msgtext.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
      lr_applog->save_to_db( ).

      RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
        EXPORTING
          http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
  ENDTRY.

  " Prepare password structures
  ls_pwd-bapipwd  = ls_pass-newpassword.
  ls_pwdx-bapipwd = abap_true.

  ls_mesg-msgty = 'I'.
  ls_mesg-msgid = '/SAVY/MESSAGES'.
  ls_mesg-msgno = '047'.
  ls_mesg-msgv1 = lv_username.
  lr_applog->msg_add_log( im_msg = ls_mesg ).

  " Reset password via BAPI
  TRY.
      CALL FUNCTION 'BAPI_USER_CHANGE'
        EXPORTING
          username  = lv_username
          password  = ls_pwd
          passwordx = ls_pwdx
        TABLES
          return    = lt_return.

      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_ret>).
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '016'.
        ls_mesg-msgv1 = <fs_ret>-type.
        ls_mesg-msgv2 = <fs_ret>-id.
        ls_mesg-msgv3 = <fs_ret>-number.
        ls_mesg-msgv4 = <fs_ret>-message.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
      ENDLOOP.

    CATCH cx_root INTO lx_exception.
      lv_msgtext = lx_exception->get_text( ).
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '029'.
      ls_mesg-msgv1 = lv_username.
      ls_mesg-msgv2 = lv_msgtext.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
      lr_applog->save_to_db( ).

      RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
        EXPORTING
          http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
  ENDTRY.

  " Check BAPI return for errors
  READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
  DATA(lv_has_error) = COND #( WHEN sy-subrc = 0 THEN abap_true ELSE abap_false ).

  READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'A'.
  IF sy-subrc = 0.
    lv_has_error = abap_true.
  ENDIF.

  IF lv_has_error = abap_true.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ls_mesg-msgty = 'E'.
    ls_mesg-msgid = '/SAVY/MESSAGES'.
    ls_mesg-msgno = '048'.
    ls_mesg-msgv1 = lv_username.
    lr_applog->msg_add_log( im_msg = ls_mesg ).
    lr_applog->save_to_db( ).

    RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
      EXPORTING
        http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
  ENDIF.

  " Commit transaction
  TRY.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      ls_mesg-msgty = 'S'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '049'.
      ls_mesg-msgv1 = lv_username.
      lr_applog->msg_add_log( im_msg = ls_mesg ).

    CATCH cx_root INTO lx_exception.
      lv_msgtext = lx_exception->get_text( ).
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '019'.
      ls_mesg-msgv1 = lv_username.
      ls_mesg-msgv2 = lv_msgtext.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
      lr_applog->save_to_db( ).

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
        EXPORTING
          http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
  ENDTRY.

  " Build success response — mask password
  READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_success>)
    WITH KEY type = 'S'.
  IF sy-subrc = 0.
    ls_pass-status      = <fs_success>-type.
    ls_pass-message     = <fs_success>-message.
    ls_pass-newpassword = TEXT-001.
  ENDIF.

  " Save application log and set response
  lr_applog->save_to_db( ).

  io_response->set_busi_data( is_busi_data = ls_pass ).

  endmethod.
ENDCLASS.
