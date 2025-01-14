# powershell-toolkit
A basic toolkit that launches other PowerShell scripts.

For reference as to what scripts I would call with the overall toolkit, look under the Scripts folder.

The Go.au3 file is used to run the main.ps1 file wrapped inside of an EXE. Did this as it was tedious launching the .ps1 file in an environment that had running scripts disabled as part of good security practice.
It also enabled including extra files such as the Functions.ps1 file so that the main.ps1 file would be easier to manage.

Originally this file included all of the scripts as well but debugging became tedious when the script would work outside of the EXE but once compiled it would crash due to a lacking dependency or other issue.
Hence the update that made it so the Scripts would exist outside of the EXE for rapid development purposes.

Build instructions:

**I encourage you to look over all the code before blindly running it. Good security posture to do that.**

Pull down the repo using
```git clone https://github.com/atomicangel/powershell-toolkit.git```
and make the necessary changes inside of ```main.ps1``` to fit your domain environment. Specifically under the **File-Menu function** you need to set the path for the Scripts folder. Under the ```Functions.ps1``` you need to set the **$server** and **$search_base** variables. The **$disabled_ou** variable is there since it was used in a system I worked with, but if you don't need that you can delete/comment out all lines containing that variable and it won't break the script as it's only there for output purposes.

The Go.au3 file is built with AutoIt v3, so you will need to also grab that: ```https://www.autoitscript.com/site/```

Just run the Go.au3 through the Au3toExe_x64 (you can use the x86 compiler for a legacy system) compiler pointing it at the Go.au3 file for input and you will be good to go. **I would change the Compression settings to not use the UPX stub as that can trigger Antivirus software.** Once you do that, it should have created Go.exe in the project folder. Move that to a location convenient and run it.
