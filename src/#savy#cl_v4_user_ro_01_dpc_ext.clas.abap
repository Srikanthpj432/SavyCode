class /SAVY/CL_V4_USER_RO_01_DPC_EXT definition
  public
  inheriting from /SAVY/CL_V4_USER_RO_01_DPC
  create public .

public section.

  methods /IWBEP/IF_V4_DP_ADVANCED~EXECUTE_ACTION
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_RO_01_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_v4_dp_advanced~execute_action.
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
      WHEN 'UnAssignRoles'.

        DATA: BEGIN OF ltt_actgrp.
                INCLUDE TYPE /savy/cl_user_role_una_mpc=>ts_userunassign.
        DATA:   userrolesset TYPE TABLE OF /savy/cl_user_role_una_mpc=>ts_userroles.
        DATA:   statusresultset TYPE TABLE OF /savy/cl_user_role_una_mpc=>ts_statusresult.
        DATA: END OF ltt_actgrp.

        DATA: ls_deep      LIKE ltt_actgrp,
              lv_username  TYPE bapibname-bapibname,
              lt_roles     TYPE TABLE OF agr_name,
              lt_actroles  TYPE TABLE OF bapiagr,
              lt_return    TYPE TABLE OF bapiret2,
              lt_roles_tmp TYPE STANDARD TABLE OF /savy/i_role_get,
              lt_agr       TYPE STANDARD TABLE OF /savy/i_user_role_get,
              lv_msgtext   TYPE string,
              lx_exception TYPE REF TO cx_root,
              lr_applog    TYPE REF TO /savy/cl_app_log,
              ls_result    TYPE /savy/cl_user_role_una_mpc=>ts_statusresult,
              ls_mesg      TYPE bal_s_msg.

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
            ls_mesg-msgno = '032'.
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

        lv_username      = ls_deep-username.
        TRANSLATE lv_username TO UPPER CASE.
        ls_deep-version  = /savy/cl_app_log=>gv_version.

        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '007'.
        ls_mesg-msgv1 = ls_deep-version.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.

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

        " Check if user exists and is unlocked
        TRY.
            DATA lv_user_exists TYPE c LENGTH 1.
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

        " Validate roles not empty
        lt_roles = ls_deep-userrolesset.

        IF lt_roles IS INITIAL.
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

        " Validate all roles exist in master data
        TRY.
            SELECT * FROM /savy/i_role_get
              INTO TABLE @lt_roles_tmp
              FOR ALL ENTRIES IN @lt_roles
              WHERE rolename = @lt_roles-table_line.

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

            " Check each role exists
            LOOP AT lt_roles ASSIGNING FIELD-SYMBOL(<fs_roles>).
              TRY.
                  DATA(ls_role) = lt_roles_tmp[ rolename = <fs_roles> ].
                CATCH cx_sy_itab_line_not_found INTO lx_exception.
                  CLEAR ls_mesg.
                  ls_mesg-msgty = 'E'.
                  ls_mesg-msgid = '/SAVY/MESSAGES'.
                  ls_mesg-msgno = '024'.
                  ls_mesg-msgv1 = <fs_roles>.
                  IF lr_applog IS BOUND.
                    lr_applog->msg_add_log( im_msg = ls_mesg ).
                  ENDIF.
              ENDTRY.
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

        " Get existing user role assignments
        TRY.
            SELECT * FROM /savy/i_user_role_get
              INTO TABLE @lt_agr
              WHERE username = @lv_username.

            IF sy-subrc = lc_subrc_success AND lt_agr IS NOT INITIAL.

              " Remove duplicates
              DATA(lt_agr_unique) = lt_agr.
              DELETE ADJACENT DUPLICATES FROM lt_agr_unique COMPARING rolename.
              CLEAR lt_agr.
              lt_agr = lt_agr_unique.

              " Remove requested roles and track unassigned ones
              LOOP AT lt_agr ASSIGNING FIELD-SYMBOL(<fs_agr>).
                READ TABLE lt_roles TRANSPORTING NO FIELDS
                  WITH KEY table_line = <fs_agr>-rolename.
                IF sy-subrc = 0.
                  " This role is in the unassign list - mark it
                  DELETE lt_agr_unique WHERE username = <fs_agr>-username
                                         AND rolename = <fs_agr>-rolename.
                  CONCATENATE <fs_agr>-rolename ls_deep-status
                    INTO ls_deep-status SEPARATED BY space.
                ENDIF.
              ENDLOOP.

              " Build lt_actroles with remaining roles to keep
              LOOP AT lt_agr_unique ASSIGNING FIELD-SYMBOL(<fs_agrunique>).
                APPEND VALUE #(
                  agr_name = <fs_agrunique>-rolename
                  from_dat = <fs_agrunique>-fromdate
                  to_dat   = <fs_agrunique>-todate
                ) TO lt_actroles.
              ENDLOOP.

              CLEAR ls_mesg.
              ls_mesg-msgty = 'I'.
              ls_mesg-msgid = '/SAVY/MESSAGES'.
              ls_mesg-msgno = '028'.
              ls_mesg-msgv1 = lv_username.
              IF lr_applog IS BOUND.
                lr_applog->msg_add_log( im_msg = ls_mesg ).
              ENDIF.

              " Unassign via BAPI - reassign only remaining roles
              TRY.
                  CALL FUNCTION 'BAPI_USER_ACTGROUPS_ASSIGN'
                    EXPORTING
                      username       = lv_username
                    TABLES
                      activitygroups = lt_actroles
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
                  ls_mesg-msgno = '033'.
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

            ELSE.
              " User has no existing roles - nothing to unassign
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

        " Save application log and set response
        lr_applog->save_to_db( ).

        io_response->set_busi_data( ia_busi_data = ls_deep ).

      WHEN OTHERS.
        RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented.

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
