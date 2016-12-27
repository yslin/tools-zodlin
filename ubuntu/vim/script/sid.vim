" Trick to get the current script ID
function! s:SID1()
    map <SID>xx <SID>xx
    let s:tlist_sid = substitute(maparg('<SID>xx'), '<SNR>\(\d\+\)_xx$',
                \ '\1', '')
    unmap <SID>xx
    return s:tlist_sid
endfun

echo "SID1:" . s:SID1()

"Real function name:<SNR>56_SID2
function! s:SID2()
    "function <SNR>56_SID2
    echo expand('<sfile>') 
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID2$')
endfun

echo "SID2:" . s:SID2()
exec 'call <SNR>' . s:SID2() . '_SID2()'

let s:mySNR = ''
function! s:SNR()
  if s:mySNR == ''
    let s:mySNR = matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSNR$')
  endif
  return s:mySNR
endfun

echo "SNR:" . s:SNR()
