@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Profiles Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity /SAVY/I_PROFILE_TEXT as select from usr11
   association to parent /SAVY/I_PROFILES_GET as _profiles
   on $projection.ProfileName =  _profiles.ProfileName
{
    key profn as ProfileName,
    key langu as Language,
    key cast(  aktps as abap.char(1) )  as Version,
        ptext as Description,
        
        _profiles
    
}
