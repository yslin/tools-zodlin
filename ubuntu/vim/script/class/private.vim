"There is no way to make methods or properties private. However, if you make
"up some conventions for yourself, then you can make the intent of your code
"clear (even though vim wont actually enforce it). I have the convention that
"any method or property starting with an underscore should be treated as
"private.

"start the prototype
let AK47 = {}

"the constructor
function! AK47.New(ammo)
    let newAK47 = copy(self)
    let newAK47._ammo = a:ammo
    return newAK47
endfunction

"an instance method
function! AK47.fire()
    if self._ammo > 0
        echo "BANG!"
        let self._ammo -= 1
    else
        echo "click"
    endif
endfunction
