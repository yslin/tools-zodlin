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
"7.commands                                                                    "
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
"1.a.lang/
" taglist.vim : Source code browser (supports C/C++, java, perl, python, tcl, sql, php, etc) {{{2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -name: 'vim-scripts/taglist.vim'
" -dir : ~/.vim/bundle/taglist.vim
" -help: taglist.txt
" -link: http://www.vim.org/scripts/script.php?script_id=273
" Ubuntu: sudo apt-get install exuberant-ctags
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"exec 'set runtimepath+='.expand('$HOME') . '/.vim/lang/all/taglist.vim'
"exec 'helptags '.expand('$HOME') . '/.vim/lang/all/taglist.vim/doc'
" 開啟檔案時,是否自動打開taglist
let Tlist_Auto_Open = 0
" 點擊taglist顯示的項目時,是否自動關閉taglist
let Tlist_Close_On_Select = 0
" 當文件關閉時,是否會自動關閉taglist並離開vim
let Tlist_Exit_OnlyWindow = 1
" 從taglist切換到文件時,是否自動將所在的tag自動高亮,可以:TlistHighlightTag來更新
let Tlist_Auto_Highlight_Tag = 1
" 是否只顯示當前檔案的taglist,而非buffers中所有的檔案
let Tlist_Show_One_File = 1
" 是否調整vim寬度來顯示taglist
let Tlist_Inc_Winwidth = 0

" User define language
" support .smali filetype, modify ~/.ctags to match regular expression.
let tlist_smali_settings ='smali;v:field;f:function'
" taglist.vim }}}2
" Tagbar : Display tags of the current file ordered by scope {{{2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -name: 'majutsushi/tagbar'
" -version: 2.6.1
" -help: :h tagbar.txt
" -link: http://www.vim.org/scripts/script.php?script_id=3465
"        https://github.com/majutsushi/tagbar
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
exec 'set runtimepath+='.expand('$HOME') . '/.vim/lang/all/tagbar'
"The display of the icons used to indicate open or closed folds
let g:tagbar_iconchars = ['+', '-'] 
"Auto to open a closed fold when auto focus on.
"需要停留在同一行幾秒/儲存/進入文件.
let g:tagbar_autoshowtag = 1

"TODO: windows需要設定ctags
"let g:tagbar_ctags_bin = 

" User define language,像taglist一樣
" Not defined now :h tagbar-extend

" 與eclim相衝
"nnoremap <silent> <F7> :TagbarToggle<CR>
"" set focus to TagBar when opening it
"let g:tagbar_autofocus = 1
" Tagbar }}}2
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
" The NERD tree: A tree explorer plugin for navigating the filesystem {{{2
" Replace netrw built-in vim.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" -name: 'scrooloose/nerdtree'
" -help: :h NERD_tree.txt
" -version: 5.0.0
" -link: http://www.vim.org/scripts/script.php?script_id=1658
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
exec 'set runtimepath+='.expand('$HOME') . '/.vim/visual/nerdtree'
"let NERDChristmasTree = 1
"let NERDTreeHighlightCursorline = 1
"let NERDTreeShowBookmarks = 1
"顯示隱藏檔案
let NERDTreeShowHidden = 1
"忽略顯示以下檔案
"let NERDTreeIgnore = ['.vim$', '\~$', '.svn$', '\.git$', '.DS_Store', '.sass-cache']
"nmap <leader>w :NERDTreeToggle<CR>

" auto start NERDTree when vim start without any args.
"autocmd StdinReadPre * let s:nerd_std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:nerd_std_in") | NERDTree | endif

func! Zod_Plugin_nerdtree_Clear()
endf
func! Zod_Plugin_nerdtree(...)
    if exists("g:loaded_Zod_Plugin_nerdtree")
        return
    endif
    let g:loaded_Zod_Plugin_nerdtree = 1
    "NERDTree
    ":NERDTreeToggle
    "call Zod_Key_Mapping(1, 0, '', 'nerdtree', 'nmap', '<silent><unique>', '<leader>fe1', ':NERDTreeToggle<CR>', 'Split & Explore directory')
    "call Zod_Key_Mapping(1, 0, '', 'nerdtree', 'nmap', '<silent><unique>', '<leader>fe2', ':NERDTreeMirror<CR>', 'Split & Explore directory with the same list')
endf

"call Zod_Load_Plugin_Key_Map({
"            \'disable' : 0,
"            \'name': 'Zod_nerdtree',
"            \'dir': '*/nerdtree/', 
"            \'keymapFile': '*/nerdtree/plugin/NERD_tree.vim',
"            \'keyclearFunc': 'Zod_Plugin_nerdtree_Clear',
"            \'keymapFunc': 'Zod_Plugin_nerdtree'})
" The NERD tree }}}2
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
    "紀錄目前視窗id
    let prevwinid = win_getid()
    "left window:檔案列表
    NERDTreeToggle
    "right window:函式/變數列表
    TagbarToggle
    "bottom window:錯誤訊息/vimgrep列表
    call ToggleList("Quickfix List", 'c')
    "跳回開啟文件的視窗
    call win_gotoid(prevwinid)
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
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F5>', ':ZodCompileProgram<CR>', '編譯程式碼')
    "按照對應的檔案格式,編譯與執行程式,
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F6>', ':ZodRunProgram<CR>', '編譯並執行執行程式碼')
    "按照對應的檔案格式,設定breakpoint
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F7>', ':call SetProgramBreakpoint()<CR>', '設定Breakpoint')
    "按照對應的檔案格式,移除breakpoint
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<s-F7>', ':call RemoveProgramBreakpoint()<CR>', '移除Breakpoint')
    "按照對應的檔案格式,執行Debug程式
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F8>', ':ZodDebugProgram<CR>', '進入Debugger')
    " 單鍵 <F7> 控制 syntax on/off。倒斜線是 Vim script 的折行標誌
    " 按一次 <F7> 是 on 的話，再按一次則是 off，再按一次又是 on。
    " 原因是有時候顏色太多會妨礙閱讀。
    "call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F7>', ':call ToggleSyntax()<CR>', '關閉/開啟語法高亮')

    "f7設定取得getqflist, setqflist,各種不同的checker

    "將目前vim設定各存成一個會話文件和viminfo文件
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F9>', ':ZodSaveSessionInfo<CR>', '儲存vim session')

    "讀取会话文件與viminfo文件
    call Zod_Key_Mapping(1, 0, '', '.vimrc', 'map', '<unique>', '<F10>', ':ZodLoadSessionInfo<CR>', '讀取vim session')

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

    call Zod_Key_Mapping(a:add_list, 0, '', '.vimrc', 'map', '', '<leader>main', ':ZodInitCode<CR>', '按照對應的filetype,讀取基本的程式碼entry point')
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
        au BufNewFile *.sh,*.c,*.cpp,*.cc,*.java,*.pl,*.py,*.php,*.exp exec ":ZodSetTitle"

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
"=============================================================================="
"6.script_function-------------------------------------------------------------"
"=============================================================================="
" 6.script_function {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"設定各種自定義函式,並且強制覆蓋原定義,所以要小心有甚麼相衝可能不會顯示
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"variable local to a script file by prepending "s:".  
"對各種不同程式給予不同的hello world檔案
" FUNCTION: InitCode() {{{2
func! s:InitCode()
	if &filetype == 'c'
        call append(line("."), 	 "#include <stdio.h>")
		call append(line(".")+1, "int main(int argc, char *argv[])")
		call append(line(".")+2, "{")
		call append(line(".")+3, "	printf(\"\");")
		call append(line(".")+4, "	return 0;")
		call append(line(".")+5, "}")
	elseif &filetype == 'sh'
        call append(line("."), 	 "NO_ARGS=0")
        call append(line(".")+1, 	 "E_OPTERROR=65")
        call append(line(".")+2, 	 "USAGE=\"Usage: `basename $0` -f<INFILE> -o<OUTFILE>")
        call append(line(".")+3, 	 "Try './`basename $0` -h' for more information.\"")
        call append(line(".")+4, 	 "if [ $# -eq \"$NO_ARGS\" ] # should check for no arguments")
        call append(line(".")+5, 	 "then")
        call append(line(".")+6, 	 "	exit $E_OPTERROR")
        call append(line(".")+7, 	 "fi")
        call append(line(".")+8, 	 "while getopts f:o:v:h OPTION ; do")
        call append(line(".")+9, 	 "	case \"$OPTION\" in")
        call append(line(".")+10, 	 "		f)")
        call append(line(".")+11, 	 "			INFILE=\"$OPTARG\" ;")
        call append(line(".")+12, 	 "			echo \"input: $INFILE\";;")
        call append(line(".")+13, 	 "		o) ")
        call append(line(".")+14, 	 "			OUTFILE=\"$OPTARG\" ;")
        call append(line(".")+15, 	 "			echo \"output: $OUTFILE\";;")
        call append(line(".")+16, 	 "		v) ")
        call append(line(".")+17, 	 "			VERBOSE=true ;;")
        call append(line(".")+18, 	 "		h) echo \"$USAGE\" ;")
        call append(line(".")+19, 	 "			exit 1")
        call append(line(".")+20, 	 "			;;")
        call append(line(".")+21, 	 "	esac")
        call append(line(".")+22, 	 "done")
        call append(line(".")+23, 	 "\#實際傳進的參數量")
        call append(line(".")+24, 	 "shift `echo \"$OPTIND - 1\" | bc` ")
        call append(line(".")+25, 	 "echo \"$(($OPTIND - 1))\"")
	elseif &filetype == 'perl'
        call append(line("."),     "use Getopt::Long;")
		call append(line(".")+  1, "use Pod::Usage;")
		call append(line(".")+  2, "exit(&main(@ARGV));")
		call append(line(".")+  3, "sub main{")
		call append(line(".")+  4, "\# Define options")
		call append(line(".")+  5, "    my %options = ();")
		call append(line(".")+  6, "    my @opt_specs = (")
		call append(line(".")+  7, "        'help',")
		call append(line(".")+  8, "        'man', ")
		call append(line(".")+  9, "        'lib=s@', ")
		call append(line(".")+ 10, "        'flag=s%', ")
		call append(line(".")+ 11, "        'debug:i',")
		call append(line(".")+ 12, "    );")
		call append(line(".")+ 13, "\# declare default values for variables")
		call append(line(".")+ 14, "    $options{'lib'} = ['~/lib'];")
		call append(line(".")+ 15, "    $options{'flag'} = {'debug' => 'true'};")
		call append(line(".")+ 16, "    $options{'debug'} = 1;")
		call append(line(".")+ 17, "")
		call append(line(".")+ 18, "    parse_command_line(\\%options, \\@opt_specs);")
		call append(line(".")+ 19, "    return 0;")
		call append(line(".")+ 20, "}")
		call append(line(".")+ 21, "")
		call append(line(".")+ 22, "sub parse_command_line{")
		call append(line(".")+ 23, "    my ($options_ref, $opt_specs_ref) = @_;")
		call append(line(".")+ 24, "    my %options = %$options_ref;")
		call append(line(".")+ 25, "    my @opt_specs = @$opt_specs_ref;")
		call append(line(".")+ 26, "    my $parser = Getopt::Long::Parser->new();")
		call append(line(".")+ 27, "    $parser->getoptions(\\%options, @opt_specs) || pod2usage(2);")
		call append(line(".")+ 28, "    pod2usage(1)  if ($options{'help'}); ")
		call append(line(".")+ 29, "    pod2usage(VERBOSE => 2)  if ($options{'man'});")
		call append(line(".")+ 30, "")
		call append(line(".")+ 31, "\# display resulting values of variables")
		call append(line(".")+ 32, "    print <<EOS;")
		call append(line(".")+ 33, "Libs:           @{[ join ', ', @{$options{'lib'}} ]} ")
		call append(line(".")+ 34, "Flags:          @{[ join \" \", map { \"$_ = $options{'flag'}{$_}\" } keys %{$options{'flag'}} ]}")
		call append(line(".")+ 35, "Remaining:      @{[ join ', ', @ARGV ]} ")
		call append(line(".")+ 36, "EOS")
		call append(line(".")+ 37, "}")
		call append(line(".")+ 38, "")
		call append(line(".")+ 39, "__END__")
		call append(line(".")+ 40, "")
		call append(line(".")+ 41, "=head1 NAME")
		call append(line(".")+ 42, "")
		call append(line(".")+ 43, "The name of your program or module.")
		call append(line(".")+ 44, "sample - Using Getopt::Long and Pod::Usage")
		call append(line(".")+ 45, "")
		call append(line(".")+ 46, "=head1 SYNOPSIS")
		call append(line(".")+ 47, "")
		call append(line(".")+ 48, "\A one-line description of what your program or module does (purportedly). ")
		call append(line(".")+ 49, "sample [options] [file ...]")
		call append(line(".")+ 50, "")
		call append(line(".")+ 51, "  Options:   ")
		call append(line(".")+ 52, "    -help            brief help message")
		call append(line(".")+ 53, "")
		call append(line(".")+ 54, "    -man             full documentation")
		call append(line(".")+ 55, "")
		call append(line(".")+ 56, "=head1 OPTIONS ")
		call append(line(".")+ 57, "")
		call append(line(".")+ 58, "=over 8 ")
		call append(line(".")+ 59, "")
		call append(line(".")+ 60, "=item B<-help> ")
		call append(line(".")+ 61, "")
		call append(line(".")+ 62, "Print a brief help message and exits.")
		call append(line(".")+ 63, "")
		call append(line(".")+ 64, "=item B<-man>")
		call append(line(".")+ 65, "")
		call append(line(".")+ 66, "Prints the manual page and exits.")
		call append(line(".")+ 67, "")
		call append(line(".")+ 68, "=back")
		call append(line(".")+ 69, "")
		call append(line(".")+ 70, "=head1 DESCRIPTION")
		call append(line(".")+ 71, "")
		call append(line(".")+ 72, "The bulk of your documentation. (Bulk is good in this context.) ")
		call append(line(".")+ 73, "")
		call append(line(".")+ 74, "=head1 AUTHOR")
		call append(line(".")+ 75, "")
		call append(line(".")+ 76, "Who you are. (Or an alias, if you are ashamed of your program.)")
		call append(line(".")+ 77, "")
		call append(line(".")+ 78, "=head1 BUGS")
		call append(line(".")+ 79, "")
		call append(line(".")+ 80, "What you did wrong (and why it wasn't really your fault). ")
		call append(line(".")+ 81, "")
		call append(line(".")+ 82, "=head1 SEE ALSO ")
		call append(line(".")+ 83, "")
		call append(line(".")+ 84, "Where people can find related information (so they can work around your bugs). ")
		call append(line(".")+ 85, "")
		call append(line(".")+ 86, "=head1 COPYRIGHT")
		call append(line(".")+ 87, "")
		call append(line(".")+ 88, "The copyright statement. If you wish to assert an explicit copyright, you should say something like:")
		call append(line(".")+ 89, "")
		call append(line(".")+ 90, "Copyright 2013, Randy Waterhouse.  All Rights Reserved.")
		call append(line(".")+ 91, "")
		call append(line(".")+ 92, "=cut ")
	elseif &filetype == 'python'
        call append(line("."), 	 "def main():")
		call append(line(".")+1, "    print 'main'")
		call append(line(".")+2, "")
		call append(line(".")+3, "if __name__ == '__main__':")
		call append(line(".")+4, "    main()")
	elseif &filetype == 'cpp'
        call append(line("."), 	 "#include <stdio.h>")
		call append(line(".")+1, "#include <iostream>")
		call append(line(".")+2, "using namespace std;")
		call append(line(".")+3, "int main(int argc, char *argv[])")
		call append(line(".")+4, "{")
		call append(line(".")+5, "	cout<<\"\"<<endl;")
		call append(line(".")+6, "	return 0;")
		call append(line(".")+7, "}")
	elseif &filetype == 'java'
        call append(line("."), 	 "public class ".expand("%<")."{")
		call append(line(".")+1, "    public static void main(String[] argv) {")
		call append(line(".")+2, "    }")
		call append(line(".")+3, "}")
	elseif &filetype == 'php'
        call append(line("."),"function main()")
        call append(line(".")+1,"{")
        call append(line(".")+2,"}")
        call append(line(".")+3,"")
        call append(line(".")+4,"try")
        call append(line(".")+5,"{")
        call append(line(".")+6,"    main();")
        call append(line(".")+7,"}")
        call append(line(".")+8,"catch(Exception $e) ")
        call append(line(".")+9,"{")
        call append(line(".")+10,"    print $e->getMessage();")
        call append(line(".")+11,"} ")
	"相當於對.txt檔案做處理,因為我把所有.txt設為help檔案屬性 
	elseif &filetype == 'help'
        call append(line("."), 	 "vim:tw=78:ts=8:ft=help")
	endif
endf
" 1}}}
"自動插入各種文件開頭說明檔
" FUNCTION: SetTitle() {{{2
func! s:SetTitle()
        "如果文件类型为.sh文件
        if &filetype == 'sh' || &filetype == 'python' || &filetype == 'perl' || &filetype == 'expect'
                call setline(1,          "\#==============================================================================")
                call append(line("."),   "\# Copyright ".strftime("%Y")." zod.yslin")
                call append(line(".")+1,"\# Author: zod.yslin")
                call append(line(".")+2,"\# Email:")
                call append(line(".")+3,"\# File Name: ".expand("%"))
                call append(line(".")+4,"\# Description:")
                call append(line(".")+5,"\#")
                call append(line(".")+6,"\# Edit History:")
                call append(line(".")+7,"\#   ".strftime("%Y-%m-%d")."    File created.")
                call append(line(".")+8,"\#==============================================================================")
                call append(line(".")+9,"")
        else
                "java 其它程序文件
                call setline(1,          "/*==============================================================================")
                call append(line("."), " * Copyright ".strftime("%Y")." zod.yslin")
                call append(line(".")+1," * Author: zod.yslin")
                call append(line(".")+2," * Email: ")
                call append(line(".")+3," * File Name: ".expand("%"))
                call append(line(".")+4," * Description: ")
                call append(line(".")+5," * ")
                call append(line(".")+6," * Edit History: ")
                call append(line(".")+7," *   ".strftime("%Y-%m-%d")."    File created.")
                call append(line(".")+8," *=============================================================================*/")
                call append(line(".")+9,"")
        endif
        "如果为php文件，添加相应头和尾
        if &filetype == 'php'
                call append(0, "\#!/usr/bin/php")
                call append(1, "<?php")
                call append(line("$"), "?>")
        endif
        "如果为sh文件，添加相应的头
        if &filetype == 'sh'
                call append(0, "\#!/bin/bash")
                "如果为python文件，添加相应的头和编码设定
        elseif &filetype == 'python'
                call append(0, "\#!/usr/bin/env python")
                call append(1, "\# -*- coding: utf-8 -*-")
        elseif &filetype == 'perl'
                call append(0, "\#!/usr/bin/perl")
        elseif &filetype == 'expect'
                call append(0, "\#!/usr/bin/expect")
        endif
endf
" 2}}}
"global variable
let g:CLASSPATH = ":./*:$HOME/lib/*:/usr/share/java/junit4.jar"
"make the file executable.
" FUNCTION: SetExecutableBit() {{{2
func! s:SetExecutableBit()
    let fname = expand("%:p")
    checktime
    execute "au FileChangedShell " . fname . " :echo"
    silent !chmod a+x %
    checktime
    execute "au! FileChangedShell " . fname
endf
" 2}}}
"設定C++的Error Fomat給QuickFix用
" FUNCTION: SetCppEFM() {{{2
func! s:SetCppEFM()
    set efm=
    " A bunch of warnings which are benign.
    let &efm .= '%-G%.%#UNIX_CXX_TEMP_DIR%.%#'
    let &efm .= ',%-G%.%#undefined\ variable\ `DEBUG_FLAG%.%#'
    let &efm .= ',%-G%.%#undefined\ variable\ `OBJ_DIR%.%#'
    let &efm .= ',%-G%.%#undefined\ variable\ `VERBOSE%.%#'
    let &efm .= ',%-G%.%#undefined\ variable\ `LIB_UT_LIB_DEPEND%.%#'
    let &efm .= ',%-G%.%#undefined\ variable\ `BOLD_%.%#'
    let &efm .= ',%-G%.%#javarules\.gnu\ is\ deprecated%.%#'
    let &efm .= ',%-G%.%#msrc-action%.%#'
    let &efm .= ',%-G%.%#Done\ prebuild%.%#'
    let &efm .= ',%-G%.%#Done\ build%.%#'
    let &efm .= ',%-G%.%#Running\ prebuild%.%#'
    let &efm .= ',%-G%.%#Running\ build%.%#'
    let &efm .= ',%-G%.%#is\ obsolete%.%#'
    let &efm .= ',%-G%.%#include\ path\ is\ out-of-model%.%#'
    let &efm .= ',%-G%.%#compflags\.gnu%.%#'
    let &efm .= ',%-GSBT%.%#'
    let &efm .= ',%-GCompiling\ %.%#'
    let &efm .= ',%-GThe\ makefile\ %.%#'
    let &efm .= ',%-GPlease\ specify\ %.%#'
    let &efm .= ',%-GUsing\ default\ %.%#'
    let &efm .= ',%-GModule\ entry\ %.%#'
    let &efm .= ',%-GBuild\ type\ %.%#'
    let &efm .= ',%-GWarning\ level\ %.%#'
    let &efm .= ',%-Gdistcc[%.%#'
    let &efm .= ',%-W%.%#compflags\.gnu%.%#'
    let &efm .= ',%.%#from\ %f:%l:%c,'
    let &efm .= ',%f:\ In\ function\ %.%#=%m'
    let &efm .= ',%*[^"]"%f"%*\D%l: %m'
    let &efm .= ',"%f"%*\D%l: %m'
    let &efm .= ',%-G%f:%l: (Each undeclared identifier is reported only once'
    let &efm .= ',%-G%f:%l: for each function it appears in.)'
    let &efm .= ',%f:%l:%c:%m'
    let &efm .= ',%f:%l'
    let &efm .= ',%f(%l):%m,%f:%l:%m,"%f"\, line %l%*\D%c%*[^ ] %m'
    let &efm .= ',%-D%*\a[%*\d]: Entering directory `%f'."'"
    let &efm .= ',%-D%*\a: Entering directory `%f'."'"
    " let &efm .= ',%-X%*\a[%*\d]: Leaving directory `%f'."'"
    " let &efm .= ',%-X%*\a: Leaving directory `%f'."'"
    " let &efm .= ',%-G%*\a[%*\d]: Entering directory `%f'."'"
    " let &efm .= ',%-G%*\a: Entering directory `%f'."'"
    let &efm .= ',%-G%*\a[%*\d]: Leaving directory `%f'."'"
    let &efm .= ',%-G%*\a: Leaving directory `%f'."'"
    let &efm .= ',%-DMaking %*\a in %f'
    let &efm .= ',%f|%l| %m '
    " let &efm .= ',%-G%.%#'
endf
" 2}}}

"對應各種不同檔案呼叫對應的compiler並且執行該程式
" FUNCTION: CompileProgram() {{{2
func! s:CompileProgram() 
	"save
	exec "w" 
    set efm&
    cclose
	if &filetype == 'c' 
        set makeprg=gcc\ -lm\ -lpthread\ -L/usr/local/lib\ -L.\ -I/usr/local/include\ -I.\ -g\ -o\ %<\ %
        "ZodSetCppEFM
        make
        if getqflist() == []
            exec "!./%<"
        end
	elseif &filetype == 'cpp'
        set makeprg=g++\ -lm\ -lpthread\ -L/usr/local/lib\ -L.\ -I/usr/local/include\ -I.\ -g\ -o\ %<\ %
        "ZodSetCppEFM
        make
        if getqflist() == []
            exec "!./%<"
        end
    "Java程序
	elseif &filetype == 'java' 
        compile javac
        set shellpipe=2>&1\|\ tee\ vim_java_compile_error.txt
		exec "make -cp " g:CLASSPATH " %" 
        " && java -cp " g:CLASSPATH " %<" 
		exec "call getchar()"
	"Perl程序
	elseif &filetype == 'perl'
		exec "!perl %"
		exec "call getchar()"
	"Python程序
	elseif &filetype == 'python'
        exec "ZodSetExecutableBit"
		exec "!./%"
		exec "call getchar()"
	"Ruby程序
	elseif &filetype == 'rb'
        setlocal efm=%+GSyntax\ OK
        setlocal efm+=%+E%f:%l:efm\ parse\ error
        setlocal efm+=%A%f:%l:in\ %*[^:]:\ %m
        setlocal efm+=%A%f:%l:\ %m
        setlocal efm+=%-C%\tfrom\ %f:%l:%m
        setlocal efm+=%-Z%\tfrom\ %f:%l
        setlocal efm+=%-Z%p^
        setlocal efm+=%-G%.%#
        set makeprg=ruby\ %
        exec "make"
	"PHP程序
	elseif &filetype == 'php'
		exec "!php %"
		exec "call getchar()"
	"Shell程序
	elseif &filetype == 'sh'
		exec "!bash %"
		exec "call getchar()"
	"Expect程序
	elseif &filetype == 'expect' || &filetype == 'exp'
		exec "!expect %"
		exec "call getchar()"
	"vim script程序
	elseif &filetype == 'vim'
		exec "source %"
		exec "call getchar()"
	endif 
endf
" 2}}}

func! ShowProgramError(outfile)
    let error_win_num = bufwinnr(a:outfile)
    if error_win_num != -1
        exec error_win_num."wincmd w"
    else
        exec "rightbelow vnew ".a:outfile
    endif
    if getqflist() != []
        botright cw
    endif
endf

" FUNCTION: RunProgram() {{{2
func! s:RunProgram() 
	"save
	exec "w" 
	if &filetype == 'c' 
		exec "!gcc -lm -lpthread -L/usr/local/lib -L. -I/usr/local/include -I. % -g -o %< && ./%<" 
		exec "call getchar()"
	elseif &filetype == 'cpp'
		exec "!g++ -L/usr/local/lib -L. -I/usr/local/include -I. % -g -o %< && ./%<"
		exec "call getchar()"
    "Java程序
	elseif &filetype == 'java' 
        let outfile="vim_java_run_error.txt" 
        exec 'set shellpipe=2>&1\|\ tee\ '.outfile
        set makeprg=java
        set errorformat=%m(%f:%l),%+G%.%#Exception:%.%#,%-G%.%#
        exec "make -cp " g:CLASSPATH " %<"
        call ShowProgramError(outfile)
        "Perl程序
    elseif &filetype == 'perl'
        exec "!perl %"
        exec "call getchar()"
        "Python程序
    elseif &filetype == 'python'
        "Reference: http://www.vim.org/scripts/script.php?script_id=477
        exec "ZodSetExecutableBit"
        "ToDo: 分辨python 2, 3的header line
        let outfile="vim_python_run_error.txt" 
        exec 'set shellpipe=2>&1\|\ tee\ '.outfile
        set makeprg=python
        set errorformat=
                    \%A\ \ File\ \"%f\"\\\,\ line\ %l\\\,%m,
                    \%C\ \ \ \ %.%#,
                    \%+Z%.%#Error\:\ %.%#,
                    \%A\ \ File\ \"%f\"\\\,\ line\ %l,
                    \%+C\ \ %.%#,
                    \%-C%p^,
                    \%Z%m,
                    \%-G%.%#
        exec "make %"
        call ShowProgramError(outfile)
        "Ruby程序
    elseif &filetype == 'rb'
        exec "!ruby %"
        exec "call getchar()"
        "PHP程序
    elseif &filetype == 'php'
        exec "!php %"
        exec "call getchar()"
        "Shell程序
    elseif &filetype == 'sh'
        exec "!bash %"
        exec "call getchar()"
        "Expect程序
    elseif &filetype == 'expect' || &filetype == 'exp'
        exec "!expect %"
		exec "call getchar()"
	"vim script程序
	elseif &filetype == 'vim'
		exec "source %"
		exec "call getchar()"
	endif 
endf
" 2}}}

" Author: Nick Anderson <nick at anders0n.net>
" Website: http://www.cmdln.org
" Adapted from sonteks post on Vim as Python IDE
" http://blog.sontek.net/python-with-a-modular-ide-vim
" I modiy 'ipdb' to 'pdb'
"python << EOF
"import vim
"def SetBreakpoint():
"    import re
"    nLine = int( vim.eval( 'line(".")'))
"
"    strLine = vim.current.line
"    strWhite = re.search( '^(\s*)', strLine).group(1)
"
"    vim.current.buffer.append(
"       "%(space)sfrom pdb import set_trace;set_trace() %(mark)s Breakpoint %(mark)s" %
"         {'space':strWhite, 'mark': '#' * 30}, nLine - 1)
"
"#vim.command( 'map <f8> :py SetBreakpoint()<cr>')
"
"def RemoveBreakpoints():
"    import re
"
"    nCurrentLine = int( vim.eval( 'line(".")'))
"
"    nLines = []
"    nLine = 1
"    for strLine in vim.current.buffer:
"        if strLine.lstrip()[:37] == 'from pdb import set_trace;set_trace()':
"            nLines.append( nLine)
"            print nLine
"        nLine += 1
"
"    nLines.reverse()
"
"    for nLine in nLines:
"        vim.command( 'normal %dG' % nLine)
"        vim.command( 'normal dd')
"        if nLine < nCurrentLine:
"            nCurrentLine -= 1
"
"    vim.command( 'normal %dG' % nCurrentLine)
"
"#vim.command( 'map <s-f8> :py RemoveBreakpoints()<cr>')
"EOF

func! SetProgramBreakpoint()
    "Python
    if &filetype == 'python'
        py SetBreakpoint()
    endif
endf

func! RemoveProgramBreakpoint()
    "Python
    if &filetype == 'python'
        py RemoveBreakpoints()
    endif
endf

"定義Debug函式來調用debugger測試程式
" FUNCTION: DebugProgram() {{{2
func! s:DebugProgram()
	"save
	exec "w"
	"C程序
	if &filetype == 'c'
		exec "!gdb %<"
	elseif &filetype == 'cpp'
		exec "!gdb %<"
		"Java程序
	elseif &filetype == 'java'
		exec "!javac -cp " g:CLASSPATH " %"
		exec "!jdb %<"
	endif
endf
" 2}}}
" FUNCTION: SaveSessionInfo() {{{2
func! s:SaveSessionInfo()
	let savefile = input("請輸入存檔檔名(或按enter用預設值)", "vim70",
				\	"file")
	let f=findfile(savefile.".vim") 
	let w=filewritable(savefile.".vim")
	if(f !="" && w )
		echo savefile "檔案已存在,確定要覆蓋(y/n)"
		let cfirm = nr2char(getchar())
	else 
		let cfirm = '@' 
		exe "mksession ".savefile.".vim"
		exe "wviminfo ".savefile.".viminfo"
		echo "檔案已儲存"
	endif
	if(cfirm == 'y')
		echo "檔案已儲存"
		exe "mksession! ".savefile.".vim"
		exe "wviminfo! ".savefile.".viminfo"
	elseif(cfirm == '@')
	else
		echo "已取消寫入"
	endif
	let _ = ""
endf
" 2}}}
" FUNCTION: LoadSessionInfo() {{{2
func! s:LoadSessionInfo()
	let loadfile = input("請輸入讀檔檔名(或按enter用預設值)", "vim70",
				\	"file")
	let f=findfile(loadfile.".vim") 
	let w=filewritable(loadfile.".vim")
	if(f !="" && w )
		exe "source ".loadfile.".vim"
		exe "rviminfo ".loadfile.".viminfo"
		echo "檔案讀取完畢"
	else
		echo "檔案讀取失敗"
	endif
endf
" 2}}}

" Creating centered titles
func! CapitalizeCenterAndMoveDown()
   s/\<./\u&/g   "Built-in substitution capitalizes each word
   center        "Built-in center command centers entire line
   +1            "Built-in relative motion (+1 line down)
endf

" Toggling syntax highlighting
func! ToggleSyntax()
    if exists("g:syntax_on")
        syntax off      "Not 'syntax clear' (which does something else)
    else
        syntax enable   "Not 'syntax on' (which overrides colorscheme)
    endif
endf

"產生tags從svn/yslinlinuxrc/doctags
func! UpdateDocTags()

endf


" 1}}}
"=============================================================================="
"7.commands--------------------------------------------------------------------"
"=============================================================================="
"7.commands {{{1
command! ZodInitCode call s:InitCode()
command! ZodSetTitle call s:SetTitle()
command! ZodSetExecutableBit call s:SetExecutableBit()
command! ZodSetCppEFM call s:SetCppEFM()
command! ZodCompileProgram call s:CompileProgram()
command! ZodRunProgram call s:RunProgram() 
command! ZodDebugProgram call s:DebugProgram()
command! ZodSaveSessionInfo call s:SaveSessionInfo()
command! ZodLoadSessionInfo call s:LoadSessionInfo()
" 1}}}
