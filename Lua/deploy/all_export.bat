@echo off

chcp 65001

set LUA_PATH=!/../tools/excel2lua/?.lua;!/../quanta/?.lua;;

:: 解析xlsm文件为lua
..\tools\quanta.exe --entry=convertor  --input=./ --output=../client/config --allsheet=1

pause

