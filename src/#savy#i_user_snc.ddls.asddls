@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Snc'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #D,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity /SAVY/I_USER_SNC as select from usracl
       association to parent /SAVY/I_USER_GET as _UserDetail
   on $projection.Username =  _UserDetail.Username
   {
   key bname   as Username,
       guiflag as SNCGUIflag,
       pname   as PrintableName,
       _UserDetail
   
}
