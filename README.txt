Working
-------
dia (tested 0.97.3p9)
gimp (tested 2.99.14p0)
vlc (tested 3.0.18)
gcc (tested 11.2.0p6) - gcc fetches additional g++, gmake, gdb
git (tested 2.40.0)

Terrible Hack
-------------
blender (tested 3.0.1p1) - LD_LIBRARY_PATH ignored
libreoffice (tested 7.5.1.2v0) - icu4c has ICU_DATA disabled
chromium (tested 111.0.5563.110) - icu4c has ICU_DATA disabled

Partially working
-----------------


# TODO
Scan libs using objdump instead of ldd or hardcoding (i.e blender)
$ objdump -p libreoffice/bin/zstd | grep "  NEEDED"
