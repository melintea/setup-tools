@echo off
::
:: A script around the Windows Performance Toolkit (x86 version even on x64 machines)
::
:: Usage: _profile <file.etl> TsPid
::
:: !!Notes!!: 
::   - stop ProcessExplorer before usage. It uses the same kernel hooks. [error: NT Kernel Logger: Cannot create a file when that file already exists 0xb7]
::   - symbols must be on a local drive. It will not process TS syms otherwise (but according to doc, it should be able to use network shares).
::   - manually empty the sym cache each time new TS binaries are used. It will take hours to refill.
::
::   http://msdn.microsoft.com/library/ff190975
::   http://msdn.microsoft.com/en-us/library/windows/desktop/hh162967.aspx
::   http://blogs.msdn.com/b/pigscanfly/archive/2009/08/06/stack-walking-in-xperf.aspx
::   http://www.altdevblogaday.com/2012/05/06/xperf-wait-analysisfinding-idle-time/
::   http://devproconnections.com/development/use-xperfs-wait-analysis-application-performance-troubleshooting?page=2
::

:: Disable paging on 64bit
::   REG ADD "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" -v DisablePagingExecutive -d 0x1 -t REG_DWORD -f 

set _XPERFPATH=C:\Program Files (x86)\Windows Kits\8.0\Windows Performance Toolkit;C:\Program Files (x86)\Windows Kits\8.0\Debuggers\x86
set PATH=%_XPERFPATH%;%PATH%
::echo %PATH%

set _PRFFILE=%1
IF [%1] == [] set _PRFFILE=_prffile.etl
::IF [%1] == [] GOTO MyLabel
echo Info collected to: %_PRFFILE%

set _TSPID=%2
IF [%2] == [] GOTO _GETPID


:: 
:: Capture
::
:_CAPTURE

:: Where is time being spent: _cpu ==> Summary Table
::xperf -on latency+SPINLOCK -stackwalk Profile  -BufferSize 1024 -MinBuffers 20 -MaxBuffers 6400 -Pids %_TSPID%

:: Wait analysis: CPU Scheduling => Summary Table with Ready Thread
::xperf -on Base+CSWITCH+DISPATCHER -stackwalk CSwitch+ReadyThread  -BufferSize 1024 -MinBuffers 20 -MaxBuffers 6400 -Pids %_TSPID%

:: +Spinlocks
::xperf -on Base+Latency+CSWITCH+DISPATCHER+spinlock -stackwalk Profile+CSwitch+ReadyThread+ThreadCreate+ThreadDelete+CritSecCollision  -BufferSize 1024 -MinBuffers 20 -MaxBuffers 6400 -Pids %_TSPID%
xperf -on Base+Latency+CSWITCH+DISPATCHER+spinlock -stackwalk Profile+CSwitch+ReadyThread+ThreadCreate+ThreadDelete -BufferSize 1024 -MinBuffers 20 -MaxBuffers 6400 -Pids %_TSPID%



echo Press Enter to stop profiling.
pause

xperf -d %_PRFFILE% 
::xperf -i %_PRFFILE% -symbols -o %_PRFFILE%.spin.txt -a spinlock -summary -counts 5



:: 
:: Analyze: 
::     Where is time being spent: _cpu ==> Summary Table
::     Wait analysis: CPU Scheduling => Summary Table with Ready Thread
::

::set _NT_SYMBOL_PATH=q:\Symbols;Q:\SymCache;%_NT_SYMBOL_PATH%
::set _NT_SYMCACHE_PATH=Q:\SymCache
::xperf %_PRFFILE%
::pause


goto _END


:_GETPID
tlist /p TsServerU.exe
set /p _TSPID=TsServerU PID:
GOTO _CAPTURE

:_END
@echo Exit now...
