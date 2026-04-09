class /SAVY/CL_USER_PROFI_02_DPC_EXT definition
  public
  inheriting from /SAVY/CL_USER_PROFI_02_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_USER_PROFI_02_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.

    DATA: BEGIN OF ltt_prof.
            INCLUDE TYPE /savy/cl_user_profi_02_mpc=>ts_userunassign.
    DATA:   userprofilesset TYPE TABLE OF /savy/cl_user_profi_02_mpc=>ts_userprofiles.
    DATA:   statusresultset   TYPE TABLE OF /savy/cl_user_profi_02_mpc=>ts_statusresult.
    DATA: END OF ltt_prof.

    DATA: ls_deep        LIKE ltt_prof,
          lv_username    TYPE bapibname-bapibname,
          lt_proflist    TYPE TABLE OF bapiprof,
          lt_profiles    TYPE TABLE OF bapiprof,
          lt_return      TYPE TABLE OF bapiret2,
          lo_msg         TYPE REF TO /iwbep/if_message_container,
          lv_user_exists TYPE c LENGTH 1,
          lv_msgtext     TYPE string,
          lx_exception   TYPE REF TO cx_root,
          ls_mesg        TYPE bal_s_msg,
          lr_applog      TYPE REF TO /savy/cl_app_log,
          lv_str(255)    TYPE c,
          lt_uprofiles   TYPE STANDARD TABLE OF /savy/i_user_profiles,
          lt_prof_all    TYPE STANDARD TABLE OF /savy/i_profiles_get,
          ls_result      TYPE /savy/cl_user_profi_02_mpc=>TS_statusresult,
          lv_char50      TYPE char50.

    CONSTANTS: lc_subrc_success TYPE sy-subrc VALUE 0,
               lc_user_unlocked TYPE usr02-uflag VALUE '0'.

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
      ID 'ACTVT'      FIELD '23'.

    IF sy-subrc <> 0.
      lo_msg->add_message(
      iv_msg_type   = /iwbep/cl_cos_logger=>error
      iv_msg_id     = '/SAVY/MESSAGES'
      iv_msg_number = '065').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = lo_msg.
    ENDIF.

    " Read entry data with exception handling
    TRY.
        io_data_provider->read_entry_data( IMPORTING es_data = ls_deep ).
        IF 1 = 2.
          MESSAGE i066(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '066'.
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
    TRANSLATE lv_username TO UPPER CASE.
    ls_Deep-version = /savy/cl_app_log=>gv_version.

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
        iv_msg_number = '008'  ).

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

    " Validate Profiles
    lt_profiles = ls_deep-userprofilesset.

    IF lt_profiles IS INITIAL.
      IF 1 = 2.
        MESSAGE i059(/savy/messages).
      ENDIF.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '059'.
      ls_mesg-msgv1 = lv_username.
      IF lr_applog IS BOUND.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
      ENDIF.
      CALL METHOD lr_applog->save_to_db( ).

      lo_msg->add_message(
        iv_msg_type   = /iwbep/cl_cos_logger=>error
        iv_msg_id     = '/SAVY/MESSAGES'
        iv_msg_number = '059' ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = lo_msg.
    ENDIF.

    " Validate all roles exist
    TRY.
        SELECT * FROM /savy/i_profiles_get
          INTO TABLE @lt_prof_All
          FOR ALL ENTRIES IN @lt_profiles
          WHERE profilename = @lt_profiles-bapiprof.
        IF sy-subrc <> lc_subrc_success.
          IF 1 = 2.
            MESSAGE i060(/savy/messages).
          ENDIF.
          CLEAR ls_mesg.
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '060'.
          ls_mesg-msgv1 = lv_username.
          IF lr_applog IS BOUND.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
          ENDIF.
          CALL METHOD lr_applog->save_to_db( ).

          lo_msg->add_message(
            iv_msg_type   = /iwbep/cl_cos_logger=>error
            iv_msg_id     = '/SAVY/MESSAGES'
            iv_msg_number = '060' ).

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = lo_msg.
        ENDIF.

        " Check each activity group exists in master data
        LOOP AT lt_profiles ASSIGNING FIELD-SYMBOL(<fs_profiles>).
          TRY.
              DATA(ls_profile) = lt_prof_all[ profilename = <fs_profiles> ].
            CATCH cx_sy_itab_line_not_found INTO lx_exception.
              IF 1 = 2.
                MESSAGE i061(/savy/messages).
              ENDIF.
              CLEAR ls_mesg.
              ls_mesg-msgty = 'E'.
              ls_mesg-msgid = '/SAVY/MESSAGES'.
              ls_mesg-msgno = '061'.
              ls_mesg-msgv1 = <fs_profiles>.
              IF lr_applog IS BOUND.
                lr_applog->msg_add_log( im_msg = ls_mesg ).
              ENDIF.
          ENDTRY.
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


    SELECT * FROM /savy/i_user_profiles INTO TABLE @lt_uprofiles
      WHERE username = @lv_username.

    IF sy-subrc <> lc_subrc_success.
      IF 1 = 2.
        MESSAGE i070(/savy/messages).
      ENDIF.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '070'.
      ls_mesg-msgv1 = lv_username.
      IF lr_applog IS BOUND.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
      ENDIF.
      CALL METHOD lr_applog->save_to_db( ).

      lv_char50 = lv_username.

      lo_msg->add_message(
        iv_msg_type   = /iwbep/cl_cos_logger=>error
        iv_msg_id     = '/SAVY/MESSAGES'
        iv_msg_number = '070'
        iv_msg_v1     = lv_char50 ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = lo_msg.
    ENDIF.

    LOOP AT lt_profiles ASSIGNING FIELD-SYMBOL(<fs_profiles_tmp>).
      TRY.
          DATA(ls_existing) = lt_uprofiles[ profile = <fs_profiles_tmp>-bapiprof ].

          " Role already in list, skip
        CATCH cx_sy_itab_line_not_found.
          IF ls_existing IS INITIAL.
            IF 1 = 2.
              MESSAGE i069(/savy/messages).
            ENDIF.
            CLEAR ls_mesg.
            ls_mesg-msgty = 'E'.
            ls_mesg-msgid = '/SAVY/MESSAGES'.
            ls_mesg-msgno = '069'.
            ls_mesg-msgv1 = <fs_profiles_tmp>-bapiprof.
            IF lr_applog IS BOUND.
              lr_applog->msg_add_log( im_msg = ls_mesg ).
            ENDIF.
            CALL METHOD lr_applog->save_to_db( ).

            lv_char50 = <fs_profiles_tmp>-bapiprof.

            lo_msg->add_message(
              iv_msg_type   = /iwbep/cl_cos_logger=>error
              iv_msg_id     = '/SAVY/MESSAGES'
              iv_msg_number = '069'
              iv_msg_v1     = lv_char50 ).

            RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
              EXPORTING
                message_container = lo_msg.
          ENDIF.

      ENDTRY.
    ENDLOOP.


    DATA(lt_uprofiles_unique) = lt_uprofiles.
    DELETE ADJACENT DUPLICATES FROM lt_uprofiles_unique COMPARING profile.
    CLEAR lt_uprofiles.

    lt_uprofiles = lt_uprofiles_unique.

    LOOP AT lt_uprofiles ASSIGNING FIELD-SYMBOL(<fs_uprofiles>).
      READ TABLE lt_profiles TRANSPORTING NO FIELDS
       WITH KEY bapiprof = <fs_uprofiles>-profile.
      IF sy-subrc = 0.
        DELETE lt_uprofiles_unique WHERE username   = <fs_uprofiles>-username
                                     AND profile    = <fs_uprofiles>-profile.

        CONCATENATE <fs_uprofiles>-profile ls_deep-status INTO ls_deep-status SEPARATED BY space.
      ENDIF.
    ENDLOOP.

    LOOP AT lt_uprofiles_unique ASSIGNING FIELD-SYMBOL(<fs_uprofunique>).

      APPEND INITIAL LINE TO lt_proflist ASSIGNING FIELD-SYMBOL(<fs_proflist>).
      <fs_proflist>-bapiprof = <fs_uprofunique>-profile.

    ENDLOOP.

    IF 1 = 2.
      MESSAGE i062(/savy/messages).
    ENDIF.
    CLEAR ls_mesg.
    ls_mesg-msgty = 'I'.
    ls_mesg-msgid = '/SAVY/MESSAGES'.
    ls_mesg-msgno = '062'.
    ls_mesg-msgv1 = lv_username.
    IF lr_applog IS BOUND.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
    ENDIF.

    " UnAssign profiles via BAPI
    TRY.

        CALL FUNCTION 'BAPI_USER_PROFILES_ASSIGN'
          EXPORTING
            username = lv_username
          TABLES
            profiles = lt_proflist
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
        iv_msg_number   = '029' ).

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
        MESSAGE i063(/savy/messages).
      ENDIF.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '063'.
      ls_mesg-msgv1 = lv_username.
      IF lr_applog IS BOUND.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
      ENDIF.

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
          MESSAGE i067(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'S'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '067'.
        ls_mesg-msgv1 = ls_deep-status.
        ls_mesg-msgv2 = lv_username.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.

        CONCATENATE TEXT-001 ' ' ls_deep-status INTO ls_deep-status SEPARATED BY space.

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
