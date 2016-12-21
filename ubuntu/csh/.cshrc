setenv LC_CTYPE "zh_TW.UTF-8"
setenv LC_COLLATE "zh_TW.UTF-8"
setenv LC_TIME "zh_TW.UTF-8"
setenv LC_NUMERIC "zh_TW.UTF-8"
setenv LC_MONETARY "zh_TW.UTF-8"
setenv LC_MESSAGES "zh_TW.UTF-8"
setenv LC_ALL zh_TW.UTF-8

#     [1;30m  �`�Ǧ�  
#     [1;31m  �G����  
#     [1;32m  �G���  
#     [1;33m   ����   
#     [1;34m  �G�`��  
#     [1;35m  �G����  
#     [1;36m  �G�L��  
#     [1;37m  �G�զ�  


#set SVCROOT = '~/svc'
#$PATH=$HOME/dd/igor-0.0:$PATH
#�]�wls color
#setenv CLICOLOR
#set color
setenv LSCOLORS ExGxFxdxCxDxDxBxBxExEx
#ls ���C��
setenv LS_COLORS 'di=1;36:ln=0;35:so=0;32:pi=0;33:ex=0;32:bd=0;33;46:cd=0;36;43'
#autolist���C��
#set prompt=" [5mbsd1[0m [/u/gcs/95/9555545] -yslin- "
#�t�κ޲z�̥i�� root �P�@��ϥΪ̪����ܦr�����ҰϧO 
#set prompt="%B[%n@%m %/]>" 
if ($?prompt) then
# set prompt="%{^[[1;34m%}%T%{^[[m%} %{^[[1;31m%}%n%{^[[1;33m%}@%{^[[1;32m%}%m %{^[[1;32m%}[%~]%{^[[m%} >"
	set prompt="%B[%n@%m ]>" 
	if ($?tcsh) then
    set mail = (/var/mail/$USER)
    bindkey "^W" backward-delete-word
    bindkey -k up history-search-backward
    bindkey -k down history-search-forward
		#FreeBSD �� tcsh �� history search backward ���\��O�]���b ~/.cshrc �����G��G  
		#�p�G�z���Q�ϥ� history search backware�A�u�n�N�ӤG��R���Y�i�C
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
#�o���ܼƬO�ΨӨϺ�T���ɮשΩR�O�Q�X�i(tab��),�Ӥ��o�Xĵ�i�n�C
set autolist
#�p�G�n����U Tab ��ܥX�i�Ϊ����O,��^D�]�i�H���P�˥\�� 
#set autocorrect 
#tcsh�|�ھڥi�ા�ɮ׸��|,���A�󥿥i�઺���~
#set correct = all 
#set notify 
set matchbeep = never 
#�o���ܼƬO�Ψӱ����ɵo�Xĵ�i�n,�]�N�O"�G"���@�n
#nomatch:����X�ŦX���ɮשΩR�O��,�o�Xĵ�i�n
#ambiguous:���ܦh�ɮשΩR�O�ŦX��,�o�Xĵ�i�n
#notunique:���@��T�ŦX,���٦���L�����B�ŦX���ɦW�ΩR�O��,�o�Xĵ�i�n
#never:�L�צb���󱡪p�����o�Xĵ�i�n
set autoexpand
#�ھڨϥΪ�key�J���r��,�۰ʰѦ�history list���R�O,�M��ñN���X�i���Ĥ@�ӲŦX���R�O
set ignoreeof 
set noclobber
set history = 100
#�Y�b .cshrc �� .tcshrc ���� set history , �h�|�b .history����ܥX�L�h�Ұ��L���Ʊ�
