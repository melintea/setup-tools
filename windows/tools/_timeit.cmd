::
:: A script to time commands
:: Usage: _timeit cmd args
:: http://stackoverflow.com/questions/673523/how-to-measure-execution-time-of-command-in-windows-command-line
::

@echo off
@setlocal 

set _start_t=%time%

:: runs your command
cmd /c %*

set _end_t=%time%
set _options="tokens=1-4 delims=:."
for /f %_options% %%a in ("%_start_t%") do set _start_t_h=%%a & set /a _start_t_m=100%%b %% 100 & set /a _start_t_s=100%%c %% 100 & set /a _start_t__milis=100%%d %% 100
for /f %_options% %%a in ("%_end_t%")   do set _end_t_h=%%a & set /a _end_t_m=100%%b %% 100 & set /a _end_t_s=100%%c %% 100 & set /a _end_t__milis=100%%d %% 100

set /a _hours=%_end_t_h%-%_start_t_h%
set /a _mins=%_end_t_m%-%_start_t_m%
set /a _secs=%_end_t_s%-%_start_t_s%
set /a _milis=%_end_t__milis%-%_start_t__milis%
if %_hours%  lss 0   set /a _hours = 24%_hours%
if %_mins%   lss 0   set /a _hours = %_hours% - 1 & set /a _mins = 60%_mins%
if %_secs%   lss 0   set /a _mins = %_mins% - 1 & set /a _secs = 60%_secs%
if %_milis%  lss 0   set /a _secs = %_secs% - 1 & set /a _milis = 100%_milis%
if 1%_milis% lss 100 set /a _milis = 0%_milis%

:: mission accomplished
set /a _total_secs = %_hours%*3600 + %_mins%*60 + %_secs% 
echo *** Command took %_hours%h:%_mins%m:%_secs%s.%_milis%ms (%_total_secs%.%_milis%s total)
