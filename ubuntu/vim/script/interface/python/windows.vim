python << EOF
import vim
w = vim.windows[0]       # Indexing (read-only)
print w                  # window number
print dir(w)             # method of window
print w.cursor           # current cursor position
print w.height           # window height
#w in vim.windows        # Membership test
n = len(vim.windows)     # Number of elements
print n
#for w in vim.windows:   # Sequential access
EOF
