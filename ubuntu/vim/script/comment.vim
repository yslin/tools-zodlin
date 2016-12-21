try
    echo "> " "Print generic prompt
catch
    echo "The echo command expects one or more strings, "
                \"so this line produces an error complaining " 
                \"about the missing closing quote on "
                \"(what Vim assumes to be) the second string."
endtry

" fix the above problem by using a vertical bar to explicitly begin a new
" statement before starting the comment,
echo "> " | "Print generic prompt
