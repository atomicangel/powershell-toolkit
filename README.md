# powershell-toolkit
A basic toolkit that launches other PowerShell scripts.

For reference as to what scripts I would call with the overall toolkit, look under the Scripts folder.

The Go.au3 file is used to run the main.ps1 file wrapped inside of an EXE. Did this as it was tedious launching the .ps1 file in an environment that had running scripts disabled as part of good security practice.
It also enabled including extra files such as the Functions.ps1 file so that the main.ps1 file would be easier to manage.

Originally this file included all of the scripts as well but debugging became tedious when the script would work outside of the EXE but once compiled it would crash due to a lacking dependency or other issue.
Hence the update that made it so the Scripts would exist outside of the EXE for rapid development purposes.

Build instructions:
Pull down the repo using
```git clone https://github.com/atomicangel/powershell-toolkit.git```
and make the necessary changes inside of ```main.ps1``` to fit your domain environment. Specifically under the ```File-Menu function``` you need to set the path for the Scripts folder. Under the ```Functions.ps1``` you need to set the ```$server``` and ```$search_base``` variables. The ```$disabled_ou``` variable is there since it was used in a system I worked with, but if you don't need that you can delete/comment out all lines containing that variable and it won't break the script as it's only there for output purposes.
