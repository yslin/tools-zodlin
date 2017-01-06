let files = glob("`find . -name '*' -print`")
"echo files
let files_commas = substitute(files, "\n", ",", "g")
"echo files_commas
let gfiles = globpath(files_commas, "*.vim")
" a string
"echo gfiles

let currentFilesString = globpath(".", "*.vim")
"echo currentFilesString

let currentFilesList = globpath(".", "*.vim", 0, 1)
for file in currentFilesList
    echo file
endfor
