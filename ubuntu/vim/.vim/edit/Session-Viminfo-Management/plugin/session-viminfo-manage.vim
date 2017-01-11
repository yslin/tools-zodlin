"===============================================================================
"
" File:        plugin/workspace.vim
" Version:     1.0
" Modified:    2014-08-17
" Description: This plugin provides commands to save and load vim session and 
"              viminfo files automatically. 
" Maintainer:  Brant Chen <brantchen2008@gmail.com and xkdcc@163.com>
" Manual:      Read ":help workspaceIntro".
"
" ============================================================================

" Initialization: {{{

if exists("g:loaded_workspace") || &cp
	" User doesn't want this plugin or compatible is set, let's get out!
	finish
endif
let g:loaded_workspace= 1
let save_cpo = &cpo
set cpo&vim

if v:version < 700
	echoerr "workspace: This plugin requires vim >= 7!"
	finish
endif

let s:loaded_workspace= 1
let workspace_version = "1.0"

if !exists("g:session_viminfo_dir")
	" If you're using a symlink to your script, but your resources are in
	" the same directory as the actual script, you'll need to do this:
	"   1: Get the absolute path of the script
	"   2: Resolve all symbolic links
	"   3: Get the folder of the resolved absolute file
	let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
	let g:session_viminfo_dir = resolve(s:path . "/../sessions/")
endif

" Functions: {{{

" Function: s:PrintError() function {{{2
" Print error message.
"
" Args:
"
" Returns:
"   None.
function s:PrintError(msg)
	echohl ErrorMsg
	echom a:msg
	echohl Normal
endfunction

" Function: s:ListSessionVimInfo() function {{{2
" List session and viminfo name.
" Args:
"
" Returns:
"   1 if the var is set, 0 otherwise
function s:ListSessionVimInfo()
	" Note: 
	" Following line: if there are 2342.session, xcvoui.session
	" it will return 2342 and xcvoui
	let s:SessionList = sort(map(split(globpath(g:session_viminfo_dir, "*.session"), "\n"), 'fnamemodify(v:val, ":t:r")'))
	"echom "SessionList:".string(s:SessionList)
	let s:ViminfoList = sort(map(split(globpath(g:session_viminfo_dir, "*.viminfo"), "\n"), 'fnamemodify(v:val, ":t:r")'))
	"echom "ViminfoList:".string(s:ViminfoList)
	let s:MatchedWorkspace = []
	let s:WorkspaceItem = ""
	let s:i = 0
	let s:j = 0
	if len(s:SessionList) > 0 && len(s:ViminfoList) > 0
		for s:i in range(len(s:SessionList))
			if fnamemodify(s:SessionList[s:i], ":p") != fnamemodify(s:DefaultWorkspaceSessionName, ":p")
				for s:j in range(len(s:ViminfoList))
					if s:SessionList[s:i] == s:ViminfoList[s:j]
						call add(s:MatchedWorkspace, fnamemodify(s:SessionList[s:i], ":r"))
						break
					endif
				endfor
			endif
		endfor
	endif

	" Print all existed items
	if len(s:MatchedWorkspace) > 0 
		let s:i=0
		for s:i in range(len(s:MatchedWorkspace))
			echom "     [" . s:i . "] " . s:MatchedWorkspace[s:i]
		endfor
	endif
	return 1
endfunction

" Function: s:SaveWorkspaceCore(sf,vf) function {{{2
" This function is to save vim session and viminfo files. 
"
" Args:
"   -sf: the full file path of session file
"   -vf: the full file path of viminfo file
" Returns:
"   1 if works well, 0 otherwise. 
function! s:SaveWorkspaceCore()
	call s:ListSessionVimInfo()

	let savefile = input("請輸入存檔檔名(或按enter用預設值)", "vim70",
				\   "file")
	let f=findfile(g:session_viminfo_dir."/".savefile.".session") 
	let w=filewritable(g:session_viminfo_dir."/".savefile.".session")
	if (f !="" && w)
		echo "\n"
		echo savefile."檔案已存在,確定要覆蓋(y/n)"
		let cfirm = nr2char(getchar())
	else  
		let cfirm = '@' 
		exe "mksession ".g:session_viminfo_dir."/".savefile.".session"
		exe "wviminfo ".g:session_viminfo_dir."/".savefile.".viminfo"
		echo "\n檔案已儲存:".g:session_viminfo_dir."/".savefile
		return 1
	endif 
	if(cfirm == 'y')
		exe "mksession! ".g:session_viminfo_dir."/".savefile.".session"
		exe "wviminfo! ".g:session_viminfo_dir."/".savefile.".viminfo"
		echo "\n檔案已儲存:".g:session_viminfo_dir."/".savefile
		return 1
	elseif(cfirm == '@')
	else  
		echo "\n已取消儲存"
		return 0
	endif 
endfunction

" Function: s:WorkspaceOperator(...) function {{{2
" This function is used to call funcref to SaveWorkspaceCore and LoadWorkspaceCore. 
"
" Args:
"   If no args, will pass session and viminfo files with default names under
"   current folder to funcref.
"   For example:
"     workspace.session
"     viminfo.viminfo
" If only one arg found(For more details, please refer to code):
"   > If this is not a path by isdirectory() and is not an existed
"   directory, then pass workspace files with arg name to funcref.
"     For example:
"     my.ws
"     Then you can get:
"      ./my.session
"      ./my.viminfo
"   > If this is an existed folder by using isdirectory(), then pass session and viminfo files
"     under the path with default name to funcref. 
"     Please note, the folder must exist beforehand.
"     For example:
"     ~/backup_dev/
"     Then you can get:
"     ~/backup_dev/workspace.session
"     ~/backup_dev/viminfo.viminfo
"   > If it's a path but with the suffix .ws.
"     For example:
"     ~/backup_dev/my.ws 
"     If ~/backup_dev/ existed, then pass following to funcref:
"       ~/backup_dev/my.session
"       ~/backup_dev/my.viminfo
"     If not existed, report error message and do nothing.
"   > Otherwise, report error message and do nothing.
" If otherwise, report error msg and do nothing.
"
" Returns:
"   1 if works well, 0 otherwise
function! s:WorkspaceOperator(...)
	if a:0 == 1 
		" Note: Please don't use call(a:1, ['xxx', 'xxx'])!!! That's fault!
		call a:1(s:DefaultWorkspaceSessionName, s:DefaultWorkspaceViminfoName) 
		return 1 
	elseif a:0 == 2 
		" Detect arg whether it's a path
		let slash_index = match(a:2, '[\|/]')
		" We put . and .. to else branch.
		if slash_index == -1 && a:2 != '.' && a:2 != '..' " Specified workspace name
			" We process name without path in this branch.
			" For example:
			" test.ws
			" Please note: without .ws as suffix should be illegal.

			if (match(a:2,".ws") > 0) && (match(a:2, ".ws") == (strlen(a:2) - strlen(".ws")))
				" Above first condition: must find .ws in a:2, exclude ".ws"
				" Above second condition: must have a name for .ws, but not something like my.wsxxx.
				" So legal input should be something like:
				"   te.ws
				let s:WorkspaceName=strpart(a:2, 0, strlen(a:2) - strlen(".ws"))

				" s:WorkspaceName should not a existed folder or file
				if ! isdirectory(s:WorkspaceName) && glob(s:WorkspaceName) == "" 
					call a:1(s:WorkspaceName . ".session", s:WorkspaceName . ".viminfo")
					return 1
				else
					echohl ErrorMsg
					echom 'workspace: [' . a:2 . '] exists as a folder or file under current path.'
					echom 'workspace: Please use another workspace name.' 
					echohl Normal
					return 0
				endif
			else
				" For example, .ws or .wsaxxasds or xcvouia
				echohl ErrorMsg
				echom 'workspace: Seems you did not give legal name.'
				echom 'workspace: Your input: ' . a:2
				echom 'workspace: Here comes an example, you need give a name with .ws as suffix: ~/my.ws or test.ws' 
				echom 'workspace: But not:     ~/.ws or test'
				echohl Normal
				return 0
			endif
		else " This would be a path
			try
				" Note:
				" I found fnamemodify parse '\' as '/root'! no matter '\' in
				" which position.

				" I don't want to support \
				if match(a:2, '\') != -1
					echohl ErrorMsg
					echom 'workspace: Please remove \ from [' . a:2 . '].'
					echohl Normal
					return 0
				endif

				if isdirectory(a:2)
					" Just specify a folder.  
					" We need pass workspace files with default name but under
					" the specified folder to funcref.

					" To remove redundant '/'
					if match(a:2, '/', strlen(a:2)-1) != (strlen(a:2) -1)
						call a:1(a:2 . "/" . s:DefaultWorkspaceSessionName, a:2 . "/" . s:DefaultWorkspaceViminfoName)
					else
						call a:1(a:2 . s:DefaultWorkspaceSessionName, a:2 . s:DefaultWorkspaceViminfoName)
					endif
					return 1
				else 
					" Specify a folder with your workspace name.
					" Folder must be existed already, workspace name should
					" have .ws as suffix.

					" Condition:
					" 1. fnamemodify(a:2, ":p:h") must be an existed folder
					" 2. must have .ws as suffix
					" 3. Must have a name for .ws.
					" For example, you must type: <folder_path>/name.ws
					" but not like: <folder_path>/.ws

					if ! isdirectory(fnamemodify(a:2, ":p:h"))  
						echohl ErrorMsg
						echom 'workspace: Folder [' . fnamemodify(a:2, ":p:h") . '] not exist.'
						echom 'workspace: Please create it beforehand.'
						echohl Normal
						return 0
					endif

					" Please note -1 in following line.
					" Because fnamemodify didn't get last /.
					" For example: fnamemodify('/tmp/my.ws', ":p:h") will
					" return /tmp but not /tmp/
					if ! (match(a:2,".ws") == (strlen(a:2) - 1 - 2))
						echohl ErrorMsg
						echom 'workspace: Seems you do not have .ws as suffix.'
						echom 'workspace: Your input: ' . a:2
						echohl Normal
						return 0
					endif

					" if it's relative path, for example, you're in /abc, you
					" type ../test.ws
					" then :p:h will return /abc
					" :p will return /abc/test.ws
					let s:head_path_len=strlen(fnamemodify(a:2,":p:h"))
					let s:full_path_len=strlen(fnamemodify(a:2, ":p"))
					let s:len_wsname_without_suffix = s:full_path_len - s:head_path_len - 1 - strlen('.ws')

					if s:len_wsname_without_suffix <= 0
						echohl ErrorMsg
						echom 'workspace: Seems you did not give a name to .ws'
						echom 'workspace: Your input: ' . a:2
						echom 'workspace: Here comes an example: Savews ~/my.ws' 
						echom 'workspace: But not:     Savews ~/.ws'
						echohl Normal
						return 0
					endif

					" Replace suffix:
					" change .ws to .session
					" change .ws to .viminfo (This is a must, because
					" wviminfo must create file with viminfo or .viminfo
					" as suffix from vim script.)
					let s:wk_name=strpart(fnamemodify(a:2, ":p"), 0, s:head_path_len + 1 + s:len_wsname_without_suffix) . '.session'
					let s:viminfo_name=strpart(fnamemodify(a:2, ":p"), 0, s:head_path_len + 1 + s:len_wsname_without_suffix) . '.viminfo'

					call a:1(s:wk_name, s:viminfo_name)

					return 1 
				endif
			catch
				echohl ErrorMsg
				echom 'workspace: Invalid args found [' . a:2 . '].'
				echohl Normal
				return 0
			endtry
		endif
	else
		echohl ErrorMsg
		echom 'workspace: Only accept 0 or 1 arg.'
		echohl Normal
		return 0
	endif
endfunction

" Function: s:LoadWorkspaceCore(sf,vf) function {{{2
" This function is to read vim session and viminfo files. 
"
" Args:
"   -sf: the full file path of session file
"   -vf: the full file path of viminfo file
" Returns:
"   1 if works well, 0 otherwise. 
function! s:LoadWorkspaceCore(sf, vf)
	try
		if glob(a:sf) == "" 
			echohl ErrorMsg
			echom 'workspace: [' fnamemodify(a:sf, ":p") . '] not exist.'
			echom 'workspace: Do nothing.'
			echohl Normal
			return 0
		endif
		if glob(a:vf) == ""
			echohl ErrorMsg
			echom 'workspace: [' fnamemodify(a:vf, ":p") . '] not exist.'
			echom 'workspace: Do nothing.'
			echohl Normal
			return 0
		endif

		let s:cur_dir=getcwd()

		execute "silent source " . a:sf
		echo "workspace: Load [" . fnamemodify(a:sf, ":p") . "] sucessfully."

		execute "rviminfo " . a:vf
		echo "workspace: Load [" . fnamemodify(a:vf, ":p") . "] sucessfully."
		let s:LastWorkspaceName=fnamemodify(a:sf, ":p:r") . ".ws"
		echo "Workspace Name:[" . s:LastWorkspaceName . "]"

		execute "cd " . s:cur_dir
		return 1
	catch
		echohl ErrorMsg
		echom 'workspace: Call s:LoadWorkspaceCore failed:'
		echom "workspace: a:sf: " . a:sf 
		echom "workspace: a:vf: " . a:vf
		echohl Normal
		return 0
	endtry
endfunction

" Function: s:PromptExistedWorkspaceName() function {{{2
" This function is to prompt cur dir existed workspace name.
" For example, if there is:
"   test.session test.viminfo
" so the workspace name is test.
" Then add test to s:CurPathWorkspaceNameList
"
" Args:
" Returns:
"   1 if works well, 0 otherwise. 
function!  s:PromptExistedWorkspaceName() 
	" If workspace.session and workspace.viminfo existed, load them directly
	" But not return.
	if glob(s:DefaultWorkspaceSessionName) != "" && glob(s:DefaultWorkspaceViminfoName) != ""
		echohl WarningMsg
		echom "workspace: You have default workspace files:"
		echom 'workspace:   ' . fnamemodify(s:DefaultWorkspaceSessionName, ":p")
		echom 'workspace:   ' . fnamemodify(s:DefaultWorkspaceViminfoName, ":p")
		echom 'workspace: We will load them by default.'
		echohl Normal
		call s:LoadWorkspaceCore(s:DefaultWorkspaceSessionName, s:DefaultWorkspaceViminfoName)
		" call input("workspace: Press any key to continue...")
		return 1
	endif

	" Note: 
	" Following line: if there are 2342.session, xcvoui.session
	" it will return 2342 and xcvoui
	"let s:SessionList=sort(map(split(globpath(".", "*.session"), "\n"), 'fnamemodify(v:val, ":r")'))
	let s:SessionList=sort(map(split(globpath(g:session_viminfo_dir, "*.session"), "\n"), 'fnamemodify(v:val, ":r")'))
	"echom "SessionList:".string(s:SessionList)
	"let s:ViminfoList=sort(map(split(globpath(".", "*.viminfo"), "\n"), 'fnamemodify(v:val, ":r")'))
	let s:ViminfoList=sort(map(split(globpath(g:session_viminfo_dir, "*.viminfo"), "\n"), 'fnamemodify(v:val, ":r")'))
	"echom "ViminfoList:".string(s:ViminfoList)
	let s:MatchedWorkspace=[]
	let s:WorkspaceItem=""
	let s:i=0
	let s:j=0
	if len(s:SessionList) > 0 && len(s:ViminfoList) > 0
		for s:i in range(len(s:SessionList))
			if fnamemodify(s:SessionList[s:i], ":p") != fnamemodify(s:DefaultWorkspaceSessionName, ":p")
				for s:j in range(len(s:ViminfoList))
					if s:SessionList[s:i] == s:ViminfoList[s:j]
						call add(s:MatchedWorkspace, fnamemodify(s:SessionList[s:i], ":r"))
						break
					endif
				endfor
			endif
		endfor
	endif
	"echom "MatchedWorkspace:".string(s:MatchedWorkspace)

	if len(s:MatchedWorkspace) > 0 
		if len(s:MatchedWorkspace) == 1
			" Just load it
			call s:LoadWorkspaceCore(s:MatchedWorkspace[0] . ".session", s:MatchedWorkspace[0] . ".viminfo")
			return 1
		else 
			let s:loopflag=0
			while (s:loopflag != 1 )
				echom "workspace: Please input the expected workspace index you want to load:"

				" Print all existed items
				call s:ListSessionVimInfo()

				" Get user's choice
				let s:UserChoice = input("Your input(q to exit this fucntion of workspace plugin): ")

				" If this is a number
				if s:UserChoice =~# '^\d\+$' 
					echo "User choice: " . s:UserChoice
					if s:UserChoice >= 0 && s:UserChoice < len(s:MatchedWorkspace) 
						call s:LoadWorkspaceCore(g:session_viminfo_dir."/".s:MatchedWorkspace[str2nr(s:UserChoice)] . ".session", g:session_viminfo_dir."/".s:MatchedWorkspace[str2nr(s:UserChoice)] . ".viminfo")
						return 1
					else
						echohl WarningMsg 
						echom "workspace: Illegal input. Please try again."
						echom "workspace: Your input: " . s:UserChoice
						echohl Normal 

						continue
					endif
				else 
					if s:UserChoice == "q" || s:UserChoice == "Q"
						echom "workspace: You choose not to load vim session and viminfo files."
						return 1
					else
						echohl WarningMsg 
						echom "workspace: Illegal input. Please try again."
						echom ""
						echohl Normal 

						continue
					endif
				endif
			endwhile
		endif
	endif
	return 1
endfunction
"}}}

" Commands: {{{

let s:SavewsCoreFuncref = function('s:SaveWorkspaceCore')
"command! -nargs=? -bar Savews :call s:WorkspaceOperator(s:SavewsCoreFuncref, <f-args>)
let s:LoadwsCoreFuncref = function('s:LoadWorkspaceCore')
"command! -nargs=? -bar Loadws :call s:WorkspaceOperator(s:LoadwsCoreFuncref, <f-args>)

command! SaveSession :call s:SaveWorkspaceCore()
command! LoadSession :call s:PromptExistedWorkspaceName()
"}}}

" Initialization: {{{
let s:DefaultWorkspaceName="workspace"
let s:DefaultWorkspaceSessionName="workspace.session"
let s:DefaultWorkspaceViminfoName="workspace.viminfo"

" Once execute SaveWorkspaceCore, we save the session and viminfo files name.
" in order to save them when VimLeave
let s:LastWorkspaceName="" 

" We get all *.session and *.viminfo from current folder while VimEnter,
" Then give chance to user to select to use which one and load them.
" If only session and viminfo files with default name found or only one
" session and viminfo files found, we just load them without notification.
let s:CurPathWorkspaceNameList=[]

"}}}

" Autocommands: {{{

"augroup workspace 
"  au!
"
"  " Note: 
"  " I found if we put call func in augroup, then it can't print complete message
"  " We can only see last sentense.
"  " So I move call PromptExistedWorkspaceName() to InitCheck()
"  " autocmd VimEnter *
"        " \ call <SID>PromptExistedWorkspaceName() |
"        " \ if s:CurPathWorkspaceNameList != [] | 
"        " \ call <SID>WorkspaceOperator(s:LoadwsCoreFuncref, <f-args>) |
"        " \ endif 
"  autocmd VimLeavePre * 
"        \ if s:LastWorkspaceName!="" |
"        \   call <SID>WorkspaceOperator(s:SavewsCoreFuncref, s:LastWorkspaceName) |
"        \ endif
"augroup END

"}}}


let &cpo = save_cpo

" vim:foldmethod=marker:foldcolumn=4:ts=2:sw=2
