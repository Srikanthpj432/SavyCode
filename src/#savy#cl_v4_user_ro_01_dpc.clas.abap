class /SAVY/CL_V4_USER_RO_01_DPC definition
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
  methods /IWBEP/IF_V4_DP_BASIC~READ_REF_TARGET_KEY_DATA_LIST
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
  methods USERROLESSET_CREATE
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_CREATE
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_CREATE
    raising
      /IWBEP/CX_GATEWAY .
  methods USERROLESSET_DELETE
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_DELETE
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_DELETE
    raising
      /IWBEP/CX_GATEWAY .
  methods USERROLESSET_READ
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_READ
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_READ
    raising
      /IWBEP/CX_GATEWAY .
  methods USERROLESSET_READ_LIST
    importing
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_LIST
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_LIST
    raising
      /IWBEP/CX_GATEWAY .
  methods USERROLESSET_UPDATE
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_UPDATE
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_UPDATE
    raising
      /IWBEP/CX_GATEWAY .
  methods USERUNASSIGNSET_CREATE
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_CREATE
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_CREATE
    raising
      /IWBEP/CX_GATEWAY .
  methods USERUNASSIGNSET_DELETE
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_DELETE
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_DELETE
    raising
      /IWBEP/CX_GATEWAY .
  methods USERUNASSIGNSET_READ
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_READ
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_READ
    raising
      /IWBEP/CX_GATEWAY .
  methods USERUNASSIGNSET_READ_LIST
    importing
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_LIST
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_LIST
    raising
      /IWBEP/CX_GATEWAY .
  methods USERUNASSIGNSET_UPDATE
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_UPDATE
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_UPDATE
    raising
      /IWBEP/CX_GATEWAY .
  methods USERUNASSIGN_READ_REF_KEY_LIST
    importing
      !IO_RESPONSE type ref to /IWBEP/IF_V4_RESP_BASIC_REF_L
      !IO_REQUEST type ref to /IWBEP/IF_V4_REQU_BASIC_REF_L
    raising
      /IWBEP/CX_GATEWAY .
private section.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_RO_01_DPC IMPLEMENTATION.


  method /IWBEP/IF_V4_DP_BASIC~CREATE_ENTITY.
*&-----------------------------------------------------------------------------------------------*
*&* This class has been generated  on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
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
*             EntitySet -  UserrolesSet
*-------------------------------------------------------------------------*
    WHEN 'USERROLESSET'.
*     Call the entity set generated method
      userrolesset_create(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

*-------------------------------------------------------------------------*
*             EntitySet -  UserunassignSet
*-------------------------------------------------------------------------*
    WHEN 'USERUNASSIGNSET'.
*     Call the entity set generated method
      userunassignset_create(
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
*&* This class has been generated  on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside the DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
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
*             EntitySet -  UserrolesSet
*-------------------------------------------------------------------------*
    WHEN 'USERROLESSET'.
*     Call the entity set generated method
      userrolesset_delete(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

*-------------------------------------------------------------------------*
*             EntitySet -  UserunassignSet
*-------------------------------------------------------------------------*
    WHEN 'USERUNASSIGNSET'.
*     Call the entity set generated method
      userunassignset_delete(
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
*&* This class has been generated  on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
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
*             EntitySet -  UserrolesSet
*-------------------------------------------------------------------------*
    WHEN 'USERROLESSET'.
*     Call the entity set generated method
      userrolesset_read(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

*-------------------------------------------------------------------------*
*             EntitySet -  UserunassignSet
*-------------------------------------------------------------------------*
    WHEN 'USERUNASSIGNSET'.
*     Call the entity set generated method
      userunassignset_read(
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
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
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
*             EntitySet -  UserrolesSet
*-------------------------------------------------------------------------*
    WHEN 'USERROLESSET'.
*     Call the entity set generated method
      userrolesset_read_list(
        EXPORTING
          io_request  = io_request
          io_response = io_response
       ).
*-------------------------------------------------------------------------*
*             EntitySet -  UserunassignSet
*-------------------------------------------------------------------------*
    WHEN 'USERUNASSIGNSET'.
*     Call the entity set generated method
      userunassignset_read_list(
        EXPORTING
          io_request  = io_request
          io_response = io_response
       ).
    WHEN OTHERS.
      super->/iwbep/if_v4_dp_basic~read_entity_list( io_Request  = io_request
                                                     io_response = io_response ).
  ENDCASE.
  endmethod.


  method /IWBEP/IF_V4_DP_BASIC~READ_REF_TARGET_KEY_DATA_LIST.
*&-----------------------------------------------------------------------------------------------*
*&* This class has been generated  on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC provider subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

  DATA lv_source_entity_name TYPE /iwbep/if_v4_med_element=>ty_e_med_internal_name.

  io_request->get_source_entity_type( IMPORTING ev_source_entity_type_name = lv_source_entity_name ).

  CASE lv_source_entity_name.
*-------------------------------------------------------------------------*
*             Entity -  Userunassign
*-------------------------------------------------------------------------*
    WHEN 'USERUNASSIGN'.
*     Call the entity type generated method
      userunassign_read_ref_key_list(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

    WHEN OTHERS.
      super->/iwbep/if_v4_dp_basic~read_ref_target_key_data_list( io_request  = io_request
                                                                  io_response = io_response ).
  ENDCASE.
  endmethod.


  method /IWBEP/IF_V4_DP_BASIC~UPDATE_ENTITY.
*&-----------------------------------------------------------------------------------------------*
*&* This class has been generated  on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
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
*             EntitySet -  UserrolesSet
*-------------------------------------------------------------------------*
    WHEN 'USERROLESSET'.
*     Call the entity set generated method
      userrolesset_update(
           EXPORTING io_request  = io_request
                     io_response = io_response
                       ).

*-------------------------------------------------------------------------*
*             EntitySet -  UserunassignSet
*-------------------------------------------------------------------------*
    WHEN 'USERUNASSIGNSET'.
*     Call the entity set generated method
      userunassignset_update(
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
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_statusresult  TYPE /savy/cl_v4_user_ro_01_mpc=>ts_statusresult.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_create=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_create=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method STATUSRESULTSET_DELETE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_statusresult TYPE /savy/cl_v4_user_ro_01_mpc=>ts_statusresult.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_delete=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_delete=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method STATUSRESULTSET_READ.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_statusresult TYPE /savy/cl_v4_user_ro_01_mpc=>ts_statusresult.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_read=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_read=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method STATUSRESULTSET_READ_LIST.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA lt_statusresult TYPE /savy/cl_v4_user_ro_01_mpc=>tt_statusresult.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_list=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_list=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method STATUSRESULTSET_UPDATE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_statusresult TYPE /savy/cl_v4_user_ro_01_mpc=>ts_statusresult.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_update=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_update=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERROLESSET_CREATE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_userroles  TYPE /savy/cl_v4_user_ro_01_mpc=>ts_userroles.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_create=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_create=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERROLESSET_DELETE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_userroles TYPE /savy/cl_v4_user_ro_01_mpc=>ts_userroles.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_delete=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_delete=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERROLESSET_READ.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_userroles TYPE /savy/cl_v4_user_ro_01_mpc=>ts_userroles.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_read=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_read=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERROLESSET_READ_LIST.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA lt_userroles TYPE /savy/cl_v4_user_ro_01_mpc=>tt_userroles.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_list=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_list=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERROLESSET_UPDATE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_userroles TYPE /savy/cl_v4_user_ro_01_mpc=>ts_userroles.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_update=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_update=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERUNASSIGNSET_CREATE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_userunassign  TYPE /savy/cl_v4_user_ro_01_mpc=>ts_userunassign.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_create=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_create=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERUNASSIGNSET_DELETE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_userunassign TYPE /savy/cl_v4_user_ro_01_mpc=>ts_userunassign.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_delete=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_delete=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERUNASSIGNSET_READ.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_userunassign TYPE /savy/cl_v4_user_ro_01_mpc=>ts_userunassign.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_read=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_read=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERUNASSIGNSET_READ_LIST.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA lt_userunassign TYPE /savy/cl_v4_user_ro_01_mpc=>tt_userunassign.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_list=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_list=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERUNASSIGNSET_UPDATE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

*Used for setting business data
*  DATA ls_userunassign TYPE /savy/cl_v4_user_ro_01_mpc=>ts_userunassign.

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_update=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_update=>ty_s_todo_process_list.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.


  method USERUNASSIGN_READ_REF_KEY_LIST.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 16:08:00 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the DPC implementation, use the
*&*   generated methods inside DPC subclass - /SAVY/CL_V4_USER_RO_01_DPC_EXT
*&-----------------------------------------------------------------------------------------------*

  DATA ls_todo_list TYPE /iwbep/if_v4_requ_basic_ref_l=>ty_s_todo_list. "#EC NEEDED
  DATA ls_done_list TYPE /iwbep/if_v4_requ_basic_ref_l=>ty_s_todo_process_list.
  DATA lv_nav_property_name TYPE /iwbep/if_v4_med_element=>ty_e_med_internal_name.

* Get the request options the application should/must handle
  io_request->get_todos( IMPORTING es_todo_list = ls_todo_list ).

  io_request->get_navigation_prop( IMPORTING ev_navigation_prop_name = lv_nav_property_name ).

  CASE lv_nav_property_name.
    WHEN 'USERUNASSIGNTOACTIVITYGROUPS'.
    WHEN OTHERS.
  ENDCASE.

* Report list of request options handled by application
  io_response->set_is_done( ls_done_list ).
  endmethod.
ENDCLASS.
