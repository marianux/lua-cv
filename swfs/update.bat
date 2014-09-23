@echo off

FOR /f %%i IN ("%0") DO (
set this_path=%%~dpi
)

set origin_file=vipAug1\vipAug1_mod.swf
::set origin_file=sept11\sept22.swf
::set origin_file=sept11\sept11.swf
::set origin_file="sept11\sept11 - copia.swf"
::set origin_file="sept22\sept22 - copia.swf"


set dest_path=%HOMEDRIVE%%HOMEPATH%\AppData\Roaming\JPEXS\FFDec\saved\
echo %this_path%%origin_file%
FOR /F %%I IN ('DIR %dest_path%*.tmp /B /O:-D') DO set dest_file=%dest_path%%%I
echo %dest_file%

copy %this_path%%origin_file% %dest_file% /Y

::pause