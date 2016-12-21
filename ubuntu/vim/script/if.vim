" In Vimscript, as in C, only the numeric value zero is false in a boolean
" context; any non-zero numeric value—whether positive or negative—is
" considered true. However, all the logical and comparison operators
" consistently return the value 1 for true.

" True
echo "True:" 1 == 1
" False
echo "False:" 1 != 1

" When a string is used as a boolean, it is first converted to an integer, and
" then evaluated for truth (non-zero) or falsehood (zero). This implies that
" the vast majority of strings—including most non-empty strings—will evaluate
" as being false.
if !""
    echo "\"\" is false"
endif

if !"false"
    echo "\"false\" is false"
endif

if !"true"
    echo "\"true\" is false"
endif

if "8"
    echo "\"8\" is true"
endif

if !"0"
    echo "\"0\" is false"
endif

if empty("")
   echo "empty string is true"
endif

if !empty("some")
   echo "nonempty string is false"
endif

let ident = 'Vim'

if ident == 0   "Always true (string 'Vim' converted to number 0)
    echo ident "always equals to 0"
endif

if ident == '0'  "Uses string equality if ident contains string
                 "but numeric equality if ident contains number
    echo ident " equal to 0"      
endif

" String comparisons normally honor the local setting of Vim's ignorecase
" option, but any string comparator can also be explicitly marked as
" case-sensitive (by appending a #) or case-insensitive (by appending a ?):
let name = 'batman'
if name ==? 'Batman'         | "Equality always case insensitive
    echo "I'm [Bb]atman"
endif

if name ==# 'Batman' | "Equality always case sensitive
    echo "I'm Batman"
endif

if version >= 500
    echo version
endif

" :h expr4
if "a" == "a"
    echo "a equal"
endif


if "a" != "b"
    echo "a != b"
endif

let i = 2
if i % 2 == 1
    echo "is 1"
else
    echo "is 0"
endif

let str = "b"
if str == "a"
    echo "a"
elseif str == "b"
    echo "b"
else
    echo "c"
endif
