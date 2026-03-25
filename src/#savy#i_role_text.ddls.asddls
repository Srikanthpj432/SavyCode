@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PFCG Role Description'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_ROLE_TEXT as select from agr_texts
   association to parent /SAVY/I_ROLE_GET as _PfcgRole
   on $projection.RoleName =  _PfcgRole.Rolename
{
    
    key agr_name as RoleName,
    key spras    as Language,
    key line     as LineId,
    text     as Description,
    
    _PfcgRole
}
