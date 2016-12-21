setenv LC_CTYPE "zh_TW.UTF-8"
setenv LC_COLLATE "zh_TW.UTF-8"
setenv LC_TIME "zh_TW.UTF-8"
setenv LC_NUMERIC "zh_TW.UTF-8"
setenv LC_MONETARY "zh_TW.UTF-8"
setenv LC_MESSAGES "zh_TW.UTF-8"
setenv LC_ALL zh_TW.UTF-8

#     [1;30m  ²`¦Ç¦â  
#     [1;31m  «G¬õ¦â  
#     [1;32m  «Gºñ¦â  
#     [1;33m   ¶À¦â   
#     [1;34m  «G²`ÂÅ  
#     [1;35m  «Gµµ¦â  
#     [1;36m  «G²LÂÅ  
#     [1;37m  «G¥Õ¦â  


#set SVCROOT = '~/svc'
#$PATH=$HOME/dd/igor-0.0:$PATH
#³]©wls color
#setenv CLICOLOR
#set color
setenv LSCOLORS ExGxFxdxCxDxDxBxBxExEx
#ls ªºÃC¦â
setenv LS_COLORS 'di=1;36:ln=0;35:so=0;32:pi=0;33:ex=0;32:bd=0;33;46:cd=0;36;43'
#autolistªºÃC¦â
#set prompt=" [5mbsd1[0m [/u/gcs/95/9555545] -yslin- "
#¨t²ÎºÞ²zªÌ¥iÅý root »P¤@¯ë¨Ï¥ÎªÌªº´£¥Ü¦r¤¸¦³©Ò°Ï§O 
#set prompt="%B[%n@%m %/]>" 
if ($?prompt) then
# set prompt="%{^[[1;34m%}%T%{^[[m%} %{^[[1;31m%}%n%{^[[1;33m%}@%{^[[1;32m%}%m %{^[[1;32m%}[%~]%{^[[m%} >"
	set prompt="%B[%n@%m ]>" 
	if ($?tcsh) then
    set mail = (/var/mail/$USER)
    bindkey "^W" backward-delete-word
    bindkey -k up history-search-backward
    bindkey -k down history-search-forward
		#FreeBSD ªº tcsh ¦³ history search backward ªº¥\¯à¬O¦]¬°¦b ~/.cshrc ¤¤¦³¤G¦æ¡G  
		#¦pªG±z¤£·Q¨Ï¥Î history search backware¡A¥u­n±N¸Ó¤G¦æ§R°£§Y¥i¡C
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
#³o­ÓÅÜ¼Æ¬O¥Î¨Ó¨Ïºë½TªºÀÉ®×©Î©R¥O³QÂX®i(tabÁä),¦Ó¤£µo¥XÄµ§iÁn¡C
set autolist
#¦pªG­n«ö¨â¤U Tab Åã¥Ü¥X¥i¥Îªº«ü¥O,¥Î^D¤]¥i¥H¦³¦P¼Ë¥\¯à 
#set autocorrect 
#tcsh·|®Ú¾Ú¥i¯àª¾ÀÉ®×¸ô®|,´À§A§ó¥¿¥i¯àªº¿ù»~
#set correct = all 
#set notify 
set matchbeep = never 
#³o­ÓÅÜ¼Æ¬O¥Î¨Ó±±¨î¦ó®Éµo¥XÄµ§iÁn,¤]´N¬O"¹G"ªº¤@Án
#nomatch:¬°§ä¥X²Å¦XªºÀÉ®×©Î©R¥O®É,µo¥XÄµ§iÁn
#ambiguous:¦³«Ü¦hÀÉ®×©Î©R¥O²Å¦X®É,µo¥XÄµ§iÁn
#notunique:§ä¨ì¤@ºë½T²Å¦X,¦ýÁÙ¦³¨ä¥L¸ûªø¥B²Å¦XªºÀÉ¦W©Î©R¥O®É,µo¥XÄµ§iÁn
#never:µL½×¦b¥ô¦ó±¡ªp³£¤£µo¥XÄµ§iÁn
set autoexpand
#®Ú¾Ú¨Ï¥ÎªÌkey¤Jªº¦r¤¸,¦Û°Ê°Ñ¦Òhistory listªº©R¥O,´M§ä¨Ã±N¨äÂX®i¦¨²Ä¤@­Ó²Å¦Xªº©R¥O
set ignoreeof 
set noclobber
set history = 100
#­Y¦b .cshrc ©Î .tcshrc ¤¤¦³ set history , «h·|¦b .history¤¤Åã¥Ü¥X¹L¥h©Ò°µ¹Lªº¨Æ±¡
