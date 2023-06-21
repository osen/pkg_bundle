export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${prefix}/lib/vlc"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${prefix}/lib/qt5"

export QT_QPA_PLATFORM_PLUGIN_PATH="${prefix}/lib/qt5/plugins"
export VLC_PLUGIN_PATH="${prefix}/lib/vlc/plugins"

export XDG_DATA_DIRS="${prefix}/share:${XDG_DATA_DIRS}"

"${prefix}/lib/vlc/vlc-cache-gen" "${prefix}/lib/vlc/plugins"
