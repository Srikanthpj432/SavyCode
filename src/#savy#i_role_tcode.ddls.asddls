@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Role Tcodes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity /SAVY/I_ROLE_TCODE as select from agr_tcodes as a
   association to parent /SAVY/I_ROLE_GET as _RoleTcode
   on $projection.RoleName =  _RoleTcode.Rolename
{
    key a.agr_name as RoleName,
        a.tcode    as Tcode,
                
        _RoleTcode
}
