#!/bin/bash

# /usr/local/include/luajit-2.0
LUAJIT_INCLUDE=foo

# libmylib.a
MYLIB=feh.a

for f in *.lua; do
  luajit -b $f `basename $f .lua`.o
done

ar rcus $MYLIB *.o
gcc -o myexe stub.c -I$LUAJIT_INCLUDE \
  -L/usr/local/lib -lluajit-5.1 -Wl,--whole-archive $MYLIB -Wl,--no-whole-archive -Wl,-E
