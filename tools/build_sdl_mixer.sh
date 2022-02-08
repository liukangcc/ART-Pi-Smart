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

APP_NAME="SDL2_mixer"
VERSION="2.0.4"
APP_DIR=${APP_NAME}-${VERSION}
ROOTDIR="/home/liukang/repo/ART-Pi-smart/userapps"
LIB_DIR=${ROOTDIR}/sdk/lib
INC_DIR=${ROOTDIR}/sdk/include
SDL_DIR=${ROOTDIR}/sdk/include/sdl
RT_DIR=${ROOTDIR}/sdk/rt-thread
RT_INC=" -I. -Iinclude -I${ROOTDIR} -I${RT_DIR}/include -I${RT_DIR}/components/dfs -I${RT_DIR}/components/drivers -I${RT_DIR}/components/finsh -I${RT_DIR}/components/net -I${INC_DIR} -I${SDL_DIR}  -DHAVE_CCONFIG_H"
RT_INC+=" -I${ROOTDIR}/../kernel/bsp/imx6ull-artpi-smart/drivers/"

export CPPFLAGS=${RT_INC}
export LDFLAGS="-L${RT_DIR}/lib -L${LIB_DIR} "

export LIBS="-T ${ROOTDIR}/linker_scripts/arm/cortex-a/link.lds -march=armv7-a -marm -msoft-float -Wl,--whole-archive -lrtthread -Wl,--no-whole-archive -n -static -Wl,--start-group -lc -lgcc -lrtthread -Wl,--end-group"

# default build
function builddef() {
    cd ${APP_DIR}
    ./configure \
	--prefix=/home/liukang/repo/sdl_package/sdl_mixer_lib \
	--target=${CROSS_COMPILE} \
	--host=${CROSS_COMPILE}  \
	--build=i686-pc-linux-gnu \
	--enable-shared=no \
    --disable-music-mod \
    --enable-music-cmd=no \
    --enable-music-mp3-mad-gpl --enable-music-mp3=no \
    --enable-static \
    SDL_CFLAGS="-I${LIB_DIR}" \
    SDL_LIBS="-lSDL2 -lrtthread"
    make clean
    if [ "$1" == "verbose" ]; then
        make V=1
    else
        make
    fi
    make install
}

builddef $1

echo "========= sdl2_mixer building finished. ========="
