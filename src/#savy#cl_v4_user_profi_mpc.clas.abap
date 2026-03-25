class /SAVY/CL_V4_USER_PROFI_MPC definition
  public
  inheriting from /IWBEP/CL_V4_ABS_MODEL_PROV
  create public .

public section.

  types:
     begin of TS_STATUSRESULT,
         MESSAGE type C length 70,
         STATUS type C length 10,
         USERNAME type C length 12,
     end of TS_STATUSRESULT .
  types:
     TT_STATUSRESULT type standard table of TS_STATUSRESULT .
  types:
     begin of TS_USERASSIGN,
         STATUS type C length 200,
         VERSION type C length 10,
         USERNAME type C length 12,
     end of TS_USERASSIGN .
  types:
     TT_USERASSIGN type standard table of TS_USERASSIGN .
  types:
     begin of TS_USERPROFILES,
         BAPIPROF type C length 12,
     end of TS_USERPROFILES .
  types:
     TT_USERPROFILES type standard table of TS_USERPROFILES .

  methods /IWBEP/IF_V4_MP_BASIC~DEFINE
    redefinition .
protected section.
private section.

  methods DEFINE_USERPROFILES
    importing
      !IO_MODEL type ref to /IWBEP/IF_V4_MED_MODEL
    raising
      /IWBEP/CX_GATEWAY .
  methods DEFINE_STATUSRESULT
    importing
      !IO_MODEL type ref to /IWBEP/IF_V4_MED_MODEL
    raising
      /IWBEP/CX_GATEWAY .
  methods DEFINE_USERASSIGN
    importing
      !IO_MODEL type ref to /IWBEP/IF_V4_MED_MODEL
    raising
      /IWBEP/CX_GATEWAY .
ENDCLASS.



CLASS /SAVY/CL_V4_USER_PROFI_MPC IMPLEMENTATION.


  method /IWBEP/IF_V4_MP_BASIC~DEFINE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 10:51:12 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - /SAVY/CL_V4_USER_PROFI_MPC_EXT
*&-----------------------------------------------------------------------------------------------*
  define_statusresult( io_model ).
  define_userassign( io_model ).
  define_userprofiles( io_model ).
  endmethod.


  method DEFINE_STATUSRESULT.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 10:51:12 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - /SAVY/CL_V4_USER_PROFI_MPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA lo_entity_type    TYPE REF TO /iwbep/if_v4_med_entity_type.
 DATA lo_property       TYPE REF TO /iwbep/if_v4_med_prim_prop.
 DATA lo_entity_set     TYPE REF TO /iwbep/if_v4_med_entity_set.
***********************************************************************************************************************************
*   ENTITY - Statusresult
***********************************************************************************************************************************
 lo_entity_type = io_model->create_entity_type( iv_entity_type_name = 'STATUSRESULT' ). "#EC NOTEXT

 lo_entity_type->set_edm_name( 'Statusresult' ).            "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'MESSAGE' ). "#EC NOTEXT
 lo_property->set_edm_name( 'Message' ).                    "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_max_length( iv_max_length = '70' ).       "#EC NOTEXT

 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'STATUS' ). "#EC NOTEXT
 lo_property->set_edm_name( 'Status' ).                     "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_max_length( iv_max_length = '10' ).       "#EC NOTEXT

 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'USERNAME' ). "#EC NOTEXT
 lo_property->set_edm_name( 'Username' ).                   "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_is_key( ).
 lo_property->set_max_length( iv_max_length = '12' ).       "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
 lo_entity_set = lo_entity_type->create_entity_set( 'STATUSRESULTSET' ). "#EC NOTEXT
 lo_entity_set->set_edm_name( 'StatusresultSet' ).          "#EC NOTEXT
  endmethod.


  method DEFINE_USERASSIGN.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 10:51:12 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - /SAVY/CL_V4_USER_PROFI_MPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA lo_entity_type    TYPE REF TO /iwbep/if_v4_med_entity_type.
 DATA lo_property       TYPE REF TO /iwbep/if_v4_med_prim_prop.
 DATA lo_entity_set     TYPE REF TO /iwbep/if_v4_med_entity_set.
 DATA lo_nav_prop       TYPE REF TO /iwbep/if_v4_med_nav_prop.
***********************************************************************************************************************************
*   ENTITY - Userassign
***********************************************************************************************************************************
 lo_entity_type = io_model->create_entity_type( iv_entity_type_name = 'USERASSIGN' ). "#EC NOTEXT

 lo_entity_type->set_edm_name( 'Userassign' ).              "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'STATUS' ). "#EC NOTEXT
 lo_property->set_edm_name( 'Status' ).                     "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_max_length( iv_max_length = '200' ).      "#EC NOTEXT

 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'VERSION' ). "#EC NOTEXT
 lo_property->set_edm_name( 'Version' ).                    "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_max_length( iv_max_length = '10' ).       "#EC NOTEXT

 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'USERNAME' ). "#EC NOTEXT
 lo_property->set_edm_name( 'Username' ).                   "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_is_key( ).
 lo_property->set_max_length( iv_max_length = '12' ).       "#EC NOTEXT


***********************************************************************************************************************************
*   Navigation Properties
***********************************************************************************************************************************
 lo_nav_prop = lo_entity_type->create_navigation_property( iv_property_name = 'USERASSIGNTOUSERPROFILES' ). "#EC NOTEXT
 lo_nav_prop->set_edm_name( 'UserassignToUserprofiles' ).   "#EC NOTEXT
 lo_nav_prop->set_target_entity_type_name( 'USERPROFILES' ).
 lo_nav_prop->set_target_multiplicity( 'N' ).
 lo_nav_prop->set_on_delete_action( 'None' ).               "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
 lo_entity_set = lo_entity_type->create_entity_set( 'USERASSIGNSET' ). "#EC NOTEXT
 lo_entity_set->set_edm_name( 'UserassignSet' ).            "#EC NOTEXT

 lo_entity_set->add_navigation_prop_binding( iv_navigation_property_path = 'USERASSIGNTOUSERPROFILES'
                                                              iv_target_entity_set = 'USERPROFILESSET' ). "#EC NOTEXT
  endmethod.


  method DEFINE_USERPROFILES.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 10:51:12 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - /SAVY/CL_V4_USER_PROFI_MPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA lo_entity_type    TYPE REF TO /iwbep/if_v4_med_entity_type.
 DATA lo_property       TYPE REF TO /iwbep/if_v4_med_prim_prop.
 DATA lo_entity_set     TYPE REF TO /iwbep/if_v4_med_entity_set.
***********************************************************************************************************************************
*   ENTITY - Userprofiles
***********************************************************************************************************************************
 lo_entity_type = io_model->create_entity_type( iv_entity_type_name = 'USERPROFILES' ). "#EC NOTEXT

 lo_entity_type->set_edm_name( 'Userprofiles' ).            "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'BAPIPROF' ). "#EC NOTEXT
 lo_property->set_edm_name( 'Bapiprof' ).                   "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_is_key( ).
 lo_property->set_max_length( iv_max_length = '12' ).       "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
 lo_entity_set = lo_entity_type->create_entity_set( 'USERPROFILESSET' ). "#EC NOTEXT
 lo_entity_set->set_edm_name( 'UserprofilesSet' ).          "#EC NOTEXT
  endmethod.
ENDCLASS.
