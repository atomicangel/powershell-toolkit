#RequireAdmin


DirCreate(@TempDir & "\Toolkit\Scripts\PLTW")
FileInstall(".\main.ps1", @TempDir & "\Toolkit\")
FileInstall(".\Functions.ps1",@TempDir & "\Toolkit\")

FileChangeDir(@TempDir & "\Toolkit\")

ShellExecuteWait("powershell", '-ep bypass -File .\main.ps1')

DirRemove(@TempDir & "\Toolkit\", 1)