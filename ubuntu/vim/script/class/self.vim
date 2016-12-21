" When a function is defined with the "dict" attribute it can be used in a
" special way with a dictionary.
" The entry in the Dictionary is a |Funcref|.  
" The local variable "self" refers to the dictionary the function was invoked
" from.
function! Mylen() dict
    return len(self.data)
endfunction
let mydict = {'data': [0, 1, 2, 3], 'len': function("Mylen")}
echo mydict.len()


"another way to define len
let myclass = {}

function! myclass.len()
    return len(self.data)
endfunction
let myclass.data = [0,1,2,3]
echo myclass.len()


"start the prototype
let AK47 = {}

"the constructor
function! AK47.New(ammo)
    let newAK47 = copy(self)
    let newAK47.ammo = a:ammo
    return newAK47
endfunction

"an instance method
function! AK47.fire()
    if self.ammo > 0
        echo "BANG!"
        let self.ammo -= 1
    else
        echo "click"
    endif
endfunction

"at runtime we can do this:
let a = AK47.New(2)
              " => 2
echo a.ammo   
call a.fire() " => BANG!
call a.fire() " => BANG!
call a.fire() " => click
