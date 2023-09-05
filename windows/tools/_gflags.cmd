::
::
::

::set _NT_SYMBOL_PATH=%_NT_SYMBOL_PATH%;C:\Users\Aurelian.Melinte\Desktop\orgspancore
set _NT_SYMBOL_PATH=cache*c:\symbols;SRV*\\i3devops.inin.com\dailybuildsymbols;cache*c:\symbols;SRV*\\i3devops.inin.com\gasymbols;cache*c:\symbols;SRV*\\i3devops.inin.com\builds\symbols\oldgasymbols;cache*c:\symbols;SRV*http://msdl.microsoft.com/download/symbols

reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" /v GlobalFlag /s

::start "" "C:\Program Files (x86)\Windows Kits\8.1\Debuggers\x86\gflags.exe" 
start "" "C:\Program Files (x86)\Windows Kits\10\Debuggers\x64\gflags.exe"
