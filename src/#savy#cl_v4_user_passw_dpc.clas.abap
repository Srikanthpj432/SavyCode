class /SAVY/CL_V4_USER_PASSW_DPC definition
  public
  inheriting from /IWBEP/CL_V4_ABS_DATA_PROVIDER
  create public .

public section.

  methods /IWBEP/IF_V4_DP_BASIC~READ_ENTITY_LIST
    redefinition .
  methods /IWBEP/IF_V4_DP_BASIC~CREATE_ENTITY
    redefinition .
  methods /IWBEP/IF_V4_DP_BASIC~READ_ENTITY
    redefinition .
  methods /IWBEP/IF_V4_DP_BASIC~UPDATE_ENTITY
    redefinition .
  methods /IWBEP/IF_V4_DP_BASIC~DELETE_ENTITY
    redefinition .
protected section.

  methods STATUSRESULTSET_CREATE
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_CREATE
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_CREATE
    raising
      /IWBEP/CX_GATEWAY .
  methods STATUSRESULTSET_DELETE
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_DELETE
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_DELETE
    raising
      /IWBEP/CX_GATEWAY .
  methods STATUSRESULTSET_READ
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_READ
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_READ
    raising
      /IWBEP/CX_GATEWAY .
  methods STATUSRESULTSET_READ_LIST
    importing
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_LIST
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_LIST
    raising
      /IWBEP/CX_GATEWAY .
  methods STATUSRESULTSET_UPDATE
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_UPDATE
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_UPDATE
    raising
      /IWBEP/CX_GATEWAY .
  methods USERNEWPASSWORDS_CREATE
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_CREATE
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_CREATE
    raising
      /IWBEP/CX_GATEWAY .
  methods USERNEWPASSWORDS_DELETE
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_DELETE
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_DELETE
    raising
      /IWBEP/CX_GATEWAY .
  methods USERNEWPASSWORDS_READ
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_READ
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_READ
    raising
      /IWBEP/CX_GATEWAY .
  methods USERNEWPASSWORDS_READ_LIST
    importing
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_LIST
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_LIST
    raising
      /IWBEP/CX_GATEWAY .
  methods USERNEWPASSWORDS_UPDATE
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_UPDATE
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_UPDATE
    raising
      /IWBEP/CX_GATEWAY .
private section.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_PASSW_DPC IMPLEMENTATION.


  method /IWBEP/IF_V4_DP_BASIC~CREATE_ENTITY.
*&-----------------------------------------------------------------------------------------------*
*&* This class has been generated  on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

  DATA lv_entityset_name TYPE /iwbep/if_v4_med_element=>ty_e_med_internal_name.

  io_request->get_entity_set( IMPORTING ev_entity_set_name = lv_entityset_name ).

  CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  StatusresultSet
*-------------------------------------------------------------------------*
    WHEN 'STATUSRESULTSET'.
*     Call the entity set generated method
      statusresultset_create(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

*-------------------------------------------------------------------------*
*             EntitySet -  UserNewpasswordSet
*-------------------------------------------------------------------------*
    WHEN 'USERNEWPASSWORDSET'.
*     Call the entity set generated method
      usernewpasswords_create(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

    WHEN OTHERS.
      super->/iwbep/if_v4_dp_basic~create_entity( io_request  = io_request
                                                  io_Response = io_response ).
  ENDCASE.
  endmethod.


  method /IWBEP/IF_V4_DP_BASIC~DELETE_ENTITY.
*&-----------------------------------------------------------------------------------------------*
*&* This class has been generated  on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside the DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

  DATA lv_entityset_name TYPE /iwbep/if_v4_med_element=>ty_e_med_internal_name.

  io_request->get_entity_set( IMPORTING ev_entity_set_name = lv_entityset_name ).

  CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  StatusresultSet
*-------------------------------------------------------------------------*
    WHEN 'STATUSRESULTSET'.
*     Call the entity set generated method
      statusresultset_delete(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

*-------------------------------------------------------------------------*
*             EntitySet -  UserNewpasswordSet
*-------------------------------------------------------------------------*
    WHEN 'USERNEWPASSWORDSET'.
*     Call the entity set generated method
      usernewpasswords_delete(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

    WHEN OTHERS.
      super->/iwbep/if_v4_dp_basic~delete_entity( io_request  = io_request
                                                  io_response = io_response ).
  ENDCASE.
  endmethod.


  method /IWBEP/IF_V4_DP_BASIC~READ_ENTITY.
*&-----------------------------------------------------------------------------------------------*
*&* This class has been generated  on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

  DATA lv_entityset_name TYPE /iwbep/if_v4_med_element=>ty_e_med_internal_name.

  io_request->get_entity_set( IMPORTING ev_entity_set_name = lv_entityset_name ).

  CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  StatusresultSet
*-------------------------------------------------------------------------*
    WHEN 'STATUSRESULTSET'.
*     Call the entity set generated method
      statusresultset_read(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

*-------------------------------------------------------------------------*
*             EntitySet -  UserNewpasswordSet
*-------------------------------------------------------------------------*
    WHEN 'USERNEWPASSWORDSET'.
*     Call the entity set generated method
      usernewpasswords_read(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

    WHEN OTHERS.
      super->/iwbep/if_v4_dp_basic~read_entity( io_request  = io_request
                                                io_response = io_response ).


  ENDCASE.
  endmethod.


  method /IWBEP/IF_V4_DP_BASIC~READ_ENTITY_LIST.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

  DATA lv_entityset_name TYPE /iwbep/if_v4_med_element=>ty_e_med_internal_name.

  io_request->get_entity_set( IMPORTING ev_entity_set_name = lv_entityset_name ).

  CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  StatusresultSet
*-------------------------------------------------------------------------*
    WHEN 'STATUSRESULTSET'.
*     Call the entity set generated method
      statusresultset_read_list(
        EXPORTING
          io_request  = io_request
          io_response = io_response
       ).
*-------------------------------------------------------------------------*
*             EntitySet -  UserNewpasswordSet
*-------------------------------------------------------------------------*
    WHEN 'USERNEWPASSWORDSET'.
*     Call the entity set generated method
      usernewpasswords_read_list(
        EXPORTING
          io_request  = io_request
          io_response = io_response
       ).
    WHEN OTHERS.
      super->/iwbep/if_v4_dp_basic~read_entity_list( io_Request  = io_request
                                                     io_response = io_response ).
  ENDCASE.
  endmethod.


  method /IWBEP/IF_V4_DP_BASIC~UPDATE_ENTITY.
*&-----------------------------------------------------------------------------------------------*
*&* This class has been generated  on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

  DATA lv_entityset_name TYPE /iwbep/if_v4_med_element=>ty_e_med_internal_name.

  io_request->get_entity_set( IMPORTING ev_entity_set_name = lv_entityset_name ).

  CASE lv_entityset_name.
*-------------------------------------------------------------------------*
*             EntitySet -  StatusresultSet
*-------------------------------------------------------------------------*
    WHEN 'STATUSRESULTSET'.
*     Call the entity set generated method
      statusresultset_update(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

*-------------------------------------------------------------------------*
*             EntitySet -  UserNewpasswordSet
*-------------------------------------------------------------------------*
    WHEN 'USERNEWPASSWORDSET'.
*     Call the entity set generated method
      usernewpasswords_update(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

    WHEN OTHERS.
      super->/iwbep/if_v4_dp_basic~update_entity( io_request  = io_request
                                                  io_response = io_Response ).
  ENDCASE.
  endmethod.


  method STATUSRESULTSET_CREATE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_statusresult  TYPE /savy/cl_v4_user_passw_mpc=>ts_statusresult.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_create=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_create=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method STATUSRESULTSET_DELETE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_statusresult TYPE /savy/cl_v4_user_passw_mpc=>ts_statusresult.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_delete=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_delete=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method STATUSRESULTSET_READ.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_statusresult TYPE /savy/cl_v4_user_passw_mpc=>ts_statusresult.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_read=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_read=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method STATUSRESULTSET_READ_LIST.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA lt_statusresult TYPE /savy/cl_v4_user_passw_mpc=>tt_statusresult.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_list=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_list=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method STATUSRESULTSET_UPDATE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_statusresult TYPE /savy/cl_v4_user_passw_mpc=>ts_statusresult.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_update=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_update=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERNEWPASSWORDS_CREATE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_usernewpassword  TYPE /savy/cl_v4_user_passw_mpc=>ts_usernewpassword.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_create=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_create=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERNEWPASSWORDS_DELETE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_usernewpassword TYPE /savy/cl_v4_user_passw_mpc=>ts_usernewpassword.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_delete=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_delete=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERNEWPASSWORDS_READ.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_usernewpassword TYPE /savy/cl_v4_user_passw_mpc=>ts_usernewpassword.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_read=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_read=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERNEWPASSWORDS_READ_LIST.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA lt_usernewpassword TYPE /savy/cl_v4_user_passw_mpc=>tt_usernewpassword.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_list=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_list=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERNEWPASSWORDS_UPDATE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 23.03.2026 18:12:42 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_PASSW_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_usernewpassword TYPE /savy/cl_v4_user_passw_mpc=>ts_usernewpassword.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_update=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_update=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.
ENDCLASS.
