cd "${prefix}"
cc -opatch-icu "${standalone_prefix}/hacks/patch-icu.c"
./patch-icu
