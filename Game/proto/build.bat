

@echo off
setlocal enabledelayedexpansion

set RootDir=%~dp0
set CProtoDir=%RootDir%\..\cbin\proto
set SProtoDir=%RootDir%\..\sbin\proto
if not exist %CProtoDir% md %CProtoDir%
if not exist %SProtoDir% md %SProtoDir%

set Files=
for %%i in (*.proto) do (
	echo "build %%i"
	call set "Files=%%i %%Files%%"
)
protoc.exe --descriptor_set_out=%CProtoDir%\ncmd_cs.pb %Files%
protoc.exe --descriptor_set_out=%SProtoDir%\ncmd_cs.pb %Files%
protoc.exe --include_source_info --descriptor_set_out=%SProtoDir%\comment.pb %Files%

pause

