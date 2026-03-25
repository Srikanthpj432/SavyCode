@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Parameters Delta'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity /SAVY/I_USER_PARAMETERS_DELTA as select from usr05 as a
   left outer join tparat as b on a.parid = b.paramid
   association to parent /SAVY/I_USER_GET_DELTA as _UserDelta
   on $projection.Username =  _UserDelta.Username
{
    
    key a.bname as Username,
    key a.parid   as ParameterId,
        a.parva   as ParameterValue,
      b.partext   as Description,
      _UserDelta 
}
where b.sprache = $session.system_language
