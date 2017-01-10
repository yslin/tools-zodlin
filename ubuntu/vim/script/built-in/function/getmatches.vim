"searchstring1
"searchstring2
"searchstring3
highlight MyGroup ctermbg=green guibg=green
match MyGroup /search/
"[{'group': 'MyGroup', 'pattern': 'search', 'priority': 10, 'id': 1}]
echo getmatches()
