
@ set vspath=%1%
@ set disk=%2%
@ set current=%3%
@ set currpath=%4%
@ set makexsb=%5%
@ set setvcvar=%6%
@ echo %current%
@ %disk%
@ cd %vspath%\VC\bin
@ call %setvcvar%
@ echo %current%
@ %current%
cd %currpath%
@ cd build
@ call %makexsb% clean
@ call %makexsb%
cd ..
echo "The XSB installation has finished"
