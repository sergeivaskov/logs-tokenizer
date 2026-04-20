@echo off
REM Logs Tokenizer launcher
REM Usage: Double-click this file

cd /d "%~dp0"

echo ========================================
echo   Logs Tokenizer - Smart log compression
echo ========================================
echo.
echo Starting...
echo.

REM Visible window for debugging (good for first run)
REM If works fine, uncomment line below and comment current one
powershell.exe -ExecutionPolicy Bypass -File "logs-tokenizer.ps1"

REM For hidden mode use this line:
REM start "Logs Tokenizer" powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "logs-tokenizer.ps1"

echo.
echo Logs Tokenizer finished
pause
