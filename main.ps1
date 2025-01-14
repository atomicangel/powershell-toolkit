<# Version 2.2 07/23/2024
I had added in credential checking awhile back but it was dependent on AD tools being installed.
I have switched it out for a different mechanism that doesn't require those tools to be installed.
Unfortunately it is less secure since it pushes out the password in plaintext to the DC.
That said I'm not storing it in plaintext anywhere in here so it's only done in real time.
Also the presumption is that if the network/device is compromised you have bigger issues to handle anyways.
#>

<# Version 2.0 03/02/2022 (dd/mm/yyyy)
Refactoring to make updating scripts and adding functions easier.
#>

# Toolkit code starts here

# Pull in functions file.
Set-ExecutionPolicy Bypass -Force
. .\Functions.ps1

# Variables are here
$bios_info = get-wmiobject -class win32_bios
$bios_date = $bios_info.Name

# Main code that runs the Toolkit.

function Main-Menu {
    clear
    File-Menu -Path "\\path\to\folder\with\scripts"
}

function Get-Creds {
<# Get credentials and verify they are working. #>

$global:creds = Get-Credential -UserName 'example\' -Message 'Enter username and password'
$username = $global:creds.username

# Get current domain using logged-on user's credentials
$CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName

try {
$test_creds = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$UserName,$($global:creds.GetNetworkCredential().password))
If ($test_creds.distinguishedName -eq $null) {
#Write-Host "Throwing..."
throw
}
} catch {
write-host "Authentication failed - please verify your username and password."
Get-Creds
}
}

Get-Creds
Main-Menu