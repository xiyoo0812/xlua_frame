@echo off

chcp 65001

:: 解析xlsm文件为lua

set LUA_PATH=!/excel2lua/?.lua;;

quanta.exe --entry=convertor --input=./cfg_xls --output=./config

pause

