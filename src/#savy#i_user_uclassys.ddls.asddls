@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User_Uclassys'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_UCLASSYS  as select from usr06
   association to parent /SAVY/I_USER_GET as _SavUserGet
   on $projection.Username =  _SavUserGet.Username
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
       _SavUserGet
}
