@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User_Parameters'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_PARAMETERS as select from usr05 as a
   left outer join tparat as b on a.parid = b.paramid
   association to parent /SAVY/I_USER_GET as _SavUserGet
   on $projection.Username =  _SavUserGet.Username
{
    
    key a.bname as Username,
    key a.parid   as ParameterId,
        a.parva   as ParameterValue,
      b.partext   as Description,
      _SavUserGet 
}
where b.sprache = $session.system_language
