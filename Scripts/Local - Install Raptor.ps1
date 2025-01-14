<# Version 1.0 06/14/2024

A quick script to handle installing all of the bits for Raptor.
The sysadmin couldn't/wouldn't script this, and the components used to be installed using an EXE made by the company.
Now each piece needs installed manually.
#>

Write-Host -ForegroundColor yellow -BackgroundColor black "Installing .net 3.5..."
Dism /online /enable-feature /featurename:NetFX3 /All /Source:\\tornado\install\raptor\sxs /LimitAccess
Write-Host -ForegroundColor yellow -BackgroundColor black "Installing Dymo Connect..."
Start-Process -NoNewWindow "\\tornado\install\Raptor\DYMO Connect DLS8Setup.8.5.3.exe" -ArgumentList '/silent'
sleep 60	# The above program does not respect the -Wait parameter.
Write-Host -ForegroundColor yellow -BackgroundColor black "Installing Dymo printer drivers..."
Start-Process -NoNewWindow "\\tornado\install\Raptor\DYMO Printer Drivers DCDSetup1.4.3.131.exe" -ArgumentList '/silent' -Wait
Write-Host -ForegroundColor yellow -BackgroundColor black "Installing Scanner drivers..."
Start-Process -NoNewWindow "\\tornado\install\Raptor\3M CR5400 PageReader Scanner DriversSetup_3_3_6_2.exe" -ArgumentList '/silent' -Wait
Write-Host -ForegroundColor yellow -BackgroundColor black "Running install for .net 4.5, may say it's already installed."
Start-Process -NoNewWindow "\\tornado\install\Raptor\NET_4.5.1.exe" -ArgumentList '/silent' -Wait
Write-Host -ForegroundColor yellow -BackgroundColor black "And finally, installing Raptor Hardware Services..."
Write-Host -ForegroundColor yellow -BackgroundColor black "This will take awhile, go get a coffee or something."
Start-Process -NoNewWindow "\\tornado\install\Raptor\Raptor.HardwareServices_2_3_6_0.exe" -ArgumentList '/silent' -Wait
Write-Host -ForegroundColor Black -BackgroundColor White "All done!"
Pause
Main-Menu