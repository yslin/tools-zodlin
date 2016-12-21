" Write writefile.vim to file writefile.vim_{backup_count}
func! SaveBackup ()
    let b:backup_count = exists('b:backup_count') ? b:backup_count+1 : 1
    return writefile(getline(1,'$'), bufname('%') . '_' . b:backup_count)
endf

echo SaveBackup()
