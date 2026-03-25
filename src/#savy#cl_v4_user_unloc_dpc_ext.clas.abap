class /SAVY/CL_V4_USER_UNLOC_DPC_EXT definition
  public
  inheriting from /SAVY/CL_V4_USER_UNLOC_DPC
  create public .

public section.

  methods /IWBEP/IF_V4_DP_ADVANCED~EXECUTE_ACTION
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_UNLOC_DPC_EXT IMPLEMENTATION.


  method /IWBEP/IF_V4_DP_ADVANCED~EXECUTE_ACTION.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_V4_DP_ADVANCED~EXECUTE_ACTION
*  EXPORTING
*    IO_REQUEST  =
*    IO_RESPONSE =
*    .
**  CATCH /iwbep/cx_gateway.
**ENDTRY.


    DATA lv_action TYPE c LENGTH 30.
    io_request->get_action( IMPORTING ev_action_name = lv_action ).

    CASE lv_action.
      WHEN 'UserUnlock'.

        DATA: lv_username    TYPE bapibname-bapibname,
              lt_return      TYPE TABLE OF bapiret2,
              ls_result      TYPE /savy/cl_user_unlock_mpc=>ts_statusresult,
              lr_applog      TYPE REF TO /savy/cl_app_log,
              lv_msgtext     TYPE string,
              lx_exception   TYPE REF TO cx_root,
              lv_user_exists TYPE c LENGTH 1,
              ls_mesg        TYPE bal_s_msg.

        DATA: BEGIN OF ls_param.
                INCLUDE TYPE /savy/cl_user_unlock_mpc=>ts_userunlock.
        DATA: END OF ls_param.

        CONSTANTS: lc_subrc_success TYPE sy-subrc VALUE 0.

        " Initialize application log
        TRY.
            CREATE OBJECT lr_applog.
            CLEAR ls_mesg.
            ls_mesg-msgty = 'I'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '001'.
            IF lr_applog IS BOUND.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDIF.
          CATCH cx_sy_create_object_error.
            MESSAGE i002(/savy/messages).
            RETURN.
        ENDTRY.

        " Read request parameters
        TRY.
            io_request->get_parameter_data(
              IMPORTING
                es_parameter_data = ls_param ).

            lv_username = ls_param-username.
            TRANSLATE lv_username TO UPPER CASE.

            CLEAR ls_mesg.
            ls_mesg-msgty = 'I'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '042'.
            ls_mesg-msgv1 = lv_username.
            IF lr_applog IS BOUND.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDIF.

          CATCH cx_root INTO lx_exception.
            lv_msgtext = lx_exception->get_text( ).
            CLEAR ls_mesg.
            ls_mesg-msgty = 'E'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '006'.
            ls_mesg-msgv1 = lv_msgtext.
            IF lr_applog IS BOUND.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDIF.
            lr_applog->save_to_db( ).

            RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
              EXPORTING
                http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
        ENDTRY.

        " Check authorization
        AUTHORITY-CHECK OBJECT '/SAVY/USER'
          ID '/SAVY/USER' FIELD lv_username
          ID 'ACTVT'      FIELD '23'.

        IF sy-subrc <> 0.
          RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
            EXPORTING
              http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-forbidden.
        ENDIF.

        " Input validation
        IF lv_username IS INITIAL.
          CLEAR ls_mesg.
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '008'.
          IF lr_applog IS BOUND.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
          ENDIF.
          lr_applog->save_to_db( ).

          RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
            EXPORTING
              http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
        ENDIF.

        " Check if user exists (no uflag filter - unlock works on locked users too)
        TRY.
            SELECT SINGLE @abap_true
              FROM usr02
              WHERE bname = @lv_username
              INTO @lv_user_exists.

            IF sy-subrc <> lc_subrc_success.
              CLEAR ls_mesg.
              ls_mesg-msgty = 'E'.
              ls_mesg-msgid = '/SAVY/MESSAGES'.
              ls_mesg-msgno = '021'.
              ls_mesg-msgv1 = lv_username.
              IF lr_applog IS BOUND.
                lr_applog->msg_add_log( im_msg = ls_mesg ).
              ENDIF.
              lr_applog->save_to_db( ).

              RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
                EXPORTING
                  http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
            ENDIF.

            CLEAR ls_mesg.
            ls_mesg-msgty = 'S'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '010'.
            ls_mesg-msgv1 = lv_username.
            IF lr_applog IS BOUND.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDIF.

          CATCH cx_sy_open_sql_db INTO lx_exception.
            lv_msgtext = lx_exception->get_text( ).
            CLEAR ls_mesg.
            ls_mesg-msgty = 'E'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '011'.
            ls_mesg-msgv1 = lv_username.
            ls_mesg-msgv2 = lv_msgtext.
            IF lr_applog IS BOUND.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDIF.
            lr_applog->save_to_db( ).

            RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
              EXPORTING
                http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
        ENDTRY.

        CLEAR ls_mesg.
        ls_mesg-msgty = 'S'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '043'.
        ls_mesg-msgv1 = lv_username.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.

        " Call Unlock BAPI
        TRY.
            CALL FUNCTION 'BAPI_USER_UNLOCK'
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
              IF lr_applog IS BOUND.
                lr_applog->msg_add_log( im_msg = ls_mesg ).
              ENDIF.
            ENDLOOP.

          CATCH cx_root INTO lx_exception.
            lv_msgtext = lx_exception->get_text( ).
            CLEAR ls_mesg.
            ls_mesg-msgty = 'E'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '029'.
            ls_mesg-msgv1 = lv_username.
            ls_mesg-msgv2 = lv_msgtext.
            IF lr_applog IS BOUND.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDIF.
            lr_applog->save_to_db( ).

            RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
              EXPORTING
                http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
        ENDTRY.

        " Check BAPI return for errors
        READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
        IF sy-subrc = 0.
          DATA(lv_has_error) = abap_true.
        ENDIF.

        READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'A'.
        IF sy-subrc = 0.
          lv_has_error = abap_true.
        ENDIF.

        IF lv_has_error = abap_true.
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

          CLEAR ls_mesg.
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '044'.
          ls_mesg-msgv1 = lv_username.
          IF lr_applog IS BOUND.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
          ENDIF.
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

            CLEAR ls_mesg.
            ls_mesg-msgty = 'S'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '045'.
            ls_mesg-msgv1 = lv_username.
            IF lr_applog IS BOUND.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDIF.

          CATCH cx_root INTO lx_exception.
            lv_msgtext = lx_exception->get_text( ).
            CLEAR ls_mesg.
            ls_mesg-msgty = 'E'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '019'.
            ls_mesg-msgv1 = lv_username.
            ls_mesg-msgv2 = lv_msgtext.
            IF lr_applog IS BOUND.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDIF.
            lr_applog->save_to_db( ).

            CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

            RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
              EXPORTING
                http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
        ENDTRY.

        " Build success response
        READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_success>)
          WITH KEY type = 'S'.
        IF sy-subrc = 0.
          ls_result-username = lv_username.
          ls_result-status   = <fs_success>-type.
          ls_result-message  = <fs_success>-message.
        ENDIF.

        " Save application log and set response
        lr_applog->save_to_db( ).

        io_response->set_busi_data( ia_busi_data = ls_result ).

      WHEN OTHERS.
        RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented.

    ENDCASE.


  endmethod.
ENDCLASS.
