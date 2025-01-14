$server = <server ip or hostname>

$userid = Read-Host -Prompt "Enter userid to query the AD about"
$queryresult = Get-ADUser -Server $server -Credential $global:creds -Filter "name -like '$userid'" -Properties *
$passwordexpirydate = Get-ADUser -Server $server -Credential $global:creds -Filter "name -like '$userid'" -Properties "msDS-UserPasswordExpiryTimeComputed" | Select-Object -Property @{Name="Password Expiry Date";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} | Format-List
$combinedresult = $($($queryresult | Format-List -Property DisplayName,EmailAddress,Department,HomeDirectory,LastLogonDate,BadLogonCount,LockedOut,LastBadPasswordAttempt,PasswordLastSet) + $passwordexpirydate)
Write-Output $combinedresult
pause
Main-Menu