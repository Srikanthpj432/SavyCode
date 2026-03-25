class /SAVY/CL_V4_USER_CHANG_DPC_EXT definition
  public
  inheriting from /SAVY/CL_V4_USER_CHANG_DPC
  create public .

public section.

  methods /IWBEP/IF_V4_DP_ADVANCED~CREATE_ENTITY
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_CHANG_DPC_EXT IMPLEMENTATION.


  method /IWBEP/IF_V4_DP_ADVANCED~CREATE_ENTITY.
**TRY.
*CALL METHOD SUPER->/IWBEP/IF_V4_DP_ADVANCED~CREATE_ENTITY
*  EXPORTING
*    IO_REQUEST  =
*    IO_RESPONSE =
*    .
**  CATCH /iwbep/cx_gateway.
**ENDTRY.

    DATA: BEGIN OF ltt_deep_struc,
            statusresultset TYPE TABLE OF /SAVY/CL_V4_USER_CHANG_mpc=>ts_statusresult.
            INCLUDE TYPE /SAVY/CL_V4_USER_CHANG_mpc=>ts_userchange.
    DATA:   parameterset TYPE TABLE OF /SAVY/CL_V4_USER_CHANG_mpc=>ts_parameter,
            groupsset    TYPE TABLE OF /SAVY/CL_V4_USER_CHANG_mpc=>ts_groups,
          END OF ltt_deep_struc.

    DATA: ls_deep        LIKE ltt_deep_struc,
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
          lr_applog      TYPE REF TO /savy/cl_app_log,
          ls_result      TYPE /SAVY/CL_V4_USER_CHANG_mpc=>ts_statusresult,
          ls_mesg        TYPE bal_s_msg.

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

    " Check authorization
    AUTHORITY-CHECK OBJECT '/SAVY/USER'
      ID '/SAVY/USER' FIELD sy-uname
      ID 'ACTVT'      FIELD '02'.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
        EXPORTING
          http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-forbidden.
    ENDIF.

    " Read entry data - V4 WAY
    TRY.
        io_request->get_busi_data( IMPORTING es_busi_data = ls_deep ).

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

    lv_username     = ls_deep-username.
    TRANSLATE lv_username TO UPPER CASE.
    ls_deep-version = /savy/cl_app_log=>gv_version.

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

    " Check if user exists
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
          ls_mesg-msgno = '073'.
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

    " Process reference user parameters
    ls_refuser = ls_deep-ref_user.
    IF ls_refuser-ref_user IS NOT INITIAL.
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
    DELETE ADJACENT DUPLICATES FROM lt_parameter COMPARING parid.

    " Groups
    lt_groups = ls_deep-groupsset.

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
            address    = ls_address
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
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      CLEAR ls_mesg.
      ls_mesg-msgty = 'E'.
      ls_mesg-msgid = '/SAVY/MESSAGES'.
      ls_mesg-msgno = '075'.
      ls_mesg-msgv1 = lv_username.
      IF lr_applog IS BOUND.
        lr_applog->msg_add_log( im_msg = ls_mesg ).
      ENDIF.
      lr_applog->save_to_db( ).

      RAISE EXCEPTION TYPE /iwbep/cx_v4_not_implemented
        EXPORTING
          http_status_code = /iwbep/cx_v4_not_implemented=>gcs_http_status_codes-bad_request.
    ENDIF.

    " Commit the transaction
    TRY.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

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

    " Save application log
    lr_applog->save_to_db( ).

    " Return response - V4 WAY
    io_response->set_busi_data( ls_deep ).

  endmethod.
ENDCLASS.
