@echo off

chcp 65001

set LUA_PATH=!/encrypt/?.lua;;

:: 编码lua文件
quanta.exe --entry=encrypt --input=../script --output=./export

pause

