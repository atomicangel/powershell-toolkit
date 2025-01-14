<# Version 0.5 03/02/2022
Rebuilding Delete User to not require a GUI anymore.
#>

function delete-user() {
clear
Write-Host "1) Delete specific user from machine"
Write-Host "2) Delete all student profiles from machine"
Write-Host "3) Exit"

$selection = Read-Host -Prompt "Pick your poison"

switch($selection) {
    '1' {
        $username = Read-Host -Prompt "Enter the username exactly as it appears in the Users folder"
        $UserPath = "C:\Users\" + $username
        Write-Host $UserPath
        $User = Get-WMIObject -class Win32_UserProfile | Where {((!$_.Special) -and ($_.LocalPath -eq "$UserPath"))}
        $User.delete()
        pause
        delete-user
    }
    '2' {
        Write-Output "Pulling all student profiles to be removed..."
        $profiles = Get-WMIObject -class Win32_UserProfile | Where {((!$_.Special) -and ($_.LocalPath -match '[0-9]') -and ($_.LocalPath -ne "C:\Users\admin1") -and ($_.LocalPath -ne "C:\Users\admin2"))}
        Write-Output " "
        ForEach ($prof in $profiles) {
        Write-Output $("Deleting " + $prof.LocalPath + "...")
        $prof.delete()
        }
        pause
        delete-user
    }
    '3' {
        Main-Menu
    }
}
}

delete-user