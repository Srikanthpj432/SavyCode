class /SAVY/CL_V4_USER_CREAT_DPC_EXT definition
  public
  inheriting from /SAVY/CL_V4_USER_CREAT_DPC
  create public .

public section.

  methods /IWBEP/IF_V4_DP_ADVANCED~CREATE_ENTITY
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_CREAT_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_v4_dp_advanced~create_entity.

    DATA: BEGIN OF ltt_deep_struc,
            statusresultset TYPE TABLE OF /savy/cl_v4_user_creat_mpc=>ts_statusresult.
            INCLUDE TYPE /savy/cl_v4_user_creat_mpc=>ts_usercreate.
    DATA:   parameterset    TYPE TABLE OF /savy/cl_v4_user_creat_mpc=>ts_parameter,
            groupsset       TYPE TABLE OF /savy/cl_v4_user_creat_mpc=>ts_groups,
          END OF ltt_deep_struc.

    DATA: ls_deep            LIKE ltt_deep_struc,
          lv_username        TYPE bapibname-bapibname,
          ls_logon           TYPE bapilogond,
          ls_address         TYPE bapiaddr3,
          ls_defaults        TYPE bapidefaul,
          ls_password        TYPE bapipwd,
          ls_company         TYPE bapiuscomp,
          ls_refuser         TYPE bapirefus,
          ls_snc             TYPE bapisncu,
          lt_parameter       TYPE TABLE OF bapiparam,
          lt_para_ref        TYPE ustyp_t_parameters,
          lt_groups          TYPE TABLE OF bapigroups,
          lt_return          TYPE TABLE OF bapiret2,
          lx_exception       TYPE REF TO cx_root,
          lv_msgtext         TYPE string,
          lr_applog          TYPE REF TO /savy/cl_app_log,
          ls_result          TYPE /savy/cl_v4_user_creat_mpc=>ts_statusresult,
          ls_mesg            TYPE bal_s_msg,
          lt_message         TYPE /iwbep/if_v4_runtime_types=>ty_t_message,
          ls_message         TYPE /iwbep/if_v4_runtime_types=>ty_s_message,
          ls_done_list       TYPE /iwbep/if_v4_requ_adv_create=>ty_s_todo_process_list,
          lo_request_info    TYPE REF TO /iwbep/cl_v4_request_info_pro,
          lo_expand_node     TYPE REF TO /iwbep/if_v4_expand_node,
          mo_default_matcher TYPE REF TO if_abap_testdouble_matcher,
          lo_controller      TYPE REF TO if_atd_controller,
          ro_double          TYPE REF TO object,
          lv_objname         TYPE abap_intfname VALUE '/iwbep/if_v4_expand_node'.

    CONSTANTS: lc_subrc_success TYPE sy-subrc VALUE 0,
               lc_user_unlocked TYPE usr02-uflag VALUE '0',
               lc_msgid         TYPE symsgid VALUE '/SAVY/MESSAGES'.

    "-----------------------------------------------------------------
    " Step 1: Initialize Application Log
    "-----------------------------------------------------------------
    TRY.
        CREATE OBJECT lr_applog.
        lr_applog->gv_object    = '/SAVY/ROOT'.
        lr_Applog->gv_subobject = '/SAVY/IAM'.

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
    " Step 2: Authorization Check
    "-----------------------------------------------------------------
    AUTHORITY-CHECK OBJECT '/SAVY/USER'
      ID '/SAVY/USER' FIELD sy-uname
      ID 'ACTVT'      FIELD '01'.

    IF sy-subrc <> 0.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = lc_msgid.
      ls_mesg-msgno = '050'.
      ls_mesg-msgv1 = sy-uname.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
      lr_applog->save_to_db( ).
      COMMIT WORK AND WAIT.

      " Add custom message to message container
      CLEAR ls_message.
      ls_message-class      = lc_msgid.
      ls_message-number     = '050'.      " ← Your custom message number
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
    " Step 3: Read Request Business Data
    "-----------------------------------------------------------------
    TRY.
        io_request->get_busi_data( IMPORTING es_busi_data = ls_deep ).
        lv_username     = ls_deep-username.
        TRANSLATE lv_username TO UPPER CASE.
        ls_deep-version = /savy/cl_app_log=>gv_version.

        IF 1 = 2. MESSAGE i005(/savy/messages). ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '005'.
        ls_mesg-msgv1 = ls_deep-username.
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
    " Step 4: Input Validation
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
    " Step 5: Check If User Already Exists
    "-----------------------------------------------------------------
    TRY.
        SELECT SINGLE @abap_true
          FROM usr02
          WHERE bname = @lv_username
            AND uflag = @lc_user_unlocked
          INTO @DATA(lv_user_exists).

        IF sy-subrc = lc_subrc_success AND lv_user_exists = abap_true.
          CLEAR ls_mesg.
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = lc_msgid.
          ls_mesg-msgno = '009'.
          ls_mesg-msgv1 = lv_username.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
          lr_applog->save_to_db( ).
          COMMIT WORK AND WAIT.

          " Add custom message to message container
          CLEAR ls_message.
          ls_message-class      = lc_msgid.
          ls_message-number     = '009'.      " ← Your custom message number
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
    " Step 6: Process Reference User Parameters
    "-----------------------------------------------------------------
    ls_refuser = ls_deep-ref_user.

    IF ls_refuser-ref_user IS NOT INITIAL.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'I'.
      ls_mesg-msgid = lc_msgid.
      ls_mesg-msgno = '012'.
      ls_mesg-msgv1 = ls_refuser-ref_user.
      lr_applog->msg_add_log( im_msg = ls_mesg ).

      CALL FUNCTION 'SUSR_USER_PARAMETERS_GET'
        EXPORTING
          user_name           = ls_refuser-ref_user
          with_text           = 'X'
        TABLES
          user_parameters     = lt_para_ref
        EXCEPTIONS
          user_name_not_exist = 1
          OTHERS              = 2.

      CLEAR ls_mesg.
      ls_mesg-msgty = COND #( WHEN sy-subrc = 0 THEN 'I' ELSE 'W' ).
      ls_mesg-msgid = lc_msgid.
      ls_mesg-msgno = COND #( WHEN sy-subrc = 0 THEN '013' ELSE '014' ).
      ls_mesg-msgv1 = ls_refuser-ref_user.
      ls_mesg-msgv2 = COND #( WHEN sy-subrc = 0 THEN lines( lt_para_ref ) ELSE '' ).
      lr_applog->msg_add_log( im_msg = ls_mesg ).
    ENDIF.

    "-----------------------------------------------------------------
    " Step 7: Map Input to BAPI Structures
    "-----------------------------------------------------------------
    ls_logon    = ls_deep-logondata.
    ls_password = ls_deep-password.
    ls_defaults = ls_deep-defaults.
    ls_address  = ls_deep-address.
    ls_company  = ls_deep-company.

    " Merge and deduplicate parameters
    lt_parameter = ls_deep-parameterset.
    APPEND LINES OF lt_para_ref TO lt_parameter.
    SORT lt_parameter BY parid.
    DELETE ADJACENT DUPLICATES FROM lt_parameter COMPARING parid.

    lt_groups = ls_deep-groupsset.

    CLEAR ls_mesg.
    ls_mesg-msgty = 'I'.
    ls_mesg-msgid = lc_msgid.
    ls_mesg-msgno = '015'.
    ls_mesg-msgv1 = lv_username.
    lr_applog->msg_add_log( im_msg = ls_mesg ).

    "-----------------------------------------------------------------
    " Step 8: Call BAPI_USER_CREATE1
    "-----------------------------------------------------------------
    TRY.
        CALL FUNCTION 'BAPI_USER_CREATE1'
          EXPORTING
            username  = lv_username
            logondata = ls_logon
            password  = ls_password
            defaults  = ls_defaults
            address   = ls_address
            company   = ls_company
            snc       = ls_snc
            ref_user  = ls_refuser
          TABLES
            parameter = lt_parameter
            groups    = lt_groups
            return    = lt_return.

        " Log all BAPI return messages
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
    " Step 9: Check BAPI Return for Errors
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
    " Step 10: Commit Transaction
    "-----------------------------------------------------------------
    TRY.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

        CLEAR ls_mesg.
        ls_mesg-msgty = 'S'.
        ls_mesg-msgid = lc_msgid.
        ls_mesg-msgno = '018'.
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
    " Step 11: Build Success Response
    "-----------------------------------------------------------------
    READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_success>)
      WITH KEY type = 'S'.

    IF sy-subrc = 0.
      ls_result-username = lv_username.
      ls_result-status   = <fs_success>-type.
      ls_result-message  = <fs_success>-message.
      APPEND ls_result TO ls_deep-statusresultset.
    ENDIF.

    " Set success message in response header
    ls_message-class      = lc_msgid.
    ls_message-number     = '018'.
    ls_message-variable_1 = lv_username.
    ls_message-severity   = 1.
    APPEND ls_message TO lt_message.

    io_response->set_header_messages( it_message = lt_message ).

    io_response->set_busi_data( ls_deep ).

    " Save final application log
    lr_applog->save_to_db( ).
    COMMIT WORK AND WAIT.

    lo_request_info ?= io_request.

    CREATE OBJECT mo_default_matcher TYPE cl_atd_matcher.
    "create controller
    CREATE OBJECT lo_controller TYPE cl_atd_controller
      EXPORTING
        io_matcher          = mo_default_matcher
        iv_double_type_name = lv_objname.

    ro_double = lo_controller->create_double( lv_objname ) .

    lo_expand_node  ?= ro_double.

    lo_request_info->set_source_expand_node( lo_expand_node ).

    ls_done_list-busi_data         = abap_true.
    ls_done_list-deep_busi_data    = abap_true.
    ls_done_list-partial_busi_data = abap_true.
    ls_done_list-expand            = abap_true.

    io_response->set_is_done( is_todo_list = ls_done_list ).

  ENDMETHOD.
ENDCLASS.
