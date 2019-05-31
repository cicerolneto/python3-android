pushd src >/dev/null

rm -rf "Python-${VERSION}"
tar -xf "Python-${VERSION}.tar.xz" || exit 1
pushd "Python-${VERSION}" >/dev/null


# export CONFIG_BUILD=${ANDROID_HOST}

export CC="${CC} -isystem ${PREFIX}/include  -no-integrated-as"
export LDFLAGS="${LDFLAGS} -L ${PREFIX}/lib"
# export CFLAGS="${CFLAGS} -Wno-unused-value -Wno-empty-body -Qunused-arguments"


export OPENSSL_INCLUDES="${PREFIX}/include/openssl"
export OPENSSL_LDFLAGS="${LDFLAGS}"
export OPENSSL_LIBS="${PREFIX}/lib"


# Apply patches and build target Python.
cat > config.site <<-SITE
	ac_cv_file__dev_ptmx=no
	ac_cv_file__dev_ptc=no
    ac_cv_func_getloadavg=no    
SITE

patch -p1  < "${FILESDIR}/gdbm.patch" || exit 1
patch -p1  < "${FILESDIR}/cppflags.patch" || exit 1
patch -p1  < "${FILESDIR}/skip-build.patch" || exit 1
patch -p1  < "${FILESDIR}/139.patch" || exit 1

autoreconf --install --verbose --force

./configure CROSS_COMPILE_TARGET=yes CONFIG_SITE=config.site --prefix="${PREFIX}" --host="${TARGET}" --build="${HOST}" --disable-ipv6 --enable-shared --without-ensurepip --with-system-ffi --with-system-expat --with-ssl-default-suites || exit 1 

make CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" HOSTPGEN="$(pwd)/Parser/hostpgen" || exit 1
make CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" HOSTPGEN="$(pwd)/Parser/hostpgen" install || exit 1


popd >/dev/null
popd >/dev/null
