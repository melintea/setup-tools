:: 
:: Visual Studio add-ons
:: https://confluence.inin.com/display/ION/Autoexp.dat+Visual+Studio+configuration
::

set AUTOEXPDAT=\\i3devfiles\builds\system\main_systest\latest\int\src\vstools\autoexp.dat
set I3VSADDIN=\\i3devfiles\builds\system\main_systest\latest\pub\gen\bin\w32\i3vsdebugaddin.dll

copy %AUTOEXPDAT% "C:\Program Files\Microsoft Visual Studio 8\Common7\Packages/Debugger"
copy %AUTOEXPDAT% "C:\Program Files\Microsoft Visual Studio 9.0\Common7\Packages\Debugger"
copy %AUTOEXPDAT% "C:\Program Files (x86)/Microsoft Visual Studio 9.0\Common7\Packages\Debugger"
copy %AUTOEXPDAT% "C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Packages\Debugger"
copy %AUTOEXPDAT% "C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\Packages\Debugger"
copy %AUTOEXPDAT% "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Packages\Debugger"

copy %I3VSADDIN%  "C:\Program Files\Microsoft Visual Studio 8\Common7\IDE"
copy %I3VSADDIN%  "C:\Program Files\Microsoft Visual Studio 9.0\Common7\IDE"
copy %I3VSADDIN%  "C:\Program Files (x86)/Microsoft Visual Studio 9.0/Common7/IDE"
copy %I3VSADDIN%  "C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE"
copy %I3VSADDIN%  "C:\Program Files (x86)\Microsoft Visual Studio 11.0\Common7\IDE"
copy %I3VSADDIN%  "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE"

pause
