::
:: cdb script (http://www.debuginfo.com/tools/cdbbatch.html)
:: Attach to a running process and watch for breakpoint.
::

set SYMPATH=C:\bridge\bin
set WDTPATH=C:\bridge\download\wdt\x64
set DBGEXE=ininbridgehost-w64r-1-0.exe

cd %WDTPATH% 

:: FOR /R %WDTPATH% %G IN (*.dll) DO "%systemroot%\system32\regsvr32.exe" /s "%G"

set _NT_SYMBOL_PATH=%SYMPATH%;%_NT_SYMBOL_PATH%;
echo %_NT_SYMBOL_PATH%

::
:: Keep looping
::
:forever
	
:: Pick a PID if multiple instances
for /f %%a in ('%WDTPATH%\tlist -p %DBGEXE%') do set PIDEXE=%%a

:: New log name
::set CDBLOG=_cdb-%RANDOM%
for /f "delims=/ tokens=1-3" %%a in ("%DATE:~4%") do (
    for /f "delims=:. tokens=1-4" %%m in ("%TIME: =0%") do (
        set CDBLOG=_cdb-%%c-%%b-%%a-%%m%%n%%o%%p
    )
)

:: -pn %DBGEXE%
%WDTPATH%\cdb -r 0 -p %PIDEXE% -logo C:\bridge\logs\%CDBLOG%.log -lines -c ".tlist;!sym prompts off;.reload /i;lm;bm i3core_w64r_4_0!i3core::create_dump_and_trace_anonymous_exception* 'kp;g';bm i3core_w64r_4_0!i3core::create_diagnostic_memory_dump* 'kp;g'; bl;.echo Running;g"

::
:: Keep looping
::
timeout 30
goto forever
::pause
