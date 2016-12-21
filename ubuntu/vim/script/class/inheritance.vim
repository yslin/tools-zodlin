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

"clone the AK47 prototype
let AK47GL = copy(AK47)

"override the old constructor
function! AK47GL.New(ammo, grenades)
    let newAK47GL = copy(self)
    let newAK47GL.ammo = a:ammo
    let newAK47GL.grenades = a:grenades
    return newAK47GL
endfunction

"define a new instance method
function! AK47GL.fireGL()
    if self.grenades > 0
        echo "OMG BOOOOOM!"
        let self.grenades -= 1
    else
        echo "click"
    endif
endfunction

"at runtime we can do this:
let a = AK47GL.New(2,1)
" => 2
echo a.ammo     
" => 1
echo a.grenades 
call a.fire()   " => BANG!
call a.fire()   " => BANG!
call a.fire()   " => click
call a.fireGL() " => OMG BOOOOOM!
call a.fireGL() " => click

"error
"let b = AK47GL.New(2)
