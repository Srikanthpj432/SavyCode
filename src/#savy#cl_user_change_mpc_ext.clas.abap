class /SAVY/CL_USER_CHANGE_MPC_EXT definition
  public
  inheriting from /SAVY/CL_USER_CHANGE_MPC
  create public .

public section.

  methods DEFINE
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS /SAVY/CL_USER_CHANGE_MPC_EXT IMPLEMENTATION.


  method DEFINE.
    super->define( ).
    DATA(lo_complex_type) = model->get_complex_type( 'Logondata' ).
    DATA(lo_property) = lo_complex_type->get_property( 'Gltgv' ).

    lo_property->set_nullable( abap_true ).


    lo_complex_type = model->get_complex_type( 'Logondata' ).
    lo_property = lo_complex_type->get_property( 'Gltgb' ).

    lo_property->set_nullable( abap_true ).
  endmethod.
ENDCLASS.
