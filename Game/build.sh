@echo off

cd quanta

make quanta

cp -fv ./bin/*.so ../sbin/
cp -fv ./bin/lua ../sbin/
cp -fv ./bin/quanta ../sbin/
