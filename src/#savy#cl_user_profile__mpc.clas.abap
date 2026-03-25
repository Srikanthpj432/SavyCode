class /SAVY/CL_USER_PROFILE__MPC definition
  public
  inheriting from /IWBEP/CL_V4_ABS_MODEL_PROV
  create public .

public section.

  types:
     begin of TS_USERPROFILEASSIGN,
         USERNAME type STRING,
         VERSION type STRING,
     end of TS_USERPROFILEASSIGN .
  types:
     TT_USERPROFILEASSIGN type standard table of TS_USERPROFILEASSIGN .

  methods /IWBEP/IF_V4_MP_BASIC~DEFINE
    redefinition .
protected section.
private section.

  methods DEFINE_USERPROFILEASSIGN
    importing
      !IO_MODEL type ref to /IWBEP/IF_V4_MED_MODEL
    raising
      /IWBEP/CX_GATEWAY .
ENDCLASS.



CLASS /SAVY/CL_USER_PROFILE__MPC IMPLEMENTATION.


  method /IWBEP/IF_V4_MP_BASIC~DEFINE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 12.01.2026 17:55:52 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - /SAVY/CL_USER_PROFILE__MPC_EXT
*&-----------------------------------------------------------------------------------------------*
  define_userprofileassign( io_model ).
  endmethod.


  method DEFINE_USERPROFILEASSIGN.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 12.01.2026 17:55:52 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - /SAVY/CL_USER_PROFILE__MPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA lo_entity_type    TYPE REF TO /iwbep/if_v4_med_entity_type.
 DATA lo_property       TYPE REF TO /iwbep/if_v4_med_prim_prop.
 DATA lo_entity_set     TYPE REF TO /iwbep/if_v4_med_entity_set.
***********************************************************************************************************************************
*   ENTITY - UserProfileAssign
***********************************************************************************************************************************
 lo_entity_type = io_model->create_entity_type( iv_entity_type_name = 'USERPROFILEASSIGN' ). "#EC NOTEXT

 lo_entity_type->set_edm_name( 'UserProfileAssign' ).       "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'USERNAME' ). "#EC NOTEXT
 lo_property->set_edm_name( 'Username' ).                   "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_is_key( ).

 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'VERSION' ). "#EC NOTEXT
 lo_property->set_edm_name( 'Version' ).                    "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
 lo_entity_set = lo_entity_type->create_entity_set( 'USERPROFILEASSIGNSET' ). "#EC NOTEXT
 lo_entity_set->set_edm_name( 'UserProfileAssignSet' ).     "#EC NOTEXT
  endmethod.
ENDCLASS.
