@echo off
echo Запуск индексатора...
echo.
.\bin\indexer.exe --config "sphinx.conf" --all %1 %2 %3 %4 %5
