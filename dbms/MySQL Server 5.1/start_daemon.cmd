@echo off
echo Запуск демона...
start .\bin\mysqld.exe --defaults-file="my.ini" %1 %2 %3 %4 %5
pause
