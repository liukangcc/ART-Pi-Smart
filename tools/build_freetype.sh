#!/bin/bash
BUILD_CONF="conf.sh"
if [ ! -f ${BUILD_CONF} ]; then
  echo "conf.sh file not exist!"
  exit 1;
fi
source ${BUILD_CONF} $1

APP_NAME="freetype"
VERSION="2.11.1"
APP_DIR=${APP_NAME}-${VERSION}

# default build
function builddef() {
    cd ${APP_DIR}
    ./autogen.sh
    ./configure \
    --host=${CROSS_COMPILE} \
    --build=i686-pc-linux-gnu \
    --target=${CROSS_COMPILE} \
    --prefix=/home/liukang/repo/sdl_package/freetype_lib \
    --enable-static \
    LDFLAGS="-L/home/liukang/repo/sdl_package/zlib_lib/lib -L/home/liukang/repo/sdl_package/libpng_lib/lib" \
    CPPFLAGS="-I/home/liukang/repo/sdl_package/zlib_lib/include -I/home/liukang/repo/sdl_package/libpng_lib/include"
    make clean
    if [ "$1" == "verbose" ]; then
        make V=1
    else
        make
    fi
    make install
}

builddef $1

echo "========= freetype building finished. ========="


