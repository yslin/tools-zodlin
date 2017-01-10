" 注意{pat}要使用'',而非"",可以少用一個\
" 4
echo match("let testing function", '\c\<\(\Vtest\)\k\+')
" 4
echo match("let testing function", "\\c\\<\\(\\Vtest\\)\\k\\+")
" ing
echo matchstr("testing", '\k\+', 4)
" 1
echo match([1, 'x'], '\a')
