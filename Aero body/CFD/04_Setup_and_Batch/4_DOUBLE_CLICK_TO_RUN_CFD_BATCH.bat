@echo off
title Solar car CFD batch - leave this window open
cd /d "%~dp0"
echo Closing any leftover Fluent sessions first...
taskkill /F /T /IM fluent.exe >nul 2>&1
taskkill /F /T /IM "cx26*" >nul 2>&1
taskkill /F /T /IM "fl26*" >nul 2>&1
taskkill /F /T /IM "fl_mpi26*" >nul 2>&1
timeout /t 10 /nobreak >nul
set "FL=%AWP_ROOT261%\fluent\ntbin\win64\fluent.exe"
set "CORES=4"
echo Batch started %date% %time% >> batch_status.txt
for %%C in (B_coarse C_coarse A_medium B_medium C_medium) do (
  if exist "%%C.dat.h5" (
    echo %%C already done, skipping >> batch_status.txt
  ) else (
    echo START %%C %date% %time% cores=%CORES% >> batch_status.txt
    echo Running %%C ... started %time%
    "%FL%" 3ddp -t%CORES% -g -wait -i "run_%%C.jou" < nul > "log_%%C.txt" 2>&1
    if exist "%%C.dat.h5" (echo DONE %%C %date% %time% >> batch_status.txt) else (echo FAILED %%C %date% %time% >> batch_status.txt)
  )
)
echo ALL FINISHED %date% %time% >> batch_status.txt
echo.
echo All runs finished. You can close this window.
pause
