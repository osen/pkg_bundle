export PERL5LIB="${PERL5LIB}:${prefix}/share/texmf-dist/scripts/texlive"
export PERL5LIB="${PERL5LIB}:${prefix}/libdata/perl5/site_perl"

#export TEXDIR="${prefix}"
#export TEXMFSYS="${prefix}"
#export TEXMFHOME="${prefix}"

#export TEXMFSYSCONFIG="${prefix}/share/texmf-dist"
export TEXMFSYSVAR="${prefix}/share/texmf-var"
#export TEXMFLOCAL="${prefix}"
export TEXMFDIST="${prefix}/share/texmf-dist"

texconfig rehash
#fmtutil-sys --all

