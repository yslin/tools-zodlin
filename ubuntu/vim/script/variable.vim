":h 41.2

"Table 1. Vimscript variable scoping
"Prefix       Meaning
"g: varname   The variable is global
"s: varname   The variable is local to the current script file
"w: varname   The variable is local to the current editor window
"t: varname   The variable is local to the current editor tab
"b: varname   The variable is local to the current editor buffer
"l: varname   The variable is local to the current function
"a: varname   The variable is a parameter of the current function
"v: varname   The variable is one that Vim predefines

"Table 2. Vimscript pseudovariables
"Prefix        Meaning
"& varname     A Vim option (local option if defined, otherwise global)
"&l: varname   A local Vim option
"&g: varname   A global Vim option
"@ varname     A Vim register
"$ varname     An environment variable

"Table 3. expand()
echo "<cword>: " . expand("<cword>")
echo "<cWORD>: " . expand("<cWORD>")  
echo "<cfile>: " . expand("<cfile>")  
echo "<afile>: " . expand("<afile>")  
echo "<abuf>: " . expand("<abuf>")   
echo "<amatch>: " . expand("<amatch>") 
echo "<sfile>: " . expand("<sfile>")  
echo "<slnum>" . expand("<slnum>")  
	 
":h cmdline-special
echo "%(current file name): " . expand("%")
echo "#: " . expand("#")
echo "##: " . expand("##")

":h 41.8 List and Dictionary

let variable = 123
let string = "string"
let list = [1,2,3]
let strlist = [ "bar" , "foo" ]
let dict = { 'phone': '01234567' }
let dict.name = "Chopin"
echo dict

"Variable Scope
"non-prefix = global
"g: global
let var = "string"
let g:var_global = "global"

"s: script
let s:var_script = "script"
"b: buffer
let b:var_buffer = "buffer"
"v: vim built-in
"a: function arguments

let s:i = 100
echo s:i
unlet s:i
"Undefined variable: i
"echo s:i
"No such variable: "s:i", after unlet s:i  
"unlet s:i
"don't want an error message when it doesn't, append !
unlet! s:i

"When a script finishes, the local variables used there will not be
"automatically freed.  The next time the script executes, it can still use the
"old value.
if !exists("s:i")
    let s:i = 0
endif
echo s:i


echo "The value of 'tabstop' is" &ts
echo "Your home directory is" $HOME
"copy register
echo @0

let i=0
echo i
let i=i+1
echo i

let g:global_buffer = "global"
let b:global_buffer = "buffer"
echo g:global_buffer
echo b:global_buffer
