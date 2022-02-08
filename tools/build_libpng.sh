#!/bin/bash
BUILD_CONF="conf.sh"
if [ ! -f ${BUILD_CONF} ]; then
  echo "conf.sh file not exist!"
  exit 1;
fi
source ${BUILD_CONF} $1

APP_NAME="libpng"
VERSION="1.6.37"
APP_DIR=${APP_NAME}-${VERSION}

# default build
function builddef() {
    cd ${APP_DIR}
    ./configure \
    --host=${CROSS_COMPILE} \
    --build=i686-pc-linux-gnu \
    --target=${CROSS_COMPILE} \
    --prefix=/home/liukang/repo/sdl_package/libpng_lib \
    --enable-static \
    --enable-shared=no \
    LDFLAGS="-L/home/liukang/repo/sdl_package/zlib_lib/lib" \
    CPPFLAGS="-I/home/liukang/repo/sdl_package/zlib_lib/include" \
    CFLAG="-fPIC"
    make clean
    if [ "$1" == "verbose" ]; then
        make V=1
    else
        make
    fi
    make install
}

builddef $1

echo "========= libpng building finished. ========="


