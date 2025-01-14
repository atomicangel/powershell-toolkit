<# Version 1.1 - 06-03-2024

Added the ability to export as a CSV file with the same information that we would see when displaying the list on-screen.
This allows us to easily pull a list of devices and then open them into Excel for referencing or organizing.

#>

Prompt-List

Write-Output "Default action is to output to the screen, but you can also save it as a CSV file."
$temp_query = Read-Host -Prompt "Would you like to save as a csv file? (y/N)"

If ( $temp_query -eq "y") {

$outfilepath = '\\location\of\logging\folder'

$outfilename = Read-Host -Prompt "File name to write to"
$outfile = $($outfilepath + $outfilename + ".csv")
Write-Output $("Location of File: " + $outfile)
$newcsv = {} | Select "MachineName","LAPs-Admin-Pass","Description", "OS-Version", "AD-Location" | Export-Csv $outfile

$csvfile = Import-CSV $outfile  # Only need to import the file once before running the loop.
foreach ($computer in $list) {
	
	$csvfile.MachineName = $computer.name
	$csvfile.'LAPs-Admin-Pass' = $computer.'ms-Mcs-AdmPwd'
	$csvfile.Description = $computer.description
    $csvfile.'OS-Version' = $computer.OperatingSystemVersion
    $csvfile.'AD-Location' = $computer.CanonicalName
	$csvfile | Export-Csv $outfile -Append

<# Debugging
	Write-Output $computer.name
	Write-Output $computer.'ms-Mcs-AdmPwd'
	Write-Output $computer.description
	Write-Output $computer.OperatingSystemVersion
	Write-Output $computer.CanonicalName
#>
}
Read-Host -Prompt "File has been written to disk. Press Enter to return to menu."
}
else {
Write-Output $list | Format-Table -AutoSize -Property Name,'ms-Mcs-AdmPwd',Description,OperatingSystemVersion,CanonicalName
pause
}
Main-Menu