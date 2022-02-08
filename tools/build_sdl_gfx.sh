# Get initial variables
BUILD_CONF="conf.sh"
if [ ! -f ${BUILD_CONF} ]; then
  echo "conf.sh file not exist!"
  exit 1;
fi
source ${BUILD_CONF} $1

ROOTDIR="/home/liukang/repo/ART-Pi-smart/userapps"

APP_NAME="SDL2_gfx"
VERSION="1.0.4"
APP_DIR=${APP_NAME}-${VERSION}
LIB_DIR=${ROOTDIR}/sdk/lib
INC_DIR=${ROOTDIR}/sdk/include

RT_DIR=${ROOTDIR}/sdk/rt-thread
RT_INC=" -I. -Iinclude -I${ROOTDIR} -I${RT_DIR}/include -I${RT_DIR}/components/dfs -I${RT_DIR}/components/drivers -I${RT_DIR}/components/finsh -I${RT_DIR}/components/net -I${INC_DIR}/sdl -DHAVE_CCONFIG_H"
RT_INC+=" -I${ROOTDIR}/../kernel/bsp/imx6ull-artpi-smart/drivers/"

export CPPFLAGS=${RT_INC}
export LDFLAGS="-L${LIB_DIR} "

export LIBS="-T ${ROOTDIR}/linker_scripts/arm/cortex-a/link.lds -march=armv7-a -marm -msoft-float -L${RT_DIR}/lib -Wl,--whole-archive -lrtthread -Wl,--no-whole-archive -n -static -Wl,--start-group -lc -lgcc -lrtthread -Wl,--end-group"

# default build
function builddef() {
    cd ${APP_DIR}
	./autogen.sh
    ./configure \
	--target=${CROSS_COMPILE} \
	--build=i686-pc-linux-gnu \
    --host=${CROSS_COMPILE} \
	--enable-static \
    --enable-shared=no \
	--enable-mmx=no
    make clean
    if [ "$1" == "verbose" ]; then
        make V=1
    else
        make
    fi
    make install
}

builddef $1
