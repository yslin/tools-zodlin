func! LogFunc()
    let repl = substitute(expand("<sfile>"), '..LogFunc', "():", "g")
    echohl MoreMsg | echo repl | echohl None
endf

let g:diagnosis = {
            \   'Perl'   : 'Tourettes',
            \   'Python' : 'OCD',
            \   'Lisp'   : 'Megalomania',
            \   'PHP'    : 'Idiot-Savant',
            \   'C++'    : 'Savant-Idiot',
            \   'C#'     : 'Sociopathy',
            \   'Java'   : 'Delusional',
            \}

func! Create()
    call LogFunc()
    let seen = {}   " Haven't seen anything yet

    let daytonum = { 'Sun':0, 'Mon':1, 'Tue':2, 'Wed':3, 'Thu':4, 'Fri':5, 'Sat':6 }

    echo g:diagnosis

    "let lang = input("Patient's name? ")
    "let Dx = diagnosis[lang]

    let user = {}

    let user.name    = 'Bram'
    let user.acct    = 123007
    let user.pin_num = '1337'
endf

call Create()

func! Get()
    call LogFunc()
    echo g:diagnosis.Perl
    echo g:diagnosis['Perl']

    let Dx = get(g:diagnosis, 'Ruby')                     
    " Returns: 0
    echo Dx
    
    let Dx = get(g:diagnosis, 'Ruby', 'Schizophrenia')    
    " Returns: 'Schizophrenia'
    echo Dx
endf

call Get()

func! Iterate()
    call LogFunc()
    echo keys(g:diagnosis)
    echo values(g:diagnosis)

    for [next_key, next_val] in items(g:diagnosis)
        echo "Result for " next_key " is " next_val
    endfor
endf

call Iterate()

func! Assign()
    call LogFunc()
    let dict1 = {'level1': {'level2': [1,2,3,4]}}
    echo dict1
    let dict2 = dict1             " dict2 just another name for dict1
    let dict2.level1.level2[0] = 2
    echo dict1
    echo dict2

    let dict3 = copy(dict1)       " dict3 has a copy of dict1's top-level elements
    let dict2.level1.level2[0] = 3
    echo dict1
    echo dict3

    let dict4 = deepcopy(dict1)   " dict4 has a copy of dict1 (all the way down)
    let dict2.level1.level2[0] = 4
    echo dict1
    echo dict4
endf

call Assign()

func! Compare(dictA, dictB)
    call LogFunc()
    if a:dictA is a:dictB
        " They alias the same container, so must have the same keys and values
        echo "a is b"
    elseif a:dictA == a:dictB
        " Same keys and values, but maybe in different containers
        echo "a == b"
    else
        " Different keys and/or values, so must be different containers
        echo "a != b"
    endif
endf

let dict1 = {}
let dict2 = dict1
call Compare(dict1, dict2)                         | " a is b
call Compare({'key': 'val'}, {'key': 'val'})       | " a == b
call Compare({'key1': 'val'}, {'key2': 'val'})     | " a != b
call Compare({'key1': 'val1'}, {'key2': 'val2'})   | " a != b

func! AddEntry()
    call LogFunc()
    let diagnosis = {}
    let diagnosis['COBOL'] = 'Dementia'
    call extend(diagnosis, {'COBOL':'Dementia', 'Forth':'Dyslexia'})
    echo diagnosis
endf

call AddEntry()

func! Remove()
    call LogFunc()
    let dict = {"key1": "val1", "key2": "val2"}

    let removed_value = remove(dict, "key1")
    echo dict

    unlet dict["key2"]
    echo dict
endf

call Remove()

func! Filter()
    call LogFunc()
    let diagnosis = {'key': 'C', 'java': 'Savant Holiy', 'NCTU':'NCTU', 'Python': 'John'}
    " Remove any entry whose key starts with C...
    call filter(diagnosis, 'v:key[0] != "C"')
    echo diagnosis

    " Remove any entry whose value doesn't contain 'Savant'...
    call filter(diagnosis, 'v:val =~ "Savant"')
    echo diagnosis

    " Remove any entry whose value is the same as its key...
    call filter(diagnosis, 'v:key != v:val')
    echo diagnosis
endf

call Filter()

func! Empty()
    call LogFunc()
    let dict = {}
    let is_empty = empty(dict)           " True if no entries at all
    echo is_empty 

    let dict = {'n':'v'}
    let is_empty = empty(dict)           " True if no entries at all
    echo is_empty 
endf 

call Empty()

func! Length()
    call LogFunc()
    let dict = {'a':'a', 'e':'a', 'd':'a', 'c':'a', 'b':'a'}
    let entry_count = len(dict)          " How many entries?
    echo entry_count  | " 5
endf

call Length()

func! Count(dict, str)
    call LogFunc()
    let occurrences = count(a:dict, a:str)   " How many values are equal to str?
    echo "occurrences:" . occurrences
endf

call Count({'a':1, 'b':2, 'c':3, 'd':2}, 2)

func! Max(dict)
    call LogFunc()
    let greatest = max(a:dict)             " Find largest value of any entry
    echo "greatest:" . greatest
endf

call Max({'a':1, 'b':2, 'c':3, 'd':2})

func! Min(dict)
    call LogFunc()
    let least    = min(a:dict)             " Find smallest value of any entry
    echo "least:" . least
endf

call Min({'a':1, 'b':2, 'c':3, 'd':2})

func! Map(dict, value_transform_str)
    call LogFunc()
    call map(a:dict, a:value_transform_str)  " Transform values by eval'ing string
    echo a:dict

    let names = {'1': 'peter can', '2': 'josh lu', '3': 'you lin'}
    call map( names, 'toupper(v:val[0]) . tolower(v:val[1:])' )
    echo names  | " each name was correctly capitalized


    let uk2nl = {'one': 'een', 'two': 'twee', 'three': 'drie'}
    for key in keys(uk2nl)
        echo key
    endfor
    for key in sort(keys(uk2nl))
        echo key
    endfor

    echo uk2nl['one']
    echo uk2nl.one
    let uk2nl.four = 'vier'
    echo uk2nl

    "['three', 'two', 'five', 'one'] 
    echo split('three two five one')

    let alist = map(split('three two five one'), 'get(uk2nl, v:val, "???")')
    echo alist

    func! uk2nl.translate(line) dict
        return join(map(split(a:line), 'get(self, v:val, "???")'))
    endf
    echo uk2nl.translate('three two five one')
endf

call Map({'1': 'v'}, 'v:val > 3 ? 100: 40')

func! String(dict)
    call LogFunc()
    echo string(a:dict)             | " Print dictionary as key/value pairs
endf

call String({'k1':'va', 'k2':'va'})


" Passing optional arguments as variadic parameters
func! CommentBlock(comment, ...)
    call LogFunc()
    " If 1 or more optional args, first optional arg is introducer...
    let introducer =  a:0 >= 1  ?  a:1  :  "//"

    " If 2 or more optional args, second optional arg is boxing character...
    let box_char   =  a:0 >= 2  ?  a:2  :  "*"

    " If 3 or more optional args, third optional arg is comment width...
    let width      =  a:0 >= 3  ?  a:3  :  strlen(a:comment) + 2 

    " Build the comment box and put the comment inside it...
    return introducer . repeat(box_char,width) . "\<CR>"
    \    . introducer . " " . a:comment        . "\<CR>"
    \    . introducer . repeat(box_char,width) . "\<CR>"
endf

" Comment of required width, with standard delimiter and box character...
let comment_text = "hello i am comment"
let comment_width = 4
let new_comment = CommentBlock(comment_text, '//', '*', comment_width)
echo new_comment

" Box comment using ==== to standard line width...
let new_comment = CommentBlock(comment_text, '=', 72)  " 缺點是default值沒辦法跳過, 72會被當成第二個參數使用
echo new_comment  | " =7272727272727272727272727272727272727272

" Passing optional arguments in a dictionary
func! CommentBlock(comment, opt)
    call LogFunc()
    " Unpack optional arguments...
    let introducer = get(a:opt, 'intro', '//'                 )
    let box_char   = get(a:opt, 'box',   '*'                  )
    let width      = get(a:opt, 'width', strlen(a:comment) + 2)

    " Build the comment box and put the comment inside it...
    return introducer . repeat(box_char,width) . "\<CR>"
    \    . introducer . " " . a:comment        . "\<CR>"
    \    . introducer . repeat(box_char,width) . "\<CR>"
endf

" Comment of required width, with standard delimiter and box character...
let new_comment = CommentBlock(comment_text, {'width':comment_width})
echo new_comment

" Box comment using ==== to standard line width...
let new_comment = CommentBlock(comment_text, {'box':'=', 'width':72})
echo new_comment  | " //========================================================================

" The updated AlignAssignments() function
func! AlignAssignments ()
    call LogFunc()
    " Patterns needed to locate assignment operators...
    let ASSIGN_OP   = '[-+*/%|&]\?=\@<!=[=~]\@!'
    let ASSIGN_LINE = '^\(.\{-}\)\s*\(' . ASSIGN_OP . '\)\(.*\)$'

    " Locate block of code to be considered (same indentation, no blanks)...
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
    let linenum = firstline
    for line in lines
        if !empty(line)
            let newline
            \    = printf("%-*s%*s%s", max_lval, line[0], max_op, line[1], line[2])
            call setline(linenum, newline)
        endif
        let linenum += 1
    endfor
endf


" A further-improved AlignAssignments() function
func! AlignAssignments ()
    call LogFunc()
    " Patterns needed to locate assignment operators...
    let ASSIGN_OP   = '[-+*/%|&]\?=\@<!=[=~]\@!'
    let ASSIGN_LINE = '^\(.\{-}\)\s*\(' . ASSIGN_OP . '\)\(.*\)$'

    " Locate block of code to be considered (same indentation, no blanks)...
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
        " Use dictionary to improve code readable
        if len(fields) 
            call add(lines, {'lval':fields[1], 'op':fields[2], 'rval':fields[3]})
        else
            call add(lines, {'text':linetext,  'op':''                         })
        endif
    endfor

    " Determine maximal lengths of lvalue and operator...
    let op_lines = filter(copy(lines),'!empty(v:val.op)')
    let max_lval = max( map(copy(op_lines), 'strlen(v:val.lval)') ) + 1
    let max_op   = max( map(copy(op_lines), 'strlen(v:val.op)'  ) )

    " Recompose lines with operators at the maximum length...
    let linenum = firstline
    for line in lines
        " Use dictionary to improve code readable
        let newline = empty(line.op)
        \ ? line.text
        \ : printf("%-*s%*s%s", max_lval, line.lval, max_op, line.op, line.rval)
        call setline(linenum, newline)
        let linenum += 1
    endfor
endf


" A function for order-preserving uniqueness
func! Uniq () range
    call LogFunc()
    " Nothing unique seen yet...
    let have_already_seen = {}
    let unique_lines = []

    " Walk through the lines, remembering only the hitherto-unseen ones...
    for original_line in getline(a:firstline, a:lastline)
        let normalized_line = '>' . original_line 
        if !has_key(have_already_seen, normalized_line)
            call add(unique_lines, original_line)
            let have_already_seen[normalized_line] = 1
        endif
    endfor

    " Replace the range of original lines with just the unique lines...
    exec a:firstline . ',' . a:lastline . 'delete'
    call append(a:firstline-1, unique_lines)
endf

nmap ;u :%call Uniq()<CR>
vmap  u :call Uniq()<CR>

" visual select the following lines and click 'u'
" line 1
" line 1
" line 2
" line 3
" line 3


