class /SAVY/CL_USER_ROLE_ASS_DPC_EXT definition
  public
  inheriting from /SAVY/CL_USER_ROLE_ASS_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_USER_ROLE_ASS_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.

    DATA: BEGIN OF ltt_actgrp.
            INCLUDE TYPE /savy/cl_user_role_ass_mpc=>ts_userassign.
    DATA:   activitygroupsset TYPE TABLE OF /savy/cl_user_role_ass_mpc=>ts_activitygroups.
    DATA:   statusresultset   TYPE TABLE OF /savy/cl_user_role_ass_mpc=>ts_statusresult.
    DATA: END OF ltt_actgrp.

    DATA: ls_deep           LIKE ltt_actgrp,
          lv_username       TYPE bapibname-bapibname,
          lt_activitygroups TYPE TABLE OF bapiagr,
          lt_return         TYPE TABLE OF bapiret2,
          lo_msg            TYPE REF TO /iwbep/if_message_container,
          lv_user_exists    TYPE c LENGTH 1,
          lt_roles          TYPE STANDARD TABLE OF /savy/i_role_get,
          lt_agr            TYPE STANDARD TABLE OF /savy/i_user_role_get,
          lv_msgtext        TYPE string,
          lx_exception      TYPE REF TO cx_root,
          lr_applog         TYPE REF TO /savy/cl_app_log,
          ls_result         TYPE /savy/cl_user_role_ass_mpc=>ts_statusresult,
          ls_mesg           TYPE bal_s_msg.

    DATA lv_str(255)   TYPE  c.

    CONSTANTS: lc_subrc_success TYPE sy-subrc VALUE 0,
               lc_user_unlocked TYPE usr02-uflag VALUE '0'.

    TRY.
        CREATE OBJECT lr_applog.
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

    " Read entry data with exception handling
    TRY.
        io_data_provider->read_entry_data( IMPORTING es_data = ls_deep ).
        IF 1 = 2.
          MESSAGE i020(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '020'.
        ls_mesg-msgv1 = ls_deep-username.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.

      CATCH cx_root INTO lx_exception.
        lv_msgtext = lx_exception->get_text( ).

        IF 1 = 2.
          MESSAGE i006(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'E'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '006'.
        ls_mesg-msgv1 = lv_msgtext.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.

        CALL METHOD lr_applog->save_to_db( ).

        lo_msg->add_message(
          iv_msg_type   = /iwbep/cl_cos_logger=>error
          iv_msg_id     = '/SAVY/MESSAGES'
          iv_msg_number = '006' ).

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = lo_msg.
    ENDTRY.

    lv_username = ls_deep-username.
    TRANSLATE lv_username to UPPER CASE.
    ls_deep-version = /savy/cl_app_log=>gv_version.

    " Check authorization to display user
    AUTHORITY-CHECK OBJECT '/SAVY/USER'
      ID '/SAVY/USER' FIELD lv_username
      ID 'ACTVT'      FIELD '23'.

    IF sy-subrc <> 0.
      lo_msg->add_message(
      iv_msg_type   = /iwbep/cl_cos_logger=>error
      iv_msg_id     = '/SAVY/MESSAGES'
      iv_msg_number = '054').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = lo_msg.
    ENDIF.

    IF 1 = 2.
      MESSAGE i007(/savy/messages).
    ENDIF.
    CLEAR ls_mesg.
    ls_mesg-msgty = 'I'.
    ls_mesg-msgid = '/SAVY/MESSAGES'.
    ls_mesg-msgno = '007'.
    ls_mesg-msgv1 = ls_deep-version.
    IF lr_applog IS BOUND.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
    ENDIF.

    " Input validation
    IF lv_username IS INITIAL.
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

    " Validate activity groups
    lt_activitygroups = ls_deep-activitygroupsset.

    IF lt_activitygroups IS INITIAL.
      IF 1 = 2.
        MESSAGE i022(/savy/messages).
      ENDIF.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '022'.
      ls_mesg-msgv1 = lv_username.
      IF lr_applog IS BOUND.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
      ENDIF.
      CALL METHOD lr_applog->save_to_db( ).

      lo_msg->add_message(
        iv_msg_type   = /iwbep/cl_cos_logger=>error
        iv_msg_id     = '/SAVY/MESSAGES'
        iv_msg_number = '022' ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = lo_msg.
    ENDIF.
    " Validate all Roles exist
    TRY.
        SELECT * FROM /savy/i_role_get
          INTO TABLE @lt_roles
          FOR ALL ENTRIES IN @lt_activitygroups
          WHERE rolename = @lt_activitygroups-agr_name.

        IF sy-subrc <> lc_subrc_success.
          IF 1 = 2.
            MESSAGE i023(/savy/messages).
          ENDIF.
          CLEAR ls_mesg.
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '023'.
          ls_mesg-msgv1 = lv_username.
          IF lr_applog IS BOUND.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
          ENDIF.
          CALL METHOD lr_applog->save_to_db( ).

          lo_msg->add_message(
            iv_msg_type   = /iwbep/cl_cos_logger=>error
            iv_msg_id     = '/SAVY/MESSAGES'
            iv_msg_number = '023' ).

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = lo_msg.
        ENDIF.

        " Check each activity group exists in master data
        LOOP AT lt_activitygroups ASSIGNING FIELD-SYMBOL(<fs_actroles>).
          TRY.
              DATA(ls_role) = lt_roles[ rolename = <fs_actroles>-agr_name ].
            CATCH cx_sy_itab_line_not_found INTO lx_exception.
              IF 1 = 2.
                MESSAGE i024(/savy/messages).
              ENDIF.
              CLEAR ls_mesg.
              ls_mesg-msgty = 'E'.
              ls_mesg-msgid = '/SAVY/MESSAGES'.
              ls_mesg-msgno = '024'.
              ls_mesg-msgv1 = <fs_actroles>-agr_name.
              IF lr_applog IS BOUND.
                lr_applog->msg_add_log( im_msg = ls_mesg ).
              ENDIF.
*              CALL METHOD lr_applog->save_to_db( ).
*
*              lo_msg->add_message(
*                iv_msg_type   = /iwbep/cl_cos_logger=>error
*                iv_msg_id     = '/SAVY/MESSAGES'
*                iv_msg_number = '024' ).

          ENDTRY.
          CONCATENATE <fs_actroles>-agr_name ls_deep-status INTO ls_deep-status SEPARATED BY space.

          " Date validation - add business logic if needed
          IF <fs_actroles>-from_dat > sy-datum.
            <fs_actroles>-from_dat = sy-datum.
            IF 1 = 2.
              MESSAGE i025(/savy/messages).
            ENDIF.
            CLEAR ls_mesg.
            ls_mesg-msgty = 'I'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '025'.
            ls_mesg-msgv1 = <fs_actroles>-agr_name.
            ls_mesg-msgv2 = <fs_actroles>-from_dat.
            IF lr_applog IS BOUND.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDIF.
          ENDIF.

          " Validate end date is after start date
          IF <fs_actroles>-to_dat IS NOT INITIAL AND
             <fs_actroles>-to_dat < <fs_actroles>-from_dat.

            <fs_actroles>-to_dat = <fs_actroles>-from_dat + 1.

            IF 1 = 2.
              MESSAGE i026(/savy/messages).
            ENDIF.
            CLEAR ls_mesg.
            ls_mesg-msgty = 'E'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '026'.
            ls_mesg-msgv1 = <fs_actroles>-agr_name.
            IF lr_applog IS BOUND.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDIF.
          ENDIF.

        ENDLOOP.

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

        lo_msg->add_message(
          iv_msg_type = /iwbep/cl_cos_logger=>error
          iv_msg_id     = '/SAVY/MESSAGES'
          iv_msg_number = '011' ).

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = lo_msg.
    ENDTRY.

    " Get existing user assignments
    TRY.
        SELECT * FROM /savy/i_user_role_get
          INTO TABLE @lt_agr
          WHERE username = @lv_username.

        IF sy-subrc = lc_subrc_success AND lt_agr IS NOT INITIAL.
          " Merge existing roles with new ones - optimized with hashed table
          LOOP AT lt_agr ASSIGNING FIELD-SYMBOL(<fs_agrtmp>).
            TRY.
                DATA(ls_existing) = lt_activitygroups[ agr_name = <fs_agrtmp>-rolename ].
                " Role already in list, skip
              CATCH cx_sy_itab_line_not_found.
                " Add existing role to preserve it
                APPEND VALUE #(
                  agr_name = <fs_agrtmp>-rolename
                  from_dat = <fs_agrtmp>-fromdate
                  to_dat   = <fs_agrtmp>-todate
                ) TO lt_activitygroups.

            ENDTRY.
          ENDLOOP.

          " Remove duplicates - more efficient than SORT + DELETE ADJACENT
          DATA(lt_activitygroups_unique) = lt_activitygroups.
          DELETE ADJACENT DUPLICATES FROM lt_activitygroups_unique COMPARING agr_name.
          lt_activitygroups = lt_activitygroups_unique.
          IF 1 = 2.
            MESSAGE i027(/savy/messages).
          ENDIF.
          CLEAR ls_mesg.
          ls_mesg-msgty = 'I'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '027'.
          ls_mesg-msgv1 = lines( lt_agr ).
          ls_mesg-msgv2 = lines( ls_deep-activitygroupsset ).
          ls_mesg-msgv3 = lv_username.
          IF lr_applog IS BOUND.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
          ENDIF.
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

        lo_msg->add_message(
        iv_msg_type   = /iwbep/cl_cos_logger=>error
        iv_msg_id     = '/SAVY/MESSAGES'
        iv_msg_number = '011' ).

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = lo_msg.

    ENDTRY.

    IF 1 = 2.
      MESSAGE i028(/savy/messages).
    ENDIF.
    CLEAR ls_mesg.
    ls_mesg-msgty = 'I'.
    ls_mesg-msgid = '/SAVY/MESSAGES'.
    ls_mesg-msgno = '028'.
    ls_mesg-msgv1 = lv_username.
    IF lr_applog IS BOUND.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
    ENDIF.

    " Assign activity groups via BAPI
    TRY.
        CALL FUNCTION 'BAPI_USER_ACTGROUPS_ASSIGN'
          EXPORTING
            username       = lv_username
          TABLES
            activitygroups = lt_activitygroups
            return         = lt_return.

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
          iv_msg_number = '029'  ).

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
        MESSAGE i030(/savy/messages).
      ENDIF.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '030'.
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
          MESSAGE i031(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'S'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '031'.
        ls_mesg-msgv1 = ls_deep-status.
        ls_mesg-msgv2 = lv_username.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.

        ls_Deep-status = TEXT-001 && ls_deep-status.

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
          iv_msg_type = /iwbep/cl_cos_logger=>error
          iv_msg_id     = '/SAVY/MESSAGES'
          iv_msg_number = '019' ).

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = lo_msg.
    ENDTRY.

    " Build success response
    READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_success>)
      WITH KEY type = 'S'.
    IF sy-subrc = 0.
      ls_result-username = lv_username.
      ls_result-status   = <fs_success>-type.
      ls_result-message  = <fs_success>-message.
      APPEND ls_result TO ls_deep-statusresultset.

      " Add success message to container for API response
      lo_msg->add_message(
        iv_msg_type   = /iwbep/cl_cos_logger=>success
        iv_msg_id     = <fs_success>-id
        iv_msg_number = <fs_success>-number
        iv_msg_text   = <fs_success>-message ).
    ENDIF.

    " Save application log
    lr_applog->save_to_db( ).

    copy_data_to_ref( EXPORTING is_data = ls_deep
                      CHANGING  cr_data = er_deep_entity ).

  ENDMETHOD.
ENDCLASS.
