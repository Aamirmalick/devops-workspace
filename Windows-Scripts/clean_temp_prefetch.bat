@echo off
:: Check and Request Admin Privileges in the Same Window
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c %~fnx0' -Verb RunAs -WindowStyle Maximized"
    exit /b
)

:: Maximize the Command Prompt window (works after admin check)
powershell -Command "&{$wshell = New-Object -ComObject WScript.Shell; $wshell.SendKeys('^%{ENTER}')}" 


:: Set text color to Green (02 = Black background, Green text)
color 02

:: Check if banner.txt exists before displaying it
if exist D:\Devops-Practice\Windows-Scripts\banner.txt (
    type D:\Devops-Practice\Windows-Scripts\banner.txt
) else (
    echo [ERROR] banner.txt not found! Make sure it is in the same folder as this script.
)

echo.
echo.
echo.
echo Cleaning Temporary Files and Prefetch...
echo.

:: Define Temp and Prefetch Paths
set TEMP_PATH=C:\Users\CIPL\AppData\Local\Temp
set PREFETCH_PATH=C:\Windows\Prefetch

:: Cleaning Temp Folder (C:\Users\CIPL\AppData\Local\Temp)
echo Cleaning Temp folder: %TEMP_PATH% ...
for /d %%x in ("%TEMP_PATH%\*") do rd /s /q "%%x"
del /s /f /q "%TEMP_PATH%\*"
echo Temp folder cleaned.
echo.

:: Cleaning Prefetch Folder (C:\Windows\Prefetch)
echo Cleaning Prefetch folder: %PREFETCH_PATH% ...
for /d %%x in ("%PREFETCH_PATH%\*") do rd /s /q "%%x"
del /s /f /q "%PREFETCH_PATH%\*"
echo Prefetch folder cleaned.
echo.

echo Cleaning complete!
pause
