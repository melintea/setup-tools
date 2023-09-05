::
:: Analyze a list of core dumps. Usage:
:: script C:\path\to\dump1.dmp C:\path\to\dump2.dmp
::

@echo off
cls
setlocal EnableDelayedExpansion

::set _NT_SYMBOL_PATH=%_NT_SYMBOL_PATH%;C:\Users\Aurelian.Melinte\Desktop\orgspancore
set _NT_SYMBOL_PATH=cache*c:\symbols;SRV*\\i3devops.inin.com\dailybuildsymbols;cache*c:\symbols;SRV*\\i3devops.inin.com\gasymbols;cache*c:\symbols;SRV*\\i3devops.inin.com\builds\symbols\oldgasymbols;cache*c:\symbols;SRV*http://msdl.microsoft.com/download/symbols;%_NT_SYMBOL_PATH%


for /R %%i in (*.dmp) do (
::for %%i in (%*) do (
    set DUMPNAME=%%i
    set DUMPBASENAME=%%~ni
    for /f "delims=/ tokens=1-3" %%a in ("%DATE:~4%") do (
        for /f "delims=:. tokens=1-4" %%m in ("%TIME: =0%") do (
            set CDBLOG=!DUMPBASENAME!-%%c-%%b-%%a-%%m%%n%%o%%p
            echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            echo !DUMPNAME!
	        echo !CDBLOG!
            echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
            ::start /wait "cdb32 !DUMPBASENAME!" "C:\Program Files (x86)\Windows Kits\8.1\Debuggers\x86\cdb.exe" -logo .\_dmp32_!CDBLOG!.log -lines -z !DUMPNAME! -c ".symfix; .reload /f; lml; ~*kb; ^!analyze -v; q"
            start /wait "cdb64 !DUMPBASENAME!" "C:\Program Files (x86)\Windows Kits\8.1\Debuggers\x64\cdb.exe" -logo .\_dmp64_!CDBLOG!.log -lines -z !DUMPNAME! -c ".symfix; .reload /f; lml; ^!analyze -v; q"
			echo !ERRORLEVEL!
        )
    )
)

endlocal