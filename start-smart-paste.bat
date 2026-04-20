@echo off
REM Smart Paste launcher
REM Запускает утилиту из src директории

cd /d "%~dp0"

echo ========================================
echo   Smart Paste - Smart log compression
echo ========================================
echo.
echo Starting from root directory...
echo.

REM Visible window for debugging
powershell.exe -ExecutionPolicy Bypass -File "src\smart-paste-logs.ps1"

REM For hidden background mode use:
REM start "Smart Paste" powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "src\smart-paste-logs.ps1"

echo.
echo Smart Paste finished
pause
