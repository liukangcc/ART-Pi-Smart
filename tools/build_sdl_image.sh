#!/bin/bash
BUILD_CONF="conf.sh"
if [ ! -f ${BUILD_CONF} ]; then
  echo "conf.sh file not exist!"
  exit 1;
fi
source ${BUILD_CONF} $1

APP_NAME="SDL2_image"
VERSION="2.0.5"
APP_DIR=${APP_NAME}-${VERSION}
ROOTDIR="/home/liukang/repo/ART-Pi-smart/userapps"
LIB_DIR=${ROOTDIR}/sdk/lib
INC_DIR=${ROOTDIR}/sdk/include
SDL_DIR=${ROOTDIR}/sdk/include/sdl
RT_DIR=${ROOTDIR}/sdk/rt-thread

RT_INC="-I${ROOTDIR} -I${RT_DIR}/include -I${RT_DIR}/components/dfs -I${RT_DIR}/components/drivers -I${RT_DIR}/components/finsh -I${RT_DIR}/components/net -I${INC_DIR} -I${SDL_DIR} -DHAVE_CCONFIG_H"
RT_INC+=" -I${ROOTDIR}/../kernel/bsp/imx6ull-artpi-smart/drivers/"

export CPPFLAGS="${RT_INC}"
export LDFLAGS="-L${RT_DIR}/lib -L${LIB_DIR} -L/home/liukang/repo/sdl_package/zlib_lib/lib -L/home/liukang/repo/sdl_package/libpng_lib/lib"
export LIBS="-T ${ROOTDIR}/linker_scripts/arm/cortex-a/link.lds -march=armv7-a -marm -msoft-float -Wl,--whole-archive -Wl,--no-whole-archive -n -static -Wl,--start-group -lc -lgcc -Wl,--end-group"

# default build
function builddef() {
    cd ${APP_DIR}
    ./configure \
    --prefix=/home/liukang/repo/sdl_package/sdl_image_lib \
	--target=${CROSS_COMPILE} \
	--host=${CROSS_COMPILE} \
	--build=i686-pc-linux-gnu \
	--enable-shared=no \
    --enable-static \
    LIBPNG_CFLAGS="-I/home/liukang/repo/sdl_package/libpng_lib/include -I/home/liukang/repo/sdl_package/zlib_lib/include " \
    LIBPNG_LIBS="-lpng16 -lz" \
    SDL_CFLAGS="-I${LIB_DIR}" \
    SDL_LIBS="-lSDL2 -lrtthread"
    make clean
    if [ "$1" == "verbose" ]; then
        make V=1
    else
        make
    fi
}

builddef $1

echo "========= sdl2_image building finished. ========="
