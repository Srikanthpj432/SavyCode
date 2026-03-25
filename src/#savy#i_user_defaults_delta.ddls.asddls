@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Defaults Delta'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_DEFAULTS_DELTA as select from usr01
   association to parent /SAVY/I_USER_GET_DELTA as _UserDelta
   on $projection.Username =  _UserDelta.Username
{
    
    key bname   as Username,
        stcod   as StartMenu,
        cast( spld as abap.char(10) ) as Spool,
        splg    as Print1,
        _UserDelta 
}
