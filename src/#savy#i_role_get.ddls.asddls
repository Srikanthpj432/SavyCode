@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Saviynt PFCG Roles'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
define root view entity /SAVY/I_ROLE_GET as select from agr_define as a

composition [1..*] of /SAVY/I_ROLE_TCODE   as _RoleTcode
composition [1..*] of /SAVY/I_ROLE_TEXT    as _RoleText
{
    key a.agr_name   as RoleName,
        a.parent_agr as ParentRole, 
         
        _RoleTcode,  
        _RoleText
}
