set PRG_FILE=osago_new.exe

..\lazarus\fpc\2.2.4\bin\i386-win32\strip.exe --strip-all --discard-all --verbose "%PRG_FILE%"
upx --best --lzma --strip-relocs=1 "%PRG_FILE%"
pause