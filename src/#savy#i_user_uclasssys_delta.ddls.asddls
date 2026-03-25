@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User uclasssys Delta'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity /SAVY/I_USER_UCLASSSYS_DELTA as select from usr06
   association to parent /SAVY/I_USER_GET_DELTA as _UserDelta
   on $projection.Username =  _UserDelta.Username
{
    key bname as Username,
       lic_type  as LicType,
       spras     as Version,
       surcharge as CountrySurcharge,
       vondat    as SubstituteFrom,
       bisdat    as SubstituteTo,
       sysid     as SystemId,
       mandt2    as Clientt,
       aname     as ChargeableUser,
       _UserDelta
}
