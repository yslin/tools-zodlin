"2016整理方向（所有plugin都由自己下載管理,不透過套件）

"-[Config]-------------------------------------------------------------------"
" $VIM 
"    Linux:/usr/share/vim 或 /usr/local/share/vim 可設在在 $HOME/.bash_profie 或 $HOME/.bashrc
"    Windows: C:\Vim 這個目錄中，亦可設在 autoexec.bat 中
" $HOME
"    Linux:/home/your_id
"    Windows: 
" VIM設定檔存取順序 :scriptnames
"    $HOME/.exrc
"    $HOME/.vimrc
"    $HOME/.gvimrc    GUI 版本
"    $VIM/vimrc   系統預設值，最好不去修改
"    $VIM/gvimrc  GUI 版本
"    $VIM\_vimrc  Windows 版本
"    $VIM\_gvimrc
"    $HOME/.vim/plugin/ 所以注意熱鍵會被plugin給蓋過去

" VIM Plugin存取順序 :echo &rtp
"    Linux:$HOME/.vim
"    Windows:$HOME/vimfiles
"-[Filetype]-------------------------------------------------------------------"
" ~/.vim/filetype.vim 設定~/.vim/syntax/smali.vim檔案type格式,影響highligh顯示

"-[Set]------------------------------------------------------------------------"
" 查詢目前set變數的值,用:set ft?,在變數後面加上?就可以查詢了
" 其他vim專有變數像是$VIM,用:echo $VIM就可以查了

"------------------------------------------------------------------------------"
" for cscope.vim
" you should install cscope
" 可以將c source file的名稱作收尋定義、參考的位置(ctrl-]、ctrl-t)
" 如果有ctrl+]找不到tag的問題試試看下面方法
" set csprg=~/bin/cscope或set csprg=~/usr/bin/cscope

"-[Search]---------------------------------------------------------------------"
" gd和*的用法差異???都是收尋字串?

"-[New-Context-Table]----------------------------------------------------------"
"1.plugin_configure(not easy for me to rewrite)                                "
"1.0.key map function                                                          "
"1.1.plugin manager                                                            "
"1.a.lib/                                                                      "
"1.b.lang/                                                                     "
"1.c.visual/                                                                   "
"1.d.edit/                                                                     "
"   - manages runtime path of your installed scripts                           "
"   - regenerates helptags automatically                                       "
"1.e.filetype/                                                                 "
"1.f.colors/                                                                   "
"2.normal_key_map_setting                                                      "
"3.leader_key_map_setting                                                      "
"4.set_configure                                                               "
"5.au_setting                                                                  "
"6.script_function                                                             "
"7.IDE_settings                                                                "
"------------------------------------------------------------yslin contribution"
"解決gvim menu亂碼問題
if has("win32")    
    let $LANG="zh_TW.UTF-8"
    set langmenu=zh_tw.utf-8
    set encoding=utf8

    "reload menu with UTF-8 encoding
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
endif

"=============================================================================="
"1.plugin_configure------------------------------------------------------------"
"=============================================================================="
" 1.plugin_configure {{{1
"不使用pathogen管理,方便個別開關plugin
" 1.0.key map function {{{2 
"*******************************************************************************
"**  Hook after each plugin key mapping.                                      **
"**  @deprecated
"*******************************************************************************
func! Zod_Load_Plugin_Key_Map(opt)
    let disable      = get(a:opt, 'disable',      0          )
    let event        = get(a:opt, 'event',        'SourceCmd')
    let name         = get(a:opt, 'name',         'error'    )
    let dir          = get(a:opt, 'dir',          'error'    )
    let keymapFile   = get(a:opt, 'keymapFile',   'error'    )
    let KeyClearFunc = get(a:opt, 'keyclearFunc', 'error'    )
    let KeyMapFunc   = get(a:opt, 'keymapFunc',   'error'    )
    "au SourceCmd */lusty/plugin/lusty-explorer.vim :source <afile> | echo expand('<afile>') | map
    "exec 'au SourceCmd '.a:plugin.' :source <afile> | echo expand("<afile>") | map'
    exec 'augroup '. name
    exec '  au!'

    if(disable)
        if dir != 'error'
            exec 'au SourceCmd '. dir .'* :echo <afile> " disable now!"'
        endif
    else
        if event != "SourceCmd"
            " 像c.vim中用到的ftplugin沒辦法根據au FileType來攔截,只能等全部載入後再清除
            exec 'au VimEnter * :call '. KeyClearFunc . '()'
        else
            if keymapFile != 'error' && KeyClearFunc != 'error'
                "exec 'au SourceCmd '. keymapFile . ' :source <afile> | echo expand("<afile>") | call ' . KeyClearFunc . '()'
                exec 'au SourceCmd '. keymapFile . ' :source <afile> | call ' . KeyClearFunc . '()'
            endif
        endif
        call add(g:key_mapping_func, KeyMapFunc)
    endif

    exec 'augroup END'
endf

func! MyCompare(i1, i2) 
    return a:i1.lhs == a:i2.lhs ? 0 : a:i1.lhs > a:i2.lhs ? 1 : -1
endf

func! ReverseMapMode(map_mode)
    if a:map_mode == "map"
        return "unmap"
    elseif a:map_mode == "nmap"
        return  "nunmap"
    elseif a:map_mode == "vmap"
        return  "vunmap"
    elseif a:map_mode == "xmap"
        return  "xunmap" 
    elseif a:map_mode == "smap"
        return  "sunmap" 
    elseif a:map_mode == "omap"
        return  "ounmap" 
    elseif a:map_mode == "imap"
        return  "iunmap" 
    elseif a:map_mode == "lmap"
        return  "lunmap" 
    elseif a:map_mode == "cmap"
        return  "cunmap" 
    else
        return "unmap"
    endif
endf

func! UnMapMode(map_mode)
    if a:map_mode == ""
        return "unmap"
    elseif a:map_mode == "n"
        return  "nunmap"
    elseif a:map_mode == "v"	
        return  "vunmap" 
    elseif a:map_mode == "x"	
        return  "xunmap" 
    elseif a:map_mode == "s"	
        return  "sunmap" 
    elseif a:map_mode == "o"	
        return  "ounmap" 
    elseif a:map_mode == "i"	
        return  "iunmap" 
    elseif a:map_mode == "l"	
        return  "lunmap" 
    elseif a:map_mode == "c"	
        return  "cunmap" 
    else
        return "unmap"
    endif
endf


func! MapKeyClear(plugin, mode, lhs, arg, ...)
    let rhs = maparg(a:lhs, a:mode)
    if rhs != ""
        if a:0 >= 1
            " optional arg: a list records each key mapping for remapping later
            call add(a:1, rhs)
        endif
        exec UnMapMode(a:mode).' '.a:arg.' '.a:lhs
    else
        echohl MoreMsg | echo "[No Such Key Mapping]" 
                    \| echohl ErrorMsg | echon "[".a:plugin."]"
                    \| echohl SpellLocal | echon "[".a:mode."]"
                    \| echohl MoreMsg | echon a:lhs  | echohl None
        call input("")
    endif
endf

"*******************************************************************************
"**  add_list: true, add it to key_mapping_list                               **
"**  reverse_map_mode: ture, reverse map to unmap, vice versa                 **
"**  filter_str: filter lhs string and substitute with ""                     **
"**  plugin: plugin name                                                      **
"**  map_mode: Please :h :map-commands                                        **
"**  map_arg:  Please :h :map-arguments                                       **
"**  lhs: left hand shortcut key                                              **
"**  rhs: right hand shortcut key                                             **
"**  description: the utility of function                                     **
"*******************************************************************************
" Record all key mapping
let g:key_mapping_list = []
" Record all key mapping function reference
let g:key_mapping_func = []
func! Zod_Key_Mapping(add_list, reverse_map_mode, filter_str, plugin, map_mode, map_arg, lhs, rhs, description)
    try
        if a:add_list 
            call add(g:key_mapping_list, {'plugin' : a:plugin, 'map_mode' : a:map_mode, 'map_arg' : a:map_arg, 'lhs' : a:lhs, 'rhs' : a:rhs, 'description' : a:description})
        endif
        if a:filter_str != ""
            let s:lhs = substitute(a:lhs, a:filter_str, "", "") 
        else
            let s:lhs = a:lhs
        endif
        if a:reverse_map_mode
            " unmap
            let s:map_mode = ReverseMapMode(a:map_mode)
            exec s:map_mode.' '.a:map_arg.' '.s:lhs
        else
            let s:map_mode = a:map_mode
            exec s:map_mode.' '.a:map_arg.' '.s:lhs.' '.a:rhs 
        endif
        "echo s:map_mode.' '.a:map_arg.' '.s:lhs.' '.a:rhs 
    catch
        func! LineNumber()
            return substitute(v:throwpoint, '.*\D\(line \d\+\).*', '\1', "")
        endf
        echohl ErrorMsg | echo "Error detected while processing " .v:throwpoint | echohl NONE
                    \| echohl ErrorMsg | echo "E:". v:exception | echohl NONE
        call input("Press ENTER to continue...")
    endtry
endf

"ToDo: set sort, color
func! Show_Key_Map()
    "新視窗的名稱
    exec 'silent pedit [Key Mapping]'
    "設定視窗顯示為垂直對半
    wincmd P | wincmd H                                                                                                                                          

    " make buffer modifiable 
    " to append without errors
    set modifiable
    "視窗內容
    for dic_key_mapping in sort(g:key_mapping_list, function("MyCompare"))
        "echo "=".dic_key_mapping.description."="
        "echo dic_key_mapping.map_mode." ".dic_key_mapping.map_arg." ".dic_key_mapping.lhs." ".dic_key_mapping.rhs
        call append(line('$'), '('.dic_key_mapping.plugin.') "'.dic_key_mapping.description)
        call append(line('$'), dic_key_mapping.map_mode." ".dic_key_mapping.map_arg." ".dic_key_mapping.lhs." ".dic_key_mapping.rhs)
    endfor 
    setl buftype=nofile
    setl noswapfile

    setl cursorline
    setl nonu ro noma ignorecase 
    setl syntax=vim
endf

call add(g:key_mapping_func, 'Normal_Key_Map_Setting')
call add(g:key_mapping_func, 'Leader_Key_Map_Setting')
func! Key_Map_Setting(...)
    let add_list = a:0 >=1 ? a:1 : 1
    let reverse_map_mode = a:0 >=2 ? a:2 : 0
    let filter_str = a:0 >=3 ? a:3 : ''

    let mapleader = '\'

    "echo g:key_mapping_func
    for keymapFunc in g:key_mapping_func
        call call(function(keymapFunc), [add_list, reverse_map_mode, filter_str])
    endfor
endf
" Key Mapping Function }}}2
"1.1.plugin manager {{{2
" @deprecated 自行管理,反正很少用更新這個功能
" 設定所有plugin都要放在bundle,因為vundle的套件固定用這個路徑 
let s:vim_install_plugin_path = expand('$HOME') . '/.vim/bundle'
"1.1.plugin manager }}}2
"1.b.visual/
" 產生set rtp,對.vim/visual/下所有plugin產生rtp
"execute pathogen#infect('visual/{}')
" bufexplorer: Buffer Explorer / Browser {{{2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -name: bufexplorer-7.4.12.zip
" -dir : ~/.vim/visual/bufexplorer.zip
" -help: 
" -link: http://www.vim.org/scripts/script.php?script_id=42
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"當tab開太多個時可以用這個切換頁面
exec 'set runtimepath+='.expand('$HOME') . '/.vim/visual/bufexplorer'
"指令:
"\be (normal open)
"\bs (force horizontal split open)
"\bv (force vertical split open) 
" bufexplorer }}}2
" matrix.vim--Yang: Matrix screensaver for VIM {{{2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -name: matrix.vim--Yang
" -dir : ~/.vim/visual/matrix.vim--Yang
" -help: 
" -link: http://www.vim.org/scripts/script.php?script_id=1189
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
exec 'set runtimepath+='.expand('$HOME') . '/.vim/visual/matrix.vim--Yang'
"使用指令,開啟駭客任務的screensaver
"Matrix
func! Zod_Plugin_matrix_Yang_Clear()
    if exists("g:loaded_Zod_Plugin_matrix_Yang_Clear")
        return
    endif
    let g:loaded_Zod_Plugin_matrix_Yang_Clear = 1
endf

func! Zod_Plugin_matrix_Yang(add_list, reverse_map_mode, filter_str)
    if exists("g:loaded_Zod_Plugin_matrix_Yang")
        return
    endif
    let g:loaded_Zod_Plugin_matrix_Yang = 1
endf

"call Zod_Load_Plugin_Key_Map({
"            \'disable' : 0,
"            \'name': 'Zod_matrix_Yang',
"            \'dir': '*/matrix.vim--Yang/', 
"            \'keymapFile': '*/matrix.vim--Yang/plugin/matrix.vim--Yang',
"            \'keyclearFunc': 'Zod_Plugin_matrix_Yang_Clear',
"            \'keymapFunc': 'Zod_Plugin_matrix_Yang'})
" matrix.vim--Yang }}}2
" MultipleSearch: Highlight multiple searches at the same time, each with a different color {{{2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -name: MultipleSearch 
" -version: 1.3 
" -update: 2008-09-23
" -dir : ~/.vim/bundle/MultipleSearch
" -help: :h MultipleSearch.txt
" -link: http://www.vim.org/scripts/script.php?script_id=479
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
exec 'set runtimepath+='.expand('$HOME') . '/.vim/visual/MultipleSearch'

"指令
":Search <pattern>
":SearchReset

" Specifes a maximum number of colors to use (Default: 8)
let g:MultipleSearchMaxColors = 100

" :runtime syntax/colortest.vim show all color
" Defines the sequence of colors to use for searches. (Default: "red,yellow,blue,green,magenta,cyan,gray,brown")
" :XtermColorTable to check color
let g:MultipleSearchColorSequence = "1,2,3,4,5,6,9,10,11,12,13,14"

" Defines the text color for searches, so that it can still be read against the colored background.
" 15:white, 0:black
let g:MultipleSearchTextColorSequence = "15,15,15,15,15,15,0,0,0,0,0,0"

func! Zod_Plugin_MultipleSearch_Clear()
    if exists("g:loaded_Zod_Plugin_MultipleSearch_Clear")
        return
    endif
    let g:loaded_Zod_Plugin_MultipleSearch_Clear = 1
    "call MapKeyClear('MultipleSearch', 'v', '<Leader>*', '')
    "call MapKeyClear('MultipleSearch', 'n', '<Leader>*', '')
    "todo: autoload to map these keys, hard to remove and remap
    "call MapKeyClear('MultipleSearch', 'n', '<Leader>n', '')
    "call MapKeyClear('MultipleSearch', 'n', '<Leader>N', '')
endf

func! Zod_Plugin_MultipleSearch(...)
    if exists("g:loaded_Zod_Plugin_MultipleSearch")
        return
    endif
    let g:loaded_Zod_Plugin_MultipleSearch = 1
    "call Zod_Key_Mapping(1, 0, '', 'MultipleSearch', 'vmap', '<silent><unique>', '<Leader>*', "y:call MultipleSearch#MultipleSearch(0,'\\V'.substitute(escape(@@,\"\\\\/\\\"'\"),\"\\n\",'\\\\n','ge'))<CR>", 'Visual MultipleSearch')
    "call Zod_Key_Mapping(1, 0, '', 'MultipleSearch', 'nmap', '<silent><unique>', '<Leader>*', ":execute ':Search \\<' . expand('<cword>') . '\\>'<cr>", 'Normal MultipleSearch')
endf

call Zod_Load_Plugin_Key_Map({
            \'disable' : 0,
            \'name': 'Zod_MultipleSearch',
            \'dir': '*/MultipleSearch/', 
            \'keymapFile': '*/MultipleSearch/plugin/MultipleSearch.vim',
            \'keyclearFunc': 'Zod_Plugin_MultipleSearch_Clear',
            \'keymapFunc': 'Zod_Plugin_MultipleSearch'})
" MultipleSearch }}}2
" number marks {{{2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" It will save XXXXXDO_NOT_DELETE_IT at current directory
" -name: number marks
" -dir : ~/.vim/visual/number-marks
" -help: 
" -link: http://www.vim.org/scripts/script.php?script_id=2194
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
exec 'set runtimepath+='.expand('$HOME') . '/.vim/visual/number-marks'
"let g:Signs_file_path_corey=''		

func! Zod_Plugin_number_marks_Clear()
    if exists("g:loaded_Zod_Plugin_number_marks_Clear")
        return
    endif
    let g:loaded_Zod_Plugin_number_marks_Clear = 1
    "call MapKeyClear('number marks', '', '<c-F2>', '')
    "call MapKeyClear('number marks', '', 'mm', '')
    "call MapKeyClear('number marks', '', '<F2>', '')
    "call MapKeyClear('number marks', '', 'mb', '')
    "call MapKeyClear('number marks', '', '<s-F2>', '')
    "call MapKeyClear('number marks', '', 'mv', '')
    "call MapKeyClear('number marks', '', '<F4>', '')
    "call MapKeyClear('number marks', '', 'm.', '')
    "call MapKeyClear('number marks', '', '<F6>', '')
    "call MapKeyClear('number marks', '', '<F5>', '')
endf

func! Zod_Plugin_number_marks(add_list, reverse_map_mode, filter_str)
    if exists("g:loaded_Zod_Plugin_number_marks")
        "<leader>需要每次載入都要重新mapping
        call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, 'number marks', 'map', '<silent>', '<leader>mm', ':PlaceSign<cr>', 'Place sign')
        call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, 'number marks', 'map', '<silent>', '<leader>mn', ':GotoNextSign<cr>', 'Go to next sign')
        call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, 'number marks', 'map', '<silent>', '<leader>mp', ':GotoPrevSign<cr>', 'Go to previous sign')
        call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, 'number marks', 'map', '<silent>', '<leader>mc', ':RemoveAllSigns<cr>', 'Remove all sign')
        call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, 'number marks', 'map', '<silent>', '<leader>m.', ':MoveSign<cr>', 'Move sign')
        call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, 'number marks', 'map', '<silent>', '<leader>mq', ':ShowQFList<cr>', 'Show signs in quickfix')
        call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, 'number marks', 'map', '<silent>', '<leader>mw', ':ShowSignList<cr>', 'Show signs in new window')
        call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, 'number marks', 'map', '<silent>', '<leader>ms', ':SaveSigns<cr>', 'Save sign')
        call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, 'number marks', 'map', '<silent>', '<leader>ml', ':LoadSigns<cr>', 'Load sign')
        return
    endif
    let g:loaded_Zod_Plugin_number_marks = 1
endf

call Zod_Load_Plugin_Key_Map({
            \'disable' : 0,
            \'name': 'Zod_number_marks',
            \'dir': '*/number-marks/', 
            \'keymapFile': '*/number-marks/plugin/marks_corey.vim',
            \'keyclearFunc': 'Zod_Plugin_number_marks_Clear',
            \'keymapFunc': 'Zod_Plugin_number_marks'})
" number marks }}}2
"1.f.colors/                                                                   "
" 產生set rtp,對.vim/colors/下所有plugin產生rtp
"execute pathogen#infect('colors/{}')
" xterm-color-table {{{2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -name: All 256 xterm colors with their RGB equivalents, right in Vim! 
" -dir : ~/.vim/color/xterm-color-table
" -help: 
" -link: https://github.com/guns/xterm-color-table.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
exec 'set runtimepath+='.expand('$HOME') . '/.vim/colors/xterm-color-table'
"使用指令XtermColorTable產生所有顏色表格,方便設定colorscheme
" xterm-color-table 2}}}
" molokai : A port of the monokai scheme for TextMate {{{2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -name: molokai : A port of the monokai scheme for TextMate 
" -dir : ~/.vim/color/
" -help: 
" -link: http://www.vim.org/scripts/script.php?script_id=2340
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set colorscheme from .vim/colors/molokai.vim
"需要在syntax on, enable後設定
"colorscheme molokai
" molokai 2}}}
" plugin_configure }}}1
"=============================================================================="
"2.normal_key_map_setting------------------------------------------------------"
"=============================================================================="
" 2.normal_key_map_setting {{{1
" QuickFix: {{{2
" http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
command! -bang -nargs=? QFixToggle call ToggleList("QuickFix List", 'c')
func! GetBufferList()
    redir =>buflist
    silent! ls
    redir END
    return buflist
endf

func! ToggleList(bufname, pfx)
    let buflist = GetBufferList()
    for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
        if bufwinnr(bufnum) != -1
            exec(a:pfx.'close')
            return
        endif
    endfor
    if a:pfx == 'l' && len(getloclist(0)) == 0
        echohl ErrorMsg
        echo "Location List is Empty."
        return
    endif
    let winnr = winnr()
    exec("botright ".a:pfx.'open')
    if winnr() != winnr
        wincmd p
    endif
endf

"nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
"nmap <silent> <leader>e :call ToggleList("Quickfix List", 'c')<CR>
" 2}}}
" Replace {{{2
"---------------------------------------------------------------------------
" Tip #382: Search for <cword> and replace with input() in all open buffers
"---------------------------------------------------------------------------
"fun! Replace()
"    let s:word = input("Replace " . expand('<cword>') . " with:")
"    :exe 'bufdo! %s/\<' . expand('<cword>') . '\>/' . s:word . '/ge'
"    :unlet! s:word
"endfun
"
""replace the current word in all opened buffers
"map <leader>r :call Replace()<CR>
" }}}2
" Copy Mode {{{2
func! CopyMode()
    if &foldcolumn == 0
        set number
        set foldcolumn=1
    else
        set nonumber
        set foldcolumn=0
    endif
endf
" }}}2
" Toggle {{{2
func! Zod_Toggle()
    NERDTreeToggle
    "NERDTreeTabsToggle
    TagbarToggle
    exe "2wincmd w"
endf
" }}}2
func! Normal_Key_Map_Setting(...)
    if exists("g:loaded_Normal_Key_Map_Setting")
        return
    endif
    let g:loaded_Normal_Key_Map_Setting = 1
    "todo: open together.
    call Zod_Key_Mapping(1, 0, '', 'taglist', 'map', '<silent><unique>', '<F1>', ':call Zod_Toggle()<CR>', '顯示nerdtree,taglist的menu')

    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F2>', ':call CopyMode()<CR>', '切換[顯示/不顯示]行號/折疊符號')

    "切換[highlight/no highlight]search
    "map <F3> : set hls!<BAR>set nohls?<CR>

    "在当前文件中快速查找光标下的单词：
    "nmap <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr> 

    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F3>', ':QFixToggle<CR>', '彈出QuickFix的視窗')

    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F4>', ': set paste!<BAR>set paste?<CR>', '使用貼上模式,避免貼上時影響縮排格式(Toggle on/off paste mode)')
    "讓insert模式下也可切換
    set pastetoggle=<F4>

    "按照對應的檔案格式,編譯與執行程式,
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F5>', ':call CompileProgram()<CR>', '編譯程式碼')
    "按照對應的檔案格式,編譯與執行程式,
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F6>', ':call RunProgram()<CR>', '編譯並執行執行程式碼')
    "按照對應的檔案格式,設定breakpoint
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F7>', ':call SetProgramBreakpoint()<CR>', '設定Breakpoint')
    "按照對應的檔案格式,移除breakpoint
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<s-F7>', ':call RemoveProgramBreakpoint()<CR>', '移除Breakpoint')
    "按照對應的檔案格式,執行Debug程式
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F8>', ':call DebugProgram()<CR>', '進入Debugger')
    " 單鍵 <F7> 控制 syntax on/off。倒斜線是 Vim script 的折行標誌
    " 按一次 <F7> 是 on 的話，再按一次則是 off，再按一次又是 on。
    " 原因是有時候顏色太多會妨礙閱讀。
    "call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F7>', ':call ToggleSyntax()<CR>', '關閉/開啟語法高亮')

    "f7設定取得getqflist, setqflist,各種不同的checker

    "將目前vim設定各存成一個會話文件和viminfo文件
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F9>', ':call SaveSessionInfo()<CR>', '儲存vim session')

    "讀取会话文件與viminfo文件
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F10>', ':call LoadSessionInfo()<CR>', '讀取vim session')

    "檔案寫入日期方便作日記
    "call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F10>', ':read !date<CR>', '讀取日期')
    "呼叫xxd將檔案轉成16進位顯示
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F11>', ':%!xxd<CR>', '將檔案轉為16進位格式')
    "將轉成16進位的檔案恢復二進位格式
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F12>', ':%!xxd -r<CR>', '將16進位格式轉回檔案')

    "插入修改或編輯code的作者相關資訊
    ""add code資訊
    "call Zod_Key_Mapping(1, 0, '', '.vimrc', 'vmap', '', '<F2>' ,'xi/* Added by yslin on:<Esc>:read !date <CR>kJ$a BEGIN */<CR>/*<CR>   Please add your comment here<CR><Esc>a*/<CR>#if 1<CR><CR>#endif<CR>/* Added by yslin on:<Esc>:read !date <CR>kJ$a END */<CR><ESC>', '')
    ""modify code資訊
    "call Zod_Key_Mapping(1, 0, '', '.vimrc', 'vmap', '', '<F3>', 'xi/* Modified by yslin on:<CR><Esc>k:read !date <CR>k<CR>kJ$a BEGIN */<CR>/*<CR> Please add your comment here<CR><Esc>a*/<CR>#if 1<CR>#else<CR>#endif<CR>/* Modified by yslin on:<Esc>:read !date <CR>kJ$a END<ESC>J$a*/<CR><ESC>', '')
    ""delete code資訊
    "call Zod_Key_Mapping(1, 0, '', '.vimrc', 'vmap', '', '<F4>', 'xi/* Deleted by yslin on:<CR><Esc>k:read !date <CR>k<CR>kJ$a BEGIN */<CR>/*<CR> Please add your comment here<CR><Esc>a*/<CR>#if 0<CR>#endif<CR>/* Deleted by yslin on:<Esc>:read !date <CR>kJ$a END<ESC>J$a*/<CR><ESC>', '')
    ""copyright宣告
    "call Zod_Key_Mapping(1, 0, '', '.vimrc', 'vmap', '', '<F5>', 'xi/*<CR>◎→ ‣ ™☆★<CR>Dad( ￣ 灬￣): I told you, dont follow my steps, son<CR>*<CR>* ☆°﹒☆．﹒☆°﹒☆．﹒☆°﹒☆．﹒☆°﹒☆．﹒☆° <CR> ╔╩═══════╗╔════════╗╔════════╗╔════════╗<CR> ║真的很棒╠╣辛苦您了╠╣谢谢分享╠╣期待续贴╠<CR> ╚◎══════◎╝╚◎══════◎╝╚◎══════◎╝╚◎══════◎╝<CR> °﹒☆°．﹒．°∴°﹒°．°☆°．°﹒°∴°．﹒．°☆﹒°<CR> Authored by yslin on:<Esc>:read !date <CR>kJ$a<CR>*<CR>* @desc:<CR>*<CR>* @history<CR>*/<CR><Esc>', '')
    ""函式功能宣告
    "call Zod_Key_Mapping(1, 0, '', '.vimrc', 'vmap', '', '<F6>', 'xi/* Function authored by yslin on:<Esc>:read !date <CR>kJ$a */<CR>/*<CR> * @desc:<CR>* @param:<CR>* @return:<CR>*/<CR><Esc>', '')

    "排版文字
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<leader>C', ':call CapitalizeCenterAndMoveDown()<CR>', '將文字置中並且大寫每個字的第一個字母')

    "Fast reloading of the .vimrc
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<silent><unique>', '<leader>ss', ':source ~/.vimrc<cr>', '重新載入.vimrc')
    "Fast editing of .vimrc
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<silent><unique>', '<leader>se', ':e ~/.vimrc<cr>', '編輯.vimrc')
    "Fast updating of doc
    "call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<silent>', '<leader>h', ':helptags ~/.vim/doc<cr>', '')

    "Home, End key mapping for rxvt terminal, bash mapping seeing .inputrc 
    "normal mode ([H, Ow) = (<Esc>[H, <Esc>Ow)
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '', '<Esc>[H', '<Home>', '')
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '', '<Esc>OH', '<Home>', '')
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '', '<Esc>Ow', '<End>', '')
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '', '<Esc>OF', '<End>', '')
    "insert mode
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'imap', '', '<Esc>[H', '<Home>', '')
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'imap', '', '<Esc>OH', '<Home>', '')
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'imap', '', '<Esc>Ow', '<End>', '')
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'imap', '', '<Esc>OF', '<End>', '')
endf
" }}}1
"=============================================================================="
"3.leader_key_map_setting------------------------------------------------------"
"=============================================================================="
" 3.leader_key_map_setting {{{
func! Leader_Key_Map_Setting(add_list, reverse_map_mode, filter_str)
    call Zod_Key_Mapping(a:add_list, 0, '', '.vimrc', 'map', '', '\\', ':if g:leader_key_count_switch == 0 <BAR> call Key_Map_Setting(0, 1, ".leader.") <BAR><CR> else <BAR> call Key_Map_Setting(0, 0, ".leader.") <BAR> endif<CR>', '開啟/關閉Leader模式')

    call Zod_Key_Mapping(a:add_list, 0, '', '.vimrc', 'map', '', '<leader>main', ':call InitCode()<CR>', '按照對應的filetype,讀取基本的程式碼entry point')
    call Zod_Key_Mapping(a:add_list, 0, '', '.vimrc', 'map', '', '<leader>ide0', ':call IDE_SingleFile()<CR>', '開啟IDE Single File模式')
    call Zod_Key_Mapping(a:add_list, 0, '', '.vimrc', 'map', '', '<leader>ide1', ':call IDE_Makefile()<CR>', '開啟IDE Makefile模式')
    call Zod_Key_Mapping(a:add_list, 0, '', '.vimrc', 'map', '', '<leader>ide2', ':call IDE_Eclim()<CR>', '開啟IDE Eclim模式')

    "tab設定
    ":tabs 顯示所有標籤頁
    ":tabm [N] 移動到第N順位
    "CTRL+i go to previous tab
    " CTRL-I = <Tab>
    call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, '.vimrc', 'map', '', '<leader><C-i>', ':tabp<CR>', '前往左邊分頁')

    "CTRL+n go to next tab
    call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, '.vimrc', 'map', '', '<leader><C-o>', ':tabn<CR>', '前往右邊分頁')

    "CTRL-Tab is Next window
    "noremap <C-Tab> :tabn<CR>
    "inoremap <C-Tab> <C-O>:tabn<CR>
    "cnoremap <C-Tab> <C-C>:tabn<CR>

    "CTRL-F4 is Close window
    "noremap <C-F4> :tabc
    "inoremap <C-F4> <C-O>:tabc
    "cnoremap <C-F4> <C-C>:tabc

    "CTRL+N is new tab
    call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, '.vimrc', 'map', '', '<leader><C-n>', ':tabe<CR>', '開啟新分頁')
    "inoremap <C-N> <C-O>:tabe<CR>
    "cnoremap <C-N> <C-C>:tabe<CR>

    "CTRL+d is close tab
    "noremap <C-D> :tabc<CR>

    let g:leader_key_count_switch = exists('g:leader_key_count_switch') ? !g:leader_key_count_switch : 1
endf
" }}}


"=============================================================================="
"3.leader_key_map_setting------------------------------------------------------"
"=============================================================================="
" 3.leader_key_map_setting {{{
func! Leader_Key_Map_Setting(add_list, reverse_map_mode, filter_str)
    call Zod_Key_Mapping(a:add_list, 0, '', '.vimrc', 'map', '', '\\', ':if g:leader_key_count_switch == 0 <BAR> call Key_Map_Setting(0, 1, ".leader.") <BAR><CR> else <BAR> call Key_Map_Setting(0, 0, ".leader.") <BAR> endif<CR>', '開啟/關閉Leader模式')

    call Zod_Key_Mapping(a:add_list, 0, '', '.vimrc', 'map', '', '<leader>main', ':call InitCode()<CR>', '按照對應的filetype,讀取基本的程式碼entry point')
    call Zod_Key_Mapping(a:add_list, 0, '', '.vimrc', 'map', '', '<leader>ide0', ':call IDE_SingleFile()<CR>', '開啟IDE Single File模式')
    call Zod_Key_Mapping(a:add_list, 0, '', '.vimrc', 'map', '', '<leader>ide1', ':call IDE_Makefile()<CR>', '開啟IDE Makefile模式')
    call Zod_Key_Mapping(a:add_list, 0, '', '.vimrc', 'map', '', '<leader>ide2', ':call IDE_Eclim()<CR>', '開啟IDE Eclim模式')

    "tab設定
    ":tabs 顯示所有標籤頁
    ":tabm [N] 移動到第N順位
    "CTRL+i go to previous tab
    " CTRL-I = <Tab>
    call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, '.vimrc', 'map', '', '<leader><C-i>', ':tabp<CR>', '前往左邊分頁')

    "CTRL+n go to next tab
    call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, '.vimrc', 'map', '', '<leader><C-o>', ':tabn<CR>', '前往右邊分頁')

    "CTRL-Tab is Next window
    "noremap <C-Tab> :tabn<CR>
    "inoremap <C-Tab> <C-O>:tabn<CR>
    "cnoremap <C-Tab> <C-C>:tabn<CR>

    "CTRL-F4 is Close window
    "noremap <C-F4> :tabc
    "inoremap <C-F4> <C-O>:tabc
    "cnoremap <C-F4> <C-C>:tabc

    "CTRL+N is new tab
    call Zod_Key_Mapping(a:add_list, a:reverse_map_mode, a:filter_str, '.vimrc', 'map', '', '<leader><C-n>', ':tabe<CR>', '開啟新分頁')
    "inoremap <C-N> <C-O>:tabe<CR>
    "cnoremap <C-N> <C-C>:tabe<CR>

    "CTRL+d is close tab
    "noremap <C-D> :tabc<CR>

    let g:leader_key_count_switch = exists('g:leader_key_count_switch') ? !g:leader_key_count_switch : 1
endf
" }}}


"=============================================================================="
"4.set_configure---------------------------------------------------------------"
"=============================================================================="
" 4.set_configure {{{1
" 設定<Leader>為 '\'
let mapleader = '\'
let g:mapleader = '\'

"set altkeymap
"來支援 256 色的環境,使得airline的顏色顯示正確/colorscheme的配色正確顯示
set t_Co=256
"設定目前文字/背景顏色,游標顯示的方式(加底線)
"colorscheme evening
"設定高亮顯示當前列
set cursorline
"設定高量顯示當前行
"set cursorcolumn
"依據不同的背景色選擇不同的高量顯示當前列(已設定colorscheme所以不需要設了)
"if &background== "light"
    "顯示當行用底線
    "highlight comment cterm=none ctermbg=darkblue guibg=darkblue
"    highlight CursorLine cterm=none ctermbg=lightblue
"else
"    highlight comment cterm=none ctermbg=green
    "顯示當行用高亮
"    highlight CursorLine cterm=none ctermbg=darkblue
"endif
"設定目前游標上下至少顯示多少行數
set scrolloff=3


"開啟語法功能
syntax enable
"語法高亮度
syntax on

"啟用vi兼容模式,可以讓古老的vi script可以使用
"set compatible
"叫vim不要使用與vi兼容的模式, 否則很多 vim 的新功能就不能使用, ex: filetype
"eclim要設成不相容
set nocompatible

"增加指定目錄下的tags作為help tag的來源,:help topic會到這些目錄找尋topic
set tags+=$HOME/.vim/doc/tags,$VIMRUNTIME/doc/tags
"設定:wviminfo viminfo要存的資訊數量
set viminfo='1000,f1,<500,:500,@500,/500,s30

"設定filetype可以自動辨識該檔案類型, ex: .c .cpp可以開啟各自的語法亮度
filetype on
"可以定義對各個特別的文件作特殊的熱鍵或是設定
filetype indent on          " Enable filetype-specific indenting
filetype plugin on          " Enable filetype-specific plugins
filetype plugin indent on   " Enable loading indent file for filetype

"insert模式中indent:換行時可以自動縮排.eol:可以刪除到上一行的行尾.start:可以刪除到這行開頭.
set backspace=indent,eol,start

"設定高亮的顏色
"highlight Search term=reverse ctermbg=yellow ctermfg=grey
"每輸入一個字元就找符合該字的位置
set incsearch
"將search到的字元用高亮度顯示
set hlsearch
"搜尋時不區分大小寫
set ignorecase
"收尋時不缺分大小寫,除非出現一個大寫後,才區分大小寫
set smartcase

"讓VIM中的keyword以較暗沉的顏色表現出來，適用於亮色系的背景
"set background=light
"讓 VIM 中的 keyword 以較亮眼的顏色表現出來，適用於暗色系的背景
set background=dark
"每行左邊顯示行號
set number
"右下角顯示目前遊標的行列位置
set ruler
"右下角ruler的左邊顯示輸入的指令
set showcmd
"輸入對應括號時,會跳回前一個括號顯示配對的情況
set showmatch
"左下角會顯示目前的模式(Visual, Select, Insert)
set showmode
"一行若是太長,則向右延伸到螢幕外邊
set nowrap
"在ex模式下,輸入tab補完會出現補完的清單
set wildmenu
"設定wildmenu顯示的清單樣式
"set wildmode=list:longest


"保存50個命令和50個查找模式的歷史
set history=50

"設定開啟的分頁最多幾個
set tabpagemax=20

"tab鍵縮排縮幾個空白長度
set shiftwidth=4
set tabstop=4
"把tab展開成空白.
set expandtab
"不把tab展開成空白
"set noet
"換行時會自動對齊上一行的縮排
set autoindent
"對C program自動縮排
set cindent
"set smartindent
"set indentexpr

"設定vim不使用modeline
set nomodeline
"啟用modeline；
"set modeline
"將搜尋modeline 的範圍設定為文件開頭和末尾各兩行，若省略則預設為五行。
"set modelines=2
"(在檔案開頭/結尾設定一些參數),來對文件作特殊的設置(像vim:tw=78:ts=8:ft=help:
"表示set tw=78, set ts=8, set ft=help)

"設定Quickfix
"set makeprg=gcc\ % 
"set errorformat=%E%f:%l:\ %m,%-Z%p^,%-C%.%#,%-G%.%# 
"copen      "打开错误窗口


"注意:應該要把putty, screen, bash, .vimrc設定成一樣的term, encoding
"set encoding=cp950
"檔案預設編碼
set fileencoding=utf-8
"所有可使用的編碼
set fileencodings=ucs-bom,utf-8,gbk,big5,utf8,gb2312
"可使用的檔案格式 fileformat
set ffs=unix,dos
"預設的檔案格式 (r 與 n ^M)
set ff=unix
"設定 vim 內部如何表示字元
set encoding=utf-8
"終端機編碼
set termencoding=utf-8

"設定狀態列一直都顯示
set laststatus=2

"在vim左邊邊界欄位顯示fold的編號順序
set foldcolumn=1
" 設定fold的方法
" python fold {{{2
"Then you will be able to be inside a method and type 'za' to open and close a fold.
"set foldmethod=indent
"set foldlevel=99
" }}}2

set foldmethod=marker
set foldenable

" by smartboy
"let &termencoding = &encoding
"set encoding=utf-8
"set fileencoding=big5
"set fileencodings=ucs-bom,utf-8,big5,gb2312,korea,gb18030,latin1

"設定顏色樣式(mac textmate)
colorscheme molokai

" }}}1

"=============================================================================="
"5.au_setting------------------------------------------------------------------"
"=============================================================================="
" 5.au_setting {{{
" debug autocmd
"set verbose=9

if has("autocmd")
    exec 'set runtimepath+='.expand('$HOME') . '/.vim/lang/smali'

    " vim載入所有plugin後,設定Key Map
    augroup Zod_KeyMap
        " Remove ALL autocommands for the current group.
        au!
        au VimEnter * call Key_Map_Setting()
    augroup END

    " 參考/usr/share/vim/vim73/filetype.vim
    " Shell scripts (sh, ksh, bash, bash2, csh); Allow .bash* etc.
    " Make syntax on .bash_aliases
    augroup Zod_ShellScript
        au!
        au BufNewFile,BufRead .bash* call SetFileTypeSH("bash")
    augroup END

    " 編輯二進位檔案,自動使用xxd轉換
    augroup Zod_Binary
        au!
        au BufReadPre  *.bin let &bin=1
        " %: 1,$ ; !xxd : execute external command xxd ; %!xxd : all content
        " pipe to xxd and get it back to vim
        au BufReadPost *.bin if &bin | %!xxd
        au BufReadPost *.bin set ft=xxd | endif
        au BufWritePre *.bin if &bin | %!xxd -r
        au BufWritePre *.bin endif
        au BufWritePost *.bin if &bin | %!xxd
        au BufWritePost *.bin set nomod | endif
    augroup END

    augroup Zod_JAVA
        au!
        "au BufRead *.java call input("cal1")
        "autocmd FileType java set omnifunc=javacomplete#Complete
       "au FileType java set makeprg=javac
       "au FileType java set errorformat=%E%f:%l:\ %m,%-Z%p^,%+C%.%#,%-G%.%#
       "au FileType java set errorformat=%A%f:%l:\ %m,%+Z%p^,%+C%.%#,%-G%.%#
       "au FileType java set makeef=error.txt\ ;\ cp\ error.txt\ error.txt.bak
       "au FileType java set shellpipe=2>&1\|\ tee\ error.txt
    augroup END
"set makeprg=javac
""set makeef=c:\dev\src\errors.txt
""set shellpipe=2>
"set errorformat=%A%f:%l:\ %m,%C%m

"noremap <C-\>1 :w<CR>:set ch=5<CR>:make -d . %:p<CR>
"noremap <C-\>2 :cp<CR>
"noremap <C-\>3 :cn<CR>
"noremap <C-\>4 :cl<CR>


    func! PythonCodeStyle()
        set tabstop=8
        set expandtab
        set softtabstop=4
        set shiftwidth=4
        set textwidth=79
        set autoindent
    endf

    "ToDo: complete, file explorer(left), tagbar/taglist(right), quickfix(bottom)
    augroup Zod_Python_IDE
        au!
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType python call PythonCodeStyle()
        "let g:SuperTabDefaultCompletionType = "context"
        "set completeopt=menuone,longest,preview
    augroup END

    "Vim doesn't realize that you are in a virtualenv so it wont give you code
    "completion for libraries only installed there.
    " Add the virtualenv's site-packages to vim path
"py << EOF
"    import os.path
"    import sys
"    import vim
"    if 'VIRTUAL_ENV' in os.environ:
"        project_base_dir = os.environ['VIRTUAL_ENV']
"        sys.path.insert(0, project_base_dir)
"        activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
"        execfile(activate_this, dict(__file__=activate_this))
"EOF

    "The only true django tweak I make is before I open vim I'll export the
    "DJANGO_SETTINGS_MODULE environment so that I get code completion for
    "django modules as well
    "export DJANGO_SETTINGS_MODULE=project.settings

    " Enable omni completion. (Ctrl-X Ctrl-O)
    "autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    "autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    "autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    "autocmd FileType css set omnifunc=csscomplete#CompleteCSS
    "autocmd FileType c set omnifunc=ccomplete#Complete
    "" use syntax complete if nothing else available
    "if has("autocmd") && exists("+omnifunc")
    "    autocmd Filetype *
    "                \ if &omnifunc == "" |
    "                \ setlocal omnifunc=syntaxcomplete#Complete |
    "                \ endif
    "endif
    "set cot-=preview "disable doc preview in omnicomplete

    "" make CSS omnicompletion work for SASS and SCSS
    "autocmd BufNewFile,BufRead *.scss set ft=scss.css
    "autocmd BufNewFile,BufRead *.sass set ft=sass.css

    " 程式碼的初始設定
    augroup CodeInit
        au!
        " 設定程式碼的標頭檔
        au BufNewFile *.sh,*.c,*.cpp,*.cc,*.java,*.pl,*.py,*.php,*.exp exec ":call SetTitle()"

        " *.c 從~/.vim/bundle/c.vim/c-support/templates/Template寫到c檔案開頭

        "读入.c,.h.cpp,.sh,.java,.php,.py文件自动打开Taglist
        "au BufRead *.[ch],*.cpp,*.sh,*.java,*.php,*.py exec ":Tlist"
    augroup END


    "設置Java的自動補全,改用eclim,所以disable now
    "javacomplete.vim 用Ctrl-X,Ctrl-O在插入模式String.之後輸入class method之類的
    "setlocal omnifunc=javacomplete#Complete   "自動補全
    "setlocal completefunc=javacomplete#CompleteParamsInfo   "參數提示
    "autocmd FileType java setlocal omnifunc=javacomplete#Complete
    "autocmd Filetype cpp,c,java,cs set omnifunc=cppcomplete#Complete 

    au! BufRead,BufNewFile *.asm	map <F5> :w \| !nasm -o a.out -f elf -g % && ./a.out<CR>

    "讓vimrc修改後自動生效(TODO:mac,cygwin)
	if has("macunix")   
		echo "Macintosh version of Vim, using Unix files (OS-X)."
	elseif has("unix")   
		"Unix version of Vim
		au! BufWritePost .vimrc source $HOME/.vimrc
	elseif has("win32")    
		"Win32 version of Vim (MS-Windows 95 and later, 32 or 64 bits)
		au! BufWritePost .vimrc source $VIM/_vimrc
	elseif has("win32unix") 
		echo "Win32 version of Vim, using Unix files (Cygwin)"
	endif


    "[不如<C-N> <C-P> <C-X>好用]设置输入代码的自动补全(需要word_complete.vim)
    "autocmd BufEnter * call DoWordComplete()

    "設定.txt為vim help的syntax格式
    augroup Zod_Text
        au!
        au BufRead,BufNewFile *.txt set filetype=help
        au BufRead,BufNewFile *.txt set modeline
        au BufRead,BufNewFile *.txt set modelines=2
    augroup END

    "設定cmake filetype
    augroup CMakeSyntax
        au!
        autocmd BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in set filetype=cmake
        autocmd BufRead,BufNewFile *.ctest,*.ctest.in set filetype=cmake
    augroup END

    "autogenerate tags after writing files to ~/.vim/doc
    "autocmd BufWritePost ~/.vim/doc/* :helptags ~/.vim/doc


    "對.viki自動進入viki編輯模式
    augroup Zod_Viki
        au!
        au BufRead,BufNewFile *.viki set ft=viki
    augroup END


    augroup Zod_FileTypeDetect
        au!
        au BufRead,BufNewFile *.spt setfiletype snippet

        " for txl syntax highlighting
        au BufNewFile,BufRead *.Txl,*.txl,*.Grammar,*.grammar,*.Rules,*.rules,*.Module,*.module,*.Mod,*.mod,*.Grm,*.grm,*.Rul,*.rul set ft=txl
    augroup END 


    augroup Zod_Win_Batch_File
        au!
        au VimEnter *.bat set ff=dos
    augroup END
else
	echoerr "[.vimrc] Vim ". version . " doesn't support autocmd"
endif

" for snippetEmu
"imap <F2> <Plug>Jumper
"let g:snip_start_tag = "@"
"let g:snip_end_tag= "@"

"" for tSkeleton
"autocmd BufNewFile *.pl        TSkeletonSetup perl.pl
"autocmd BufNewFile *.py        TSkeletonSetup python.py
"let g:tskelDateFormat = "%b-%d-%Y"
"let g:tskelUserName	= "xx-xxx XXX"
"let g:tskelUserEmail = "xxxx@xxxx.org"
"let g:tskelUserWWW = "http://xxxx.org"

" for python.vim
"au FileType python source ~/.vim/plugin/python.vim
" for *.py
"au BufRead,BufNewFile *.py set ai et nu sw=4 ts=4 tw=79


" ins-completion options
hi Pmenu ctermbg=DarkBlue ctermfg=Grey
hi PmenuSel ctermbg=DarkGreen ctermfg=white
"set pumheight=16

"highlight SpellErrors ctermfg=Red guifg=Red cterm=underline gui=underline  term=reverse
"highlight Normal ctermbg=black ctermfg=white
"highlight Folded ctermbg=black ctermfg=darkcyan
"highlight CursorLine cterm=none ctermbg=darkblue
"set cursorcolumn
"highlight CursorLine cterm=none ctermbg=blue
"map <F3> :set cursorline!<CR><Bar>:echo "Highlight active cursor line: " . strpart("OffOn", 3 * &cursorline, 3)<CR>

"highlight LineNr term=bold cterm=NONE ctermfg=yellow ctermbg=none gui=NONE guifg=DarkGrey guibg=NONE 
"map <F4> :set number!<CR><Bar>:echo "Line Number: " . strpart("OffOn", 3 * &number, 3)<CR>


" spelling check
"map <F2> :set spell!<CR><Bar>:echo "Spell check: " . strpart("OffOn", 3 * &spell, 3)<CR>

" }}}
