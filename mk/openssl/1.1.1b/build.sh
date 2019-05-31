pushd src >/dev/null

rm -rf "${PACKAGE}"
tar -xf "${PACKAGE}.tar.gz" || exit 1
pushd "${PACKAGE}" >/dev/null

[[ ! -d "${PREFIX}/share" ]] && (mkdir "${PREFIX}/share" || exit 1)

#patch -p1 < "${FILESDIR}/use-lld.patch" || exit 1
#patch -p1 < "${FILESDIR}/lld-issue32518.patch" || exit 1
#patch -p1 < "${FILESDIR}/llvm.patch" || exit 1
patch -p1 < "${FILESDIR}/android.patch" || exit 1

export OPENSSL_TARGET="android-${ANDROID_PLATFORM}"
# NDK Roots are needed for the setenv and the open ssl configure
export ANDROID_NDK_HOME="${NDK_ROOT}"
export ANDROID_NDK_ROOT="${NDK_ROOT}"

# OpenSSL needs clang in path
export PATH="${PATH}:${CLANG_PREFIX}/bin/:${CLANG_PREFIX}/${ANDROID_TARGET}/bin"

#export CPPFLAGS="-D__ANDROID_API__=${ANDROID_API_LEVEL}"
#export CC="${CC} -isystem ${NDK_ROOT}/sysroot/usr/include -isystem ${NDK_ROOT}/sysroot/usr/include/${ANDROID_TARGET}"

CUR_DIR="$(dirname "$BASH_SOURCE")"

export HASHBANGPERL="/usr/bin/perl"

# Setup some extra env stuff
#"sh ${CUR_DIR}/setenv-android.sh" "${ANDROID_PLATFORM}" "llvm" || exit 1
. ${CUR_DIR}/setenv-android.sh "${ANDROID_PLATFORM}" "llvm" || exit 1

./Configure --prefix="${PREFIX}" --openssldir="${PREFIX}/share" ${OPENSSL_TARGET} 'no-shared' || exit 1
# Yan
##./Configure--prefix=/usr --openssldir=/etc/ssl openssl_target 'no-shared'

make || exit 1
make install_sw install_ssldirs || exit 1

# Remove binaries from premises.
rm -f "${PREFIX}/bin/"{openssl,c_rehash} || exit 1

popd >/dev/null
popd >/dev/null
