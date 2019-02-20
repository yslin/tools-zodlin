"insert class並且啟用UltiSnips自動補完
call feedkeys("iclass\<C-R>=UltiSnips#ExpandSnippet()\<CR>")
"功能同上,只是用command執行,上面缺點好像不保證與其他指令的執行順訊
execute "normal iclass\<C-R>=UltiSnips#ExpandSnippet()\<CR>"
