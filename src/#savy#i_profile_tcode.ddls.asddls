@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Profile Tcodes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity /SAVY/I_PROFILE_TCODE as select distinct from ust10s as a
      inner join ust12 as b on a.objct = b.objct
                            and a.auth  = b.auth
      inner join tstca as c on b.objct = c.objct
  association to parent /SAVY/I_PROFILES_GET as _profiles
    on $projection.ProfileName = _profiles.ProfileName
{
    key a.profn as ProfileName,
        c.tcode as Tcode,
        b.objct as AuthObject,
        b.auth  as AuthName,
        b.field as AuthField,
        c.value as AuthValue,
        
        _profiles       
}
