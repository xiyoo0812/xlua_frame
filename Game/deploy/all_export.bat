@echo off

chcp 65001

set LUA_PATH=!/../quanta/tools/excel2lua/?.lua;!/../quanta/script/?.lua;;

:: 解析xlsm文件为lua
..\sbin\quanta.exe --entry=convertor  --input=./ --output=../client/config --allsheet=1
..\sbin\quanta.exe --entry=convertor  --input=./ --output=../server/config --allsheet=1

pause

