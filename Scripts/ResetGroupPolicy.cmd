@echo off

echo Cleaning up Group Policy...
echo.
del /S /Q C:\Windows\System32\GroupPolicy
del /S /Q C:\Windows\System32\GroupPolicyUsers

echo.

gpupdate /force

pause