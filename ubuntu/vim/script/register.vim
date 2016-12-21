"register '%' (name of the current	file) 
echo @% . " = register.vim"

"register '#' (name of the alternate file) cannot be used.
"echo @#

" @= you are prompted to enter an expression.  
echo ""
:execute "normal! @=9*10-11\<cr>"
echo @= . " = 9*10-11"

" <c-v><c-m> =  is "<cr>"
echo ""
:normal! @=1*2+3
echo @= . " = 1*2+3"
"register ':' Contains the most recent executed command-line.
echo @:

"register '@' contains copy content 
echo @@
