class /SAVY/CL_V4_USER_CREAT_MPC definition
  public
  inheriting from /IWBEP/CL_V4_ABS_MODEL_PROV
  create public .

public section.

  types:
     TS_ADDRESS type BAPIADDR3 .
  types:
     TS_COMPANY1 type BAPIUSCOMP .
  types:
     TS_DEFAULTS type BAPIDEFAUL .
  types:
     TS_LOGONDATA type BAPILOGOND .
  types:
     TS_PASSWORD type BAPIPWD .
  types:
     TS_REFUSER type BAPIREFUS .
  types:
     TS_GROUPS type BAPIGROUPS .
  types:
     TT_GROUPS type standard table of TS_GROUPS .
  types:
     TS_PARAMETER type BAPIPARAM .
  types:
     TT_PARAMETER type standard table of TS_PARAMETER .
  types:
     begin of TS_STATUSRESULT,
         MESSAGE type C length 70,
         STATUS type C length 10,
         USERNAME type C length 12,
     end of TS_STATUSRESULT .
  types:
     TT_STATUSRESULT type standard table of TS_STATUSRESULT .
  types:
     begin of TS_USERCREATE,
         DEFAULTS type TS_DEFAULTS,
         COMPANY type TS_COMPANY1,
         ADDRESS type TS_ADDRESS,
         REF_USER type TS_REFUSER,
         PASSWORD type TS_PASSWORD,
         LOGONDATA type TS_LOGONDATA,
         VERSION type C length 10,
         USERNAME type C length 12,
     end of TS_USERCREATE .
  types:
     TT_USERCREATE type standard table of TS_USERCREATE .

  methods /IWBEP/IF_V4_MP_BASIC~DEFINE
    redefinition .
protected section.
private section.

  methods DEFINE_GROUPS
    importing
      !IO_MODEL type ref to /IWBEP/IF_V4_MED_MODEL
    raising
      /IWBEP/CX_GATEWAY .
  methods DEFINE_STATUSRESULT
    importing
      !IO_MODEL type ref to /IWBEP/IF_V4_MED_MODEL
    raising
      /IWBEP/CX_GATEWAY .
  methods DEFINE_PARAMETER
    importing
      !IO_MODEL type ref to /IWBEP/IF_V4_MED_MODEL
    raising
      /IWBEP/CX_GATEWAY .
  methods DEFINE_USERCREATE
    importing
      !IO_MODEL type ref to /IWBEP/IF_V4_MED_MODEL
    raising
      /IWBEP/CX_GATEWAY .
  methods DEFINE_COMPLEXTYPES
    importing
      !IO_MODEL type ref to /IWBEP/IF_V4_MED_MODEL
    raising
      /IWBEP/CX_GATEWAY .
ENDCLASS.



CLASS /SAVY/CL_V4_USER_CREAT_MPC IMPLEMENTATION.


  method /IWBEP/IF_V4_MP_BASIC~DEFINE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 17:09:54 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - /SAVY/CL_V4_USER_CREAT_MPC_EXT
*&-----------------------------------------------------------------------------------------------*
  define_complextypes( io_model ).
  define_groups( io_model ).
  define_parameter( io_model ).
  define_statusresult( io_model ).
  define_usercreate( io_model ).
  endmethod.


  method DEFINE_COMPLEXTYPES.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 17:09:54 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - /SAVY/CL_V4_USER_CREAT_MPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA:
   lo_prim_prop    TYPE REF TO /iwbep/if_v4_med_prim_prop,
   lo_complex_type TYPE REF TO /iwbep/if_v4_med_cplx_type.
 DATA ls_ADDRESS TYPE bapiaddr3.
 DATA ls_COMPANY1 TYPE bapiuscomp.
 DATA ls_DEFAULTS TYPE bapidefaul.
 DATA ls_LOGONDATA TYPE bapilogond.
 DATA ls_PASSWORD TYPE bapipwd.
 DATA ls_REFUSER TYPE bapirefus.
***********************************************************************************************************************************
*  COMPLEX TYPE - Address
***********************************************************************************************************************************
 lo_complex_type = io_model->create_complex_type_by_struct( iv_complex_type_name = 'ADDRESS' is_structure = ls_ADDRESS
                                                            iv_add_conv_to_prim_props = abap_true ). "#EC NOTEXT

 lo_complex_type->set_edm_name( 'Address' ).                "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PERS_NO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'PersNo' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'ADDR_NO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'AddrNo' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TITLE_P' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'TitleP' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '30' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'FIRSTNAME' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Firstname' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'LASTNAME' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Lastname' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'BIRTH_NAME' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'BirthName' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'MIDDLENAME' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Middlename' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'SECONDNAME' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Secondname' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'FULLNAME' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Fullname' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '80' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'FULLNAME_X' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'FullnameX' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TITLE_ACA1' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'TitleAca1' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '20' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TITLE_ACA2' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'TitleAca2' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '20' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PREFIX1' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Prefix1' ).                   "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '20' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PREFIX2' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Prefix2' ).                   "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '20' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TITLE_SPPL' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'TitleSppl' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '20' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'NICKNAME' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Nickname' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'INITIALS' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Initials' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'NAMEFORMAT' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Nameformat' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '2' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'NAMCOUNTRY' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Namcountry' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '3' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'LANGU_P' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'LanguP' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '2' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'LANGUP_ISO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'LangupIso' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '2' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'SORT1_P' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Sort1P' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '20' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'SORT2_P' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Sort2P' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '20' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'DEPARTMENT' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Department' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'FUNCTION' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Function' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'BUILDING_P' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'BuildingP' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'FLOOR_P' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'FloorP' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'ROOM_NO_P' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'RoomNoP' ).                   "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'INITS_SIG' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'InitsSig' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'INHOUSE_ML' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'InhouseMl' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'COMM_TYPE' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'CommType' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '3' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TITLE' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Title' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '30' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'NAME' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Name' ).                      "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'NAME_2' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Name2' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'NAME_3' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Name3' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'NAME_4' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Name4' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'C_O_NAME' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'COName' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'CITY' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'City' ).                      "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'DISTRICT' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'District' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'CITY_NO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'CityNo' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '12' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'DISTRCT_NO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'DistrctNo' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '8' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'CHCKSTATUS' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Chckstatus' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'POSTL_COD1' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'PostlCod1' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'POSTL_COD2' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'PostlCod2' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'POSTL_COD3' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'PostlCod3' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PO_BOX' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'PoBox' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PO_BOX_CIT' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'PoBoxCit' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PBOXCIT_NO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'PboxcitNo' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '12' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'DELIV_DIS' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'DelivDis' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '15' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TRANSPZONE' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Transpzone' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'STREET' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Street' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '60' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'STREET_NO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'StreetNo' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '12' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'STR_ABBR' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'StrAbbr' ).                   "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '2' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'HOUSE_NO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'HouseNo' ).                   "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'HOUSE_NO2' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'HouseNo2' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'STR_SUPPL1' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'StrSuppl1' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'STR_SUPPL2' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'StrSuppl2' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'STR_SUPPL3' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'StrSuppl3' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'LOCATION' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Location' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'BUILDING' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Building' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'FLOOR' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Floor' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'ROOM_NO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'RoomNo' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'COUNTRY' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Country' ).                   "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '3' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'COUNTRYISO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Countryiso' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '2' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'LANGU' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Langu' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '2' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'LANGU_ISO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'LanguIso' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '2' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'REGION' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Region' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '3' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'SORT1' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Sort1' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '20' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'SORT2' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Sort2' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '20' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TIME_ZONE' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'TimeZone' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '6' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TAXJURCODE' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Taxjurcode' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '15' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'ADR_NOTES' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'AdrNotes' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '50' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TEL1_NUMBR' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Tel1Numbr' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '30' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TEL1_EXT' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Tel1Ext' ).                   "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'FAX_NUMBER' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'FaxNumber' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '30' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'FAX_EXTENS' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'FaxExtens' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'E_MAIL' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'EMail' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '241' ).     "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'BUILD_LONG' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'BuildLong' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '20' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'REGIOGROUP' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Regiogroup' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '8' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'HOME_CITY' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'HomeCity' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'HOMECITYNO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Homecityno' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '12' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PCODE1_EXT' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Pcode1Ext' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PCODE2_EXT' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Pcode2Ext' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PCODE3_EXT' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Pcode3Ext' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PO_W_O_NO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'PoWONo' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'Boolean' ).     "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PO_BOX_REG' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'PoBoxReg' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '3' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'POBOX_CTRY' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'PoboxCtry' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '3' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PO_CTRYISO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'PoCtryiso' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '2' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'DONT_USE_S' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'DontUseS' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '4' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'DONT_USE_P' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'DontUseP' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '4' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'HOUSE_NO3' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'HouseNo3' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'LANGU_CR_P' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'LanguCrP' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '2' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'LANGUCPISO' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Langucpiso' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '2' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PO_BOX_LOBBY' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'PoBoxLobby' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'DELI_SERV_TYPE' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'DeliServType' ).              "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '4' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'DELI_SERV_NUMBER' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'DeliServNumber' ).            "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '10' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'COUNTY_CODE' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'CountyCode' ).                "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '8' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'COUNTY' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'County' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TOWNSHIP_CODE' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'TownshipCode' ).              "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '8' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TOWNSHIP' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Township' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'XPCPT' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Xpcpt' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT
***********************************************************************************************************************************
*  COMPLEX TYPE - Company
***********************************************************************************************************************************
 lo_complex_type = io_model->create_complex_type_by_struct( iv_complex_type_name = 'COMPANY1' is_structure = ls_COMPANY1
                                                            iv_add_conv_to_prim_props = abap_true ). "#EC NOTEXT

 lo_complex_type->set_edm_name( 'Company' ).                "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'COMPANY' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Company1' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '42' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TEMPLATE_ORGTYPE' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'TemplateOrgtype' ).           "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT
***********************************************************************************************************************************
*  COMPLEX TYPE - Defaults
***********************************************************************************************************************************
 lo_complex_type = io_model->create_complex_type_by_struct( iv_complex_type_name = 'DEFAULTS' is_structure = ls_DEFAULTS
                                                            iv_add_conv_to_prim_props = abap_true ). "#EC NOTEXT

 lo_complex_type->set_edm_name( 'Defaults' ).               "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'STCOD' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Stcod' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '20' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'SPLD' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Spld' ).                      "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '30' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'SPLG' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Splg' ).                      "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'SPDB' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Spdb' ).                      "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'SPDA' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Spda' ).                      "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'DATFM' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Datfm' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'DCPFM' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Dcpfm' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'LANGU' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Langu' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '2' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'CATTKENNZ' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Cattkennz' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'KOSTL' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Kostl' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '8' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'START_MENU' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'StartMenu' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '30' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TIMEFM' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Timefm' ).                    "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TZONE_IANA' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'TzoneIana' ).                 "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '64' ).      "#EC NOTEXT
***********************************************************************************************************************************
*  COMPLEX TYPE - Logondata
***********************************************************************************************************************************
 lo_complex_type = io_model->create_complex_type_by_struct( iv_complex_type_name = 'LOGONDATA' is_structure = ls_LOGONDATA
                                                            iv_add_conv_to_prim_props = abap_true ). "#EC NOTEXT

 lo_complex_type->set_edm_name( 'Logondata' ).              "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'GLTGV' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Gltgv' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'Date' ).        "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'GLTGB' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Gltgb' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'Date' ).        "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'USTYP' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Ustyp' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'CLASS' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Class' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '12' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'ACCNT' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Accnt' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '12' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'TZONE' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Tzone' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '6' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'LTIME' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Ltime' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'TimeOfDay' ).   "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'BCODE' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Bcode' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'Binary' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '8' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'CODVN' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Codvn' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PASSCODE' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Passcode' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'Binary' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '20' ).      "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'CODVC' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Codvc' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'PWDSALTEDHASH' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Pwdsaltedhash' ).             "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '255' ).     "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'CODVS' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Codvs' ).                     "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '1' ).       "#EC NOTEXT

 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'SECURITY_POLICY' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'SecurityPolicy' ).            "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT
***********************************************************************************************************************************
*  COMPLEX TYPE - Password
***********************************************************************************************************************************
 lo_complex_type = io_model->create_complex_type_by_struct( iv_complex_type_name = 'PASSWORD' is_structure = ls_PASSWORD
                                                            iv_add_conv_to_prim_props = abap_true ). "#EC NOTEXT

 lo_complex_type->set_edm_name( 'Password' ).               "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'BAPIPWD' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'Bapipwd' ).                   "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '40' ).      "#EC NOTEXT
***********************************************************************************************************************************
*  COMPLEX TYPE - RefUser
***********************************************************************************************************************************
 lo_complex_type = io_model->create_complex_type_by_struct( iv_complex_type_name = 'REFUSER' is_structure = ls_REFUSER
                                                            iv_add_conv_to_prim_props = abap_true ). "#EC NOTEXT

 lo_complex_type->set_edm_name( 'RefUser' ).                "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_prim_prop = lo_complex_type->create_prim_property( iv_property_name = 'REF_USER' ). "#EC NOTEXT
 lo_prim_prop->set_add_annotations( abap_true ).

 lo_prim_prop->set_edm_name( 'RefUser1' ).                  "#EC NOTEXT
 lo_prim_prop->set_edm_type( iv_edm_type = 'String' ).      "#EC NOTEXT
 lo_prim_prop->set_max_length( iv_max_length = '12' ).      "#EC NOTEXT
  endmethod.


  method DEFINE_GROUPS.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 17:09:54 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - /SAVY/CL_V4_USER_CREAT_MPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA lo_entity_type    TYPE REF TO /iwbep/if_v4_med_entity_type.
 DATA lo_property       TYPE REF TO /iwbep/if_v4_med_prim_prop.
 DATA lo_entity_set     TYPE REF TO /iwbep/if_v4_med_entity_set.
 DATA lv_GROUPS  TYPE bapigroups.
***********************************************************************************************************************************
*   ENTITY - Groups
***********************************************************************************************************************************
 lo_entity_type = io_model->create_entity_type_by_struct( iv_entity_type_name = 'GROUPS' is_structure = lv_GROUPS
                                                          iv_add_conv_to_prim_props = abap_true ). "#EC NOTEXT

 lo_entity_type->set_edm_name( 'Groups' ).                  "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'USERGROUP' ). "#EC NOTEXT
 lo_property->set_add_annotations( abap_true ).
 lo_property->set_edm_name( 'Usergroup' ).                  "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_is_key( ).
 lo_property->set_max_length( iv_max_length = '12' ).       "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
 lo_entity_set = lo_entity_type->create_entity_set( 'GROUPSSET' ). "#EC NOTEXT
 lo_entity_set->set_edm_name( 'GroupsSet' ).                "#EC NOTEXT
  endmethod.


  method DEFINE_PARAMETER.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 17:09:54 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - /SAVY/CL_V4_USER_CREAT_MPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA lo_entity_type    TYPE REF TO /iwbep/if_v4_med_entity_type.
 DATA lo_property       TYPE REF TO /iwbep/if_v4_med_prim_prop.
 DATA lo_entity_set     TYPE REF TO /iwbep/if_v4_med_entity_set.
 DATA lv_PARAMETER  TYPE bapiparam.
***********************************************************************************************************************************
*   ENTITY - Parameter
***********************************************************************************************************************************
 lo_entity_type = io_model->create_entity_type_by_struct( iv_entity_type_name = 'PARAMETER' is_structure = lv_PARAMETER
                                                          iv_add_conv_to_prim_props = abap_true ). "#EC NOTEXT

 lo_entity_type->set_edm_name( 'Parameter' ).               "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'PARID' ). "#EC NOTEXT
 lo_property->set_add_annotations( abap_true ).
 lo_property->set_edm_name( 'Parid' ).                      "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_is_key( ).
 lo_property->set_max_length( iv_max_length = '20' ).       "#EC NOTEXT

 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'PARVA' ). "#EC NOTEXT
 lo_property->set_add_annotations( abap_true ).
 lo_property->set_edm_name( 'Parva' ).                      "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_max_length( iv_max_length = '18' ).       "#EC NOTEXT

 lo_property = lo_entity_type->create_prim_property( iv_property_name = 'PARTXT' ). "#EC NOTEXT
 lo_property->set_add_annotations( abap_true ).
 lo_property->set_edm_name( 'Partxt' ).                     "#EC NOTEXT
 lo_property->set_edm_type( iv_edm_type = 'String' ).       "#EC NOTEXT
 lo_property->set_max_length( iv_max_length = '60' ).       "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
 lo_entity_set = lo_entity_type->create_entity_set( 'PARAMETERSET' ). "#EC NOTEXT
 lo_entity_set->set_edm_name( 'ParameterSet' ).             "#EC NOTEXT
  endmethod.


  method DEFINE_STATUSRESULT.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 17:09:54 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - /SAVY/CL_V4_USER_CREAT_MPC_EXT
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


  method DEFINE_USERCREATE.
*&----------------------------------------------------------------------------------------------*
*&* This class has been generated on 24.03.2026 17:09:54 in client 100
*&*
*&*       WARNING--> NEVER MODIFY THIS CLASS <--WARNING
*&*   If you want to change the MPC implementation, use the
*&*   generated methods inside MPC subclass - /SAVY/CL_V4_USER_CREAT_MPC_EXT
*&-----------------------------------------------------------------------------------------------*

 DATA lo_entity_type    TYPE REF TO /iwbep/if_v4_med_entity_type.
 DATA lo_property       TYPE REF TO /iwbep/if_v4_med_prim_prop.
 DATA lo_entity_set     TYPE REF TO /iwbep/if_v4_med_entity_set.
 DATA lo_nav_prop       TYPE REF TO /iwbep/if_v4_med_nav_prop.
 DATA lo_complex_prop  TYPE REF TO /iwbep/if_v4_med_cplx_prop.
***********************************************************************************************************************************
*   ENTITY - UserCreate
***********************************************************************************************************************************
 lo_entity_type = io_model->create_entity_type( iv_entity_type_name = 'USERCREATE' ). "#EC NOTEXT

 lo_entity_type->set_edm_name( 'UserCreate' ).              "#EC NOTEXT

***********************************************************************************************************************************
*   Properties
***********************************************************************************************************************************
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
*   Complex Properties
***********************************************************************************************************************************
 lo_complex_prop = lo_entity_type->create_complex_property( 'DEFAULTS' ).
 lo_complex_prop->set_edm_name( 'Defaults' ).               "#EC NOTEXT
 lo_complex_prop->set_complex_type( 'DEFAULTS' ).

 lo_complex_prop = lo_entity_type->create_complex_property( 'COMPANY' ).
 lo_complex_prop->set_edm_name( 'Company' ).                "#EC NOTEXT
 lo_complex_prop->set_complex_type( 'COMPANY1' ).

 lo_complex_prop = lo_entity_type->create_complex_property( 'ADDRESS' ).
 lo_complex_prop->set_edm_name( 'Address' ).                "#EC NOTEXT
 lo_complex_prop->set_complex_type( 'ADDRESS' ).

 lo_complex_prop = lo_entity_type->create_complex_property( 'REF_USER' ).
 lo_complex_prop->set_edm_name( 'RefUser' ).                "#EC NOTEXT
 lo_complex_prop->set_complex_type( 'REFUSER' ).

 lo_complex_prop = lo_entity_type->create_complex_property( 'PASSWORD' ).
 lo_complex_prop->set_edm_name( 'Password' ).               "#EC NOTEXT
 lo_complex_prop->set_complex_type( 'PASSWORD' ).

 lo_complex_prop = lo_entity_type->create_complex_property( 'LOGONDATA' ).
 lo_complex_prop->set_edm_name( 'Logondata' ).              "#EC NOTEXT
 lo_complex_prop->set_complex_type( 'LOGONDATA' ).


***********************************************************************************************************************************
*   Navigation Properties
***********************************************************************************************************************************
 lo_nav_prop = lo_entity_type->create_navigation_property( iv_property_name = 'GROUPSSET' ). "#EC NOTEXT
 lo_nav_prop->set_edm_name( 'GroupsSet' ).                  "#EC NOTEXT
 lo_nav_prop->set_target_entity_type_name( 'GROUPS' ).
 lo_nav_prop->set_target_multiplicity( 'N' ).
 lo_nav_prop->set_on_delete_action( 'None' ).               "#EC NOTEXT
 lo_nav_prop = lo_entity_type->create_navigation_property( iv_property_name = 'PARAMETERSET' ). "#EC NOTEXT
 lo_nav_prop->set_edm_name( 'ParameterSet' ).               "#EC NOTEXT
 lo_nav_prop->set_target_entity_type_name( 'PARAMETER' ).
 lo_nav_prop->set_target_multiplicity( 'N' ).
 lo_nav_prop->set_on_delete_action( 'None' ).               "#EC NOTEXT


***********************************************************************************************************************************
*   ENTITY SETS
***********************************************************************************************************************************
 lo_entity_set = lo_entity_type->create_entity_set( 'USERCREATESET' ). "#EC NOTEXT
 lo_entity_set->set_edm_name( 'UserCreateSet' ).            "#EC NOTEXT

 lo_entity_set->add_navigation_prop_binding( iv_navigation_property_path = 'PARAMETERSET'
                                                              iv_target_entity_set = 'PARAMETERSET' ). "#EC NOTEXT
 lo_entity_set->add_navigation_prop_binding( iv_navigation_property_path = 'GROUPSSET'
                                                              iv_target_entity_set = 'GROUPSSET' ). "#EC NOTEXT
  endmethod.
ENDCLASS.
