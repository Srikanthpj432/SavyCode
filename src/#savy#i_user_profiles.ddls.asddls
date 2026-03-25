@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User_Profiles'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_PROFILES as select from ust04
        association to parent /SAVY/I_USER_GET as _SavUserGet
   on $projection.UserName = _SavUserGet.Username
{
        key bname    as  UserName,
            profile  as  Profile,
        
        _SavUserGet
}

