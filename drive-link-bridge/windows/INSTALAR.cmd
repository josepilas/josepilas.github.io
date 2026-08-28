@echo off
setlocal
set "ROOT=%~1"
if "%ROOT%"=="" (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0instalar.ps1"
) else (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0instalar.ps1" -DriveRoot "%ROOT%"
)
echo.
pause
