::
::
::

:: http://stackoverflow.com/questions/7568425/how-can-i-determine-why-my-process-terminates
:: -t indicates write dump at process termination
:: -e	Write a dump when the process encounters an unhandled exception. Include the 1 to create dump on first chance exceptions.

"C:\Program Files (x86)\Windows Kits\8.1\Debuggers\x64\procdump.exe" -ma -t -l -o -w ininbridgeserver-w32d-1-0.exe c:\Temp\ininbridgeserver.dmp 
