:: http://support.microsoft.com/kb/268343

:: Windows 11:
:: This needs Windows 10 SDK, version 1803 (10.0.17134.12) as newer versions do not work ("Traces could not be callected because the Stack Trace Database is full")

::set PATH=%PATH%;C:\Program Files (x86)\Windows Kits\8.0\Debuggers\x86
set PATH=%PATH%;C:\Program Files (x86)\Windows Kits\10\Debuggers\x64.1803

set DOTNETPATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319
set I3BINSPATH=%PATH%
set I3BIN=test_i3voicecontrol_common-w64d-1-0.exe

::D:\i3\ic\server;C:\Windows\Microsoft.NET\Framework\v4.0.30319;C:\Program Files\Interactive Intelligence\Bridge Server\bin;C:\Program Files\Interactive Intelligence\Bridge Server\packages\7be1b32e-bc8f-4d0c-9671-276c1c586872;SRV*c:\symbols*http://DevSymbolServer.inin.com/symbolserver/DailyBuildSymbols;SRV*c:\symbols*http://DevSymbolServer.inin.com/symbolserver/GASymbols;SRV*c:\symbols*http://DevSymbolServer.inin.com/symbolserver/MicrosoftSymbols;SRV*c:\symbols*http://DevSymbolServer.inin.com/MicrosoftSymbols 
set _NT_SYMBOL_PATH=%DOTNETPATH%;%I3BINSPATH%;%_NT_SYMBOL_PATH%
echo %_NT_SYMBOL_PATH%


gflags -i %I3BIN% +ust
gflags /i %I3BIN% /tracedb 100

::
echo Start the program then press enter when first messsage box opens
pause

tlist /p %I3BIN%
set /p _TSPID=%I3BIN% PID:

umdh -p:%_TSPID% -f:_snap.%I3BIN%.1.log

::
echo Let the program continue to the next message box then press enter
pause
umdh -p:%_TSPID% -f:_snap.%I3BIN%.2.log
::cdb -pv -p %_TSPID% -lines -c ".dump /o /mAipwd %I3BIN%.1.dmp; q"

umdh _snap.%I3BIN%.1.log _snap.%I3BIN%.2.log > _diff.%I3BIN%.12.log
::cdb -pv -p %_TSPID% -lines -c ".loadby sos clr; !eeheap; !dumpheap -stat; q" >> _diff.%I3BIN%.12.log

::
echo Let the program continue to the next message box/end
pause
::gflags -i %I3BIN% -ust

