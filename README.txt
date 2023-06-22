Current Target: 7.3 amd64

Working
-------
dia (tested 0.97.3p9)
gimp (tested 2.99.14p0)
vlc (tested 3.0.18)
gcc (tested 11.2.0p6) - gcc fetches additional g++, gmake, gdb
git (tested 2.40.0)

blender (tested 3.0.1p1) - patch - LD_LIBRARY_PATH ignored in some libs
libreoffice (tested 7.5.1.2v0) - patch - icu4c has ICU_DATA disabled
chromium (tested 111.0.5563.110) - patch - icu4c has ICU_DATA disabled
firefox (tested 111.0) - patch - disable pledge/unveil

Partially working
-----------------
none

# NOTES
Scan libs using objdump instead of ldd or hardcoding (i.e blender)
$ objdump -p libreoffice/bin/zstd | grep "  NEEDED"

