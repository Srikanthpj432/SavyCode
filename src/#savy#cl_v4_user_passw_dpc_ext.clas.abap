class /SAVY/CL_V4_USER_PASSW_DPC_EXT definition
  public
  inheriting from /SAVY/CL_V4_USER_PASSW_DPC
  create public .

public section.

  methods /IWBEP/IF_V4_DP_ADVANCED~CREATE_ENTITY
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_PASSW_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_v4_dp_advanced~create_entity.

    DATA: ls_pass      TYPE /savy/cl_v4_user_passw_mpc=>ts_usernewpassword,
          ls_pwd       TYPE bapipwd,
          ls_pwdx      TYPE bapipwdx,
          lv_username  TYPE bapibname-bapibname,
          lt_return    TYPE TABLE OF bapiret2,
          lr_applog    TYPE REF TO /savy/cl_app_log,
          lv_msgtext   TYPE string,
          lx_exception TYPE REF TO cx_root,
          ls_mesg      TYPE bal_s_msg,
          ls_done_list TYPE /iwbep/if_v4_requ_adv_create=>ty_s_todo_process_list,
          lt_message   TYPE /iwbep/if_v4_runtime_types=>ty_t_message,
          ls_message   TYPE /iwbep/if_v4_runtime_types=>ty_s_message.

    CONSTANTS: lc_subrc_success TYPE sy-subrc VALUE 0,
               lc_user_unlocked TYPE usr02-uflag VALUE '0',
               lc_msgid         TYPE symsgid VALUE '/SAVY/MESSAGES'.

    "-----------------------------------------------------------------
    " Step 1: Initialize Application Log
    "-----------------------------------------------------------------
    TRY.
        CREATE OBJECT lr_applog.

        IF 1 = 2. MESSAGE i001(/savy/messages). ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '001'.
        lr_applog->msg_add_log( im_msg = ls_mesg ).

      CATCH cx_sy_create_object_error INTO lx_exception.
        " Technical - App log creation failed
        RAISE EXCEPTION TYPE /iwbep/cx_v4_runtime
          EXPORTING
            http_status_code = '500'
            previous         = lx_exception.
    ENDTRY.

    "-----------------------------------------------------------------
    " Step 2: Get Message Container
    "-----------------------------------------------------------------
    TRY.
        DATA(lo_msg) = io_response->get_message_container( ).

        IF 1 = 2. MESSAGE i003(/savy/messages). ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '003'.
        lr_applog->msg_add_log( im_msg = ls_mesg ).

      CATCH cx_root INTO lx_exception.
        lv_msgtext = lx_exception->get_text( ).

        IF 1 = 2. MESSAGE i004(/savy/messages). ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'E'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '004'.
        ls_mesg-msgv1 = lv_msgtext.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
        lr_applog->save_to_db( ).
        COMMIT WORK AND WAIT.

        " Add custom message to message container
        CLEAR ls_message.
        ls_message-class      = lc_msgid.
        ls_message-number     = '004'.      " ← Your custom message number
        ls_message-variable_1 = sy-uname.
        ls_message-severity   = 3.          " 1=Info 2=Warning 3=Error
        APPEND ls_message TO lt_message.

        " Set message in response before raising exception
        io_response->set_header_messages( it_message = lt_message ).

        " Technical - Cannot get message container
        RAISE EXCEPTION TYPE /iwbep/cx_v4_runtime
          EXPORTING
            http_status_code = '500'
            previous         = lx_exception.
    ENDTRY.

    "-----------------------------------------------------------------
    " Step 3: Authorization Check
    "-----------------------------------------------------------------
    AUTHORITY-CHECK OBJECT '/SAVY/USER'
      ID '/SAVY/USER' FIELD sy-uname
      ID 'ACTVT'      FIELD '01'.

    IF sy-subrc <> 0.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = lc_msgid.
      ls_mesg-msgno = '053'.
      ls_mesg-msgv1 = sy-uname.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
      lr_applog->save_to_db( ).
      COMMIT WORK AND WAIT.

      " Add custom message to message container
      CLEAR ls_message.
      ls_message-class      = lc_msgid.
      ls_message-number     = '053'.      " ← Your custom message number
      ls_message-variable_1 = sy-uname.
      ls_message-severity   = 3.          " 1=Info 2=Warning 3=Error
      APPEND ls_message TO lt_message.

      " Set message in response before raising exception
      io_response->set_header_messages( it_message = lt_message ).

      " 403 Forbidden - No authorization
      RAISE EXCEPTION TYPE /iwbep/cx_v4_access_check
        EXPORTING
          http_status_code = '403'.
    ENDIF.

    "-----------------------------------------------------------------
    " Step 4:  Read Request Business Data
    "-----------------------------------------------------------------
    TRY.
        io_request->get_busi_data(
          IMPORTING
            es_busi_data = ls_pass ).

        lv_username = ls_pass-username.
        TRANSLATE lv_username TO UPPER CASE.
        ls_pass-version = /savy/cl_app_log=>gv_version.

        IF 1 = 2. MESSAGE i046(/savy/messages). ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '046'.
        ls_mesg-msgv1 = ls_pass-username.
        lr_applog->msg_add_log( im_msg = ls_mesg ).

      CATCH cx_root INTO lx_exception.
        lv_msgtext = lx_exception->get_text( ).
        CLEAR ls_mesg.
        ls_mesg-msgty = 'E'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '006'.
        ls_mesg-msgv1 = lv_msgtext.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
        lr_applog->save_to_db( ).
        COMMIT WORK AND WAIT.

        " Add custom message to message container
        CLEAR ls_message.
        ls_message-class      = lc_msgid.
        ls_message-number     = '006'.      " ← Your custom message number
        ls_message-variable_1 = lv_username.
        ls_message-severity   = 3.          " 1=Info 2=Warning 3=Error
        APPEND ls_message TO lt_message.

        " Set message in response before raising exception
        io_response->set_header_messages( it_message = lt_message ).

        " 400 Bad Request - Cannot read input
        RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
          EXPORTING
            http_status_code = '400'
            previous         = lx_exception.
    ENDTRY.

    "-----------------------------------------------------------------
    " Step 5: Input Validation
    "-----------------------------------------------------------------
    IF lv_username IS INITIAL.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = lc_msgid.
      ls_mesg-msgno = '008'.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
      lr_applog->save_to_db( ).
      COMMIT WORK AND WAIT.

      " Add custom message to message container
      CLEAR ls_message.
      ls_message-class      = lc_msgid.
      ls_message-number     = '008'.      " ← Your custom message number
      ls_message-variable_1 = lv_username.
      ls_message-severity   = 3.          " 1=Info 2=Warning 3=Error
      APPEND ls_message TO lt_message.

      " Set message in response before raising exception
      io_response->set_header_messages( it_message = lt_message ).

      " 400 Bad Request - Username empty
      RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
        EXPORTING
          http_status_code = '400'.
    ENDIF.
    "-----------------------------------------------------------------
    " Step 6: Check if user exists and is unlocked
    "-----------------------------------------------------------------
    TRY.
        SELECT SINGLE @abap_true
          FROM usr02
          WHERE bname = @lv_username
            AND uflag = @lc_user_unlocked
          INTO @DATA(lv_user_exists).

        IF sy-subrc <> lc_subrc_success.
          CLEAR ls_mesg.
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = lc_msgid.
          ls_mesg-msgno = '021'.
          ls_mesg-msgv1 = lv_username.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
          lr_applog->save_to_db( ).
          COMMIT WORK AND WAIT.

          " Add custom message to message container
          CLEAR ls_message.
          ls_message-class      = lc_msgid.
          ls_message-number     = '021'.      " ← Your custom message number
          ls_message-variable_1 = lv_username.
          ls_message-severity   = 3.          " 1=Info 2=Warning 3=Error
          APPEND ls_message TO lt_message.

          " Set message in response before raising exception
          io_response->set_header_messages( it_message = lt_message ).

          " 400 Bad Request - User already exists
          RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
            EXPORTING
              http_status_code = '400'.
        ENDIF.

        CLEAR ls_mesg.
        ls_mesg-msgty = 'S'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '010'.
        ls_mesg-msgv1 = lv_username.
        lr_applog->msg_add_log( im_msg = ls_mesg ).

      CATCH cx_sy_open_sql_db INTO lx_exception.
        lv_msgtext = lx_exception->get_text( ).
        CLEAR ls_mesg.
        ls_mesg-msgty = 'E'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '011'.
        ls_mesg-msgv1 = lv_username.
        ls_mesg-msgv2 = lv_msgtext.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
        lr_applog->save_to_db( ).
        COMMIT WORK AND WAIT.

        " Add custom message to message container
        CLEAR ls_message.
        ls_message-class      = lc_msgid.
        ls_message-number     = '011'.      " ← Your custom message number
        ls_message-variable_1 = lv_username.
        ls_message-severity   = 3.          " 1=Info 2=Warning 3=Error
        APPEND ls_message TO lt_message.

        " Set message in response before raising exception
        io_response->set_header_messages( it_message = lt_message ).

        " 500 Internal - Database error
        RAISE EXCEPTION TYPE /iwbep/cx_v4_runtime
          EXPORTING
            http_status_code = '500'
            previous         = lx_exception.
    ENDTRY.
    "-----------------------------------------------------------------
    " Step 7:  Prepare password structures
    "-----------------------------------------------------------------
    ls_pwd-bapipwd  = ls_pass-newpassword.
    ls_pwdx-bapipwd = abap_true.

    CLEAR ls_mesg.
    ls_mesg-msgty = 'I'.
    ls_mesg-msgid = lc_msgid.
    ls_mesg-msgno = '047'.
    ls_mesg-msgv1 = lv_username.
    lr_applog->msg_add_log( im_msg = ls_mesg ).

    "-----------------------------------------------------------------
    " Step 9: Call BAPI_USER_CHANGE - Reset Password
    "-----------------------------------------------------------------
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
          ls_mesg-msgty = <fs_ret>-type.
          ls_mesg-msgid = <fs_ret>-id.
          ls_mesg-msgno = <fs_ret>-number.
          ls_mesg-msgv1 = <fs_ret>-message.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDLOOP.

      CATCH cx_root INTO lx_exception.
        lv_msgtext = lx_exception->get_text( ).
        CLEAR ls_mesg.
        ls_mesg-msgty = 'E'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '029'.
        ls_mesg-msgv1 = lv_username.
        ls_mesg-msgv2 = lv_msgtext.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
        lr_applog->save_to_db( ).
        COMMIT WORK AND WAIT.

        " Add custom message to message container
        CLEAR ls_message.
        ls_message-class      = lc_msgid.
        ls_message-number     = '029'.      " ← Your custom message number
        ls_message-variable_1 = lv_username.
        ls_message-severity   = 3.          " 1=Info 2=Warning 3=Error
        APPEND ls_message TO lt_message.

        " Set message in response before raising exception
        io_response->set_header_messages( it_message = lt_message ).

        " 500 Internal - BAPI technical failure
        RAISE EXCEPTION TYPE /iwbep/cx_v4_runtime
          EXPORTING
            http_status_code = '500'
            previous         = lx_exception.
    ENDTRY.

    "-----------------------------------------------------------------
    " Step 10: Check BAPI Return for Errors
    "-----------------------------------------------------------------
    DATA(lv_has_error) = abap_false.

    READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
    IF sy-subrc = 0. lv_has_error = abap_true. ENDIF.

    READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'A'.
    IF sy-subrc = 0. lv_has_error = abap_true. ENDIF.

    IF lv_has_error = abap_true.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      " Get first error message from BAPI return
      READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_err>)
        WITH KEY type = 'E'.
      IF sy-subrc <> 0.
        READ TABLE lt_return ASSIGNING <fs_err>
          WITH KEY type = 'A'.
      ENDIF.

      CLEAR ls_mesg.
      ls_mesg-msgty = <fs_err>-type.
      ls_mesg-msgid = <fs_err>-id.
      ls_mesg-msgno = <fs_err>-number.
      ls_mesg-msgv1 = lv_username.
      ls_mesg-msgv2 = COND #( WHEN sy-subrc = 0
                               THEN <fs_err>-message
                               ELSE 'Check BAPI return messages' ).
      lr_applog->msg_add_log( im_msg = ls_mesg ).
      lr_applog->save_to_db( ).
      COMMIT WORK AND WAIT.

      " Add custom message to message container
      CLEAR ls_message.
      ls_message-class      = <fs_err>-id.
      ls_message-number     = <fs_err>-number.      " ← Your custom message number
      ls_message-variable_1 = lv_username.
      ls_message-severity   = 3.          " 1=Info 2=Warning 3=Error
      APPEND ls_message TO lt_message.

      " Set message in response before raising exception
      io_response->set_header_messages( it_message = lt_message ).

      " 400 Bad Request - BAPI business validation failed
      RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
        EXPORTING
          http_status_code = '400'.
    ENDIF.

    "-----------------------------------------------------------------
    " Step 11: Commit Transaction
    "-----------------------------------------------------------------
    TRY.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

        CLEAR ls_mesg.
        ls_mesg-msgty = 'S'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '049'.
        ls_mesg-msgv1 = lv_username.
        lr_applog->msg_add_log( im_msg = ls_mesg ).

      CATCH cx_root INTO lx_exception.
        lv_msgtext = lx_exception->get_text( ).
        CLEAR ls_mesg.
        ls_mesg-msgty = 'E'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '019'.
        ls_mesg-msgv1 = lv_username.
        ls_mesg-msgv2 = lv_msgtext.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
        lr_applog->save_to_db( ).
        COMMIT WORK AND WAIT.

        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        " Add custom message to message container
        CLEAR ls_message.
        ls_message-class      = lc_msgid.
        ls_message-number     = '019'.      " ← Your custom message number
        ls_message-variable_1 = lv_username.
        ls_message-severity   = 3.          " 1=Info 2=Warning 3=Error
        APPEND ls_message TO lt_message.

        " Set message in response before raising exception
        io_response->set_header_messages( it_message = lt_message ).

        " 500 Internal - Commit failed
        RAISE EXCEPTION TYPE /iwbep/cx_v4_runtime
          EXPORTING
            http_status_code = '500'
            previous         = lx_exception.
    ENDTRY.

    "-----------------------------------------------------------------
    " Step 12: Build Success Response
    "-----------------------------------------------------------------
    ls_message-class      = lc_msgid.
    ls_message-number     = '049'.
    ls_message-variable_1 = lv_username.
    ls_message-severity   = 1.
    APPEND ls_message TO lt_message.

    io_response->set_header_messages( it_message = lt_message ).

    io_response->set_busi_data( ls_pass ).

    " Save final application log
    lr_applog->save_to_db( ).
    COMMIT WORK AND WAIT.

    ls_done_list-busi_data         = abap_true.
    ls_done_list-deep_busi_data    = abap_true.
    ls_done_list-partial_busi_data = abap_true.
    io_response->set_is_done( is_todo_list = ls_done_list ).

  ENDMETHOD.
ENDCLASS.
