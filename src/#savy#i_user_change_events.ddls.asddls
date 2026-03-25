@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User_Change_events'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_CHANGE_EVENTS as   select from cdhdr as H
    inner join cdpos as P
      on  P.objectclas = H.objectclas
      and P.objectid   = H.objectid
      and P.changenr   = H.changenr
{
  key cast( H.objectid as abap.char(12) ) as Username,        // SU01 username
      max(case
        when P.chngind = 'D' then 'DELETED'
        else 'CHANGED'
      end )                               as EventType, 
      max(H.udate)                        as ChangeDate
}
where
      H.objectclas = 'IDENTITY'
      group by H.objectid 
