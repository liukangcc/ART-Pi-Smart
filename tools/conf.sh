#!/bin/bash
export RTT_EXEC_PATH=/home/liukang/repo/ART-Pi-smart/tools/gnu_gcc/arm-linux-musleabi_for_x86_64-pc-linux-gnu/bin
export PATH=$PATH:$RTT_EXEC_PATH:$RTT_EXEC_PATH/../arm-linux-musleabi/bin

export CROSS_COMPILE="arm-linux-musleabi"

if [ "$1" == "debug" ]; then
    export CFLAGS="-march=armv7-a -marm -msoft-float -D__RTTHREAD__ -O0 -g -gdwarf-2 -Wall -n --static"
else
    export CFLAGS="-march=armv7-a -marm -msoft-float -D__RTTHREAD__ -O2 -Wall -n --static"
fi

export AR=${CROSS_COMPILE}-ar
export AS=${CROSS_COMPILE}-as
export LD=${CROSS_COMPILE}-ld
export RANLIB=${CROSS_COMPILE}-ranlib
export CC=${CROSS_COMPILE}-gcc
export CXX=${CROSS_COMPILE}-g++
export NM=${CROSS_COMPILE}-nm

