@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'User_Get_Delta'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
define root view entity /SAVY/I_USER_GET_DELTA as select from /SAVY/I_USER_CHANGE_AUDIT as R
  composition [0..*] of /SAVY/I_USER_CHANGE_AUDITITEM  as _ChangeItems 
  composition [0..1] of /SAVY/I_USER_ADDRESS_DELTA    as _Address
  composition [0..1] of /SAVY/I_USER_DEFAULTS_DELTA   as _Defaults
  composition [0..1] of /SAVY/I_USER_SNC_DELTA        as _Snc
  composition [0..1] of /SAVY/I_USER_REFERENCE_DELTA  as _Reference
  composition [0..1] of /SAVY/I_USER_GROUP_DELTA      as _Group
  composition [0..1] of /SAVY/I_USER_LOGON_DELTA      as _Logondata 
  composition [0..1] of /SAVY/I_USER_ADMINDATA_DELTA  as _Admindata
  composition [0..1] of /SAVY/I_USER_UCLASSSYS_DELTA  as _Uclasssys
  composition [0..1] of /SAVY/I_USER_COMPANY_DELTA    as _Company
  composition [0..*] of /SAVY/I_USER_PROFILES_DELTA   as _Profiles
  composition [0..*] of /SAVY/I_USER_ROLES_DELTA      as _Roles
  composition [0..*] of /SAVY/I_USER_PARAMETERS_DELTA as _Parameters    


{
      key R.Username,
          R.UserDeleted,
          R.UserChange,
          R.LastDate,
         
      _ChangeItems,   
      _Address,
      _Defaults,
      _Snc,
      _Reference,
      _Group,
      _Logondata,
      _Admindata,
      _Profiles,
      _Roles,
      _Parameters,
      _Uclasssys,
      _Company

}
