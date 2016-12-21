let running = 1
while running < 5
    echo "Run..."
    let running = running + 1
endwhile

let i = 1
while i < 5
    echo "count is" i
    let i += 1
endwhile


for i in [1,2,3,4]
    echo i
endfor

for i in range(1,10)
" i = 1 ~ 10
    echo i
endfor

for a in range(8, 4, -2)
    echo a
endfor

let counter=0
while counter < 4
    echo counter
    if counter == 0
        let counter += 2
        continue
    endif
    if counter == 3
        break
    endif
    let counter += 1
endwhile
echo counter


let alist = ['one', 'two', 'three']
for n in alist
    echo n
endfor

for line in getline(1, 20)
    if line =~ "for.*"
        echo matchstr(line, 'for.*')
    endif
endfor



let uk2nl = {'one': 'een', 'two': 'twee', 'three': 'drie'}
for key in keys(uk2nl)
    echo key
endfor
for key in sort(keys(uk2nl))
    echo key
endfor
