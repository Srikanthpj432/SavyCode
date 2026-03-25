@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User_Admin_Data'
@Metadata.ignorePropagatedAnnotations: true
define  view entity /SAVY/I_USER_ADMINDATA as select from usr02
   association to parent /SAVY/I_USER_GET as _SavUserGet
   on $projection.UserName =  _SavUserGet.Username
{
    key bname  as UserName,
        aname  as AdminUser,
        erdat  as CreationDate,
        trdat  as LastLogonDate,
        
        _SavUserGet
}
