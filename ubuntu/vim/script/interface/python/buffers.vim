python << EOF
import vim
print type(vim.buffers)   # 'buffer' List
print len(vim.buffers)    # Number of elements
b = vim.buffers[0]        # Indexing (read-only)
print dir(b)              # Methods of 'buffer'
help(b.append)            # Help of append() of buffer
print "buffer line:", b[0]
print "buffer line:", b[1]
#b in vim.buffers         # Membership test
#for b in vim.buffers:    # Sequential access

# :help python-buffer
print b.name          # file's name
print b.number        # buffer number (:buffers)
#b.append(str)        # Append a line to the buffer
#b.append(str, nr)    # Idem, below line "nr"
#b.append(list)       # Append a list of lines to the buffer
#b.append(list, nr)   # Idem, below line "nr"
print b.mark('b')     # Return a tuple (row,col) representing the position
r = b.range(2,10)         # Return a range object (see python-range)
print r.start
print r.end
print "range line:", r[0]
print "range line:", r[1]
EOF
