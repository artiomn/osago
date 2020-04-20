@echo off
set MYSQL_SERVER_DIR="MySQL Server 5.1"
set SPHINX_DIR="Sphinx"

cd %MYSQL_SERVER_DIR%

echo Starting database manager system server...
call start_daemon.cmd

cd %MYSQL_SERVER_DIR%

echo Starting client...
call mysql.bat
