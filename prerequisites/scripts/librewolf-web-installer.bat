@echo off
setlocal EnableDelayedExpansion

set "aria2c=C:\prerequisites\aria2c.exe"
set "link=https://gitlab.com/librewolf-community/browser/windows/uploads/72e64b46c7986ab436cd82f263062861/librewolf-106.0-2.en-US.win64-setup.exe"
set "sha1=62859eb9064175600f76f8632e5c9261472a94cd"
set "file_name=librewolf-106.0-2.en-US.win64-setup.exe"
set "working_dir=!temp!\librewolf"

ping archlinux.org > nul 2>&1
if not !errorlevel! == 0 (
    echo error: no internet connection
    echo info: press any key to continue
    pause > nul 2>&1
    exit /b 1
)

if not exist "!aria2c!" (
    echo error: !aria2c! not exists
    echo info: press any key to continue
    pause > nul 2>&1
    exit /b 1
)

if exist !working_dir! (
    rd /s /q "!working_dir!"
)
mkdir "!working_dir!"

echo info: downloading librewolf
"!aria2c!" "!link!" -d "!working_dir!" -o "!file_name!"

if not exist "!working_dir!\!file_name!" (
    echo error: download unsuccessful, please download librewolf manually
    echo info: press any key to continue
    pause > nul 2>&1
    exit /b 1
)

for /f "delims=" %%a in ('certutil -hashfile "!working_dir!\!file_name!" SHA1 ^| find /i /v "SHA1" ^| find /i /v "Certutil"') do (
    set "file_sha1=%%a"
)
set "file_sha1=!file_sha1: =!"

if not "!file_sha1!" == "!sha1!" (
    echo error: sha1 mismatch, binary may be corrupted
)

start "" "!working_dir!\!file_name!"

echo info: press any key to continue
pause > nul 2>&1
exit /b 0

