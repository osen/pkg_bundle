cd "${prefix}"
cc -opatch-icu "${pkg_bundle_share}/patch-icu.c"
./patch-icu
