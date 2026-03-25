@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Admindata Delta'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity /SAVY/I_USER_ADMINDATA_DELTA as select from usr02
   association to parent /SAVY/I_USER_GET_DELTA as _UserDelta
   on $projection.Username =  _UserDelta.Username
{
    key bname  as Username,
        aname  as AdminUser,
        erdat  as CreationDate,
        trdat  as LastLogonDate,
        
        _UserDelta
}
