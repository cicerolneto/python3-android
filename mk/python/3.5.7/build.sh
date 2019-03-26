pushd src >/dev/null

rm -rf "Python-${VERSION}"
tar -xf "Python-${VERSION}.tar.xz" || exit 1
pushd "Python-${VERSION}" >/dev/null

# Build host components.
#AR=ar AS=as CC=gcc CFLAGS= CPP=cpp CPPFLAGS= CXX=g++ CXXFLAGS= LD=ld LDFLAGS= RANLIB=ranlib ./configure || exit 1
#AR=ar AS=as CC=gcc CFLAGS= CPP=cpp CPPFLAGS= CXX=g++ CXXFLAGS= LD=ld LDFLAGS= RANLIB=ranlib make BUILDPYTHON=hostpython hostpython PGEN=Parser/hostpgen Parser/hostpgen || exit 1

echo "Step 2"

#$$$./configure --enable-optimizations || exit 1
echo "Step 2.2"
#$$$make BUILDPYTHON=hostpython hostpython PGEN=Parser/hostpgen Parser/hostpgen || exit 1

autoreconf --install --verbose --force

echo "Step 3"
#$$$make distclean || exit 1

echo "Step 4"

# BDS REMOVE
# Apply patches and build target Python.
cat > config.site <<-SITE
	ac_cv_file__dev_ptmx=yes
	ac_cv_file__dev_ptc=no
	ac_cv_func_getloadavg=no
SITE
patch -p1  < "${FILESDIR}/${PACKAGE}-fileutils.patch" || exit 1
patch -p1  < "${FILESDIR}/${PACKAGE}-posixmodule.patch" || exit 1
# #ln -sf "${TOOL_PREFIX}/sysroot/usr/include/"{linux,sys}"/soundcard.h"
# patch -p1  < "${FILESDIR}/${PACKAGE}-android-locale.patch" || exit 1
# patch -Ep1 < "${FILESDIR}/${PACKAGE}-android-libmpdec.patch" || exit 1
# patch -p1  < "${FILESDIR}/${PACKAGE}-android-misc.patch" || exit 1
# #patch -p1  < "${FILESDIR}/${PACKAGE}-android-print.patch" || exit 1
# patch -p1  < "${FILESDIR}/${PACKAGE}-android-extras.patch" || exit 1
# #patch -p1  < "${FILESDIR}/${PACKAGE}-accept4.patch" || exit 1
# patch -p1  < "${FILESDIR}/${PACKAGE}-python-nl_langinfo.patch" || exit 1 
# patch -p1  < "${FILESDIR}/${PACKAGE}-android-audio.patch" || exit 1 
# BDS REMOVE


#./configure CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" CONFIG_SITE=config.site --prefix="${PREFIX}" --host="${TARGET}" --build="${HOST}" --disable-ipv6 --enable-shared --without-ensurepip || exit 1 
echo "Step 5"
#xxx./configure CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" CONFIG_SITE=config.site --prefix="${PREFIX}" --host="${TARGET}" --build="${HOST}" --disable-ipv6 --enable-shared --without-ensurepip --with-system-ffi --with-system-expat || exit 1 
./configure CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" CONFIG_SITE=config.site --host="${TARGET}" --build="${HOST}" --disable-ipv6 --enable-shared --without-ensurepip --with-system-ffi --with-system-expat || exit 1 
# ./configure CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" CONFIG_SITE=config.site \
#      --prefix="${PREFIX}" \
#      --host="${TARGET}" \
#      --build="${HOST}" \
#      --disable-ipv6 \
# #     --target="${TARGET}" \
# ##     --enable-shared \
# #     --with-system-ffi \
# #     --with-system-expat \
# ##     --without-ensurepip \
#      || exit 1

echo "Step 6"

#XXXmake CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" HOSTPGEN="$(pwd)/Parser/hostpgen" || exit 1
make  || exit 1
echo "Step 6.1"
#xxxmake CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" HOSTPGEN="$(pwd)/Parser/hostpgen" install || exit 1
make install || exit 1

popd >/dev/null
popd >/dev/null

echo "Step 7"