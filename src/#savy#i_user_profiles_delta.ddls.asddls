@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Profiles Delta'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_PROFILES_DELTA as select from ust04 as a
    left outer join usr11 as b on a.profile = b.profn
        association to parent /SAVY/I_USER_GET_DELTA as _UserDelta
   on $projection.Username = _UserDelta.Username
{
        key a.bname    as  Username,
        a.profile  as  Profile,
        b.langu    as  Language,
        cast( b.aktps as abap.char(10) )    as  ActiveVersion,
        b.ptext    as  ProfileText,
        
        _UserDelta
}
where b.langu = $session.system_language
