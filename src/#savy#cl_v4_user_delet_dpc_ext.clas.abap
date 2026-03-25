class /SAVY/CL_V4_USER_DELET_DPC_EXT definition
  public
  inheriting from /SAVY/CL_V4_USER_DELET_DPC
  create public .

public section.

  methods /IWBEP/IF_V4_DP_ADVANCED~DELETE_ENTITY
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_DELET_DPC_EXT IMPLEMENTATION.


METHOD /IWBEP/IF_V4_DP_ADVANCED~DELETE_ENTITY.

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
    ID 'ACTVT'      FIELD '06'.

  IF sy-subrc <> 0.
    RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
      EXPORTING
        http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-forbidden.
  ENDIF.

  " Get username from URL key
  TRY.
      DATA ls_key TYPE /SAVY/CL_V4_USER_DELET_MPC=>TS_STATUSRESULT.

      io_request->get_key_data(
        IMPORTING
          es_key_data = ls_key ).

      lv_username = ls_key-username.
      TRANSLATE lv_username TO UPPER CASE.

      ls_mesg-msgty = 'I'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '034'.
      ls_mesg-msgv1 = lv_username.
      lr_applog->msg_add_log( im_msg = ls_mesg ).

    CATCH cx_root INTO lx_exception.
      lr_applog->save_to_db( ).
      RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
        EXPORTING
          http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
  ENDTRY.

  " Check if user exists
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

  ls_mesg-msgty = 'S'.
  ls_mesg-msgid = '/SAVY/MESSAGES'.
  ls_mesg-msgno = '035'.
  ls_mesg-msgv1 = lv_username.
  lr_applog->msg_add_log( im_msg = ls_mesg ).

  " Delete user via BAPI
  TRY.
      CALL FUNCTION 'BAPI_USER_DELETE'
        EXPORTING
          username = lv_username
        TABLES
          return   = lt_return.

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
    ls_mesg-msgno = '036'.
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
      ls_mesg-msgno = '037'.
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

  " Save application log
  lr_applog->save_to_db( ).

ENDMETHOD.
ENDCLASS.
