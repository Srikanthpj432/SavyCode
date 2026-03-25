@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Defaults'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_DEFAULTS 
as select from usr01
   association to parent /SAVY/I_USER_GET as _SavUserGet
   on $projection.UserName =  _SavUserGet.Username
{
    
    key bname   as UserName,
        stcod   as StartMenu,
        cast( spld as abap.char(10) ) as Spool,
        splg    as Print1,
        _SavUserGet 
}

