cd "${prefix}"
cc -opatch-icu "${pkg_bundle_share}/patch-icu2.c"
./patch-icu

mv "${prefix}/bin/node" "${prefix}/bin/node.bin"
mv "${prefix}/bin/npm" "${prefix}/bin/npm.bin"
