@echo off
mode 120,30
color 0A
title PigOS 0.1 - Advanced Batch Operating System

set "logfile=DebugLog.txt"
if not exist %logfile% echo DebugLog initialized. > %logfile%

echo [%date% %time%] PigOS 0.1 Started >> %logfile%

cls
echo     ╔═══════════════════════════╗
echo     ║    P I G O S   0 . 1      ║
echo     ║      L O A D I N G        ║
echo     ╚═══════════════════════════╝
echo.
timeout /t 2 >nul

:: Ensure user database exists
if not exist user.txt type nul > user.txt

:: Initialize system variables
set "system_version=0.1"
set "user_logged_in=0"
set "user_permission=0"

:: Main menu with navigation
:menu
cls
echo ====================================
echo         Welcome to PigOS 0.1
echo ====================================
echo 1. Login
echo 2. Register
echo 3. System Information
echo 4. Exit
echo ====================================
set /p choice=Choose an option: 
if "%choice%"=="1" goto login
if "%choice%"=="2" goto register
if "%choice%"=="3" goto sysinfo
if "%choice%"=="4" exit
goto menu

:register
cls
echo Register a new user
set /p username=Enter username: 
findstr /i "^%username%:" user.txt >nul && (echo Username already exists! & timeout /t 2 >nul & goto menu)
set /p password=Enter password: 
echo %username%:%password% >> user.txt
echo Registration successful!
echo [%date% %time%] User "%username%" registered. >> %logfile%
timeout /t 2 >nul
goto menu

:login
cls
echo Login to PigOS 0.1
set /p username=Enter username: 
set /p password=Enter password: 
set "loginSuccess=0"
for /f "tokens=1,2 delims=:" %%A in (user.txt) do (
    if /i "%%A"=="%username%" if "%%B"=="%password%" set loginSuccess=1
)
if "%loginSuccess%"=="1" (
    echo Login successful!
    echo [%date% %time%] User "%username%" logged in successfully. >> %logfile%
    set "user_logged_in=1"
    timeout /t 2 >nul 
    goto desktop
) else (
    echo Invalid credentials! 
    echo [%date% %time%] Failed login attempt for user "%username%". >> %logfile%
    timeout /t 2 >nul
    goto menu
)

:desktop
cls
echo ====================================
echo       PigOS 0.1 - User Dashboard
echo ====================================
echo 1. Notepad
echo 2. File Manager
echo 3. System Information
echo 4. Debugging Tools
echo 5. User Settings
echo 6. Logout
echo 7. Shutdown
echo ====================================
set /p choice=Choose an option: 
if "%choice%"=="1" goto notepad
if "%choice%"=="2" goto filemanager
if "%choice%"=="3" goto sysinfo
if "%choice%"=="4" goto debugtools
if "%choice%"=="5" goto usersettings
if "%choice%"=="6" goto logout
if "%choice%"=="7" exit
goto desktop

:notepad
cls
echo PigOS Notepad - Type your text below. Press CTRL+Z then ENTER to save.
set /p filename=Enter file name (without extension): 
copy con %filename%.txt
echo [%date% %time%] Created file "%filename%.txt" using Notepad. >> %logfile%
cls
echo File saved as "%filename%.txt"
pause
goto desktop

:filemanager
cls
echo File Manager
echo 1. View Files
echo 2. Delete File
echo 3. Rename File
echo 4. Move File
echo 5. Create New Folder
echo 6. View Folder Contents
echo 7. Back to Desktop
set /p fmchoice=Choose an option: 
if "%fmchoice%"=="1" (
    dir
    echo [%date% %time%] User viewed files. >> %logfile%
    pause
    goto filemanager
)
if "%fmchoice%"=="2" (
    set /p delfile=Enter filename to delete: 
    if exist "%delfile%" (
        del "%delfile%" 
        echo File "%delfile%" deleted successfully.
        echo [%date% %time%] Deleted file "%delfile%". >> %logfile%
    ) else (
        echo File not found.
        echo [%date% %time%] Failed to delete "%delfile%" (file not found). >> %logfile%
    )
    timeout /t 2 >nul
    goto filemanager
)
if "%fmchoice%"=="3" (
    set /p oldfile=Enter filename to rename: 
    set /p newfile=Enter new name: 
    rename "%oldfile%" "%newfile%"
    echo [%date% %time%] Renamed file "%oldfile%" to "%newfile%". >> %logfile%
    goto filemanager
)
if "%fmchoice%"=="4" (
    set /p movfile=Enter filename to move: 
    set /p newpath=Enter new path: 
    move "%movfile%" "%newpath%"
    echo [%date% %time%] Moved file "%movfile%" to "%newpath%". >> %logfile%
    goto filemanager
)
if "%fmchoice%"=="5" (
    set /p foldername=Enter folder name: 
    mkdir "%foldername%" 
    echo [%date% %time%] Created folder "%foldername%". >> %logfile%
    goto filemanager
)
if "%fmchoice%"=="6" (
    set /p folder=Enter folder name: 
    dir "%folder%"
    echo [%date% %time%] Viewed contents of folder "%folder%". >> %logfile%
    pause
    goto filemanager
)
if "%fmchoice%"=="7" goto desktop
goto filemanager

:sysinfo
cls
echo System Information
systeminfo | more
echo [%date% %time%] User viewed system information. >> %logfile%
pause
goto desktop

:debugtools
cls
echo Debugging Tools
echo 1. View Running Processes
echo 2. System Performance
echo 3. View Network Configuration
echo 4. Check Disk Space
echo 5. Back to Desktop
set /p dbgchoice=Choose an option: 
if "%dbgchoice%"=="1" (
    tasklist
    echo [%date% %time%] User viewed running processes. >> %logfile%
    pause
    goto debugtools
)
if "%dbgchoice%"=="2" (
    wmic cpu get loadpercentage 
    wmic os get freephysicalmemory
    echo [%date% %time%] User checked system performance. >> %logfile%
    pause
    goto debugtools
)
if "%dbgchoice%"=="3" (
    ipconfig
    echo [%date% %time%] User checked network configuration. >> %logfile%
    pause
    goto debugtools
)
if "%dbgchoice%"=="4" (
    dir C:\ 
    echo [%date% %time%] User checked disk space. >> %logfile%
    pause
    goto debugtools
)
if "%dbgchoice%"=="5" goto desktop
goto debugtools

:usersettings
cls
echo User Settings
echo 1. Change Password
echo 2. Set Permissions (Admin/User)
echo 3. Back to Desktop
set /p usrchoice=Choose an option: 
if "%usrchoice%"=="1" goto changepassword
if "%usrchoice%"=="2" goto setpermissions
if "%usrchoice%"=="3" goto desktop
goto usersettings

:changepassword
cls
echo Change Password
set /p newpass=Enter new password: 
set "user_logged_in=0"
echo [%date% %time%] User "%username%" changed password. >> %logfile%
timeout /t 2 >nul
goto menu

:setpermissions
cls
echo Set User Permissions (Admin/User)
echo 1. Set Admin
echo 2. Set User
echo 3. Back to Desktop
set /p permchoice=Choose an option: 
if "%permchoice%"=="1" (
    set user_permission=1
    echo [%date% %time%] User "%username%" set as Admin. >> %logfile%
    goto desktop
)
if "%permchoice%"=="2" (
    set user_permission=0
    echo [%date% %time%] User "%username%" set as User. >> %logfile%
    goto desktop
)
if "%permchoice%"=="3" goto desktop
goto setpermissions

:logout
cls
echo Logging out...
echo [%date% %time%] User "%username%" logged out. >> %logfile%
set "user_logged_in=0"
timeout /t 2 >nul
goto menu
