# todo: all function/alias/command follows the steps:
# 1. myfunction -h like man
# 2. easy use and show how to use it

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias ptt='ssh -2 bbs@ptt.cc'
    alias vmore='vim -u ~/.vimpagerrc -'
    alias svnrevertdir="svn st | grep 'D   ' | cut -d ' ' -f 8 | xargs -i svn revert {}"
    alias javal='java -cp ~/lib/*:. '
    alias javalc='javac -cp ~/lib/*:. '
    alias bashd='bash -x'
    alias gitupdate='git ls-files -d | xargs git checkout --'
    alias cqual='src/cqual -config config/lattice '
    alias cqual1='src/cqual -config config/lattice examples/taint1.c'
    alias sublime_text='/home/zod/code/game/SublimeText2/sublime_text'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# quick change directory to parent
alias ..='cd ..'
alias .1='cd ..'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .-='cd -'
alias cd-='cd -'

# add new file to svn by ?
alias svnaddNewFiles='svn st | grep "?" | awk "{ print \$2 }" | xargs -i svn add {}'
alias svnrmOldFiles='svn st | grep "!" | awk "{ print \$2 }" | xargs -i svn rm {}'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias apktool='java -jar /home/zod/code/apktool/apktool_2.0.0rc4.jar'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Delete Alias
# unalias {alias_name}

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# all priviledge command 
if [ -f ~/.zod_bashrc ]; then
    . ~/.zod_bashrc
fi

# HOWTO Log Bash History to Syslog - 將 Bash history 寫入 Syslog, 只要於 .bashrc 寫入下述即可.
# PROMPT_COMMAND='history -a >(logger -t "$USER[$$] $SSH_CONNECTION")'



#man 5 terminfo
#可以顯示目前的term
#infocmp
#裏面有所有現在的term種類 
#/lib/terminfo

#To use the vmxnet driver, restart networking using the following commands: 
#/etc/init.d/networking stop
#rmmod pcnet32
#rmmod vmxnet
#modprobe vmxnet
#/etc/init.d/networking start

#特殊符號檔案-1,使用兩個-號加上空白就可以打特殊符號來處理
#mv -- -1

#getconf LONG_BIT , 看你output事32還是64摟..
#只是顯示你的編譯環境
#uname -m
#i686 ==> 32bit
#amd64 ==> 64 bit

#==============================================================================
# export環境變數
#==============================================================================
export PATH=$PATH:~/bin:/var/lib/gems/1.8/bin:/home/zod/下載/genymotion
ANDROID_SDK_PATH1=$HOME"/Desktop/android-sdk-linux_86"
export PATH=$PATH:$ANDROID_SDK_PATH1/platform-tools:$ANDROID_SDK_PATH1/tools
ANDROID_SDK_PATH2=$HOME"/Document/developer/adt-bundle-linux-x86_64-20140702/sdk"
export PATH=$PATH:$ANDROID_SDK_PATH2/platform-tools:$ANDROID_SDK_PATH2/tools
ECLIPSE_PATH=$HOME"/Document/eclipse"
export PATH=$PATH:$ECLIPSE_PATH
ANDROID_STUDIO_PATH=$HOME"/software/android-studio/bin"
export PATH=$PATH:$ANDROID_STUDIO_PATH
JAVA_SDK=$HOME"/software/jdk1.8.0_45/bin"
export PATH=$PATH:$JAVA_SDK

#java.awt.Headlessexception
#NO X11 display variable was set, but this program performed an operation which requires it.
DISPLAY=:0.0
export DISPLAY

#cd /home/yslin/svn/yslinperlexample/screenResumer

#==============================================================================
# bash 設定
#==============================================================================
#輸入部份指令, 然後按下Up鍵就會出現以前輸入過的指令，並且游標之前開頭的幾個字不變。 
#再按Up鍵，就會出現更早輸入的指令。 
bind '"\x1b\x5b\x41":history-search-backward' 
#如果按Down鍵，就會出現較晚輸入過的指令。
bind '"\x1b\x5b\x42":history-search-forward' 
#設定操作模式為vim,預設為emacs (man readline to see key binding)
#set -o vi

#   1. Bash命令行的编辑模式：
#   	（1）有两种：emacs模式、vi模式。EMACS=Esc+Meta+Alt+Control+Shift，VI=Visual+Interface。
#   	（2）emacs模式是默认的。
#   	（3）可以在选项中查看、修改输入模式：命令set -o查看，命令set -o vi/emacs修改。
#   2. emacs模式的热键操作：
#   	（1）对于字符（ctrl）：
#   			前移一个字符：ctrl+f
#   			后移一个字符：ctrl+b
#   			删除前一字符：ctrl+h
#   			删除后一字符：ctrl+d
#   	（2）对于单词（esc）：
#   			前移一个单词：esc+f
#   			后移一个单词：esc+b
#   			删除前一单词：esc+ctrl+h，或ctrl+w
#   			删除后一单词：esc+d
#   			恢复最后删除的项：ctrl+y
#   	（3）对于行（ctrl）：
#   		   移到行首：ctrl+a
#   		   移到行尾：ctrl+e
#   		   从光标所在删除直到行首：ctrl+u
#   		   从光标所在删除直到行尾：ctrl+k
#   		   移到前一行：ctrl+p
#   		   移到后一行：ctrl+n
#   	（4）对于历史文件（esc）：
#   		   移动到历史文件的首行：esc+<
#   		   移动到历史文件的末行：esc+>
#   		   在历史文件中反向搜索：ctrl+r
#       （5）編輯
#              ctrl-w	 Cut the last word
#              ctrl-u	 Cut everything before the cursor 
#              ctrl-k	 Cut everything after the cursor
#              ctrl-y	 Paste the last thing to be cut
#              ctrl-_	 Undo
#   3. 命令行补齐：
#   	（1）通用热键：
#   		   试图补齐命令行：tab
#   		   列出所有可能的备选项：esc+?
#   	（2）补齐文件名（/）：
#   		   试图补齐文件名：esc+/
#   		   列出所有备选文件名：ctrl+x+/
#   	（3）补齐用户名（~）：
#   			试图补齐用户名：esc+~
#   			列出所有备选用户名：ctrl+x+~
#   	（4）补齐主机名（@）：
#   			试图补齐主机名：esc+@
#   			列出所有备选主机名：ctrl+x+@
#   	（5）补齐内置变量（$）：
#   			试图补齐变量名：esc+$
#   			列出所有备选变量名：ctrl+x+$
#   	（6）补齐命令名（!）：
#   			试图补齐命令名：esc+!
#   			列出所有备选命令名：ctrl+x+!
#   	（7）补齐历史列表中的命令名：esc+tab
#   4. 杂项命令：
#   	（1）清屏：ctrl+l
#   	（2）反转光标所在字符及其前面的字符：ctrl+t
#   	（3）从光标处开始的整个单词大写：esc+u
#   	（4）从光标处开始的整个单词小写：esc+l
#   	（5）将光标处的单词的首字母大写：esc+c

#core dump產生的名稱來源,檢查是否有導向/dev/null
#/proc/sys/kernel/core_pattern
#設定產生core dump檔案
ulimit -c unlimited
#==============================================================================
# svn專用設定
#==============================================================================
#設定svn commit message的editor
export SVN_EDITOR=`which vim`
#設定crontab -e的editor
export EDITOR=`which vim`

#export LANG="zh_TW.Big5"

#==============================================================================
# screen專用設定
#==============================================================================
# Set the title of a Terminal window
#screen -X eval will execute each of its arguments in the current screen. 
#The command at \# title will execute the title command in all the windows 
#(the \ before # is required otherwise # will be interpreted as the beginning of a comment).
#The shelltitle command will ensure that any newly created windows use this title.
function settitle() {
if [ -n "$STY" ] ; then         # We are in a screen session
	echo "Setting screen titles to $@"
	printf "\033k%s\033\\" "$@"
	screen -X eval "at \\# title $@" "shelltitle $@"
else
	printf "\033]0;%s\007" "$@"
fi
}


#==============================================================================
# 我個人常用指令說明
#==============================================================================
cmd_name_padding=12

function yshelp() {
    ysversioncontrol
    ysinstall
	ysmaninfo
	yssearch
	ystable 
	ysbootashell
	ysprocess
	ysfilesystem
	yssched
	ysfilter 
	ysinout
    yscompress

	ysaddnewuser
	ysstorage
	ysnetwork
    ysweb

    ysterminal

    yslog
}
#==============================================================================
# Add new
#==============================================================================
ys__cmds=(
)
function ys() {
	echo "===storage commands==="
	for ((i=0; i<${#ys_[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_[$i*2]}" "${ys_[$i*2+1]}"
	done
}

#==============================================================================
# Add new
#==============================================================================
ys_log_cmds=(
logger     "a shell command interface to the syslog(3) system log module"
logwatch   "system log analyzer and reporter, notify via email"
dmesg      "print or control the kernel ring buffer"
)
function yslog() {
	echo "===log commands==="
	for ((i=0; i<${#ys_log_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_log_cmds[$i*2]}" "${ys_log_cmds[$i*2+1]}"
	done
}

#==============================================================================
# Version control 
#==============================================================================
ys_versioncontrol_cmds=(
svn up       ""
git          ""
hg pull -u   "svn update"
)
function ysversioncontrol() {
	echo "===version control commands==="
	for ((i=0; i<${#ys_versioncontrol_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_versioncontrol_cmds[$i*2]}" "${ys_versioncontrol_cmds[$i*2+1]}"
	done
}

#==============================================================================
# Install software/package
#==============================================================================
ys_install_cmds=(
"apt-get update"                "update package list"
"apt-cache search elvis\|vim"   "search the packages you've downloaded, using REGEX"
"apt-cache show postgresql"     "see the description of a package"
"dpkg -l"                       "lists all INSTALLED packages"
"dpkg -l \*"                    "list all packages"
"dpkg -l '*'"                   "list all packages"
"dpkg -l \*postgres\*"          "shows the status of packages matching that GLOB (it's not a regular expression [REGEX])"
"dpkg -l '*postgres*'"          "shows the status of packages matching that GLOB (it's not a regular expression [REGEX])"
"debtree"                       "package dependency graphs on steroids"
#Create a .dot file
#$ debtree --with-suggests <package> >out.dot
#Create a graph (PNG) from a .dot file
#$ dot -T png -o out.png out.dot
#Create a graph (Postscript) and view it using kghostview
#$ debtree <package> | dot -Tps | kghostview - &
)
function ysinstall() {
	echo "===install commands==="
	for ((i=0; i<${#ys_install_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_install_cmds[$i*2]}" "${ys_install_cmds[$i*2+1]}"
	done
}

#==============================================================================
# Terminal Setting commands
#==============================================================================
ys_terminal_cmds=(
stty  "change and print terminal line settings"
screen "screen "
Tmux "another screen"
)
function ysterminal() {
	echo "===terminal setting commands==="
	for ((i=0; i<${#ys_terminal_cmds[@]}/2; i++)); do    
		printf "%${cmd_name_padding}s: %s \n" "${ys_terminal_cmds[$i*2]}" "${ys_terminal_cmds[$i*2+1]}"
	done
}

#==============================================================================
# Search/Execute commands
#==============================================================================
ys_search_cmds=(
type 		""
find 		""
which 		""
whereis 	""
locate 		""
xargs       "build and execute command lines from standard input"
)
function yssearch() {
	echo "===search commands==="
	for ((i=0; i<${#ys_search_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_search_cmds[$i*2]}" "${ys_search_cmds[$i*2+1]}"
	done
}

#==============================================================================
# Network commands
#==============================================================================
ys_network_cmds=(
ifconfig 			""
ifup 				"bring a network interface up"
ifdown 				"take a network interface down"
netstat 			""
route 				""
arp 				""

dhcp3-server 		""
dhclient 			""

ethtool 			""

sysctl 				"configure kernel parameters at runtime"
/etc/sysctl.conf 	""


/etc/hosts 			""
/etc/resolv.conf 	""
/etc/hostname and 			""
/etc/network/interfaces  	""
/etc/network/options 		""
/proc/sys/net/ipv4 			""
 ├conf/default 				""
 └neigh/default 			""
/proc/sys/net 				""
)
function ysnetwork() {
	echo "===network commands==="
	for ((i=0; i<${#ys_network_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_network_cmds[$i*2]}" "${ys_network_cmds[$i*2+1]}"
	done
}


#==============================================================================
# Add web 
#==============================================================================
ys_web_cmds=(
mysqladmin -u root -p password   "修改帳號密碼"
dpkg-reconfigure phpmyadmin      "重設phpmyadmin"
)
function ysweb() {
	echo "===web commands==="
	for ((i=0; i<${#ys_web_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_web_cmds[$i*2]}" "${ys_web_cmds[$i*2+1]}"
	done
}

#==============================================================================
# Add new storage
#==============================================================================
ys_storage_cmds=(
cfdisk				""
fdisk				""
sfdisk				""
parted				""
gparted				""
hdparm				""
dd					""
shred				""
mdadm				""

pvcreate			""
pvdisplay			""
pvchange			""
pvck				""
vgcreate			""
vgchange			""
vgextend			""
vgdisplay			""
vgck				""
vgscan				""
lvcreate 			""
lvchange			""
lvresize 			""
lvdisplay			""

resize2fs 			""
e2fsck 				""
fsck 				""


tune2fs 			""
mkfs 				""

quota 				""

zfs 				""
sharenfs			""
sharesmb			""
sharemgr			""
share				""
unshare				""

iscsiadm			""



/etc/fstab 			""
/proc/mdstat 		""
)
function ysstorage() {
	echo "===storage commands==="
	for ((i=0; i<${#ys_storage_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_storage_cmds[$i*2]}" "${ys_storage_cmds[$i*2+1]}"
	done
}
#sudo pvcreate /dev/sdc1 # Prepare for use w/LVM
#sudo vgcreate vgname /dev/sdc1 # Create volume group
#sudo lvcreate -l 100%FREE -n volname vgname # Create logical volume
#sudo mkfs -t ext4 /dev/vgname/volname # Create filesystem
#sudo mkdir mountpoint # Create mount point
#sudo vi /etc/fstab # Set mount opts, mntpoint
#sudo mount mountpoint to mount the filesystem.

#sudo hdparm --user-master u --security-set-pass password /dev/sda8
#sudo hdparm --user-master u --security-erase password /dev/sda
#sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1



#==============================================================================
# Add new users
#==============================================================================
ys_addnewuser_cmds=(
useradd 		""
userdel      	""
usermod			""
groupadd   		""
groupdel    	""
groupmod 		""

newusers 		""
deluser 		""
newgrp 			""
delgroup  		""



users-admin 	"GTK"

vipw 			""

users 			""
groups 			""
"crypt(3)" 		"DES/MD5..."

chsh 			""
chfn 			""


/etc/passwd 	"user id/name list"
/etc/shadow 	"shadowed password file"
/etc/login.defs "passwd crypt"
/etc/default/useradd ""
/etc/adduser.con  ""
/etc/group      "group id/name list"
/etc/gshadow 	""
)
function ysaddnewuser() {
	echo "===boot a shell commands==="
	for ((i=0; i<${#ys_addnewuser_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_addnewuser_cmds[$i*2]}" "${ys_addnewuser_cmds[$i*2+1]}"
	done
}





#==============================================================================
# Manual/Info Commands 
#==============================================================================
ys_help_cmds=(
whatis  ""
man 	""
info 	""
help 	""
)
function ysmaninfo() {
	echo "===man/info commands==="
	for ((i=0; i<${#ys_help_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_help_cmds[$i*2]}" "${ys_help_cmds[$i*2+1]}"
	done
}


#==============================================================================
# Table File
#==============================================================================
ys_table_files=(
/etc/inittab 	"startup script"
/etc/rcN.d 		"startup script"
/etc/group      "group id/name list"
/etc/passwd 	"user id/name list"
/etc/shadow 	"shadowed password file"
/etc/sudoers 	"list of which users may execute what"
/etc/fstab    	"static information about the filesystems"
/etc/hosts 			""
/etc/resolv.conf 	""
/etc/hostname and 			""
/etc/network/interfaces  	""
/etc/network/options 		""
/proc/sys/net/ipv4 			""
/etc/sysctl.conf 	""
)
function ystable() {
	echo "===table files==="
	for ((i=0; i<${#ys_table_files[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_table_files[$i*2]}" "${ys_table_files[$i*2+1]}"
	done
}



#==============================================================================
# Recovery boot to a shell commands -shutdonw/telinit
#==============================================================================
ys_bootashell_cmds=(
shutdown  		"bring the system down"
telinit 		"change system runlevel"
halt 			"reboot or stop the system"
reboot 			"reboot or stop the system"
poweroff 		"reboot or stop the system"
/etc/inittab 	"startup script"
/etc/rcN.d 		"startup script"
)
function ysbootashell() {
	echo "===boot a shell commands==="
	for ((i=0; i<${#ys_bootashell_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_bootashell_cmds[$i*2]}" "${ys_bootashell_cmds[$i*2+1]}"
	done
}


#==============================================================================
# process handle commands
#==============================================================================
ys_process_cmds=(
kill   		"send a signal to a process"
pkill 		""
killall 	"kill processes by name"

ps 			"report a snapshot of the current processes"
procinfo  	"display system statistics gathered from /proc"
top 		"display Linux tasks"
uptime  	"tell how long the system has been running"
w 			""
finger 		""
lsof 		""
users 		""

nice 		"run a program with modified scheduling priority"
renice 		"alter priority of running processes"

vmstat 		"report virtual memory statistics"
free 		"display amount of free and used memory in the system"
iostat  	"report Central Processing Unit (CPU) statistics and input/output statistics for devices," 
""    		"partitions and network filesys‐tems (NFS)"
sar  		"collect, report, or save system activity information"
mpstat  	"report processors related statistics"

strace 		"trace system calls and signals"
ltrace 		"a library call tracer"
pstrace 	""
pstree      "display a tree of processes"
/proc 		""
)
function ysprocess() {
	echo "===Scheduler commands==="
	for ((i=0; i<${#ys_process_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_process_cmds[$i*2]}" "${ys_process_cmds[$i*2+1]}"
	done
}


#==============================================================================
# file system commands
#==============================================================================
ys_file_system_cmds=(
mknod					""
ln						""
"socket(2)"				""
cp						""
mv 					    ""
rename 				    ""
rm						""
rmdir					""
mkdir					""
chmod					""
chown					""
chgrp					""
chattr					"change file attributes on a Linux file system"
umask					""

rdiff-backup            "sudo apt-get install rdiff-backup"

mount					""
umount					""
iscsid                  "mount for nas through tcp"

df						"report file system disk space usage"
du						"estimate file space usage"
lsof					""
lsattr                  "list file attributes on a Linux second extended file system"
fuser					""
tree                    "list contents of directories in a tree-like format."

fsck					""
modinfo                 "program to show information about a Linux Kernel module. ex: modinfo cifs"

"hier(7)"				"description of the file system hierarchy"
/etc/fstab				"static information about the filesystems"
)

function ysfilesystem() {
	echo "===Scheduler commands==="
	for ((i=0; i<${#ys_file_system_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_file_system_cmds[$i*2]}" "${ys_file_system_cmds[$i*2+1]}"
	done
}
#==============================================================================
# substitute user identity commands
#==============================================================================
ys_suid_cmds=(
su 				"change user ID or become superuser"
sudo 			"execute a command as another user"
visudo 			"edit the sudoers file"
/etc/sudoers 	"list of which users may execute what"
root            "how to disalbe?"
/etc/shadow     "Set with a star so that their accounts cannot be logged in to"
/bin/false      "Set their shells to this or next line" 
/bin/nologin    "Protect against remote login (SSH)"
)
function yssuid() {
	echo "===Scheduler commands==="
	for ((i=0; i<${#ys_suid_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_suid_cmds[$i*2]}" "${ys_suid_cmds[$i*2+1]}"
	done
}

#==============================================================================
# Scheduler commands
#==============================================================================
ys_sched_cmds=(
at            "executes commands at a specified time"
crontab       "maintain crontab files for individual users"
/etc/init.d   "Startup scripts"
/etc/rcN.d    "N:0, 1, 2, ..."
)
function yssched() {
	echo "===Scheduler commands==="
	for ((i=0; i<${#ys_sched_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_sched_cmds[$i*2]}" "${ys_sched_cmds[$i*2+1]}"
	done
}
#==============================================================================
# Common filter commands
#==============================================================================
ys_filter_cmds=(
join    "join lines of two files on a common field"
cat     "concatenate files and print on the standard output.  -n number all output lines"
cut  	"separate lines into fields"
sort 	"sort lines"
uniq 	"(unique)print unique lines"
wc 		"count lines, words, and characters"
tee 	"copy input to two places"
head  	"read the beginning of a file"
tail 	"read the end of a file"
grep 	"search text"
#比較檔案
diff    "compare files line by line"
comm    "compare two sorted files line by line"
#perl -pe 可以替換掉下面的舊的程式
sed 	"[old filter]stream editor for filtering and transforming text"
awk 	"[old filter]pattern scanning and text processing language"
tr  	"[old filter](transliterate)translate or delete characters"

)
#ys_filter_cmds=( "${ys_filter_cmds[@]}" "upi jfo joif" )
function ysfilter() {
	echo "===filter commands==="
	for ((i=0; i<${#ys_filter_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_filter_cmds[$i*2]}" "${ys_filter_cmds[$i*2+1]}"
	done

}

#==============================================================================
# input/output commands
#==============================================================================
ys_inout_cmds=(
line    "read one line"
read  	"read from the standard input or from the file descriptor fd"
echo 	"display a line of text"
printf 	"format and print data")
function ysinout() {
	echo "===input/output commands==="
	for ((i=0; i<${#ys_inout_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_inout_cmds[$i*2]}" "${ys_inout_cmds[$i*2+1]}"
	done
}

#==============================================================================
# compress/uncompress commands
#==============================================================================
ys_compress_cmds=(
tar      "The GNU version of the tar archiving utility"
tar      "Example:\n產生tgz並傳送到遠端Server.\ntar czvhf – /local/dir | ssh ssh_user@remote_host \"cat > /dest/dir/filename.tgz\""
gzip     "compress files"
gunzip   "expand files"
zcat     "cat compress files"
)
function yscompress() {
	echo "===compress/uncompress commands==="
	for ((i=0; i<${#ys_compress_cmds[@]}/2; i++)); do    #請注意 ((   )) 雙層括號
		printf "%${cmd_name_padding}s: %s \n" "${ys_compress_cmds[$i*2]}" "${ys_compress_cmds[$i*2+1]}"
	done
}

    
#==============================================================================
# 自訂指令
#==============================================================================
function rmctrlm(){
    sed "s/$//g" $1 > $$Temp
    mv $$Temp $1.remove
}
