class /SAVY/CL_V4_USER_ROLE__DPC_EXT definition
  public
  inheriting from /SAVY/CL_V4_USER_ROLE__DPC
  create public .

public section.

  methods /IWBEP/IF_V4_DP_ADVANCED~EXECUTE_ACTION
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_ROLE__DPC_EXT IMPLEMENTATION.


METHOD /iwbep/if_v4_dp_advanced~execute_action.

    DATA: BEGIN OF ltt_actgrp.
            INCLUDE TYPE /savy/cl_v4_user_role__mpc=>ts_userassign.
    DATA:   activitygroupsset TYPE TABLE OF /savy/cl_v4_user_role__mpc=>ts_activitygroups.
    DATA:   statusresultset   TYPE TABLE OF /savy/cl_v4_user_role__mpc=>ts_statusresult.
    DATA: END OF ltt_actgrp.

    DATA: ls_deep           LIKE ltt_actgrp,
          lv_username       TYPE bapibname-bapibname,
          lt_activitygroups TYPE TABLE OF bapiagr,
          lt_return         TYPE TABLE OF bapiret2,
          lv_user_exists    TYPE c LENGTH 1,
          lt_roles          TYPE STANDARD TABLE OF /savy/i_role_get,
          lt_agr            TYPE STANDARD TABLE OF /savy/i_user_role_get,
          lv_msgtext        TYPE string,
          lx_exception      TYPE REF TO cx_root,
          lr_applog         TYPE REF TO /savy/cl_app_log,
          ls_result         TYPE /savy/cl_v4_user_role__mpc=>ts_statusresult,
          ls_mesg           TYPE bal_s_msg.

    CONSTANTS: lc_subrc_success TYPE sy-subrc VALUE 0,
               lc_user_unlocked TYPE usr02-uflag VALUE '0'.

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

    " Read request body using GET_PARAMETER_DATA
    TRY.
        io_request->get_parameter_data(
          IMPORTING
            es_parameter_data = ls_deep ).

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

    lv_username = ls_deep-username.
    TRANSLATE lv_username TO UPPER CASE.
    ls_deep-version = /savy/cl_app_log=>gv_version.

    " Check authorization
    AUTHORITY-CHECK OBJECT '/SAVY/USER'
      ID '/SAVY/USER' FIELD lv_username
      ID 'ACTVT'      FIELD '23'.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
        EXPORTING
          http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-forbidden.
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

    " Check if user exists and is unlocked
    TRY.
        SELECT SINGLE @abap_true
          FROM usr02
          WHERE bname = @lv_username
            AND uflag = @lc_user_unlocked
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

    " Validate activity groups not empty
    IF ls_deep-activitygroupsset IS INITIAL.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '022'.
      ls_mesg-msgv1 = lv_username.
      IF lr_applog IS BOUND.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
      ENDIF.
      lr_applog->save_to_db( ).

      RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
        EXPORTING
          http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
    ENDIF.

    " FIX for error 2: Map ts_activitygroups -> bapiagr explicitly
    LOOP AT ls_deep-activitygroupsset ASSIGNING FIELD-SYMBOL(<fs_src>).
      APPEND VALUE #(
        agr_name = <fs_src>-agr_name
        from_dat = <fs_src>-from_dat
        to_dat   = <fs_src>-to_dat
      ) TO lt_activitygroups.
    ENDLOOP.

    " Validate all roles exist in master data
    TRY.
        SELECT * FROM /savy/i_role_get
          INTO TABLE @lt_roles
          FOR ALL ENTRIES IN @lt_activitygroups
          WHERE rolename = @lt_activitygroups-agr_name.

        IF sy-subrc <> lc_subrc_success.
          CLEAR ls_mesg.
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '023'.
          ls_mesg-msgv1 = lv_username.
          IF lr_applog IS BOUND.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
          ENDIF.
          lr_applog->save_to_db( ).

          RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
            EXPORTING
              http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
        ENDIF.

        " Check each role and validate dates
        LOOP AT lt_activitygroups ASSIGNING FIELD-SYMBOL(<fs_actroles>).
          TRY.
              DATA(ls_role) = lt_roles[ rolename = <fs_actroles>-agr_name ].
            CATCH cx_sy_itab_line_not_found INTO lx_exception.
              CLEAR ls_mesg.
              ls_mesg-msgty = 'E'.
              ls_mesg-msgid = '/SAVY/MESSAGES'.
              ls_mesg-msgno = '024'.
              ls_mesg-msgv1 = <fs_actroles>-agr_name.
              IF lr_applog IS BOUND.
                lr_applog->msg_add_log( im_msg = ls_mesg ).
              ENDIF.
          ENDTRY.

          CONCATENATE <fs_actroles>-agr_name ls_deep-status
            INTO ls_deep-status SEPARATED BY space.

          " Date validation
          IF <fs_actroles>-from_dat > sy-datum.
            <fs_actroles>-from_dat = sy-datum.
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

          IF <fs_actroles>-to_dat IS NOT INITIAL AND
             <fs_actroles>-to_dat < <fs_actroles>-from_dat.
            <fs_actroles>-to_dat = <fs_actroles>-from_dat + 1.
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
        CLEAR ls_mesg.
        ls_mesg-msgty = 'E'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '011'.
        ls_mesg-msgv1 = lv_username.
        ls_mesg-msgv2 = lv_msgtext.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.

        RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
          EXPORTING
            http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
    ENDTRY.

    " Get existing user assignments and merge
    TRY.
        SELECT * FROM /savy/i_user_role_get
          INTO TABLE @lt_agr
          WHERE username = @lv_username.

        IF sy-subrc = lc_subrc_success AND lt_agr IS NOT INITIAL.
          LOOP AT lt_agr ASSIGNING FIELD-SYMBOL(<fs_agrtmp>).
            TRY.
                DATA(ls_existing) = lt_activitygroups[ agr_name = <fs_agrtmp>-rolename ].
              CATCH cx_sy_itab_line_not_found.
                APPEND VALUE #(
                  agr_name = <fs_agrtmp>-rolename
                  from_dat = <fs_agrtmp>-fromdate
                  to_dat   = <fs_agrtmp>-todate
                ) TO lt_activitygroups.
            ENDTRY.
          ENDLOOP.

          DATA(lt_activitygroups_unique) = lt_activitygroups.
          DELETE ADJACENT DUPLICATES FROM lt_activitygroups_unique COMPARING agr_name.
          lt_activitygroups = lt_activitygroups_unique.

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

        RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
          EXPORTING
            http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
    ENDTRY.

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
      ls_mesg-msgno = '030'.
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
        ls_mesg-msgno = '031'.
        ls_mesg-msgv1 = ls_deep-status.
        ls_mesg-msgv2 = lv_username.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.

        ls_deep-status = TEXT-001 && ls_deep-status.

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
      APPEND ls_result TO ls_deep-statusresultset.
    ENDIF.

    " Save application log and return response
    lr_applog->save_to_db( ).

    io_response->set_busi_data( ia_busi_data = ls_deep ).

ENDMETHOD.
ENDCLASS.
