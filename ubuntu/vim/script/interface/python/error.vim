python << EOF
import vim
try:
    vim.command("jfeo")
except vim.error:
    # nothing in register a
    print "error occurs"
EOF
