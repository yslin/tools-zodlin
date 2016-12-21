REM 建立symbolic link到此batch目錄下的.vimrc
if exist %programfiles(x86)%\Vim\_vimrc (
    echo "delete %programfiles(x86)%\Vim\_vimrc"
    del "%programfiles(x86)%\Vim\_vimrc"
)
mklink "%programfiles(x86)%\Vim\_vimrc" "%~dp0vim\.vimrc"

REM 建立vim plugin目錄的symbolic link
if exist %USERPROFILE%\vimfiles (
    echo "delete %USERPROFILE%\vimfiles"
    del "%USERPROFILE%\vimfiles"
)
mklink "%USERPROFILE%\vimfiles" "%~dp0vim\.vim"

REM 建立vim plugin目錄的symbolic link給pathogen使用
if exist %USERPROFILE%\.vim (
    echo "delete %USERPROFILE%\.vim"
    del "%USERPROFILE%\.vim"
)
mklink "%USERPROFILE%\.vim" "%~dp0vim\.vim"
pause
