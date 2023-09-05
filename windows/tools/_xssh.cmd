::
:: Login to remote with X
:: Usage script <IP>
::

echo macubuntu 10.254.64.198

::start "" "C:\Program Files\VcXsrv\vcxsrv.exe"  -multiwindow -clipboard -wgl -ac -displayfd 656 
start "" "C:\Program Files\VcXsrv\vcxsrv.exe"  :0.0 -clipboard -nowgl -ac -multimonitors -dpms

set DISPLAY=localhost:0
ssh -Y amelinte@%1 gnome-session --disable-acceleration-check --debug 
