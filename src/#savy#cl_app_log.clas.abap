class /SAVY/CL_APP_LOG definition
  public
  final
  create public .

public section.

  data GV_LOG_HANDLE type BALLOGHNDL .
  class-data GV_VERSION type CHAR10 value '1.0' ##NO_TEXT.
  data GV_OBJECT type BALOBJ_D .
  data GV_SUBOBJECT type BALSUBOBJ .
  constants GC_SUCCESS type CHAR1 value 'S' ##NO_TEXT.
  constants GC_ERROR type CHAR1 value 'E' ##NO_TEXT.

  methods MSG_ADD_LOG
    importing
      !IM_TEXT type CHAR255 optional
      !IM_MSGTYPE type CHAR1 optional
      !IM_MSG type BAL_S_MSG optional .
  methods SAVE_TO_DB
    exceptions
      LOG_NOT_FOUND
      SAVE_NOT_ALLOWED .
protected section.
private section.

  constants GC_MAIN_LOG type BALOBJ_D value '/SAVY/ROOT' ##NO_TEXT.
  constants GC_SUB_LOG type BALSUBOBJ value '/SAVY/IAM' ##NO_TEXT.
ENDCLASS.



CLASS /SAVY/CL_APP_LOG IMPLEMENTATION.


  METHOD msg_add_log.

    IF gv_log_handle IS INITIAL .
      DATA : ls_log TYPE bal_s_log.        "log variable

      ls_log-object    = gv_object.           "gc_main_log.
      ls_log-subobject = gv_subobject.        "gc_sub_log.
      ls_log-extnumber = sy-uname.
      ls_log-aldate    = sy-datum.
      ls_log-altime    = sy-uzeit.
      ls_log-aluser    = sy-uname.
      ls_log-altcode   = sy-tcode.
      ls_log-alprog    = sy-cprog.
      ls_log-almode    = sy-binpt.

* Create an internal log file
      CALL FUNCTION 'BAL_LOG_CREATE'
        EXPORTING
          i_s_log      = ls_log
        IMPORTING
          e_log_handle = gv_log_handle
        EXCEPTIONS
          OTHERS       = 1.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDIF.

************************************************************************
* Add the message
************************************************************************
  CALL FUNCTION 'BAL_LOG_MSG_ADD'
    EXPORTING
      i_log_handle     = gv_log_handle
      i_s_msg          = im_msg
    EXCEPTIONS
      log_not_found    = 1
      msg_inconsistent = 2
      log_is_full      = 3
      OTHERS           = 4.

*** Function for adding text to the application log
**    CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
**      EXPORTING
**        i_log_handle     = gv_log_handle
**        i_msgty          = im_msgtype
**        i_text           = im_text
**      EXCEPTIONS
**        log_not_found    = 1
**        msg_inconsistent = 2
**        log_is_full      = 3
**        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.


  METHOD save_to_db.

    DATA l_t_log_handle TYPE bal_t_logh.

* check if the log handle is initial.
    IF gv_log_handle IS INITIAL.
      RAISE log_not_found.
    ENDIF.

* Initialization
    APPEND gv_log_handle TO l_t_log_handle.

************************************************************************
* Save the application log to the database
************************************************************************
    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_client         = sy-mandt
        i_in_update_task = ' '
        i_save_all       = ' '
        i_t_log_handle   = l_t_log_handle
* IMPORTING
*       E_NEW_LOGNUMBERS =
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.

    IF sy-subrc <> 0.
      RAISE save_not_allowed.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
