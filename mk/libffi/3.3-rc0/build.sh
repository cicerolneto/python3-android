pushd src >/dev/null

rm -rf "${PACKAGE}"
tar -xf "${PACKAGE}.tar.gz" || exit 1
pushd "${PACKAGE}" >/dev/null

./configure --prefix="${PREFIX}" --host="${TARGET}" --disable-shared || exit 1
make || exit 1
make install || exit 1

popd >/dev/null
popd >/dev/null
