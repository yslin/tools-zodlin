echo "[\t]     <Tab>"
echo "[\n]     <NL>, line break"
echo "[\r]     <CR>, <Enter>"
echo "[\e]     <Esc>"
echo "[\b]     <BS>, backspace"
echo "[\"]     double quote"
echo "[\\]     \, backslash"
echo "[\<Esc>]     <Esc>"
echo "[\<C-W>]     CTRL-W"

func! CallParm(str)
    echo a:str
endf

call CallParm("hello")
call CallParm("\\/\"'")
exec "call CallParm(\"\\\\/\\\"'\")"

call CallParm("\n".'\\n')
exec "call CallParm(\"\\\n\".'\\\\n')"
