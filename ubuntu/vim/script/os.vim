if has("macunix")   
	echo "Macintosh version of Vim, using Unix files (OS-X)."
endif
if has("unix")   
	echo "Unix version of Vim."
endif
if has("win32")    
	echo "Win32 version of Vim (MS-Windows 95 and later, 32 or 64 bits)"
endif
if has("win32unix") 
	echo "Win32 version of Vim, using Unix files (Cygwin)"
endif
