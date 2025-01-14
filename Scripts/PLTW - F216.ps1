<# Need to confirm all of the stages.
XILINX has been updated for sure. I don't see ROBOTC or America's Army listed as part of the coursework.

Made all the changes I think are necessary. I mostly commented out the old programs for the time being, will remove once I'm done testing.

#>


# New F216 Post-Install Script

# Updated 16.02.2023 - Made ROBOTC and America's Army installers automatic.

# This will abort the script if it finds the final placeholder.

If (Test-Path "C:\install\F216 Post Install.txt") { 
	Write-Host "You have finished the install, aborting. If you want to run it, delete C:\install\F216 Post Install.txt first."
	Exit 88
}

If (-Not(Test-Path "C:\Users\Public\Desktop\F216.cmd")){
Write-Host "Creating a shortcut on the Desktop so it's easy to re-run the script."
cp "\\location\of\batch_file\F216.cmd" "C:\Users\Public\Desktop\"
}

notepad "\\location\of\install\PLTW\F216 Post Unattend Install Instructions.txt"

# From there grab the step number from the temporary placeholder and continue onward.
If (Test-Path C:\install\f216.txt) {
	[int]$global:stepnumber = Get-Content -Path C:\install\F216.txt
} Else {
	[int]$global:stepnumber = 1 
}

Write-Host $stepnumber

# This will cycle through the steps needed to install all the requisite software.

function installer {
# Parameters that indicate where to grab the installer and where to check that the install worked.
param ( [string]$installerpath = "\\location\of\installers\",$checkinstallpath = "C:\Program Files\" )   # Had to have default values for variables.
                    
        $process = Start-Process $installerpath -Wait -PassThru
        Write-Host $("Exit code: " + $process.ExitCode)
        If ($process.ExitCode -eq 0 -OR $process.ExitCode -eq 1603 -OR $process.ExitCode -eq 3010) {                                      # Exit 1603 is what MultiSim outputs when you tell it to not reboot, so we account for that as well.
			If (Test-Path $checkinstallpath) {                                               # Check the supplied installer path.
				$global:stepnumber++                                                                    # Increment the stepnumber
				Set-Content -Path C:\install\F216.txt -Value $global:stepnumber                         # Adjust the value of the temporary placeholder file
            } Else {
                Write-Host "File not found, check install path and update script..."     # These two sections handle errors and exit with the proper exit code
                [console]::beep(700,300) ; [console]::beep(500,300)                      # and with a proper displayed message.
                Exit 1701
				}
        } Else {
            Write-Host "Installer did not finish properly, exiting...."
            [console]::beep(500,300) ; [console]::beep(400,300)
            Exit 88
        }
}

function install {
switch ($stepnumber) {
    '1' { # Multisim Installer
        Write-Host "Step 1 - Multisim Installer"                                          # Next line will call installer function with supplied variables.
        & "\\location\of\install\PLTW\DE Software Suite\Step 1 Multisim\Setup\setup.exe"
        Read-Host -Prompt "Press Enter once the installer is done to increment the counter file."
        If (Test-Path "C:\Program Files (x86)\National Instruments\Circuit Design Suite 14.1\multisim.exe") {
        Write-Host "Multisim installed!"
    	$global:stepnumber++                                                                    # Increment the stepnumber
    	Set-Content -Path C:\install\F216.txt -Value $global:stepnumber                         # Adjust the value of the temporary placeholder file
        # Write-Host "Multisim installed! Press Enter to reboot. Will do this during debugging, once verified will be automatic."
        [console]::beep(500,300) ; [console]::beep(600,300)
        # Pause
        sleep 5
        restart-computer -force
        }
		}
    '2' { # Activate Multisim and run Vivado Insatller
		Write-Host "Activate MultiSim and turn off updates."
        Start-Process -FilePath "C:\Program Files (x86)\National Instruments\Shared\License Manager\Bin\nilmUtil.exe"
        Pause
        Write-Host " Step 2 - Vivado Installer"                                           # Next line will call installer function with supplied variables.
        If (Test-Path "\\location\of\install\PLTW\DE Software Suite\Step 2 Vivado\Setup\xsetup.exe") {
            installer -installerpath "\\location\of\install\PLTW\DE Software Suite\Step 2 Vivado\Setup\xsetup.exe" -checkinstallpath "C:\Xilinx\xic\xic.exe"
        } Else {
            installer -installerpath "\\location\of\install\PLTW\DE Software Suite\Step 2 Vivado\Xilinx_2022_self_extracting.exe" -checkinstallpath "C:\Xilinx\xic\xic.exe"
        }
        Write-Host "Vivado Xilinx 2022 installed."
        [console]::beep(500,300) ; [console]::beep(600,300)
        sleep 5
        install
		}
    #'3' { # Vivado Updater
    #    Write-Host " Step 3 - Vivado Updater"                                             # Next line will call installer function with supplied variables.
    #    installer -installerpath "\\location\of\install\PLTW\DE Software Suite\Step 2 Vivado\Step 2 - Update_2017.4.1_0131_1\xsetup.exe" -checkinstallpath "C:\Xilinx\Vivado\2017.4\win64\tools\eclipse\eclipse.exe"
    #    Write-Host "Vivado Xilinx 2017 Updater finished."
    #    [console]::beep(500,300) ; [console]::beep(600,300)
    #    sleep 5
    #    install
	#	}
    '3' { # Copy the config files
        Copy-Item -Recurse "\\location\of\install\PLTW\DE Software Suite\Step 3 Config Files\*" "C:\Program Files (x86)\National Instruments\Circuit Design Suite 14.1\pldconfig\"
        If (Test-Path "C:\Program Files (x86)\National Instruments\Circuit Design Suite 14.1\pldconfig\DigilentPLTWS7.mspc") {
			$stepnumber++
            Set-Content -Path C:\install\F216.txt -Value $stepnumber
            sleep 5
			}
        install
		}
    '4' { # NIELVISmx Installer
        Write-Host " Step 4 - NIELVISmx Installer"                                        # Next line will call installer function with supplied variables.
        installer -installerpath "\\location\of\install\PLTW\DE Software Suite\Step 4 NI ELVISmx\setup.exe" -checkinstallpath "C:\Program Files (x86)\National Instruments\NI ELVISmx Instrument Launcher\niiql.exe"
        Write-Host "NIELVIXmx installed. Will reboot automatically."
        [console]::beep(500,300) ; [console]::beep(600,300)
        sleep 5
        Restart-Computer -force
		}
    '5' { # Ardiuno Installer
        Write-Host " Step 5 - Arduino Installer"                                          # Next line will call installer function with supplied variables.
        installer -installerpath "\\location\of\install\PLTW\Arduino\arduino-1.8.5-windows.exe" -checkinstallpath "C:\Program Files (x86)\Arduino\arduino.exe"
        Write-Host "Ardiuno installed."
        [console]::beep(500,300) ; [console]::beep(600,300)
        sleep 5
        install
		}
    #'6' { # ROBOTC Installer
	#	Write-Host " Step 6 - ROBOTC Installer"                                           # Next line will call msiexec and install the program.
    #    $msiargs = '/i', "\\location\of\install\PLTW\ROBOTC\ROBOTCforVEXRobotics_456Release.msi", '/qb' , 'ALLUSERS=1'
    #    Start-Process msiexec -ArgumentList $msiargs -Wait -Passthru
    #    If (Test-Path "C:\Program Files (x86)\Robomatter Inc\ROBOTC Development Environment 4.X\RobotC.exe") { 
    #    $global:stepnumber++                                                                    # Increment the stepnumber
	#	Set-Content -Path C:\install\F216.txt -Value $global:stepnumber                         # Adjust the value of the temporary placeholder file
    #    Write-Host "ROBOTC installed."
    #   [console]::beep(500,300) ; [console]::beep(600,300)
    #    sleep 5
    #    install
    #        } Else {
    #            Write-Host "File not found, check install path and update script..."     # These two sections handle errors and exit with the proper exit code
    #            [console]::beep(700,300) ; [console]::beep(500,300)                      # and with a proper displayed message.
    #            Read-Host -Prompt "Press Enter to exit script."
    #            Exit 1701
	#			}
	#	}
    '6' { # America's Army
    #    Write-Host " Step 7 - America's Army Installer"                                   # Next line will call msiexec and install the program.
    #    $msiargs = '/i', "\\F220S01\D$\AA_Install.msi", '/qb'
    #    Start-Process msiexec -ArgumentList $msiargs -Wait -Passthru
    #
    #    If (Test-Path "C:\Program Files (x86)\America's Army Education\system\ArmyOps.exe") { # Check that the program actually installed.
    #        Write-Host "America's Army installed."
    #        [console]::beep(500,300) ; [console]::beep(600,300)
    #        cd $env:USERPROFILE\Desktop
    #            If ( $env:COMPUTERNAME -eq "F216S25" ) {                                      # If it's the teacher station, move Teacher icon and delete Student icon.
    #                mv '.\America''s Army Education Teacher.lnk' C:\Users\Public\Desktop\
    #                rm '.\America''s Army Education Student.lnk'
    #            } Else {                                                                      # If it's any other station, move the Student icon and delete the Teacher icon.
    #                mv '.\America''s Army Education Student.lnk' C:\Users\Public\Desktop\
    #                rm '.\America''s Army Education Teacher.lnk'
    #           }
            
            remove-item C:\install\f216.txt
            Set-Content -Path 'C:\install\F216 Post Install.txt' -Value "F216 Post Install Placeholder"
            rm "C:\Users\Public\Desktop\F216.cmd"
            sleep 5
            Exit 0
            
    #        } Else {
    #            Write-Host "File not found, check install path and update script..."     # These two sections handle errors and exit with the proper exit code
    #            [console]::beep(700,300) ; [console]::beep(500,300)                      # and with a proper displayed message.
    #            Read-Host -Prompt "Press Enter to exit script."
    #            Exit 1701
	#			}
		}
                    
    default {
		Write-Host "Something went wrong. Need to debug."
        pause
		}
    }
 }

install