class /SAVY/CL_USER_CHANGE_DPC_EXT definition
  public
  inheriting from /SAVY/CL_USER_CHANGE_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_USER_CHANGE_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.
**********************************************************************
* Method: User Change
* Purpose: User Change through an api Service Using bapi
* Logging: Application Log (slg1) and MESSAGE Container
* Author: SAVIYNT3(Optimized Version)
* Date: February 3rd, 2026
**********************************************************************

    DATA: BEGIN OF ltt_deep_struc,
            statusresultset TYPE TABLE OF /savy/cl_user_change_mpc=>ts_statusresult.
            INCLUDE TYPE /savy/cl_user_change_mpc=>ts_userchange.
    DATA:   parameterset TYPE TABLE OF /savy/cl_user_change_mpc=>ts_parameter,
            groupsset    TYPE TABLE OF /savy/cl_user_change_mpc=>ts_groups,
          END OF ltt_deep_struc.

    DATA: ls_deep        LIKE ltt_deep_struc,
          ls_deep_test   LIKE ltt_deep_struc,
          lv_username    TYPE bapibname-bapibname,
          ls_logon       TYPE bapilogond,
          ls_logonx      TYPE bapilogonx,
          ls_address     TYPE bapiaddr3,
          ls_addressx    TYPE bapiaddr3x,
          ls_defaults    TYPE bapidefaul,
          ls_defaultsx   TYPE bapidefax,
          ls_company     TYPE bapiuscomp,
          ls_companyx    TYPE bapiuscomx,
          ls_refuser     TYPE bapirefus,
          ls_refuserx    TYPE bapirefusx,
          ls_parameterx  TYPE bapiparamx,
          lt_parameter   TYPE TABLE OF bapiparam,
          lt_para_ref    TYPE ustyp_t_parameters,
          ls_groupsx     TYPE bapigroupx,
          lt_groups      TYPE TABLE OF bapigroups,
          lt_return      TYPE TABLE OF bapiret2,
          lv_msgtext     TYPE string,
          lx_exception   TYPE REF TO cx_root,
          lv_user_exists TYPE abap_bool,
          lv_str(255)    TYPE c,
          lo_msg         TYPE REF TO /iwbep/if_message_container,
          lr_applog      TYPE REF TO /savy/cl_app_log,
          ls_result      TYPE /savy/cl_user_change_mpc=>ts_statusresult,
          ls_mesg        TYPE bal_s_msg,
          lv_prefer      TYPE string.

    CONSTANTS: lc_subrc_success TYPE sy-subrc VALUE 0,
               lc_user_unlocked TYPE usr02-uflag VALUE '0'.

    " Initialize application log
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
      CATCH cx_sy_create_object_error.
        MESSAGE i002(/savy/messages).
        RETURN.
    ENDTRY.

    " Get message container
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
        lr_applog->save_to_db( ).

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception
          EXPORTING
            textid   = /iwbep/cx_mgw_tech_exception=>internal_error
            previous = lx_exception.
    ENDTRY.

    " Check authorization to display user
    AUTHORITY-CHECK OBJECT '/SAVY/USER'
      ID '/SAVY/USER' FIELD sy-uname
      ID 'ACTVT'      FIELD '02'.

    IF sy-subrc <> 0.
      lo_msg->add_message(
      iv_msg_type   = /iwbep/cl_cos_logger=>error
      iv_msg_id     = '/SAVY/MESSAGES'
      iv_msg_number = '071').

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = lo_msg.
    ENDIF.

    " Read entry data
    TRY.
        io_data_provider->read_entry_data( IMPORTING es_data = ls_deep ).

        IF 1 = 2.
          MESSAGE i072(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '072'.
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

        lr_applog->save_to_db( ).

        lo_msg->add_message(
          iv_msg_type   = /iwbep/cl_cos_logger=>error
          iv_msg_id     = '/SAVY/MESSAGES'
          iv_msg_number = '006').

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = lo_msg.
    ENDTRY.

    lv_username     = ls_deep-username.
    TRANSLATE lv_username TO UPPER CASE.
    ls_deep-version = /savy/cl_app_log=>gv_version.

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

      lr_applog->save_to_db( ).

      lo_msg->add_message(
        iv_msg_type   = /iwbep/cl_cos_logger=>error
        iv_msg_id     = '/SAVY/MESSAGES'
        iv_msg_number = '008' ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = lo_msg.
    ENDIF.

    " Check if user exists or not
    TRY.
        SELECT SINGLE @abap_true
          FROM usr02
          WHERE bname = @lv_username
            AND uflag = @lc_user_unlocked
          INTO @lv_user_exists.

        IF sy-subrc <> lc_subrc_success.

          IF 1 = 2.
            MESSAGE i073(/savy/messages).
          ENDIF.
          CLEAR ls_mesg.
          ls_mesg-msgty = 'E'.
          ls_mesg-msgid = '/SAVY/MESSAGES'.
          ls_mesg-msgno = '073'.
          ls_mesg-msgv1 = lv_username.
          IF lr_applog IS BOUND.
            lr_applog->msg_add_log( im_msg = ls_mesg ).
          ENDIF.

          lr_applog->save_to_db( ).

          lo_msg->add_message(
            iv_msg_type   = /iwbep/cl_cos_logger=>error
            iv_msg_id     = '/SAVY/MESSAGES'
            iv_msg_number = '073' ).

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

        lr_applog->save_to_db( ).

        lo_msg->add_message(
          iv_msg_type   = /iwbep/cl_cos_logger=>error
          iv_msg_id     = '/SAVY/MESSAGES'
          iv_msg_number = '011' ).

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = lo_msg.
    ENDTRY.

    " Process reference user parameters
    ls_refuser = ls_deep-ref_user.
    IF ls_refuser-ref_user IS NOT INITIAL.
      IF 1 = 2.
        MESSAGE i012(/savy/messages).
      ENDIF.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'I'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '012'.
      ls_mesg-msgv1 = ls_refuser-ref_user.
      IF lr_applog IS BOUND.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
      ENDIF.

      CALL FUNCTION 'SUSR_USER_PARAMETERS_GET'
        EXPORTING
          user_name           = ls_refuser-ref_user
          with_text           = 'X'
        TABLES
          user_parameters     = lt_para_ref
        EXCEPTIONS
          user_name_not_exist = 1
          OTHERS              = 2.

      IF sy-subrc = 0.

        IF 1 = 2.
          MESSAGE i013(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '013'.
        ls_mesg-msgv1 = ls_refuser-ref_user.
        ls_mesg-msgv2 = lines( lt_para_ref ).
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.

      ELSE.

        IF 1 = 2.
          MESSAGE i014(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'I'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '014'.
        ls_mesg-msgv1 = ls_refuser-ref_user.
        IF lr_applog IS BOUND.
          lr_applog->msg_add_log( im_msg = ls_mesg ).
        ENDIF.

      ENDIF.
    ENDIF.

    " Map input data to BAPI structures
    ls_logon      = ls_deep-logondata.
    ls_logonx     = ls_deep-logondatax.
    ls_defaults   = ls_deep-defaults.
    ls_defaultsx  = ls_deep-defaultsx.
    ls_address    = ls_deep-address.
    ls_addressx   = ls_deep-addressx.
    ls_company    = ls_deep-company.
    ls_companyx   = ls_deep-companyx.
    ls_parameterx = ls_deep-parameterx.
    ls_groupsx    = ls_deep-groupsx.

    " Merge parameters
    lt_parameter = ls_deep-parameterset.
    APPEND LINES OF lt_para_ref TO lt_parameter.
    SORT lt_parameter BY parid.
    DELETE ADJACENT DUPLICATES FROM lt_parameter COMPARING parid.  " OPTIMIZED: Specify key field

    " Groups
    lt_groups = ls_deep-groupsset.

    IF 1 = 2.
      MESSAGE i074(/savy/messages).
    ENDIF.
    CLEAR ls_mesg.
    ls_mesg-msgty = 'I'.
    ls_mesg-msgid = '/SAVY/MESSAGES'.
    ls_mesg-msgno = '074'.
    ls_mesg-msgv1 = lv_username.
    IF lr_applog IS BOUND.
      lr_applog->msg_add_log( im_msg = ls_mesg ).
    ENDIF.

    TRY.
        CALL FUNCTION 'BAPI_USER_CHANGE'
          EXPORTING
            username   = lv_username
            logondata  = ls_logon
            logondatax = ls_logonx
            defaults   = ls_defaults
            defaultsx  = ls_defaultsx
            address    = ls_Address
            addressx   = ls_addressx
            parameterx = ls_parameterx
            company    = ls_company
            companyx   = ls_companyx
            ref_user   = ls_refuser
            ref_userx  = ls_refuserx
            groupsx    = ls_groupsx
          TABLES
            parameter  = lt_parameter
            return     = lt_return
            groups     = lt_groups.

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
        MESSAGE i075(/savy/messages).
      ENDIF.
      CLEAR ls_mesg.
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '075'.
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

    " Commit the transaction
    TRY.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

        IF 1 = 2.
          MESSAGE i076(/savy/messages).
        ENDIF.
        CLEAR ls_mesg.
        ls_mesg-msgty = 'S'.
        ls_mesg-msgid = '/SAVY/MESSAGES'.
        ls_mesg-msgno = '076'.
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
        lr_applog->save_to_db( ).

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

*    " Return deep entity
    copy_data_to_ref(
      EXPORTING is_data = ls_deep
      CHANGING  cr_data = er_deep_entity ).

  ENDMETHOD.
ENDCLASS.
