::
:: Copy argument to a new file.
::
@echo off

set DESTFOLDER=C:\temp\_itsucks
set BASENAME=%~n1
set /A COUNTER=2

for %%f in (%DESTFOLDER%\*) do (
  set /A COUNTER+=1
)

echo copying %1 to %DESTFOLDER%\_%COUNTER%_%BASENAME%.exe
copy %1 %DESTFOLDER%\_%COUNTER%_%BASENAME%.exe
if %errorlevel% neq 0 (
    echo [101m[101m *** Error: %errorlevel%  [0m
    echo.
    echo  
    exit /b %errorlevel%
)
echo [102m[102m *** Pass: %errorlevel% [0m


::
::
::
::for /f "tokens=1,* delims= " %%a in ("%*") do set ALL_BUT_FIRST=%%b
set ALL_BUT_FIRST=%*
call set ALL_BUT_FIRST=%%ALL_BUT_FIRST:*%1=%%
echo args: %ALL_BUT_FIRST%
%DESTFOLDER%\_%COUNTER%_%BASENAME%.exe  %ALL_BUT_FIRST%
if %errorlevel% neq 0 (
    echo [101m[101m *** Error: %errorlevel%  [0m
    echo.
    echo  
    exit /b %errorlevel%
)
echo [102m[102m *** Pass: %errorlevel% [0m
