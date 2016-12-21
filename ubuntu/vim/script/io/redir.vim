let s:known_types = {}

" tagbar user define language
" Java 
let tagbar_type_java = {}
let tagbar_type_java.ctagstype = 'java'
let tagbar_type_java.kinds     = [
            \ 'p:packages:1',
            \ 'f:fields:0',
            \ 'g:enum types:0',
            \ 'e:enum constants:0',
            \ 'i:interfaces:0',
            \ 'c:classes:0',
            \ 'm:methods:0'
            \ ]
let tagbar_type_java.sro        = '.'
let tagbar_type_java.kind2scope = {
            \ 'g' : 'enum',
            \ 'i' : 'interface',
            \ 'c' : 'class'
            \ }
let tagbar_type_java.scope2kind = {
            \ 'enum'      : 'g',
            \ 'interface' : 'i',
            \ 'class'     : 'c'
            \ }
" C 
let tagbar_type_c = {}
let tagbar_type_c.ctagstype = 'c'
let tagbar_type_c.kinds     = [
            \ 'd:macros:1',
            \ 'p:prototypes:1',
            \ 'g:enums:0',
            \ 'e:enumerators:0',
            \ 't:typedefs:0',
            \ 's:structs:0',
            \ 'u:unions:0',
            \ 'm:members:0',
            \ 'v:variables:0',
            \ 'f:functions:0'
            \ ]
let tagbar_type_c.sro        = '::'
let tagbar_type_c.kind2scope = {
            \ 'g' : 'enum',
            \ 's' : 'struct',
            \ 'u' : 'union'
            \ }
let tagbar_type_c.scope2kind = {
            \ 'enum'   : 'g',
            \ 'struct' : 's',
            \ 'union'  : 'u'
            \ }

" C++ 
let tagbar_type_cpp = {}
let tagbar_type_cpp.ctagstype = 'c++'
let tagbar_type_cpp.kinds     = [
            \ 'd:macros:1',
            \ 'p:prototypes:1',
            \ 'g:enums:0',
            \ 'e:enumerators:0',
            \ 't:typedefs:0',
            \ 'n:namespaces:0',
            \ 'c:classes:0',
            \ 's:structs:0',
            \ 'u:unions:0',
            \ 'f:functions:0',
            \ 'm:members:0',
            \ 'v:variables:0'
            \ ]
let tagbar_type_cpp.sro        = '::'
let tagbar_type_cpp.kind2scope = {
            \ 'g' : 'enum',
            \ 'n' : 'namespace',
            \ 'c' : 'class',
            \ 's' : 'struct',
            \ 'u' : 'union'
            \ }
let tagbar_type_cpp.scope2kind = {
            \ 'enum'      : 'g',
            \ 'namespace' : 'n',
            \ 'class'     : 'c',
            \ 'struct'    : 's',
            \ 'union'     : 'u'
            \ }

" s:GetUserTypeDefs()
function! s:GetUserTypeDefs()
    echo "start func"
    redir => defs
    "show all globals and save into defs file
    silent execute 'let g:'
    redir END

    let deflist = split(defs, '\n')
    call map(deflist, 'substitute(v:val, ''^\S\+\zs.*'', "", "")')
    call filter(deflist, 'v:val =~ "^tagbar_type_"')

    let defdict = {}
    for defstr in deflist
        let type = substitute(defstr, '^tagbar_type_', '', '')
        execute 'let defdict["' . type . '"] = g:' . defstr
        echo defstr
    endfor

    " If the user only specified one of kind2scope and scope2kind use it to
    " generate the other one
    " Also, transform the 'kind' definitions into dictionary format
    for def in values(defdict)
        if has_key(def, 'kinds')
            let kinds = def.kinds
            let def.kinds = []
            for kind in kinds
                let kindlist = split(kind, ':')
                let kinddict = {'short' : kindlist[0], 'long' : kindlist[1]}
                if len(kindlist) == 3
                    let kinddict.fold = kindlist[2]
                else
                    let kinddict.fold = 0
                endif
                call add(def.kinds, kinddict)
            endfor
        endif

        if has_key(def, 'kind2scope') && !has_key(def, 'scope2kind')
            let def.scope2kind = {}
            for [key, value] in items(def.kind2scope)
                let def.scope2kind[value] = key
            endfor
        elseif has_key(def, 'scope2kind') && !has_key(def, 'kind2scope')
            let def.kind2scope = {}
            for [key, value] in items(def.scope2kind)
                let def.kind2scope[value] = key
            endfor
        endif
    endfor

    return defdict
endfunction

let user_defs = s:GetUserTypeDefs()
for [key, value] in items(user_defs)
    echo key . ":" 
    if !has_key(s:known_types, key) ||
                \ (has_key(value, 'replace') && value.replace)
        let s:known_types[key] = value
    else
        call extend(s:known_types[key], value)
    endif
endfor
