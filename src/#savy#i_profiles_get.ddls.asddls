@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Saviynt Profiles Data'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
define root view entity /SAVY/I_PROFILES_GET as select from usr10
composition [1..*] of /SAVY/I_PROFILE_TCODE as _profileTcode
composition [1..*] of /SAVY/I_PROFILE_TEXT as _profileText
{
    key profn as ProfileName,
        cast(  aktps as abap.char(1) )  as Version,
        modda as ModDate,
        modti as ModTime,      
        
       case typ
            when 'C'  then 'Composite Profile'
            when 'G'  then 'Generates Profile'
            when 'S'  then 'Single profile'

        else ' '       
        end as         ProfileType,
      
    _profileTcode,      
    _profileText
}
