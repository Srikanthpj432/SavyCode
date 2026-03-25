@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User Company Details'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_COMPANY_DELTA as select from usr21 as a
inner join uscompany as b on a.addrnumber = b.addrnumber
inner join adrc      as c on a.addrnumber = c.addrnumber

   association to parent /SAVY/I_USER_GET_DELTA as _SavUserGet
   on $projection.UserName =  _SavUserGet.Username
{
    key a.bname      as UserName,
        b.addrnumber as AdrsNumber,
        case c.title
        when '0001' then 'Ms.'
        when '0002' then 'Mr.'
        when '0003' then 'Company'
        when '0004' then 'Mr. and Mrs.'
        end as TitleText,
        b.company    as CompanyName,
        c.name2      as Name2,
        c.name_text  as NameText,
        c.name_co    as NameCo,
        c.city1      as City,
        c.city2      as District,
        c.city_code  as CityCode,
        c.cityp_code  as DistrictCode,
        case c.chckstatus  
        when ' ' then 'Not Checked'
        when 'C' then 'checked against city index'
        when 'D' then 'differs from city index'
        end as CheckStatus,
        c.post_code1    as CityPostalCode,
        c.post_code2    as PoBoxPostalCode,
        c.po_box        as PoBox,
        c.street        as Street,
        c.house_num1    as HouseNumber,
        c.country       as Country,
        c.langu         as Langu,
        c.region        as Region,
        c.addr_group    as AdrsGroup,
        c.tel_number    as TeleNumber,
        c.time_zone     as AdrsTimeZone,
        c.taxjurcode    as TaxJurisdiction,
        c.addresscreatedbyuser as CreatedBy,
        c.addresscreatedondatetime as CreatedDateTime,
        c.addresschangedbyuser as ChangedBy,
        c.addresschangedondatetime as ChangedDateTime,
        
    
    _SavUserGet // Make association public
}
