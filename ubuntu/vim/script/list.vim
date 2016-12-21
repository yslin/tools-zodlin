func! LogFunc()
    let repl = substitute(expand("<sfile>"), '..LogFunc', "():", "g")
    echohl MoreMsg | echo repl | echohl None
endf

func! CreateList()
    call LogFunc()
    let data = [1,2,3,4,5,6,"seven"]
    echo data[0]                 | " echoes: 1
    let data[1] = 42             | " [1, 42, 3, 4, 5, 6, "seven"]
    let data[2] += 99            | " [1, 42, 102, 4, 5, 6, "seven"]
    let data[6] .= ' samurai'    | " [1, 42, 102, 4, 5, 6, "seven samurai"]
    let data[-1] .=  ' sakula'   | " [1, 42, 102, 4, 5, 6, "seven samurai sakula"]
    echo data
endf
call CreateList()

func! CreateNestedList()
    let pow = [
                \   [ 1, 0, 0, 0  ],
                \   [ 1, 1, 1, 1  ],
                \   [ 1, 2, 4, 8  ],
                \   [ 1, 3, 9, 27 ],
                \]
    " and later...
    echo pow        | " [[1, 0, 0, 0], [1, 1, 1, 1], [1, 2, 4, 8], [1, 3, 9, 27]]
    echo pow[0][0]  | " 1
    echo pow[3][3]  | " 27
endf

call CreateNestedList()

func! Assign()
    let old_suffixes = ['.c', '.h', '.py']
    let new_suffixes = old_suffixes
    let new_suffixes[2] = '.js'
    echo old_suffixes      |" echoes: ['.c', '.h', '.js']
    echo new_suffixes      |" echoes: ['.c', '.h', '.js']
endf

call Assign()

func! Copy()
    let old_suffixes = ['.c', '.h', '.py']
    let new_suffixes = copy(old_suffixes)
    let new_suffixes[2] = '.js'
    echo old_suffixes      |" echoes: ['.c', '.h', '.py']
    echo new_suffixes      |" echoes: ['.c', '.h', '.js']
endf

call Copy()

func! ShallowCopy()
    let pow = [
                \   [ 1, 0, 0, 0  ],
                \   [ 1, 1, 1, 1  ],
                \   [ 1, 2, 4, 8  ],
                \   [ 1, 3, 9, 27 ],
                \]
    let pedantic_pow = copy(pow)
    let pedantic_pow[0][0] = 'indeterminate'
    " also changes pow[0][0] due to shared nested list
    echo pow
    echo pedantic_pow
endf

call ShallowCopy()

func! DeepCopy()
    let pow = [
                \   [ 1, 0, 0, 0  ],
                \   [ 1, 1, 1, 1  ],
                \   [ 1, 2, 4, 8  ],
                \   [ 1, 3, 9, 27 ],
                \]
    let pedantic_pow = deepcopy(pow)
    let pedantic_pow[0][0] = 'indeterminate'
    " pow[0][0] now unaffected; no nested list is shared
    echo pow
    echo pedantic_pow
endf

call DeepCopy()

func! GetSize(a_list)
    let list_length   = len(a:a_list)
    return list_length
endf

echo GetSize([1,2,3]) | " 3

func! IsEmpty(a_list)
    let list_is_empty = empty(a:a_list)     " same as: len(a_list) == 0
    return list_is_empty
endf

echo IsEmpty([]) | " 1

func! GetMaxNumber(a_list)
    let greatest_elem = max(a:a_list)
    return greatest_elem
endf

echo GetMaxNumber([3,6,8,22,4]) | " 22

func! GetMinNumber(a_list)
    let least_elem = min(a:a_list)
    return least_elem 
endf

echo GetMinNumber([32,3,-8,5]) | " -8

func! SearchNumberIndex(list, value)
    let value_found_at = index(a:list, a:value)      " uses == comparison
    return value_found_at
endf

echo SearchNumberIndex([1,2,3,4], 3) | " 2

func! SearchStringIndex(list, pattern)
    let pat_matched_at = match(a:list, a:pattern)    " uses =~ comparison
    return pat_matched_at
endf

echo SearchStringIndex(["hello", "I", "am", "Peter"], "Pe") | " 3

func! GenerateRangeList(min, max, step)
    let sequence_of_ints = range(a:max)                  " 0...max-1
    echo sequence_of_ints | " [0, 1, 2, 3]
    let sequence_of_ints = range(a:min, a:max)           " min...max
    echo sequence_of_ints | " [1, 2, 3, 4]
    let sequence_of_ints = range(a:min, a:max, a:step)   " min, min+step,...max
    echo sequence_of_ints | " [1, 3]
endf

call GenerateRangeList(1,4,2)

func! GenerateSplitList(str, delimiter_pat)
    let words = split(a:str)                    " split on whitespace
    echo words | " ['What', 'a', 'computer-science', 'student!']
    let words = split(a:str, a:delimiter_pat)   " split where pattern matches
    echo words | " ['What a computer', 'science student!']
endf

call GenerateSplitList("What a computer-science student!", "-")

func! JoinList2String(list, delimiter)
    let str = join(a:list)                " use a single space char to join
    echo str | " A good so-called perfect pro-grammer
    let str = join(a:list, a:delimiter)   " use delimiter string to join
    echo str | " A good,so-called,perfect,pro-grammer
endf

call JoinList2String(["A good", "so-called", "perfect", "pro-grammer"], ",")

let g:mapping = []

func! Append()
    call add(g:mapping, 'a1')  " append new value to end of list
    call add(g:mapping, 'a2')  " append new value to end of list
endf

func! Insert()
    call insert(g:mapping, 'i1')     " insert new value at start of list
    call insert(g:mapping, 'i2', 1)  " insert new value before index 1
endf

call Append()
call Insert()

echo g:mapping | " ['i1', 'i2', 'a1', 'a2']

func! AddSet()
    call extend(g:mapping, [1,2])      " append new values to end of list
    call extend(g:mapping, [3,4], 0)   " insert new values before index idx
endf

call AddSet()
echo g:mapping | " [3, 4, 'i1', 'i2', 'a1', 'a2', 1, 2]


func! RemoveElement()
    call remove(g:mapping, 0)      " remove element at index 0
    call remove(g:mapping, 1, 3)   " remove elements in range of indices
endf

call RemoveElement()
echo g:mapping | " [4, 'a2', 1, 2]


func! Iterate()
    call LogFunc()
    for member in sort(g:mapping)
        echon member ","
    endfor
endf

call Iterate()

func! IterateNestedList()
    call LogFunc()
    let list_of_lists = [["peter", "99", "A19083"], ["boss", "100", "B3892"]]
    for nested_list in list_of_lists
        let name   = nested_list[0] 
        let rank   = nested_list[1] 
        let serial = nested_list[2] 

        echo rank . ' ' . name . '(' . serial . ')'
    endfor

    for [name, rank, serial] in list_of_lists
        echo rank . ' ' . name . '(' . serial . ')'
    endfor
endf

call IterateNestedList()


func! Sort()
    echo sort(g:mapping) | " re-order the elements of list alphabetically
endf

call Sort()

func! MyCompare(i1, i2)
    return a:i1 == a:i2 ? 0 : a:i1 > a:i2 ? 0 : 1
endf

func! SortDefinedCompare()
    call LogFunc()
    for dic in sort(g:mapping, function("MyCompare"))
        echon dic ","
    endfor
endf

call SortDefinedCompare()

func! SortReverse()
    echo reverse(g:mapping) | " reverse order of elements in list
endf

call SortReverse()

func! SortMistake()
    " Note that all list-related procedures also return the list they’ve just modified
    let unsorted_list = [9,2,3,8]
    let sorted_list = reverse(sort(unsorted_list))
    echo unsorted_list | " [9, 8, 3, 2]
    echo sorted_list   | " [9, 8, 3, 2]

    let unsorted_list = [9,2,3,8]
    let sorted_list = reverse(sort(copy(unsorted_list)))
    echo unsorted_list | " [9, 2, 3, 8]
    echo sorted_list   | " [9, 8, 3, 2]
endf

call SortMistake()

func! Filter()
    " Remove any negative numbers from a list
    let list_of_numbers = [3, -1, 5, -2, 0]
    let positive_only = filter(copy(list_of_numbers), 'v:val >= 0')
    echo list_of_numbers
    echo positive_only
    
    " Remove any names from a list that contain the pattern /.*nix/
    let list_of_systems = ['nix', 'unix', 'linux', 'ubuntu']
    let non_starnix = filter(copy(list_of_systems), 'v:val !~ ".*nix"')
    echo list_of_systems
    echo non_starnix
endf

call Filter()

func! Map()
    " increase every number in a list by 10
    let list_of_numbers = [3, -1, 5, -2, 0]
    let increased_numbers = map(copy(list_of_numbers), 'v:val + 10')
    echo list_of_numbers
    echo increased_numbers

    " capitalize each word in a list
    let list_of_words = ['what', 'a', 'word']
    let LIST_OF_WORDS = map(copy(list_of_words), 'toupper(v:val)')
    echo list_of_words
    echo LIST_OF_WORDS
endf

call Map()

func! Concatenation()
    let activities = ['sleep', 'eat'] + ['game', 'drink']
    let activities += ['code']
    echo activities

    " Concatenation needs two lists
    " let activities += 'code'    
    " Error: Wrong variable type for +=
endf

call Concatenation()

func! Sublist()
    let week = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat']
    let weekdays = week[1:5]
    let freedays = week[0:-2]
    echo weekdays
    echo freedays

    let data = [1,2,3,4,5]
    let middle = len(data)/2
    let first_half  = data[: middle-1]    " same as: data[0 : middle-1]
    let second_half = data[middle :]      " same as: data[middle : len(data)-1]
    echo data
    echo first_half
    echo second_half
endf

call Sublist()

" 使let敘述的 = 對齊,讓code更整潔
func! AlignAssignments ()
    " Patterns needed to locate assignment operators...
    let ASSIGN_OP   = '[-+*/%|&]\?=\@<!=[=~]\@!'
    let ASSIGN_LINE = '^\(.\{-}\)\s*\(' . ASSIGN_OP . '\)\(.*\)$'

    " Locate block of code to be considered (same indentation, no blanks)
    let indent_pat = '^' . matchstr(getline('.'), '^\s*') . '\S'
    let firstline  = search('^\%('. indent_pat . '\)\@!','bnW') + 1
    let lastline   = search('^\%('. indent_pat . '\)\@!', 'nW') - 1
    if lastline < 0
        let lastline = line('$')
    endif

    " Decompose lines at assignment operators...
    let lines = []
    for linetext in getline(firstline, lastline)
        let fields = matchlist(linetext, ASSIGN_LINE)
        call add(lines, fields[1:3])
    endfor

    " Determine maximal lengths of lvalue and operator...
    let op_lines = filter(copy(lines),'!empty(v:val)')
    let max_lval = max( map(copy(op_lines), 'strlen(v:val[0])') ) + 1
    let max_op   = max( map(copy(op_lines), 'strlen(v:val[1])'  ) )

    " Recompose lines with operators at the maximum length...
    let LVAL = 0
    let OP   = 1
    let RVAL = 2

    let linenum = firstline
    for line in lines
        if !empty(line)
            let newline
            \    = printf("%-*s%*s%s", max_lval, line[LVAL], max_op, line[OP], line[RVAL]) " easy to read
            "\    = printf("%-*s%*s%s", max_lval, line[0], max_op, line[1], line[2])   " hard to read
            call setline(linenum, newline)
        endif
        let linenum += 1
    endfor
endf

" :call AlignAssignments()
" let what = 2
" let wt = [1,3]
" let what_long_string = 'test'

" Table of completion specifications (a list of lists)...
let s:completions = []
" Function to add user-defined completions...
function! AddCompletion (left, right, completion, restore)
    call insert(s:completions, [a:left, a:right, a:completion, a:restore])
endfunction
let s:NONE = ""
" Table of completions...
"                    Left   Right    Complete with...           Restore
"                    =====  =======  ====================       =======
call AddCompletion(  '{',   s:NONE,  "}",                         1    )
call AddCompletion(  '{',   '}',     "\<CR>\<C-D>\<ESC>O",        0    )
call AddCompletion(  '\[',  s:NONE,  "]",                         1    )
call AddCompletion(  '\[',  '\]',    "\<CR>\<ESC>O\<TAB>",        0    )
call AddCompletion(  '(',   s:NONE,  ")",                         1    )
call AddCompletion(  '(',   ')',     "\<CR>\<ESC>O\<TAB>",        0    )
call AddCompletion(  '<',   s:NONE,  ">",                         1    )
call AddCompletion(  '<',   '>',     "\<CR>\<ESC>O\<TAB>",        0    )
call AddCompletion(  '"',   s:NONE,  '"',                         1    )
call AddCompletion(  '"',   '"',     "\\n",                       1    )
call AddCompletion(  "'",   s:NONE,  "'",                         1    )
call AddCompletion(  "'",   "'",     s:NONE,                      0    )
call AddCompletion( '/\*',  "",      '*/',                        1    )
call AddCompletion( '/\*', '\*/',    "\<CR>* \<CR>\<ESC>\<UP>A",  0    )

" Implement smart completion magic...
func! SmartComplete ()
    " Remember where we parked...
    let cursorpos = getpos('.')
    let cursorcol = cursorpos[2]
    let curr_line = getline('.')

    echoe "cursorcol:" cursorcol
    " Special subpattern to match only at cursor position...
    let curr_pos_pat = '\%' . cursorcol . 'c'
    echoe "curr_pos_pat:" curr_pos_pat

    " Tab as usual at the left margin...
    if curr_line =~ '^\s*' . curr_pos_pat
        return "\<TAB>"
    endif

    " How to restore the cursor position...
    let cursor_back = "\<C-O>:call setpos('.'," . string(cursorpos) . ")\<CR>"

    " If a matching smart completion has been specified, use that...
    for [left, right, completion, restore] in s:completions
        let pattern = left . curr_pos_pat . right
        if curr_line =~ pattern
            echoe "curr_line:" curr_line
            echoe "pattern:" pattern
            " Code around bug in setpos() when used at EOL...
            if cursorcol == strlen(curr_line)+1 && strlen(completion)==1 
                let cursor_back = "\<LEFT>"
            endif

            " Return the completion...
            return completion . (restore ? cursor_back : "")
        endif
    endfor

    " If no contextual match and after an identifier, do keyword completion...
    if curr_line =~ '\k' . curr_pos_pat
        return "\<C-N>"

    " Otherwise, just be a <TAB>...
    else
        return "\<TAB>"
    endif
endf

" Remap <TAB> for smart completion on various characters...
inoremap <silent> <TAB>   <C-R>=SmartComplete()<CR>

" Insert Mode, click <tab> after each char as below:
" {
" [
" <
" "
" ' 
" /*
