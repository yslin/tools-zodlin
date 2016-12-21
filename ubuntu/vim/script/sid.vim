" Trick to get the current script ID
function! s:SID1()
    map <SID>xx <SID>xx
    let s:tlist_sid = substitute(maparg('<SID>xx'), '<SNR>\(\d\+\)_xx$',
                \ '\1', '')
    unmap <SID>xx
    return s:tlist_sid
endfun

echo "SID: " . s:SID1()

function! s:SID2()
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

echo s:SID()

let s:mySNR = ''
function! s:SNR()
  if s:mySNR == ''
    let s:mySNR = matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSNR$')
  endif
  return s:mySNR
endfun

echo s:SNR()
