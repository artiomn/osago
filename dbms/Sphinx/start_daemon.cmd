@echo off
echo ����� ������...
start .\bin\searchd.exe --console --config "sphinx.conf" %1 %2 %3 %4 %5

if not %errorlevel% == 0 exit;

echo                  ###############
echo               #####################
echo           ###########################
echo         ###############################
echo     ####################################
echo ###################;==,-,,,,,,-:##########
echo  ###############    -,...0... .,=, #######
echo   ##########        =..000...  .=   ######
echo    #######         .-.00000..  ,=    #####
echo     ######         .-,00000....,-      ###
echo      #######        -..0000.....=       ##
echo       #######       ,,.000.....,,         
echo        ########      ,..00....,-           
echo         ########     .-,.0...,,        #   
echo          #########     -,,,,-,      ####   
echo            ##########             #####
echo             ############      ########
echo               #####################
echo                 #################
echo                    #############
echo                      ########
echo                       ######               
echo                       #####
echo                       #####                
echo                        ####
rem echo                        ####
rem echo                         ####               
rem echo                          ###
rem echo                           ###
ping -n 2 -w 1 127.0.0.1 > nul 
echo.
echo ����� ࠡ�⠥�...

pause
