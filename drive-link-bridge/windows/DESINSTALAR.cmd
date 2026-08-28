@echo off
setlocal
reg delete "HKCU\Software\Classes\gdriveopen" /f >nul 2>&1
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Remove-Item -LiteralPath (Join-Path $env:LOCALAPPDATA 'DriveLinkBridge') -Recurse -Force -ErrorAction SilentlyContinue"
echo.
echo DriveLinkBridge removido do usuario atual.
echo.
pause
