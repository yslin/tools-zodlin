setenv LC_CTYPE "zh_TW.UTF-8"
setenv LC_COLLATE "zh_TW.UTF-8"
setenv LC_TIME "zh_TW.UTF-8"
setenv LC_NUMERIC "zh_TW.UTF-8"
setenv LC_MONETARY "zh_TW.UTF-8"
setenv LC_MESSAGES "zh_TW.UTF-8"
setenv LC_ALL zh_TW.UTF-8

#     [1;30m  深灰色  
#     [1;31m  亮紅色  
#     [1;32m  亮綠色  
#     [1;33m   黃色   
#     [1;34m  亮深藍  
#     [1;35m  亮紫色  
#     [1;36m  亮淺藍  
#     [1;37m  亮白色  


#set SVCROOT = '~/svc'
#$PATH=$HOME/dd/igor-0.0:$PATH
#設定ls color
#setenv CLICOLOR
#set color
setenv LSCOLORS ExGxFxdxCxDxDxBxBxExEx
#ls 的顏色
setenv LS_COLORS 'di=1;36:ln=0;35:so=0;32:pi=0;33:ex=0;32:bd=0;33;46:cd=0;36;43'
#autolist的顏色
#set prompt=" [5mbsd1[0m [/u/gcs/95/9555545] -yslin- "
#系統管理者可讓 root 與一般使用者的提示字元有所區別 
#set prompt="%B[%n@%m %/]>" 
if ($?prompt) then
# set prompt="%{^[[1;34m%}%T%{^[[m%} %{^[[1;31m%}%n%{^[[1;33m%}@%{^[[1;32m%}%m %{^[[1;32m%}[%~]%{^[[m%} >"
	set prompt="%B[%n@%m ]>" 
	if ($?tcsh) then
    set mail = (/var/mail/$USER)
    bindkey "^W" backward-delete-word
    bindkey -k up history-search-backward
    bindkey -k down history-search-forward
		#FreeBSD 的 tcsh 有 history search backward 的功能是因為在 ~/.cshrc 中有二行：  
		#如果您不想使用 history search backware，只要將該二行刪除即可。
  endif
endif 


#  set prompt="%{^[[1;31m%}%n%{^[[1;33m%}@%{^[[1;32m%}%m %{^[[1;32m%}[%~]%{^[[m%} >"


#set prompt="%{[[1;32m%}`uname`-%{[[1;37m%}`whoami`%{[[1;33m%}@%{[[1;31m%}`hostname -s`%{[[1;36m%}[%/]%{[[0m%}%"

#compiler or interpreter 
alias r ruby

alias make gmake
alias ls    ls -FGa 
alias dir 	ls -al
alias rm    rm -i 
alias cp    cp -i 
alias mv    mv -i 
#alias vi    'env LC_CTYPE=en_US.ISO8859-1 vim' 
#alias vim   'env LC_CTYPE=zh_TW.Big5 vim' 
#alias mutt  'env LC_CTYPE=zh_TW.Big5 mutt' 

#setenv LSCOLORS exfxcxdxbxegedabagacad 
#setenv ENABLE_STARTUP_LOCALE zh_TW.Big5 
#setenv LC_CTYPE en_US.ISO8859-1 
#setenv PACKAGEROOT ftp://ftp.tw.freebsd.org 

if ($term == "xterm" || $term == "vt100" \
		|| $term == "vt102" || $term !~ "con*") then
# bind keypad keys for console, vt100, vt102, xterm
bindkey "\e[1~" beginning-of-line  # Home
bindkey "\e[7~" beginning-of-line  # Home rxvt
bindkey "\e[2~" overwrite-mode     # Ins
bindkey "\e[3~" delete-char        # Delete
bindkey "\e[4~" end-of-line        # End
bindkey "\e[8~" end-of-line        # End rxvt
endif


#if ( $tty =~ ttyp* ) then 
#    setenv LANG zh_TW.Big5 
#else 
#    unsetenv LANG 
#endif 

#if ( $tty =~ ttyv* ) then 
#    setenv  TERM    cons25 
#else 
#    setenv  TERM    xterm-color 
#endif 

#if ( ! $?WINDOW ) then 
#    if ( $USER == root ) then 
#        set prompt="%B[%n@%m %/]# " 
#    else 
#        set prompt="%B[%n@%m %/]> " 
#    endif 
#else 
#    set prompt = "%n@%m[%/]($WINDOW) " 
#endif 

#set color
#set colorcat


set recexact 
#這個變數是用來使精確的檔案或命令被擴展(tab鍵),而不發出警告聲。
set autolist
#如果要按兩下 Tab 顯示出可用的指令,用^D也可以有同樣功能 
#set autocorrect 
#tcsh會根據可能知檔案路徑,替你更正可能的錯誤
#set correct = all 
#set notify 
set matchbeep = never 
#這個變數是用來控制何時發出警告聲,也就是"逼"的一聲
#nomatch:為找出符合的檔案或命令時,發出警告聲
#ambiguous:有很多檔案或命令符合時,發出警告聲
#notunique:找到一精確符合,但還有其他較長且符合的檔名或命令時,發出警告聲
#never:無論在任何情況都不發出警告聲
set autoexpand
#根據使用者key入的字元,自動參考history list的命令,尋找並將其擴展成第一個符合的命令
set ignoreeof 
set noclobber
set history = 100
#若在 .cshrc 或 .tcshrc 中有 set history , 則會在 .history中顯示出過去所做過的事情
