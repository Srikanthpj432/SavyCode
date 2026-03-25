@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Saviynt User Get Details'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
define root view entity /SAVY/I_USER_GET 
 as select from usr02
  composition [0..1] of /SAVY/I_USER_ADDRESS    as _Address
  composition [0..1] of /SAVY/I_USER_DEFAULTS   as _Defaults
  composition [0..1] of /SAVY/I_USER_SNC        as _Snc
  composition [0..1] of /SAVY/I_USER_REFERENCE  as _Reference
  composition [0..1] of /SAVY/I_USER_GROUPS     as _Groups
  composition [0..1] of /SAVY/I_USER_LOGON      as _Logondata
  composition [0..1] of /SAVY/I_USER_ADMINDATA  as _Admindata
  composition [0..1] of /SAVY/I_USER_UCLASSYS   as _Uclassys
  composition [0..1] of /SAVY/I_USER_COMPANY    as _Company
  composition [1..*] of /SAVY/I_USER_PROFILES   as _Profiles
  composition [1..*] of /SAVY/I_USER_ACTROLES   as _Actroles
  composition [1..*] of /SAVY/I_USER_PARAMETERS as _Parameters
  composition [0..*] of /SAVY/I_USER_CHANGE_LOG  as _ChangeItems 

{
    
    key usr02.bname as Username,
        //usr02.uflag as Lockstatus,
        case usr02.uflag
            when 0   then 'Not Locked'
            when 32  then 'Locked Globally by Administrator'
            when 64  then 'Locked Locally by Administrator'
            when 128 then 'Locked Due To Incorrect Logons'
        else 'test'       
        end as         Lockstatus,
        _Address,
        _Defaults,
        _Snc,
        _Reference,
        _Groups,
        _Logondata,
        _Admindata,
        _Company,
        _Profiles,
        _Actroles,
        _Parameters,
        _Uclassys,
        _ChangeItems        
  }
