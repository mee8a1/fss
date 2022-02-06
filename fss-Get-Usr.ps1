# [PowerShell 5.1]
# mee8a1@gmx.com @fss78.ru 20191121
#
<#
читает AD
#>

$outFile = 'fss-Get-Usr.txt'
$myServer = 'fss.local'
$iam = 'CN=** ** **,OU=ОИ (Отдел информатизации),OU=Users,OU=**,OU=**,OU=**,DC=fss,DC=local'
$myADBase = "OU=**,OU=**,DC=**,DC=local"
$myName = "**.**.**"

# very very bad practic:
#$pwd = "***" | ConvertTo-SecureString -asPlainText -Force
#$admin = "***@*.local" 
#$AdminCredentials = New-Object System.Management.Automation.PSCredential($admin,$pwd)
#

# do this for more security!
$AdminCredentials = Get-Credential "my.savchenko.78@fss.local"
#-Credential 
#Get-ADUser -Filter {EmailAddress -like "*"}
#Set-ADUser [-Identity] <ADUser> [-AccountExpirationDate <System.Nullable[System.DateTime]>] [-AccountNotDelegated <System.Nullable[bool]>] [-Add <hashtable>] [-AllowReversiblePasswordEncryption <System.Nullable[bool]>] [-CannotChangePassword <System.Nullable[bool]>] [-Certificates <hashtable>] [-ChangePasswordAtLogon <System.Nullable[bool]>] [-City <string>] [-Clear <string[]>] [-Company <string>] [-Country <string>] [-Department <string>] [-Description <string>] [-DisplayName <string>] [-Division <string>] [-EmailAddress <string>] [-EmployeeID <string>] [-EmployeeNumber <string>] [-Enabled <System.Nullable[bool]>] [-Fax <string>] [-GivenName <string>] [-HomeDirectory <string>] [-HomeDrive <string>] [-HomePage <string>] [-HomePhone <string>] [-Initials <string>] [-LogonWorkstations <string>] [-Manager <ADUser>] [-MobilePhone <string>] [-Office <string>] [-OfficePhone <string>] [-Organization <string>] [-OtherName <string>] [-PasswordNeverExpires <System.Nullable[bool]>] [-PasswordNotRequired <System.Nullable[bool]>] [-POBox <string>] [-PostalCode <string>] [-ProfilePath <string>] [-Remove <hashtable>] [-Replace <hashtable>] [-SamAccountName <string>] [-ScriptPath <string>] [-ServicePrincipalNames <hashtable>] [-SmartcardLogonRequired <System.Nullable[bool]>] [-State <string>] [-StreetAddress <string>] [-Surname <string>] [-Title <string>] [-TrustedForDelegation <System.Nullable[bool]>] [-UserPrincipalName <string>] [-AuthType {<Negotiate> | <Basic>}] [-Credential <PSCredential>] [-Partition <string>] [-PassThru <switch>] [-Server <string>] [-Confirm] [-WhatIf] [<CommonParameters>]
#$user = Get-ADUser -Identity "saraDavis"
#$user.Manager = "JimCorbin"

#$Users = Get-ADUser -Credential $AdminCredentials -Server $myServer -SearchBase $myADBase -Filter * -Properties *
$Users = Get-ADUser -Credential $AdminCredentials -Server $myServer -SearchBase $myADBase -Filter {SamAccountName -eq $myName} -Properties *
$Users.City = ''
$Users.Office = ''
$Users.OfficePhone = ''
$Users.HomePage = ''
#$Users.wWWHomePage = ''
$Users.StreetAddress = ''
$Users.POBox = ''
#$Users.postOfficeBox = ''
$Users.State = ''
#$Users.st = ''
$Users.PostalCode = ''
$Users.HomePhone = ''
$Users.pager = ''
$Users.MobilePhone = ''
#$Users.mobile = ''
$Users.Fax = ''
#$Users.facsimileTelephoneNumber = ''
$Users.ipPhone = ''
$Users.info = ''
Set-ADUser $myName -Credential $AdminCredentials -Server $myServer -Instance $Users
exit 0

$UserCnt = $Users.Count | Out-File $outFile
$Date = Get-Date -Format g | Out-File $outFile -Append
$Users | Out-File $outFile -Append
exit 0

$UsrObj = @()
foreach ($user in $Users)
{
 if ($user.SamAccountName -eq $myName)
 {
    $user | Out-File $outFile -Append
 }

}


exit 0
$a = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>Active Directory User Report</title>
<style type="text/css">
<!--
body {
font-family: Verdana, Arial;
padding: 10px;
}
  table
    {
      
        margin-right:auto;
        border: 1px solid rgb(190, 190, 190);
        font-Family: Helvetica, Tahoma;
        font-Size: 10pt;
        text-align: left;
    }
th
    {
        Text-Align: Left;
        font-size: 8pt;
        font-weight: bold;
        Color:#4682B4;
              background-color: white;
        Padding: 1px 4px 1px 4px;
    }
tr:hover td
    {
        background-color: DodgerBlue ;
        Color: #F5FFFA;
             
    }
tr:nth-child(even)
    {
        Background-Color: #D3D3D3;
    }
tr:nth-child(odd)
       {
              background-color:#F8F8FF;
       }     
      
td
    {
        Vertical-Align: Top;
        Padding: 5px;
    }
  
h1{
       clear: both;
       font-size: 12pt;
       font-weight: bold;
       }
h2{
       clear: both;
      
      
       font-size: 17px;
       font-weight: 300;
       Margin-bottom: 10px;
      
}
p{
    font-size: 10pt;
    font-weight: 300;   
    text-align: left;
    margin-bottom: 10px;
}
}
-->
</style>
</head>
"@

ImportSystemModules ActiveDirectory

#$me = '***_*'
#$usr = Get-ADUser $me -Server $myServer -Properties *
#Write-Output $usr  > "_***-GetADLastLogon-tst.txt"
#$a = $usr.CN + ";" + $usr.HomePage + ";" + $usr.EmailAddress + ";" + $usr.info + "`n" + $usr.Modified + ";" + $usr.OfficePhone
#$a
#exit 0

$Users = Get-ADUser -Server $myServer -SearchBase $myADBase -Filter * -Properties *

$UserCnt = $Users.Count
$Date = Get-Date -Format g

$UsrObj = @()
foreach ($user in $Users)
{

$usr = New-Object -TypeName PSObject -Property @{
#"Canonical Name" = $User.CanonicalName
"Name" = $User.CN
"Account" = $User.SamAccountName
"Enabled" = if ($User.Enabled -eq $true){"Yes"} else{"No"}
#"Password Expired" = if ($user.PasswordExpired -eq $true){"Expired"}else{"Not Expired"}
"Created" = $User.Created
"Logon" = $User.LastLogonDate
"Modified" = $User.Modified
"IP" = $User.HomePage
"Info" = $User.info
#"Days Elapsed Since Last Logon" = if ($user.LastLogonDate -ne $null){if($User.lastLogon -ne 0){(new-TimeSpan([datetime]::FromFileTimeUTC($User.lastLogon)) $(Get-Date)).days}else{0}}else{"Never Logged On"}
#"Last Failed Logon" = $User.LastBadPasswordAttempt
#"Account Age - Days" = (New-TimeSpan([datetime]$User.createTimeStamp) $(Get-Date)).Days 

}

$UsrObj += $usr

}

$myHTMLbody = "<body><h2>AD $myServer, path: $myADBase</h2><p>Date: $date</p><p>User Count: $UserCnt</p></body>"

$UsrObj|sort-object -property "Logon" -Descending|ConvertTo-Html "Name","Account","Enabled","Created","Logon","Modified","IP","info"`
 -head $a -body $myHTMLbody | Out-File $outFile
