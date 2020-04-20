@echo off
D:\free_pascal\lazarus\fpc\2.2.4\bin\i386-win32\windres.exe --include D:/FREE_P~1/lazarus/fpc/222A9D~1.4/bin/I386-W~1/ -O res -o D:\free_pascal\DIPLOME\osago_new.res D:/FREE_P~1/DIPLOME/OSAGO_~1.RC --preprocessor=D:\free_pascal\lazarus\fpc\2.2.4\bin\i386-win32\cpp.exe
if errorlevel 1 goto linkend
SET THEFILE=D:\free_pascal\DIPLOME\osago_new.exe
echo Linking %THEFILE%
D:\free_pascal\lazarus\fpc\2.2.4\bin\i386-win32\ld.exe -b pe-i386 -m i386pe  --gc-sections   --subsystem windows --entry=_WinMainCRTStartup    -o D:\free_pascal\DIPLOME\osago_new.exe D:\free_pascal\DIPLOME\link.res
if errorlevel 1 goto linkend
D:\free_pascal\lazarus\fpc\2.2.4\bin\i386-win32\postw32.exe --subsystem gui --input D:\free_pascal\DIPLOME\osago_new.exe --stack 16777216
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
