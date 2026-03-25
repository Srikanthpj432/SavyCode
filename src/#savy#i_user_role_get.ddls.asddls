@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Role Get'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
define root view entity /SAVY/I_USER_ROLE_GET as select from agr_users

{
        key agr_name as Rolename,
        key uname    as Username,
        key cast( from_dat as abap.char(10) ) as FromDate,
        key cast( to_dat as abap.char(10) ) as ToDate
           // col_flag as AsgnFromCompositeRole     
}
