

@echo off
setlocal enabledelayedexpansion

set RootDir=%~dp0

set Files=
for %%i in (*.proto) do (
	echo "build %%i"
	call set "Files=%%i %%Files%%"
)
protoc.exe --descriptor_set_out=ncmd_cs.pb %Files%

pause

