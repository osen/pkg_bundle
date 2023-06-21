cd "${prefix}"
cc -opatch-rpath "${standalone_prefix}/hacks/patch-rpath.c"
./patch-rpath

