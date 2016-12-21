#!/bin/bash
#========================================================================
# Author: YSLin
# Email: 
# File Name: install.sh
# Description: 
#    link all rc file to your home directory.
# To-Do:
#    改成會先檢查原本是否有這些檔案,並且詢問是否備份和覆蓋
# Edit History: 
#   2010-10-27    File created.
#========================================================================

#
# @param $1 link $PWD/$1 file to $HOME/
#
function linkFile(){
    dir=`dirname $1`
    name=`basename $1`
	src=$PWD/$1
	dst=$HOME/$name
	if [ -e $dst ] ; then
		if ! [ $src -ef $dst ] ; then
			DATE=`date +'%Y.%m.%d.%H.%M.%S'`
            #TODO read input to decide action
			#printf "$1 exist ([O]verwrite/[R]ename/[M]ove) ? "
			printf "move original $dst to $dst.$DATE"
            mv $dst $dst.$DATE
            echo "link $src to $dst"
            ln -s $src $dst
        fi
    else
        if [ -L $dst ] ; then
            echo "$dst is symbolic link, unlink now"
            unlink $dst
        fi
        echo "link $src to $dst"
        ln -s $src $dst
    fi
}

#
# Create dir if it doesn't exist
#
function checkDir(){     
    fullname=$1     
    dir=`dirname $fullname`     
    if ! [ $dir = "." ]; then
        dst=$HOME/$dir
        if ! [ -d $dst ]; then
            echo "Create " . $HOME/$dir
            mkdir -p $dst
        fi  
    fi  
}   

File=(
vim/.vimrc
vim/.vim
#.bashrc
#.inputrc
#.screenrc
#.vimpagerrc
#.tmux.conf
#ubuntu/ubuntu_install.sh
#.ctags
)

for f in ${File[@]}
do
#    checkDir $f
    linkFile $f
done
