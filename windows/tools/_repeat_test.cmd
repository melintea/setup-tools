::
:: Run test for the layer
:: _test  test_x.exe
:: 
::

@echo off
setlocal enabledelayedexpansion

echo.
echo.
echo --- 
echo --- Running %1%
echo --- 

:repeat	
%* --detect_memory_leaks=0 --log_level=test_suite --report_level=detailed
	
echo ERRORLEVEL = %ERRORLEVEL%
IF %ERRORLEVEL% NEQ 0 (
    echo [101m[101m FAIL = %1% [0m
    echo   
) ELSE (
    echo [102m[102m Pass = %1% [0m
    goto :repeat
)
	

endlocal
