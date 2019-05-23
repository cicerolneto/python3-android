pushd src >/dev/null

rm -rf "Python-${VERSION}"
tar -xf "Python-${VERSION}.tar.xz" || exit 1
pushd "Python-${VERSION}" >/dev/null

# Apply patches and build target Python.
cat > config.site <<-SITE
	ac_cv_file__dev_ptmx=no
	ac_cv_file__dev_ptc=no
SITE
#ln -sf "${TOOL_PREFIX}/sysroot/usr/include/"{linux,sys}"/soundcard.h"
patch -p1  < "${FILESDIR}/${PACKAGE}-setup.patch" || exit 1
patch -p1  < "${FILESDIR}/${PACKAGE}-cross-compile.patch" || exit 1
patch -p1  < "${FILESDIR}/${PACKAGE}-python-misc.patch" || exit 1
patch -p1  < "${FILESDIR}/${PACKAGE}-android-locale.patch" || exit 1
patch -Ep1 < "${FILESDIR}/${PACKAGE}-android-libmpdec.patch" || exit 1
patch -p1  < "${FILESDIR}/${PACKAGE}-android-misc.patch" || exit 1
#patch -p1  < "${FILESDIR}/${PACKAGE}-android-print.patch" || exit 1
patch -p1  < "${FILESDIR}/${PACKAGE}-android-extras.patch" || exit 1
#patch -p1  < "${FILESDIR}/${PACKAGE}-accept4.patch" || exit 1
patch -p1  < "${FILESDIR}/${PACKAGE}-python-nl_langinfo.patch" || exit 1 
patch -p1  < "${FILESDIR}/${PACKAGE}-android-audio.patch" || exit 1 

autoreconf --install --verbose --force


#./configure CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" CONFIG_SITE=config.site --prefix="${PREFIX}" --host="${TARGET}" --build="${HOST}" --disable-ipv6 --enable-shared --without-ensurepip || exit 1 
./configure CROSS_COMPILE_TARGET=yes CONFIG_SITE=config.site --prefix="${PREFIX}" --host="${TARGET}" --build="${HOST}" --disable-ipv6 --enable-shared --without-ensurepip --with-system-ffi --with-system-expat || exit 1 

make CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" HOSTPGEN="$(pwd)/Parser/hostpgen" || exit 1
make CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" HOSTPGEN="$(pwd)/Parser/hostpgen" install || exit 1

popd >/dev/null
popd >/dev/null

