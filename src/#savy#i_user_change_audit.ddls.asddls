@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User_Change_Audit'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_CHANGE_AUDIT as 
select from /SAVY/I_USER_CHANGE_EVENTS as E
{
  key E.Username,
      max( case when E.EventType = 'DELETED' then 1 else 0 end ) as UserDeleted,
      max( case when E.EventType = 'CHANGED' then 1 else 0 end ) as UserChange,
      max(  E.ChangeDate )               as LastDate
}
group by E.Username
