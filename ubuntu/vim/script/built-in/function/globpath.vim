let files = glob("`find . -name '*' -print`")
"echo files
let files_commas = substitute(files, "\n", ",", "g")
"echo files_commas
let gfiles = globpath(files_commas, "*.vim")
echo gfiles
