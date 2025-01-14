Write-Output "Cleaning up group policy..."
Remove-Item -Path C:\Windows\System32\GroupPolicy -Recurse -Force
Remove-Item -Path C:\Windows\System32\GroupPolicyUsers -Recurse -Force
Write-Output "Starting policy update..."

gpupdate /force 

sleep 5

Main-Menu