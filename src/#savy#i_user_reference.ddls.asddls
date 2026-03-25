@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'USER_REFERENCE'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_REFERENCE  as select from usrefus
   association to parent /SAVY/I_USER_GET as _SavUserGet
   on $projection.Username =  _SavUserGet.Username
{
         key bname as Username,
     refuser  as RefUser2,
     useralias as UserAlias,
     _SavUserGet
}
