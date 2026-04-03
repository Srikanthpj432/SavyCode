class /SAVY/CL_V4_USER_LOCK_DPC_EXT definition
  public
  inheriting from /SAVY/CL_V4_USER_LOCK_DPC
  create public .

public section.

  methods /IWBEP/IF_V4_DP_BASIC~EXECUTE_ACTION
    redefinition .
protected section.
  PRIVATE SECTION.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_LOCK_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_v4_dp_basic~execute_action.

    DATA: BEGIN OF ls_param,
            username TYPE c LENGTH 12,
          END OF ls_param.

    DATA: lv_username     TYPE bapibname-bapibname,
          lt_return       TYPE TABLE OF bapiret2,
          ls_result       TYPE /savy/cl_v4_user_lock_mpc=>ts_statusresult,
          lr_applog       TYPE REF TO /savy/cl_app_log,
          lv_msgtext      TYPE string,
          lv_char50       TYPE char50,
          lv_char50_2     TYPE char50,
          lx_exception    TYPE REF TO cx_root,
          lv_user_exists  TYPE c LENGTH 1,
          ls_mesg         TYPE bal_s_msg,
          lt_message      TYPE /iwbep/if_v4_runtime_types=>ty_t_message,
          ls_message      TYPE /iwbep/if_v4_runtime_types=>ty_s_message,
          ls_done_list    TYPE /iwbep/if_v4_requ_basic_action=>ty_s_todo_process_list,
          lo_request_info TYPE REF TO /iwbep/cl_v4_request_info_pro,
          lv_action       TYPE c LENGTH 30.

    CONSTANTS: lc_subrc_success TYPE sy-subrc VALUE 0,
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
      ID 'ACTVT'      FIELD '05'.

    IF sy-subrc <> 0.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = lc_msgid.
      ls_mesg-msgno = '052'.
      ls_mesg-msgv1 = sy-uname.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
      lr_applog->save_to_db( ).
      COMMIT WORK AND WAIT.

      lv_char50 = sy-uname.
      lo_msg->add_t100( iv_msg_type = 'E'
                        iv_msg_id   = lc_msgid
                        iv_msg_number = '052'
                        iv_msg_v1     = lv_Char50 ).

      " 403 Forbidden - No authorization
      RAISE EXCEPTION TYPE /iwbep/cx_v4_access_check
        EXPORTING
          http_status_code  = '403'
          message_container = lo_msg.
    ENDIF.

    "-----------------------------------------------------------------
    " Step 4: Get Action - Read request parameters
    "-----------------------------------------------------------------
    io_request->get_action( IMPORTING ev_action_name = lv_action ).

    CASE lv_action.
      WHEN 'USERLOCK'.

        TRY.
            io_request->get_parameter_data(
              IMPORTING
                es_parameter_data = ls_param ).

            lv_username = ls_param-username.
            TRANSLATE lv_username TO UPPER CASE.

            CLEAR ls_mesg.
            ls_mesg-msgty = 'I'.
            ls_mesg-msgid = lc_msgid.
            ls_mesg-msgno = '038'.
            ls_mesg-msgv1 = ls_param-username.
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

            lv_char50 = lv_msgtext.
            lo_msg->add_t100( iv_msg_type = 'E'
                              iv_msg_id   = lc_msgid
                              iv_msg_number = '006'
                              iv_msg_v1     = lv_Char50 ).

            " 400 Bad Request - Cannot read input
            RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
              EXPORTING
                http_status_code  = '400'
                message_container = lo_msg
                previous          = lx_exception.
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

          lo_msg->add_t100( iv_msg_type = 'E'
                            iv_msg_id   = lc_msgid
                            iv_msg_number = '052'
                            iv_msg_v1     = lv_Char50 ).

          " 400 Bad Request - Username empty
          RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
            EXPORTING
              http_status_code  = '400'
              message_container = lo_msg.
        ENDIF.

        " Check if user exists and is unlocked (cannot lock already locked user)
        TRY.
            SELECT SINGLE @abap_true
              FROM usr02
              WHERE bname = @lv_username
              INTO @lv_user_exists.

            IF sy-subrc <> lc_subrc_success.
              CLEAR ls_mesg.
              ls_mesg-msgty = 'E'.
              ls_mesg-msgid = lc_msgid.
              ls_mesg-msgno = '021'.
              ls_mesg-msgv1 = lv_username.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
              lr_applog->save_to_db( ).
              COMMIT WORK AND WAIT.

              lv_Char50  =  lv_username.
              lo_msg->add_t100( iv_msg_type = 'E'
                                iv_msg_id   = lc_msgid
                                iv_msg_number = '021'
                                iv_msg_v1     = lv_Char50 ).

              " 400 Bad Request - User already exists
              RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
                EXPORTING
                  http_status_code  = '400'
                  message_container = lo_msg.
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

            lv_Char50    =  lv_username.
            lv_Char50_2  =  lv_msgtext.
            lo_msg->add_t100( iv_msg_type = 'E'
                              iv_msg_id   = lc_msgid
                              iv_msg_number = '011'
                              iv_msg_v1     = lv_Char50
                              iv_msg_v2     = lv_Char50_2 ).

            " 500 Internal - Database error
            RAISE EXCEPTION TYPE /iwbep/cx_v4_runtime
              EXPORTING
                http_status_code  = '500'
                message_container = lo_msg
                previous          = lx_exception.
        ENDTRY.

        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '039'.
        ls_mesg-msgv1 = lv_username.
        lr_applog->msg_add_log( im_msg = ls_mesg ).

        "-----------------------------------------------------------------
        " Step 9: Call BAPI_USER_LOCK
        "-----------------------------------------------------------------
        TRY.
            CALL FUNCTION 'BAPI_USER_LOCK'
              EXPORTING
                username = lv_username
              TABLES
                return   = lt_return.

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

            lv_Char50    =  lv_username.
            lv_Char50_2  =  lv_msgtext.
            lo_msg->add_t100( iv_msg_type = 'E'
                              iv_msg_id   = lc_msgid
                              iv_msg_number = '029'
                              iv_msg_v1     = lv_Char50
                              iv_msg_v2     = lv_Char50_2 ).

            " 500 Internal - BAPI technical failure
            RAISE EXCEPTION TYPE /iwbep/cx_v4_runtime
              EXPORTING
                http_status_code  = '500'
                message_container = lo_msg
                previous          = lx_exception.
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

          lv_Char50    =  lv_username.
          lv_Char50_2  =  <fs_err>-message.
          lo_msg->add_t100( iv_msg_type = <fs_err>-type
                            iv_msg_id   = <fs_err>-id
                            iv_msg_number = <fs_err>-number
                            iv_msg_v1     = lv_Char50
                            iv_msg_v2     = lv_Char50_2 ).

          " 400 Bad Request - BAPI business validation failed
          RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
            EXPORTING
              http_status_code  = '400'
              message_container = lo_msg.
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
            ls_mesg-msgno = '041'.
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

            lv_Char50    =  lv_username.
            lv_Char50_2  =  lv_msgtext.
            lo_msg->add_t100( iv_msg_type = 'E'
                              iv_msg_id   = lc_msgid
                              iv_msg_number = '019'
                              iv_msg_v1     = lv_Char50
                              iv_msg_v2     = lv_Char50_2 ).

            " 500 Internal - Commit failed
            RAISE EXCEPTION TYPE /iwbep/cx_v4_runtime
              EXPORTING
                http_status_code  = '500'
                previous          = lx_exception
                message_container = lo_msg.
        ENDTRY.

        "-----------------------------------------------------------------
        " Step 12: Build Success Response
        "-----------------------------------------------------------------
        READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_success>)
          WITH KEY type = 'S'.
        IF sy-subrc = 0.
          ls_result-username = lv_username.
          ls_result-status   = <fs_success>-type.
          ls_result-message  = <fs_success>-message.
        ENDIF.

        io_response->set_busi_data( ls_result ).

        " Save final application log
        lr_applog->save_to_db( ).
        COMMIT WORK AND WAIT.

        ls_done_list-action_import     = abap_true.
        ls_done_list-key_data          = abap_true.
        ls_done_list-parameter_data    = abap_true.
        ls_done_list-partial_busi_data = abap_true.
        io_response->set_is_done( is_todo_list = ls_done_list ).

      WHEN OTHERS.
        RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented.

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
