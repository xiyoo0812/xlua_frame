

@echo off
setlocal enabledelayedexpansion

cd template

set SCRIPT=../../quanta/tools/lmake/ltemplate.lua
for %%i in (*.conf) do (
    ..\..\sbin\lua.exe %SCRIPT% %%i ..\%%i xlua.impl
)

pause

