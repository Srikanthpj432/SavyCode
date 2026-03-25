@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Address'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_ADDRESS as select from usr21 as a
   inner join       adrp on a.persnumber = adrp.persnumber
   left outer join  adrc on a.addrnumber = adrc.addrnumber
  association to parent /SAVY/I_USER_GET as _SavUserGet
   on $projection.UserName =  _SavUserGet.Username
{
        key a.bname  as  UserName,
        adrp.persnumber as PersonalNumber,
        adrc.addrnumber as AddressNumber,
        adrp.title      as Title,
        adrp.name_first as FirstName,
        adrp.name_last  as LastName,
        adrp.name_text  as FullName,
        adrc.nation     as Nation,
        adrc.name1      as Name1,
        adrc.name2      as Name2,
        adrc.country    as Country,
        adrc.langu      as Langu,
        adrc.region     as Region,
        
        _SavUserGet
}
