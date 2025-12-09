

@echo off
setlocal enabledelayedexpansion

cd template

set SCRIPT=../tools/lmake/ltemplate.lua
for %%i in (*.conf) do (
    ..\tools\lua.exe %SCRIPT% %%i ..\%%i xlua.impl
)

pause

