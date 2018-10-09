@echo off
REM 讓 Bat 檔裡的中文字正常顯示與讀取,chcp 變更 Command Line 語系為 UTF8 (代碼為 65001)
chcp 65001
@echo off
setlocal

set vimrc=%programfiles(x86)%\Vim\_vimrc 
REM 開啟vim查詢:help vimrc,可以得知$HOME=%USERPROFILE%
set vimfiles=%USERPROFILE%\vimfiles
set .vim=%USERPROFILE%\.vim


call :isAdmin

if %errorlevel% == 0 (
  goto :run
) else (
  echo Requesting administrative privileges...
  goto :UACPrompt
)

:isAdmin
fsutil dirty query %systemdrive% >nul
exit /b

:run
REM 建立symbolic link到此batch目錄下的.vimrc
if exist %vimrc% (
    echo "delete %vimrc%"
    del "%vimrc%"
)
mklink "%vimrc%" "%~dp0vim\.vimrc"

REM 建立vim plugin目錄的symbolic link
if exist %vimfiles% (
    echo "delete %vimfiles%"
    del "%vimfiles%"
)
mklink "%vimfiles%" "%~dp0vim\.vim"

REM 建立vim plugin目錄的symbolic link給pathogen使用
if exist %.vim% (
    echo "delete %.vim%"
    del "%.vim%"
)
mklink "%.vim%" "%~dp0vim\.vim"
exit /b

:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"

"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
pause
exit /b
