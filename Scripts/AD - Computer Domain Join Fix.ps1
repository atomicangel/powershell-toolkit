<# Unattend checker v0.6
Changelog: v0.6 - 03.03.2023
Created variables that store the code needed to run in the child processes for checking each machine.
There is a general checker_load that covers most models, but slower models will need an item added for longer timeouts.
Need to make the ForEach loops, but for now keeping it limited to one machine at a time.

Changelog v0.2 - 21.02.2023
Made the basic checker


TODO List
 [X] Starting off with a basic checker for end.txt on a machine, which is how our domain knows the post install user has finished any scripts.
 [X] Once that is established, will add a way to select the model of device.
 [X] Establish a set timer based on device model. Specifically the 2-in-1's (Will work out during testing.)
 [] Configure ping to make it so we can be flexible after the initial timer.
    - It appears to now generate a exit code of 1 on timeout/non-existant errors.
    - Not sure if it would give a 0 for Destiniation Host not reachable.
 [X] Then setting it up so the checker can run in the background.
 #>


# This function grabs all computers matching input parameters and lists the requested output.

$checker_load='
# Global variables go here
$counter = 0
$first_run = $True

# Get the computer OU and then remove it from the AD.
$computer = Get-ADComputer -Server <server ip or hostname> -Credential $global:creds -Filter "Name -like ''$computername''" -Properties *
$global:computer_OU = $($computer.DistinguishedName -Split '','' ,2)[1]

<# Leaving in as a debug code
Write-Host $computer.DistinguishedName
Write-Host $global:computer_OU
Move-ADObject -Identity $computer.ObjectGUID -TargetPath "OU=Computer,DC=example,DC=org" -Credential $global:creds
pause
Move-ADObject -Identity $computer.ObjectGUID -TargetPath $global:computer_OU -Credential $global:creds
pause
pause
#>

function checker(){
# This will check on whether a computer has finished or not.
# Step one will be to ping the computer and if it''s up, check for end.txt
# If either step "fails" (not up, no end.txt) it will wait 5 minutes and loop.
# This gives us a 25 minute window in which the computer should come online.
# If it comes online we will reset the counter and give it an extension on time.
# May also include a notification for that so I can adjust the initial timers to be more accurate.

# Function variables go here.

If ($counter -lt 5) {
ping $computername -n 1
    If ($LASTEXITCODE -eq 0) {  # If machine is online, first reset counter if it''s first run.
    Write-Host "Else below is the counter increment and sleep 300 if ping returned non 0 value."
        If ($counter -ne 0 -and $first_run -eq $True) {
            $counter = 0
            $first_run = $False
            }
    # Check for end.txt, and if it''s not there sleep and loop.
        If (Test-Path \\$computername\C$\install\end.txt) {
            # Find the machine matching the name and move it to the right OU.
            $computer = Get-ADComputer -Identity $computername -Credential $global:creds
            # This will pull the GUID of the OU for the laptop and then move the specified computer to that OU.
            Move-ADObject -Identity $computer.ObjectGUID -TargetPath $global:computer_OU -Credential $global:creds
        } Else {
            $counter++
            sleep 300
            checker
    } Else {
    # If exit code is not 0, then we wait and loop.
        $counter++
        sleep 300
        checker
        }
    } # Exit from ping check.
    Write-Host "Else below is the counter limit was reached."
} Else {
            # Find the machine matching the name and move it to the right OU.
            $computer = Get-ADComputer -Identity $computername -Credential $global:creds
            If ($LASTEXITCODE -eq 0) {
                # This will pull the GUID of the OU for the laptop and then move the specified computer to that OU.
                Move-ADObject -Identity $computer.ObjectGUID -TargetPath $global:computer_OU -Credential $global:creds
            }
        }

} # Closing bracket for the function

ping $computername -n 1
If ($LASTEXITCODE -eq 0) {  # If machine is online, check for end.txt
    Write-Host "Else below is the ping returned non zero value and we are not in the function yet."
    # Check for end.txt, and if it''s not there sleep and loop.
    If (Test-Path \\$computername\C$\install\end.txt) {
        
        # Find the machine matching the name and move it to the right OU.
        $computer = Get-ADComputer -Identity $computername -Credential $global:creds
        # This will pull the GUID of the OU for the laptop and then move the specified computer to that OU.
        Move-ADObject -Identity $computer.ObjectGUID -TargetPath $global:computer_OU -Credential $global:creds
    } Else {
        Remove-ADComputer -Identity $computer.ObjectGUID -Credential $global:creds -Confirm:$false
        sleep $timer
        checker
    }      
} Else {
Remove-ADComputer -Identity $computer.ObjectGUID -Credential $global:creds -Confirm:$false
sleep $timer
checker
}
'

 function menu(){
[string]$global:computername=Read-Host -Prompt "Enter in the machine name or Exit to return to menu"
If ( $global:computername -eq 'Exit') {
Main-Menu
}
[int]$timer = 3600  # 60 minutes
Start-Job -ArgumentList ($checker_load,$timer,$computername,$uri,$global:creds) -ScriptBlock {
    param ($checker_load,$global:timer,$computername,$uri,$global:creds)
    Invoke-Expression $checker_load
}
sleep 2
clear
menu
}

menu
