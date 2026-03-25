@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Snc Delta'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
    }
define view entity /SAVY/I_USER_SNC_DELTA as select from usracl
       association to parent /SAVY/I_USER_GET_DELTA as _UserDelta
   on $projection.Username =  _UserDelta.Username
   {
   key bname   as Username,
       guiflag as SNCGUIflag,
       pname   as PrintableName,
       _UserDelta
   
}
