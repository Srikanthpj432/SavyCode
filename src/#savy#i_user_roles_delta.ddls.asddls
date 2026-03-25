@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Roles Delta'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define view entity /SAVY/I_USER_ROLES_DELTA as select from agr_users as a
left outer join agr_texts as b on a.agr_name = b.agr_name
   association to parent /SAVY/I_USER_GET_DELTA as _UserDelta
   on $projection.Username =  _UserDelta.Username
{
        key a.agr_name       as Rolename,
        key a.uname          as Username,
            cast( a.from_dat as abap.char(10) ) as FromDate,
            cast( a.to_dat   as abap.char(10) ) as ToDate,
            b.text           as RoleText,
            
            _UserDelta
}
where b.spras = $session.system_language
  and b.line  = '00000'
