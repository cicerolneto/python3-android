pushd src >/dev/null

rm -rf "${PACKAGE}"
tar -xf "${PACKAGE}.tar.gz" || exit 1
pushd "${PACKAGE}" >/dev/null

# export CC="${CC} -isystem ${CLANG_PREFIX}/sysroot/usr/include"
#export CC="${CC} -isystem ${NDK_ROOT}/sysroot/usr/include"
export CC="${CC} -isystem ${NDK_ROOT}/sysroot/usr/include -isystem ${NDK_ROOT}/sysroot/usr/include/${ANDROID_TARGET}"
export CFLAGS="${CPPFLAGS} ${CFLAGS}"

patch -p1 < "${FILESDIR}/${PACKAGE}-makefile-env.patch" || exit 1
make clean || exit 1
make libbz2.a bzip2 bzip2recover || exit 1
make install_libbz2.a || exit 1

popd >/dev/null
popd >/dev/null
