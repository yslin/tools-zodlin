"Table 3. Vimscript operator precedence table
"Operation                            Operator syntax
"Assignment                           let var = expr
"Numeric-add-and-assign               let var += expr
"Numeric-subtract-and-assign          let var -= expr
"String-concatenate-and-assign        let var .= expr
"Ternary operator                     bool ? expr-if-true : expr-if-false
"Logical OR                           bool || bool
"Logical AND                          bool && bool
"Numeric or string equality           expr == expr
"Numeric or string inequality         expr != expr
"Numeric or string greater-then       expr > expr
"Numeric or string greater-or-equal   expr >= expr
"Numeric or string less than          expr < expr
"Numeric or string less-or-equal      expr <= expr
"Numeric addition                     num + num
"Numeric subtraction                  num - num
"String concatenation                 str . str
"Numeric multiplication               num * num
"Numeric division                     num / num
"Numeric modulus                      num % num
"Convert to number                    + num
"Numeric negation                     - num
"Logical NOT                          ! bool
"Parenthetical precedence             ( expr )

" Because filenum will always be less than filecount, the integer division
" filenum/filecount will always produce zero
let filecount = 10
"Step through each file...
for filenum in range(filecount)
    " Show progress...
    echo (filenum / filecount * 100) . '% done'

    " Make progress...
    "call process_file(filenum)
endfor

let filecount = 234

echo filecount/100   | " echoes 2
echo filecount/100.0 | " echoes 2.34
