class /SAVY/CL_V4_USER_PROFI_DPC_EXT definition
  public
  inheriting from /SAVY/CL_V4_USER_PROFI_DPC
  create public .

public section.

  methods /IWBEP/IF_V4_DP_ADVANCED~EXECUTE_ACTION
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_PROFI_DPC_EXT IMPLEMENTATION.


METHOD /iwbep/if_v4_dp_advanced~execute_action.

  DATA lv_action TYPE c LENGTH 30.
  io_request->get_action( IMPORTING ev_action_name = lv_action ).

  CASE lv_action.
    WHEN 'AssignProfiles'.

      DATA: BEGIN OF ltt_prof.
              INCLUDE TYPE /savy/cl_user_profi_01_mpc=>ts_userassign.
      DATA:   userprofilesset TYPE TABLE OF /savy/cl_user_profi_01_mpc=>ts_userprofiles.
      DATA:   statusresultset TYPE TABLE OF /savy/cl_user_profi_01_mpc=>ts_statusresult.
      DATA: END OF ltt_prof.

      DATA: ls_deep        LIKE ltt_prof,
            lv_username    TYPE bapibname-bapibname,
            lt_profiles    TYPE TABLE OF bapiprof,
            lt_return      TYPE TABLE OF bapiret2,
            lt_prof_all    TYPE STANDARD TABLE OF /savy/i_profiles_get,
            lt_uprofiles   TYPE STANDARD TABLE OF /savy/i_user_profiles,
            lv_msgtext     TYPE string,
            lx_exception   TYPE REF TO cx_root,
            lr_applog      TYPE REF TO /savy/cl_app_log,
            ls_result      TYPE /savy/cl_user_role_ass_mpc=>ts_statusresult,
            ls_mesg        TYPE bal_s_msg,
            lv_char50      TYPE char50.

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

      " Read request body using GET_PARAMETER_DATA
TRY.
    io_request->get_parameter_data( IMPORTING es_parameter_data = ls_deep ).

    lv_username = ls_deep-username.
    TRANSLATE lv_username TO UPPER CASE.
    ls_deep-version = /savy/cl_app_log=>gv_version.

          lv_username = ls_deep-username.
          TRANSLATE lv_username TO UPPER CASE.
          ls_deep-version = /savy/cl_app_log=>gv_version.

          ls_mesg-msgty = 'I'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '057'.
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

      " Check authorization
      AUTHORITY-CHECK OBJECT '/SAVY/USER'
        ID '/SAVY/USER' FIELD lv_username
        ID 'ACTVT'      FIELD '23'.

      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
          EXPORTING
            http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-forbidden.
      ENDIF.

      ls_mesg-msgty = 'I'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '007'.
      ls_mesg-msgv1 = ls_deep-version.
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
            INTO @DATA(lv_user_exists2).

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

      " Validate profiles not empty
      lt_profiles = ls_deep-userprofilesset.

      IF lt_profiles IS INITIAL.
        ls_mesg-msgty = 'E'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '059'.
        ls_mesg-msgv1 = lv_username.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
        lr_applog->save_to_db( ).
        RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
          EXPORTING
            http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
      ENDIF.

      " Validate all profiles exist in master data
      TRY.
          SELECT * FROM /savy/i_profiles_get
            INTO TABLE @lt_prof_all
            FOR ALL ENTRIES IN @lt_profiles
            WHERE profilename = @lt_profiles-bapiprof.

          IF sy-subrc <> lc_subrc_success.
            ls_mesg-msgty = 'E'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '060'.
            ls_mesg-msgv1 = lv_username.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
            lr_applog->save_to_db( ).
            RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
              EXPORTING
                http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
          ENDIF.

          " Check each profile exists in master data
          LOOP AT lt_profiles ASSIGNING FIELD-SYMBOL(<fs_profiles>).
            TRY.
                DATA(ls_prof) = lt_prof_all[ profilename = <fs_profiles>-bapiprof ].
              CATCH cx_sy_itab_line_not_found INTO lx_exception.
                ls_mesg-msgty = 'E'.
                ls_mesg-msgid = '/SAVY/MESSAGES'.
                ls_mesg-msgno = '061'.
                ls_mesg-msgv1 = <fs_profiles>-bapiprof.
                lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDTRY.
            CONCATENATE <fs_profiles>-bapiprof ls_deep-status
              INTO ls_deep-status SEPARATED BY space.
          ENDLOOP.

        CATCH cx_sy_open_sql_db INTO lx_exception.
          lv_msgtext = lx_exception->get_text( ).
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '011'.
          ls_mesg-msgv1 = lv_username.
          ls_mesg-msgv2 = lv_msgtext.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
          RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
            EXPORTING
              http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
      ENDTRY.

      " Get existing user profiles and merge
      TRY.
          SELECT * FROM /savy/i_user_profiles
            INTO TABLE @lt_uprofiles
            WHERE username = @lv_username.

          IF sy-subrc = lc_subrc_success AND lt_uprofiles IS NOT INITIAL.

            LOOP AT lt_uprofiles ASSIGNING FIELD-SYMBOL(<fs_uprofiles>).
              TRY.
                  DATA(ls_existing) = lt_profiles[ bapiprof = <fs_uprofiles>-profile ].

                  IF ls_existing IS NOT INITIAL.
                    ls_mesg-msgty = 'E'.
                    ls_mesg-msgid = '/SAVY/MESSAGES'.
                    ls_mesg-msgno = '068'.
                    ls_mesg-msgv1 = ls_existing-bapiprof.
                    lr_applog->msg_add_log( im_msg = ls_mesg ).
                    lr_applog->save_to_db( ).

                    lv_char50 = ls_existing-bapiprof.

                    RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
                      EXPORTING
                        http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
                  ENDIF.

                CATCH cx_sy_itab_line_not_found.
                  APPEND VALUE #(
                    bapiprof = <fs_uprofiles>-profile
                  ) TO lt_profiles.
              ENDTRY.
            ENDLOOP.

            " Remove duplicates
            DATA(lt_profiles_unique) = lt_profiles.
            DELETE ADJACENT DUPLICATES FROM lt_profiles_unique COMPARING bapiprof.
            lt_profiles = lt_profiles_unique.

            ls_mesg-msgty = 'I'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '027'.
            ls_mesg-msgv1 = lines( lt_uprofiles ).
            ls_mesg-msgv2 = lines( ls_deep-userprofilesset ).
            ls_mesg-msgv3 = lv_username.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
          ENDIF.

        CATCH cx_sy_open_sql_db INTO lx_exception.
          lv_msgtext = lx_exception->get_text( ).
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '011'.
          ls_mesg-msgv1 = lv_username.
          ls_mesg-msgv2 = lv_msgtext.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
          RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
            EXPORTING
              http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
      ENDTRY.

      ls_mesg-msgty = 'I'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '062'.
      ls_mesg-msgv1 = lv_username.
      lr_applog->msg_add_log( im_msg = ls_mesg ).

      " Assign profiles via BAPI
      TRY.
          CALL FUNCTION 'BAPI_USER_PROFILES_ASSIGN'
            EXPORTING
              username = lv_username
            TABLES
              profiles = lt_profiles
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
        ls_mesg-msgno = '063'.
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
          ls_mesg-msgno = '064'.
          ls_mesg-msgv1 = ls_deep-status.
          ls_mesg-msgv2 = lv_username.
          lr_applog->msg_add_log( im_msg = ls_mesg ).

          CONCATENATE TEXT-001 ' ' ls_deep-status
            INTO ls_deep-status SEPARATED BY space.

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

      " Build success response
      READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_success>)
        WITH KEY type = 'S'.
      IF sy-subrc = 0.
        ls_result-username = lv_username.
        ls_result-status   = <fs_success>-type.
        ls_result-message  = <fs_success>-message.
        APPEND ls_result TO ls_deep-statusresultset.
      ENDIF.

      " Save application log and set response
      lr_applog->save_to_db( ).

      io_response->set_busi_data( ia_busi_data = ls_deep ).

    WHEN OTHERS.
      RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented.

  ENDCASE.

ENDMETHOD.
ENDCLASS.
