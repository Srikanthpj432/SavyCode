@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption User Role Get Data'
@Metadata.ignorePropagatedAnnotations: true
define root view entity /SAVY/C_USER_ROLE_GET 
 provider contract transactional_query as projection on  /SAVY/I_USER_ROLE_GET
{
    key Rolename,
    key Username,
    key FromDate,
    key ToDate
}
