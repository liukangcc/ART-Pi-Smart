# Get initial variables
ROOTDIR="/home/liukang/repo/ART-Pi-smart/userapps"

APP_NAME="ffmpeg"

APP_DIR=${APP_NAME}
LIB_DIR=${ROOTDIR}/sdk/lib
INC_DIR=${ROOTDIR}/sdk/include

RT_DIR=${ROOTDIR}/sdk/rt-thread
RT_INC=" -I. -Iinclude -I${ROOTDIR} -I${RT_DIR}/include -I${RT_DIR}/components/dfs -I${RT_DIR}/components/drivers -I${RT_DIR}/components/finsh -I${RT_DIR}/components/net -I${INC_DIR}/sdl -DHAVE_CCONFIG_H"
RT_INC+=" -I${ROOTDIR}/../kernel/bsp/imx6ull-artpi-smart/drivers/"

export CPPFLAGS=${RT_INC}
export LDFLAGS="-L${LIB_DIR} "

export LIBS="-T ${ROOTDIR}/linker_scripts/arm/cortex-a/link.lds -march=armv7-a -marm -msoft-float -L${RT_DIR}/lib -Wl,--whole-archive -lrtthread -Wl,--no-whole-archive -n -static -Wl,--start-group -lc -lgcc -lrtthread -Wl,--end-group"

export RTT_EXEC_PATH=/home/liukang/repo/ART-Pi-smart/tools/gnu_gcc/arm-linux-musleabi_for_x86_64-pc-linux-gnu/bin
export PATH=$PATH:$RTT_EXEC_PATH:$RTT_EXEC_PATH/../arm-linux-musleabi/bin

export CROSS_COMPILE="arm-linux-musleabi"

if [ "$1" == "debug" ]; then
    export CFLAGS="-march=armv7-a -marm -msoft-float -D__RTTHREAD__ -O0 -g -gdwarf-2 -Wall -n --static"
else
    export CFLAGS="-march=armv7-a -marm -msoft-float -D__RTTHREAD__ -O2 -Wall -n --static"
fi

# default build
function builddef() {
    cd ${APP_DIR}
    ./configure \
    --cross-prefix=${CROSS_COMPILE} --enable-cross-compile --target-os=linux \
    --cc=${CROSS_COMPILE}-gcc \
    --ar=${CROSS_COMPILE}-ar \
    --ranlib=${CROSS_COMPILE}-ranlib \
    --arch=arm --prefix=/home/liukang/repo/ffmpeg/ffmpeg_lib \
    --pkg-config-flags="--static" \
    --enable-gpl --enable-nonfree --disable-ffplay --enable-swscale --enable-pthreads --disable-armv5te --disable-armv6 --disable-armv6t2 --disable-x86asm  --disable-stripping \
    --enable-libx264 --extra-cflags=-I/home/liukang/repo/x264lib/include --extra-ldflags=-L/home/liukang/repo/x264lib/lib --extra-libs=-ldl
    make clean
    if [ "$1" == "verbose" ]; then
        make V=1
    else
        make
    fi
    make install
}

builddef $1
