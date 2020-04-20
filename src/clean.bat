set clean_dirs=.;obj_int

for /D %%i in (%clean_dirs%) do (
  del %%i\*.lrs
  del %%i\.lrt
  del %%i\*.o
  del %%i\*.ppu
  del %%i\*.bak
)

pause