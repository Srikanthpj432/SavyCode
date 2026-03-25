@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Group Delta'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_GROUP_DELTA as select from usgrp_user
   association to parent /SAVY/I_USER_GET_DELTA as _UserDelta
   on $projection.Username =  _UserDelta.Username
{
    key bname     as Username,
        usergroup as UserGroup,
        _UserDelta
}
