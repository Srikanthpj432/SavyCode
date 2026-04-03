class /SAVY/CL_V4_USER_UNLOC_MPC_EXT definition
  public
  inheriting from /SAVY/CL_V4_USER_UNLOC_MPC
  create public .

public section.

  methods /IWBEP/IF_V4_MP_BASIC~DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_V4_USER_UNLOC_MPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_v4_mp_basic~define.

    CALL METHOD super->/iwbep/if_v4_mp_basic~define
      EXPORTING
        io_model      = io_model
        io_model_info = io_model_info.

    DATA: lo_action TYPE REF TO /iwbep/if_v4_med_action,
          lo_param  TYPE REF TO /iwbep/if_v4_med_act_param,
          lo_actimp TYPE REF TO /iwbep/if_v4_med_action_imp,
          lo_return TYPE REF TO /iwbep/if_v4_med_oper_return,
          lo_prim   TYPE REF TO /iwbep/if_v4_med_prim_type,
          lo_entity TYPE REF TO /iwbep/if_v4_med_entity_type.
    DATA  lv_username TYPE char12.

    lo_action = io_model->create_action( iv_action_name = 'USERUNLOCK' ).
    lo_action->set_edm_name( 'USERUNLOCK' ).
*
    lo_param = lo_action->create_parameter( iv_parameter_name = 'USERNAME' ).
    lo_param->set_edm_name( 'Username' ).
*
    lo_prim  = io_model->create_primitive_type_by_elem(
          iv_primitive_type_name = 'USERNAME'
          iv_element             = lv_username
    ).

    lo_param->/iwbep/if_v4_med_oper_param~set_primitive_type(
     iv_primitive_type_name = 'USERNAME' ).

    lo_return = lo_action->create_return( ).
*
*    " ← Get entity type from model first!
    lo_entity = io_model->get_entity_type( iv_entity_type_name = 'STATUSRESULT' ).

    lo_return->set_entity_type( iv_entity_type_name = 'STATUSRESULT' ).

    lo_actimp = lo_action->create_action_import( iv_action_import_name = 'USERUNLOCK' ).

    lo_actimp->set_entity_set_name( 'STATUSRESULTSET' ).
  ENDMETHOD.
ENDCLASS.
