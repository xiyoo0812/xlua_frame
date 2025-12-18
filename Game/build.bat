@echo off

cd .\quanta

set path==%path%;C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE
devenv.com .\quanta.sln /Build

cd ../
xcopy .\quanta\bin\*.dll  .\sbin  /y /s
xcopy .\quanta\bin\*.exe  .\sbin  /y /s

pause
