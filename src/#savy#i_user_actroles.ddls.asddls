@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Act_Roles'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_ACTROLES  as select from agr_users
   association to parent /SAVY/I_USER_GET as _SavUserGet
   on $projection.Username =  _SavUserGet.Username
{
        key agr_name   as Rolename,
            uname          as Username,
            cast( from_dat as abap.char(10) ) as FromDate,
            cast( to_dat   as abap.char(10) ) as ToDate,
            
            _SavUserGet
}

