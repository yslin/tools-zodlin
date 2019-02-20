
@echo off
setlocal

call :initColorPrint

call :colorPrint 0a "a" /n
call :colorPrint 0b "b" /n
set "txt=^" & call :colorPrintVar 0c txt /n
call :colorPrint 0d "<" /n
call :colorPrint 0e ">" /n
call :colorPrint 0f "&" /n
call :colorPrint 1a "|" /n
call :colorPrint 1b " " /n
call :colorPrint 1c "%%%%" /n
call :colorPrint 1d ^""" 
echo(
call :colorPrint 1e "*" /n
call :colorPrint 1f "?" /n
call :colorPrint 2a "!" /n
call :colorPrint 2b "." /n
call :colorPrint 2c ".." /n
call :colorPrint 2d "/" /n
call :colorPrint 2e "\" /n
call :colorPrint 2f "q:" /n
call :colorPrint 3a "a/b/" /n
call :colorPrint 3a "a\b\" /n
echo(
set complex="c:\hello world!/.\..\\a//^<%%>&|!" /^^^<%%^>^&^|!\
call :colorPrintVar 74 complex /n


@echo off
setlocal disableDelayedExpansion
set q=^"
echo(
echo(
call :c 0E "                ,      .-;" /n
call :c 0E "             ,  |\    / /  __," /n
call :c 0E "             |\ '.`-.|  |.'.-'" /n
call :c 0E "              \`'-:  `; : /" /n
call :c 0E "               `-._'.  \'|" /n
call :c 0E "              ,_.-=` ` `  ~,_" /n
call :c 0E "               '--,.    "&call :c 0c ".-. "&call :c 0E ",=!q!." /n
call :c 0E "                 /     "&call :c 0c "{ "&call :c 0A "* "&call :c 0c ")"&call :c 0E "`"&call :c 06 ";-."&call :c 0E "}" /n
call :c 0E "                 |      "&call :c 0c "'-' "&call :c 06 "/__ |" /n
call :c 0E "                 /          "&call :c 06 "\_,\|" /n
call :c 0E "                 |          (" /n
call :c 0E "             "&call :c 0c "__ "&call :c 0E "/ '          \" /n
call :c 02 "     /\_    "&call :c 0c "/,'`"&call :c 0E "|     '   "&call :c 0c ".-~!q!~~-." /n
call :c 02 "     |`.\_ "&call :c 0c "|   "&call :c 0E "/  ' ,    "&call :c 0c "/        \" /n
call :c 02 "   _/  `, \"&call :c 0c "|  "&call :c 0E "; ,     . "&call :c 0c "|  ,  '  . |" /n
call :c 02 "   \   `,  "&call :c 0c "|  "&call :c 0E "|  ,  ,   "&call :c 0c "|  :  ;  : |" /n
call :c 02 "   _\  `,  "&call :c 0c "\  "&call :c 0E "|.     ,  "&call :c 0c "|  |  |  | |" /n
call :c 02 "   \`  `.   "&call :c 0c "\ "&call :c 0E "|   '     "&call :c 0A "|"&call :c 0c "\_|-'|_,'\|" /n
call :c 02 "   _\   `,   "&call :c 0A "`"&call :c 0E "\  '  . ' "&call :c 0A "| |  | |  |           "&call :c 02 "__" /n
call :c 02 "   \     `,   "&call :c 0E "| ,  '    "&call :c 0A "|_/'-|_\_/     "&call :c 02 "__ ,-;` /" /n
call :c 02 "    \    `,    "&call :c 0E "\ .  , ' .| | | | |   "&call :c 02 "_/' ` _=`|" /n
call :c 02 "     `\    `,   "&call :c 0E "\     ,  | | | | |"&call :c 02 "_/'   .=!q!  /" /n
call :c 02 "     \`     `,   "&call :c 0E "`\      \/|,| ;"&call :c 02 "/'   .=!q!    |" /n
call :c 02 "      \      `,    "&call :c 0E "`\' ,  | ; "&call :c 02 "/'    =!q!    _/" /n
call :c 02 "       `\     `,  "&call :c 05 ".-!q!!q!-. "&call :c 0E "': "&call :c 02 "/'    =!q!     /" /n
call :c 02 "    jgs _`\    ;"&call :c 05 "_{  '   ; "&call :c 02 "/'    =!q!      /" /n
call :c 02 "       _\`-/__"&call :c 05 ".~  `."&call :c 07 "8"&call :c 05 ".'.!q!`~-. "&call :c 02 "=!q!     _,/" /n
call :c 02 "    __\      "&call :c 05 "{   '-."&call :c 07 "|"&call :c 05 ".'.--~'`}"&call :c 02 "    _/" /n
call :c 02 "    \    .=!q!` "&call :c 05 "}.-~!q!'"&call :c 0D "u"&call :c 05 "'-. '-..'  "&call :c 02 "__/" /n
call :c 02 "   _/  .!q!    "&call :c 05 "{  -'.~('-._,.'"&call :c 02 "\_,/" /n
call :c 02 "  /  .!q!    _/'"&call :c 05 "`--; ;  `.  ;" /n
call :c 02 "   .=!q!  _/'      "&call :c 05 "`-..__,-'" /n
call :c 02 "    __/'" /n
echo(

call :cleanupColorPrint
pause
exit /b

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:c Color  Str  [/n]
setlocal
set "str=%~2"
call :colorPrintVar %1 str %3
exit /b


:colorPrint Color  Str  [/n]
setlocal
set "str=%~2"
call :colorPrintVar %1 str %3
exit /b

:colorPrintVar  Color  StrVar  [/n]
if not defined %~2 exit /b
setlocal enableDelayedExpansion
set "str=a%DEL%!%~2:\=a%DEL%\..\%DEL%%DEL%%DEL%!"
set "str=!str:/=a%DEL%/..\%DEL%%DEL%%DEL%!"
set "str=!str:"=\"!"
pushd "%temp%"
findstr /p /A:%1 "." "!str!\..\x" nul
if /i "%~3"=="/n" echo(
exit /b

:initColorPrint
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "DEL=%%a"
<nul >"%temp%\x" set /p "=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%.%DEL%"
exit /b

:cleanupColorPrint
del "%temp%\x"
exit /b
