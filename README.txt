Current Target: 7.3 amd64

Introduction
-------------------------------------------------------------------

It can often be frustrating when one or two large bits of software
are required, often dragging in many dependencies which potentially
adds clutter to your installation. The approach taken by OpenBSD
to install ports/packages into /usr/local is good and allows us to
encapsulate much of the 3rd party software. However pkg_bundle goes
one step further and allows for the creation of completely
self-contained and relocatable software packages. In some cases
this can be easier to maintain and perform inventory; especially
when multiple versions of the same software are introduced.

Usage
-------------------------------------------------------------------

Package bundles can be created via the following:

  $ pkg_bundle <package>

For example, to create a package for LibreOffice, the following can
be used:

  $ pkg_bundle libreoffice

You should now see a libreoffice folder containing a completely
self-contained copy of the software. That is it!

Optionally at this point, we can either run it directly:

  $ libreoffice/libreoffice

Or we can create a portable tarball of it:

  $ tar -czf libreoffice.tar.gz libreoffice

Or we can copy it to /opt/libreoffice (preserving symlinks and
stripping user/group id) and running it from there:

  # mkdir -p /opt
  # cp -RP libreoffice /opt/libreoffice
  $ /opt/libreoffice/libreoffice

As you can hopefully see, we have a lot of flexibility now with how
we can manage the software that we did not have before without
requiring re-compilation.

Creating Links
-------------------------------------------------------------------

Effort has been made to ensure that symlinks work well and in some
cases, better than the original software. Consider the following:

  # ln -s /opt/firefox/firefox /usr/local/bin/firefox

In particular, the ability to symlink can be misused to make
Windows-style shortcuts to your application.

Tested
-------------------------------------------------------------------

The tool provides in-built support for many packages. For some of
the more complex ones, a set of rules can be provided in order to
resolve any issues.

The following is a non-exhaustive list of some of the larger software
packages which people commonly install, along with some very brief
notes of some of the tweaks that have had to be done to get them
to work.

- blender (tested 3.0.1p1) - patch - LD_LIBRARY_PATH ignored in some libs
- chromium (tested 111.0.5563.110) - patch - icu4c has ICU_DATA disabled
- dia (tested 0.97.3p9)
- firefox (tested 111.0) - patch - disable pledge/unveil
- gcc (tested 11.2.0p6) - gcc fetches additional g++, gmake, gdb
- gimp (tested 2.99.14p0)
- git (tested 2.40.0)
- libreoffice (tested 7.5.1.2v0) - patch - icu4c has ICU_DATA disabled
- texlive_texmf-full (tested 2022)
- vlc (tested 3.0.18)
- wpa_supplicant (tested 2.9p2)

Pledge and Unveil
-------------------------------------------------------------------

Pledge and Unveil offer great functionality in terms of security.
Due to a tendancy to rely on absolute paths, this conflicts with
the idea of creating bundles that can pe placed anywhere on the
filesystem. This currently mostly relates to web browsers.

- Firefox browser, the binary is patched to use a relative
  path to i.e pledge.main and unveil.main within the bundle directory
  itself. However the user needs to manually edit these files to
  specify absolute paths whenever the bundle is moved.

- Chromium browser, pledge / sandbox remains functional but
  unfortunately unveil is disabled.

Notes / TODO / Misc
-------------------------------------------------------------------

# Scan libs using objdump instead of ldd or hardcoding (i.e blender)
$ objdump -p libreoffice/bin/zstd | grep "  NEEDED"

# Copy symlinks without preserving uid/gid
$ cp -RP <source> <dest>

# export GDK_PIXBUF_MODULE_FILE="lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
# dia, this can be absolute?
# firefox

