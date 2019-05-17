pushd src >/dev/null

rm -rf "Python-${VERSION}"
tar -xf "Python-${VERSION}.tar.xz" || exit 1
pushd "Python-${VERSION}" >/dev/null

echo "Toold Prefix is ${TOOL_PREFIX}. Linux is {linux,sys}"

export CONFIG_BUILD=${ANDROID_HOST}



export CC="${CC} -no-integrated-as"
# # export CXX="${CXX} -no-integrated-as"
# # export CPP="${PP} -no-integrated-as"

# ac_cv_file__dev_ptmx=yes
# ac_cv_file__dev_ptc=no 

# Apply patches and build target Python.
cat > config.site <<-SITE
	ac_cv_file__dev_ptmx=yes
	ac_cv_file__dev_ptc=no
SITE
#ln -sf "${TOOL_PREFIX}/sysroot/usr/include/"{linux,sys}"/soundcard.h"
##patch -p1  < "${FILESDIR}/lld-compatibility.patch" || exit 1

patch -p1  < "${FILESDIR}/gdbm.patch" || exit 1
patch -p1  < "${FILESDIR}/cppflags.patch" || exit 1
patch -p1  < "${FILESDIR}/skip-build.patch" || exit 1
patch -p1  < "${FILESDIR}/139.patch" || exit 1

# patch -p1  < "${FILESDIR}/${PACKAGE}-setup.patch" || exit 1
# patch -p1  < "${FILESDIR}/${PACKAGE}-cross-compile.patch" || exit 1
# patch -p1  < "${FILESDIR}/${PACKAGE}-python-misc.patch" || exit 1
# patch -p1  < "${FILESDIR}/${PACKAGE}-android-locale.patch" || exit 1
# patch -Ep1 < "${FILESDIR}/${PACKAGE}-android-libmpdec.patch" || exit 1
# patch -p1  < "${FILESDIR}/${PACKAGE}-android-misc.patch" || exit 1
# patch -p1  < "${FILESDIR}/${PACKAGE}-android-extras.patch" || exit 1
# patch -p1  < "${FILESDIR}/${PACKAGE}-python-nl_langinfo.patch" || exit 1 
# patch -p1  < "${FILESDIR}/${PACKAGE}-android-audio.patch" || exit 1 

autoreconf --install --verbose --force

echo "OUR TARGET IS ${TARGET}"

###./configure CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" CONFIG_SITE=config.site --prefix="${PREFIX}" --host="${TARGET}" --build="${HOST}" --disable-ipv6 --without-ensurepip --with-system-ffi --with-system-expat || exit 1 
./configure CROSS_COMPILE_TARGET=yes CONFIG_SITE=config.site --prefix="${PREFIX}" --host="${TARGET}" --build="${HOST}" --disable-ipv6 --without-ensurepip --with-system-ffi --with-system-expat || exit 1 

make
make altinstall DESTDIR=self.destdir()
# make CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" HOSTPGEN="$(pwd)/Parser/hostpgen" || exit 1
# make CROSS_COMPILE_TARGET=yes HOSTPYTHON="$(pwd)/hostpython" HOSTPGEN="$(pwd)/Parser/hostpgen" install || exit 1

        # self.run(['autoreconf', '--install', '--verbose', '--force'])
        # self.run_with_env([
        #     './configure',
        #     '--prefix=/usr',
        #     '--host=' + target_arch().ANDROID_TARGET,
    #         # CPython requires explicit --build
    #         '--build=x86_64-linux-gnu',
    #         '--disable-ipv6',
    #         '--with-system-ffi',
    #         '--with-system-expat',
    #         '--without-ensurepip',
    #     ])

    # def build(self):
    #     self.run(['make'])
    #     self.run(['make', 'altinstall', f'DESTDIR={self.destdir()}'])



# ./configure --prefix=/usr --host=${ANDROID_TARGET} --build=$CONFIG_BUILD --disable-ipv6
# make 
# # make install DESTDIR=$INSTALL_DIR
# make install DESTDIR=$INSTALL_DIR

popd >/dev/null
popd >/dev/null
