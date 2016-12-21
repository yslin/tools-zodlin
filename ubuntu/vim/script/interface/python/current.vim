python << EOF
print vim.current.line       # The current line (RW)           String
print vim.current.buffer     # The current buffer (RO)         Buffer
print vim.current.window     # The current window (RO)         Window
print vim.current.range      # The current line range (RO)     Range
EOF
