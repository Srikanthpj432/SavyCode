class /SAVY/CL_USER_DELETE_DPC_EXT definition
  public
  inheriting from /SAVY/CL_USER_DELETE_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_USER_DELETE_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.

    DATA lv_username    TYPE bapibname-bapibname.
    DATA ls_params      TYPE /iwbep/s_mgw_name_value_pair.
    DATA lt_return      TYPE TABLE OF bapiret2.
    DATA ls_return      TYPE bapiret2.
    DATA ls_result      TYPE /savy/cl_user_delete_mpc=>ts_statusresult.
    DATA lo_msg         TYPE REF TO /iwbep/if_message_container.
    DATA lr_applog      TYPE REF TO /savy/cl_app_log.
    DATA lv_msgtext     TYPE string.
    DATA lx_exception   TYPE REF TO cx_root.
    DATA lv_str(255)    TYPE  c.
    DATA lv_user_exists TYPE c LENGTH 1.
    DATA ls_mesg        TYPE bal_s_msg.

    CONSTANTS: lc_subrc_success TYPE sy-subrc VALUE 0,
               lc_user_unlocked TYPE usr02-uflag VALUE '0'.

    "" Create Application Log ""
    TRY.
        CREATE OBJECT lr_applog.
        lr_applog->gv_object    = '/SAVY/ROOT'.
        lr_Applog->gv_subobject = '/SAVY/IAM'.
        IF 1 = 2.
          MESSAGE i001(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '001'.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.
      CATCH cx_sy_create_object_Error.
        MESSAGE i002(/savy/messages).
        RETURN.
    ENDTRY.

    " Get message container once
    TRY.
        lo_msg = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).
        IF 1 = 2.
          MESSAGE i003(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '003'.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.
      CATCH cx_root INTO lx_exception.
        lv_msgtext = lx_exception->get_text( ).
        " Log critical error - cannot proceed without message container
        IF 1 = 2.
          MESSAGE i004(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'E'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '004'.
        ls_mesg-msgv1 = lv_msgtext.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.
        CALL METHOD lr_applog->save_to_db( ).

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_tech_exception=>internal_error
            previous = lx_exception.
    ENDTRY.

    " Check authorization to display user
    AUTHORITY-CHECK OBJECT '/SAVY/USER'
      ID '/SAVY/USER' FIELD sy-uname
      ID 'ACTVT'      FIELD '06'.

    IF sy-subrc <> 0.
      lo_msg->add_message(
      iv_msg_type   = /iwbep/cl_cos_logger=>error
      iv_msg_id     = '/SAVY/MESSAGES'
      iv_msg_number = '051').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = lo_msg.
    ENDIF.

    IF iv_Action_name =  TEXT-001.     "'UserDelete'.
      READ TABLE it_parameter ASSIGNING FIELD-SYMBOL(<fs_para>)
        WITH KEY name = 'Username'.
      IF sy-subrc = 0.
        lv_username = <fs_para>-value.
        TRANSLATE lv_username TO UPPER CASE.
        IF 1 = 2.
          MESSAGE i034(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '034'.
        ls_mesg-msgv1 = lv_username.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.
      ELSE.
        IF 1 = 2.
          MESSAGE i008(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'E'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '008'.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.
        CALL METHOD lr_applog->save_to_db( ).

        lo_msg->add_message(
          iv_msg_type   = /iwbep/cl_cos_logger=>error
          iv_msg_id     = '/SAVY/MESSAGES'
        iv_msg_number = '008' ).

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = lo_msg.
      ENDIF.

      TRY.
          SELECT SINGLE @abap_true
            FROM usr02
            WHERE bname = @lv_username
              AND uflag = @lc_user_unlocked
            INTO @lv_user_exists.

          IF sy-subrc <> lc_subrc_success.

            IF 1 = 2.
              MESSAGE i021(/savy/messages).
            ENDIF.
            CLEAR ls_mesg.
            ls_mesg-msgty = 'E'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '021'.
            ls_mesg-msgv1 = lv_username.
            IF lr_applog IS BOUND.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDIF.
            CALL METHOD lr_applog->save_to_db( ).

            lo_msg->add_message(
              iv_msg_type   = /iwbep/cl_cos_logger=>error
              iv_msg_id     = '/SAVY/MESSAGES'
            iv_msg_number = '021' ).

            RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
              EXPORTING
                message_container = lo_msg.
          ENDIF.

          " Log successful user validation
          IF 1 = 2.
            MESSAGE i010(/savy/messages).
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

          IF 1 = 2.
            MESSAGE i011(/savy/messages).
          ENDIF.
          CLEAR ls_mesg.
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '011'.
          ls_mesg-msgv1 = lv_username.
          ls_mesg-msgv2 = lv_msgtext.
          IF lr_applog IS BOUND.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
          ENDIF.
          CALL METHOD lr_applog->save_to_db( ).

          lo_msg->add_message(
            iv_msg_type = /iwbep/cl_cos_logger=>error
            iv_msg_id     = '/SAVY/MESSAGES'
          iv_msg_number = '011' ).

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = lo_msg.
      ENDTRY.

      IF 1 = 2.
        MESSAGE i035(/savy/messages).
      ENDIF.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'S'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '035'.
      ls_mesg-msgv1 = lv_username.
      IF lr_applog IS BOUND.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
      ENDIF.

      " User Delete via BAPI
      TRY.
          CALL FUNCTION 'BAPI_USER_DELETE'
            EXPORTING
              username = lv_username
            TABLES
              return   = lt_return.

          " Log all BAPI return messages
          LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_ret>).
            IF 1 = 2.
              MESSAGE i016(/savy/messages).
            ENDIF.
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

          IF 1 = 2.
            MESSAGE i029(/savy/messages).
          ENDIF.
          CLEAR ls_mesg.
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '029'.
          ls_mesg-msgv1 = lv_username.
          ls_mesg-msgv2 = lv_msgtext.
          IF lr_applog IS BOUND.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
          ENDIF.
          CALL METHOD lr_applog->save_to_db( ).

          lo_msg->add_message(
            iv_msg_type   = /iwbep/cl_cos_logger=>error
            iv_msg_id     = '/SAVY/MESSAGES'
            iv_msg_number = '029' ).

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = lo_msg.
      ENDTRY.

      " Check for errors or abort messages
      READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'E'.
      IF sy-subrc = 0.
        DATA(lv_has_error) = abap_true.
      ENDIF.

      READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = 'A'.
      IF sy-subrc = 0.
        lv_has_error = abap_true.
      ENDIF.

      IF lv_has_error = abap_true.
        " Rollback on error
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

        IF 1 = 2.
          MESSAGE i036(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'E'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '036'.
        ls_mesg-msgv1 = lv_username.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.
        lr_applog->save_to_db( ).

        " Add first error to message container
        READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_error>)
          WITH KEY type = 'E'.
        IF sy-subrc <> 0.
          READ TABLE lt_return ASSIGNING <fs_error>
            WITH KEY type = 'A'.
        ENDIF.

        IF sy-subrc = 0.
          lo_msg->add_message(
            iv_msg_type   = /iwbep/cl_cos_logger=>error
            iv_msg_id     = <fs_error>-id
            iv_msg_number = <fs_error>-number
            iv_msg_text   = <fs_error>-message ).
        ENDIF.

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = lo_msg.

      ENDIF.

      " CRITICAL: Commit the changes - missing in original code
      TRY.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
            EXPORTING
              wait = abap_true.
          IF 1 = 2.
            MESSAGE i037(/savy/messages).
          ENDIF.
          CLEAR ls_mesg.
          ls_mesg-msgty = 'S'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '037'.
          ls_mesg-msgv1 = lv_username.
          IF lr_applog IS BOUND.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
          ENDIF.

        CATCH cx_root INTO lx_exception.
          lv_msgtext = lx_exception->get_text( ).
          IF 1 = 2.
            MESSAGE i019(/savy/messages).
          ENDIF.
          CLEAR ls_mesg.
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '019'.
          ls_mesg-msgv1 = lv_username.
          ls_mesg-msgv2 = lv_msgtext.
          IF lr_applog IS BOUND.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
          ENDIF.
          CALL METHOD lr_applog->save_to_db( ).

          " Rollback on commit failure
          CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

          lo_msg->add_message(
            iv_msg_type   = /iwbep/cl_cos_logger=>error
            iv_msg_id     = '/SAVY/MESSAGES'
            iv_msg_number = '019' ).

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = lo_msg.
      ENDTRY.

      " Build success response
      LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_success>) WHERE type = 'S'.

        ls_result-username = lv_username.
        ls_result-status   = <fs_success>-type.

        CONCATENATE ls_result-message <fs_success>-message INTO ls_result-message
        SEPARATED BY '/'.

      ENDLOOP.

      " Save application log
      lr_applog->save_to_db( ).

      copy_data_to_ref( EXPORTING is_data = ls_result
                        CHANGING  cr_data = er_data ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
