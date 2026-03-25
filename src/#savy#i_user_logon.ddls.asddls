@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'User_Logon'
@Metadata.ignorePropagatedAnnotations: true
define view entity /SAVY/I_USER_LOGON as select from usr02 as a
   left outer join usr21 as b on a.bname = b.bname
   association to parent /SAVY/I_USER_GET as _SavUserGet
   on $projection.UserName =  _SavUserGet.Username
{   
       key a.bname  as UserName,
       cast( a.gltgv as abap.char(10) ) as UserValidFrom,
       cast( a.gltgb as abap.char(10) ) as UserValidTo,
       cast( a.ustyp as abap.char(10) ) as UserType,
       a.class  as UserGroup,
       a.accnt  as AccountId,
       b.kostl  as CostCenter,
       a.tzone  as Time_Zone,
       a.ltime  as LastLogonTime,
       a.codvn  as CodeVersion,
       a.security_policy as  SecurityPolicyName,
       
       _SavUserGet
}
