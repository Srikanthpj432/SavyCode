@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Change log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity /SAVY/I_USER_CHANGE_LOG as select from /SAVY/I_USER_CHANGE_EVENTS
 association to parent /SAVY/I_USER_GET as _UserDelta
 on $projection.Username = _UserDelta.Username
{
      key Username,
          ChangeDate,
          EventType,
         _UserDelta
}
