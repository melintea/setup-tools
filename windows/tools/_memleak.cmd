:: http://support.microsoft.com/kb/268343

::set PATH=%PATH%;C:\Program Files (x86)\Windows Kits\8.0\Debuggers\x86
set PATH=%PATH%;c:\Program Files\Windows Kits\8.1\Debuggers\x86

set DOTNETPATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319
set I3BINSPATH=C:\Program Files\Interactive Intelligence\Bridge Server\bin;C:\Program Files\Interactive Intelligence\Bridge Server\packages\7be1b32e-bc8f-4d0c-9671-276c1c586872;C:\Edge\bin;D:\i3\ic\server
set I3BIN=obhost32.exe

::D:\i3\ic\server;C:\Windows\Microsoft.NET\Framework\v4.0.30319;C:\Program Files\Interactive Intelligence\Bridge Server\bin;C:\Program Files\Interactive Intelligence\Bridge Server\packages\7be1b32e-bc8f-4d0c-9671-276c1c586872;SRV*c:\symbols*http://DevSymbolServer.inin.com/symbolserver/DailyBuildSymbols;SRV*c:\symbols*http://DevSymbolServer.inin.com/symbolserver/GASymbols;SRV*c:\symbols*http://DevSymbolServer.inin.com/symbolserver/MicrosoftSymbols;SRV*c:\symbols*http://DevSymbolServer.inin.com/MicrosoftSymbols 
set _NT_SYMBOL_PATH=%DOTNETPATH%;%I3BINSPATH%;%_NT_SYMBOL_PATH%
echo %_NT_SYMBOL_PATH%


gflags -i %I3BIN% +ust
gflags /i %I3BIN% /tracedb 100

tlist /p %I3BIN%
set /p _TSPID=%I3BIN% PID:

umdh -p:%_TSPID% -f:_snap.%I3BIN%.1.log

::
echo Stop the load and press Enter for a second snapshot and .dump /mAipwd %I3BIN%.1.dmp
pause
echo Waiting 31 mins...
timeout /T 1860
umdh -p:%_TSPID% -f:_snap.%I3BIN%.2.log
cdb -pv -p %_TSPID% -lines -c ".dump /o /mAipwd %I3BIN%.1.dmp; q"

umdh _snap.%I3BIN%.1.log _snap.%I3BIN%.2.log > _diff.%I3BIN%.12.log
cdb -pv -p %_TSPID% -lines -c ".loadby sos clr; !eeheap; !dumpheap -stat; q" >> _diff.%I3BIN%.12.log

::
echo Stop the load and press Enter for a third snapshot and .dump /mAipwd %I3BIN%.2.dmp
pause
echo Waiting 31 mins...
timeout /T 1860
umdh -p:%_TSPID% -f:_snap.%I3BIN%.3.log
cdb -pv -p %_TSPID% -lines -c ".dump /o /mAipwd %I3BIN%.2.dmp; q"

umdh _snap.%I3BIN%.2.log _snap.%I3BIN%.3.log > _diff.%I3BIN%.23.log
cdb -pv -p %_TSPID% -lines -c ".loadby sos clr; !eeheap; !dumpheap -stat; q" >> _diff.%I3BIN%.23.log
umdh _snap.%I3BIN%.1.log _snap.%I3BIN%.3.log > _diff.%I3BIN%.13.log

::
pause
gflags -i %I3BIN% -ust

