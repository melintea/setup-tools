::
:: Memory leaks
::

set TSBIN=TsServerU.exe
set TSRPT=_Ts


set ININ_STLPORT_USE_MALLOC=1


gflags.exe -i %TSBIN% +ust
gflags /p /disable %TSBIN%


echo Press any key to take the first snapshot
pause
umdh -pn:%TSBIN% -f:%TSRPT%1st.log


echo Press any key to take the second snapshot
pause
umdh -pn:%TSBIN% -f:%TSRPT%2nd.log


umdh.exe -d -v %TSRPT%1st.log %TSRPT%2nd.log > %TSRPT%Diff.log


gflags.exe -i %TSBIN% -ust