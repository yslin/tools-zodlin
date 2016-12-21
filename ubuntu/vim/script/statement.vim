func! Phase(num)
    echo a:num
endf

" more statements on a single line by separating them with a vertical bar
echo "Starting..." | call Phase(1) | call Phase(2) | echo "Done"
