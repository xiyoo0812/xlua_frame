

@echo off
setlocal enabledelayedexpansion

set RootDir=%~dp0
set SProtoDir=%RootDir%\..\sbin\proto
if not exist %SProtoDir% md %SProtoDir%

cd ../quanta/proto

set Files=
for %%i in (etcd\*.proto) do (
	echo "build %%i"
	call set "Files=%%i %%Files%%"
)
protoc.exe --descriptor_set_out=%SProtoDir%\etcd.pb %Files%

pause

