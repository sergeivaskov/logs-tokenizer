@echo off
REM Logs Tokenizer launcher
REM Запускает утилиту из src директории

cd /d "%~dp0"

echo ========================================
echo   Logs Tokenizer - Smart log compression
echo ========================================
echo.
echo Starting from root directory...
echo.

REM Visible window for debugging
powershell.exe -ExecutionPolicy Bypass -File "src\logs-tokenizer.ps1"

REM For hidden background mode use:
REM start "Logs Tokenizer" powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "src\logs-tokenizer.ps1"

echo.
echo Logs Tokenizer finished
pause
