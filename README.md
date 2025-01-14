# powershell-toolkit
A basic toolkit that launches other PowerShell scripts.

For reference as to what scripts I would call with the overall toolkit, look under the Scripts folder.

The Go.au3 file is used to run the main.ps1 file wrapped inside of an EXE. Did this as it was tedious launching the .ps1 file in an environment that had running scripts disabled as part of good security practice.
It also enabled including extra files such as the Functions.ps1 file so that the main.ps1 file would be easier to manage.

Originally this file included all of the scripts as well but debugging became tedious when the script would work outside of the EXE but once compiled it would crash due to a lacking dependency or other issue.
Hence the update that made it so the Scripts would exist outside of the EXE for rapid development purposes.
