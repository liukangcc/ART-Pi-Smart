#!/bin/bash
BUILD_CONF="conf.sh"
if [ ! -f ${BUILD_CONF} ]; then
  echo "conf.sh file not exist!"
  exit 1;
fi
source ${BUILD_CONF} $1

APP_NAME="zlib"
VERSION="1.2.11"
APP_DIR=${APP_NAME}-${VERSION}

# default build
function builddef() {
    cd ${APP_DIR}
    ls
    ./configure \
    --prefix=/home/liukang/repo/sdl_package/zlib_lib \
    --static
    make clean
    if [ "$1" == "verbose" ]; then
        make V=1
    else
        make
    fi
    make install
}

builddef $1

echo "========= zlib building finished. ========="
