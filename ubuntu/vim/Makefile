#
# Makefile for the Vim documentation on Unix
#
#用autoconf來產生makefile??需要所有的檔案名稱
#將所有檔案目錄放到這邊,然後做doctags
cexample = "${HOME}/test/"      
file=`find ${cexample}  -type f | grep -v "\.svn" `    
#設定所有我的目錄下檔案都放在這邊產生tags
DOCS = ${file}
VIMTAGS = $(HOME)/.vim/doc/tags
.SUFFIXES:
.SUFFIXES: .c .o .txt .html

all: tags 

# Use "doctags" to generate the tags file.  Only works for English!
#tags: doctags $(DOCS)  因為改成用指令尋找,所以沒辦法再這做相依性
tags: doctags 
	./doctags $(DOCS) | LANG=C LC_ALL=C sort >tags
	uniq -d -2 tags
	#因為只能讀取~/.vim/doc/tags來用做:h topic<Ctrl-d>,所以將產生的tags附加.vim/doc/tags中
	cat tags >> $(VIMTAGS)
	uniq -d -2 $(VIMTAGS)

doctags: doctags.c
	$(CC) doctags.c -o doctags

