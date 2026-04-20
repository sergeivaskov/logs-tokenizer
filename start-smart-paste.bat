@echo off
REM Smart Paste launcher
REM Usage: Double-click this file

cd /d "%~dp0"

echo ========================================
echo   Smart Paste - Smart log compression
echo ========================================
echo.
echo Starting...
echo.

REM Visible window for debugging (good for first run)
REM If works fine, uncomment line below and comment current one
powershell.exe -ExecutionPolicy Bypass -File "smart-paste-logs.ps1"

REM For hidden mode use this line:
REM start "Smart Paste" powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "smart-paste-logs.ps1"

echo.
echo Smart Paste finished
pause
