cd "${prefix}"
cc -opatch-rpath "${pkg_bundle_share}/patch-rpath.c"
./patch-rpath

