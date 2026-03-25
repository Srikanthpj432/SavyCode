@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'USER_GROUPS'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_GROUPS as select from usgrp_user
   association to parent /SAVY/I_USER_GET as _SavUserGet
   on $projection.Username =  _SavUserGet.Username
{
    key bname     as Username,
        usergroup as UserGroup,
        _SavUserGet
}
