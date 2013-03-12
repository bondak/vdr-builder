#!/bin/sh
set -e

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
SRC_DIR_NAME='xbmc-pvr-addons'
SRC_URL='https://github.com/opdenkamp/xbmc-pvr-addons.git'
RELATIVE_SRC_DIR='addons/pvr.vdr.vnsi/vdr-plugin-vnsiserver'

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local delta='409'
    local version=$(git --git-dir="$SRC_DIR/.git" show "$REV:$RELATIVE_SRC_DIR/vnsi.h" | awk '/static const char \*VERSION *=/ { print $6 }' | tr -d '[";]')
    _pkg_version "$version" "$delta"
}

_deb_dir() {
    local deb_dir="$BUILD_DIR/debian"
    
    if [ ! -d "$deb_dir" ]
    then
        local makefile="$1/Makefile"
        local name="$(awk '/PLUGIN *= */ {print $3}' "$makefile")"
        cp -r "$DIR/debian" "$deb_dir"
        sed -i "s/vnsiserver/$name/g" "$deb_dir/links"
        sed -i "s/#VDR_VERSION#/$(_vdr_version)/g" "$deb_dir/control"
    fi

    echo "$deb_dir"
}

_main $@
