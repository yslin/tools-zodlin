" Event sequence in a simple Vim editing session
" > vim
"     BufWinEnter     (create a default window)
"     BufEnter        (create a default buffer)
"     VimEnter        (start the Vim session)
" :edit example.txt
"     BufNew          (create a new buffer to contain demo.txt)
"     BufAdd          (add that new buffer to the session’s buffer list)
"     BufLeave        (exit the default buffer)
"     BufWinLeave     (exit the default window)
"     BufUnload       (remove the default buffer from the buffer list)
"     BufDelete       (deallocate the default buffer)
"     BufReadCmd      (read the contexts of demo.txt into the new buffer)
"     BufEnter        (activate the new buffer)
"     BufWinEnter     (activate the new buffer's window)
" i
"     InsertEnter     (swap into Insert mode)
" Hello
"     CursorMovedI    (insert a character)
"     CursorMovedI    (insert a character)
"     CursorMovedI    (insert a character)
"     CursorMovedI    (insert a character)
"     CursorMovedI    (insert a character)
" <ESC>
"     InsertLeave     (swap back to Normal mode)
" :wq
"     BufWriteCmd     (save the buffer contents back to disk)
"     BufWinLeave     (exit the buffer's window)
"     BufUnload       (remove the buffer from the buffer list)
"     VimLeavePre     (get ready to quit Vim)
"     VimLeave        (quit Vim)

" FocusGained events are queued whenever a Vim window becomes the window
" system’s input focus, so now whenever you swap back to your Vim session, if
" you’re editing any file whose name matches the filename pattern *.txt, then
" Vim will automatically execute the specified echo command.
func! FocusGained()
    autocmd  FocusGained  *   :echo 'Welcome back, ' . $USER . '! You look great!'
    " Autocommand to autosave when leaving an editor window
    autocmd  FocusGained  *   :set cursorline
    autocmd  FocusGained  *   :redraw
    autocmd  FocusGained  *   :sleep 1
    autocmd  FocusGained  *   :set nocursorline

endf

call FocusGained()

" A cleaner way to handle multi-line autocommands
function! Highlight_cursor ()
    set cursorline
    redraw
    sleep 1
    set nocursorline
endfunction
function! Autosave ()
   if &modified && g:autosave_on_focus_change
       write
       echo "Autosaved file while you were absent" 
   endif
endfunction

autocmd  FocusGained  *.txt   :call Highlight_cursor()
autocmd  FocusLost    *.txt   :call Autosave() 

" What to do when the user’s attention is elsewhere
autocmd  FocusLost  *.txt   :call Autosave()
autocmd  FocusLost  *.p[ly] :call Checkpoint_sourcecode()
autocmd  FocusLost  *.doc  :call Reformat_current_para()

autocmd BufNewFile * :echoe "BufNewFile"		
autocmd BufReadPre * :echoe "BufReadPre"		
autocmd BufRead * :echoe "BufRead"		
autocmd BufReadPost * :echoe "BufReadPost"		
autocmd BufReadCmd * :echoe "BufReadCmd"		

autocmd FileReadPre * :echoe "FileReadPre"		
autocmd FileReadPost * :echoe "FileReadPost"		
autocmd FileReadCmd * :echoe "FileReadCmd"		

autocmd FilterReadPre * :echoe "FilterReadPre"		
autocmd FilterReadPost * :echoe "FilterReadPost"	

autocmd StdinReadPre * :echoe "StdinReadPre"		
autocmd StdinReadPost * :echoe "StdinReadPost"		

autocmd BufWrite * :echoe "BufWrite"		
autocmd BufWritePre * :echoe "BufWritePre"		
autocmd BufWritePost * :echoe "BufWritePost"		
autocmd BufWriteCmd * :echoe "BufWriteCmd"		

autocmd FileWritePre * :echoe "FileWritePre"		
autocmd FileWritePost * :echoe "FileWritePost"		
autocmd FileWriteCmd * :echoe "FileWriteCmd"		

autocmd FileAppendPre * :echoe "FileAppendPre"		
autocmd FileAppendPost * :echoe "FileAppendPost"	
autocmd FileAppendCmd * :echoe "FileAppendCmd"		

autocmd FilterWritePre * :echoe "FilterWritePre"	
autocmd FilterWritePost * :echoe "FilterWritePost"	

autocmd BufAdd * :echoe "BufAdd"		
autocmd BufCreate * :echoe "BufCreate"		
autocmd BufDelete * :echoe "BufDelete"		
autocmd BufWipeout * :echoe "BufWipeout"		

autocmd BufFilePre * :echoe "BufFilePre"		
autocmd BufFilePost * :echoe "BufFilePost"		

autocmd BufEnter * :echoe "BufEnter"		
autocmd BufLeave * :echoe "BufLeave"		
autocmd BufWinEnter * :echoe "BufWinEnter"		
autocmd BufWinLeave * :echoe "BufWinLeave"		

autocmd BufUnload * :echoe "BufUnload"		
autocmd BufHidden * :echoe "BufHidden"		
autocmd BufNew * :echoe "BufNew"		

autocmd SwapExists * :echoe "SwapExists"		

autocmd FileType * :echoe "FileType"		
autocmd Syntax * :echoe "Syntax"		
autocmd EncodingChanged * :echoe "EncodingChanged"	
autocmd TermChanged * :echoe "TermChanged"		

autocmd VimEnter * :echoe "VimEnter"		
autocmd GUIEnter * :echoe "GUIEnter"		
autocmd TermResponse * :echoe "TermResponse"		

autocmd VimLeavePre * :echoe "VimLeavePre"		
autocmd VimLeave * :echoe "VimLeave"		

autocmd FileChangedShell * :echoe "FileChangedShell"	
autocmd FileChangedShellPost * :echoe "FileChangedShellPost"	
autocmd FileChangedRO * :echoe "FileChangedRO"		

autocmd ShellCmdPost * :echoe "ShellCmdPost"		
autocmd ShellFilterPost * :echoe "ShellFilterPost"	

autocmd FuncUndefined * :echoe "FuncUndefined"		
autocmd SpellFileMissing * :echoe "SpellFileMissing"	
autocmd SourcePre * :echoe "SourcePre"		
autocmd SourceCmd * :echoe "SourceCmd"	 " :source <afile> | echo expand('<afile>')

autocmd VimResized * :echoe "VimResized"		
autocmd FocusGained * :echoe "FocusGained"		
autocmd FocusLost * :echoe "FocusLost"		
autocmd CursorHold * :echoe "CursorHold"		
autocmd CursorHoldI * :echoe "CursorHoldI"		
autocmd CursorMoved * :echoe "CursorMoved"		
autocmd CursorMovedI * :echoe "CursorMovedI"		

autocmd WinEnter * :echoe "WinEnter"		
autocmd WinLeave * :echoe "WinLeave"		
autocmd TabEnter * :echoe "TabEnter"		
autocmd TabLeave * :echoe "TabLeave"		
autocmd CmdwinEnter * :echoe "CmdwinEnter"		
autocmd CmdwinLeave * :echoe "CmdwinLeave"		

autocmd InsertEnter * :echoe "InsertEnter"		
autocmd InsertChange * :echoe "InsertChange"		
autocmd InsertLeave * :echoe "InsertLeave"		

autocmd ColorScheme * :echoe "ColorScheme"		

autocmd RemoteReply * :echoe "RemoteReply"		

autocmd QuickFixCmdPre * :echoe "QuickFixCmdPre"	
autocmd QuickFixCmdPost * :echoe "QuickFixCmdPost"	

autocmd SessionLoadPost * :echoe "SessionLoadPost"	

autocmd MenuPopup * :echoe "MenuPopup"		

autocmd User * :echoe "User"			
