@echo off

FOR /f %%i IN ("%0") DO (
set this_path=%%~dpi
)

set origin_file=vipAug1\vipAug1_mod.swf
set dest_path=%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\JPEXS\FFDec\saved\
echo %this_path%%origin_file%
FOR /F %%I IN ('DIR %dest_path%*.tmp /B /O:-D') DO set dest_file=%dest_path%%%I
echo %dest_file%

copy %this_path%%origin_file% %dest_file% /Y

::pause