let boo = 5
let str = "string"
let str = 'az'
let result = "default"
if boo < 2
    let result = "boo greater than 2"
elseif str == "string"
    let result = "str == string"
":h regexp, :h =~
elseif str =~ '[a-z]\+'
    let result = "str match a-z"
endif
echo result

"Vim automatically converts a string to a number when it is looking for
"    a number.  When using a string that doesn't start with a digit the
"    resulting number is zero.
if ! "false"
    echo "it is 0"
endif

if "true"
    echo "it is true"
else
    echo "it is 0"
endif

echo &term
if &term == "xterm"
    " Do stuff for xterm
elseif &term == "vt100"
    " Do stuff for a vt100 terminal
else
    " Do something for other terminals
endif

"LOGIC OPERATIONS
let a = 2
let b = 3
echo   a b
echo   a == b   "equal to"
echo   a != b   "not equal to"
echo   a > b    "greater than"
echo   a>= b    "greater than or equal to"
echo   a < b    "less than"
echo   a <= b   "less than or equal to"


echo v:version
if v:version >= 700
    echo "congratulations"
else
    echo "you are using an old version, upgrade!"
endif

" string will convert into number 0
if 0 == "one"
    echo "0 is always equal 'string'"
endif

let a = "str"
let b = "[a-z]*"
echo  a =~ b      "matches with"
echo  a !~ b      "does not match with"

if str =~ " "
    echo "str contains a space"
endif

if str !~ '\.$'
    echo "str does not end in a full stop"
endif

if "abc" ==? "ABC"
    echo "==? ignore case"
endif


if "ABC" ==# "ABC"
    echo "==# case sensitive"
endif


if "ABC" =~? "[abC]*"
    echo "=~? ignore case sensitive"
endif
