
Write-Output "Pulling all user profiles to be removed..."
$profiles = Get-WMIObject -class Win32_UserProfile | Where {((!$_.Special) -and ($_.LocalPath -match '[0-9]') -and ($_.LocalPath -match '[0-9]') -and ($_.LocalPath -ne "C:\Users\admin1") -and ($_.LocalPath -ne "C:\Users\admin2"))}

Write-Output " "
ForEach ($prof in $profiles) {
$message = "Deleting " + $prof.LocalPath + "..."
Write-Output $message
$prof.delete()
}

Write-Output " "
Write-Output "Cleaning up group policy..."
Remove-Item -Path C:\Windows\System32\GroupPolicy -Recurse -Force
Remove-Item -Path C:\Windows\System32\GroupPolicyUsers -Recurse -Force
gpupdate /force

Write-Output " "
Write-Output "Cleaning up Wi-Fi..."
netsh wlan delete profile "*"

Write-Output " "
Write-Output "Running bios.vbs. It has been prompting for us to manually allow the .exe to run."
Write-Output "The BIOS Update should run automatically otherwise."
Write-Output "Press Enter to shutdown the machine if it's not prompting to run the BIOS Update."
Write-Output "DO NOT PRESS ENTER IF YOU MANUALLY ALLOWED THE BIOS UPDATE TO RUN."

del C:\install\working.txt
del C:\install\bios.txt

\\location\of\install\scripts\bios.vbs			# Sysadmin still likes VBS...

pause

Main-Menu