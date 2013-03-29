#!/bin/sh
set -e

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
SRC_URL='git://projects.vdr-developer.org/vdr-plugin-live.git'

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:setup.h | awk -F '[ "]' '/\#define LIVEVERSION / { print $4 }')
    _pkg_version "$version"
}


_deb_dir() {
	local src="$1"
    local deb_dir="$BUILD_DIR/debian"
    
    if [ ! -d "$deb_dir" ]
    then
        cp -r "$DIR/debian" "$deb_dir"
        cp -r "$src/debian/plugin.live.conf" "$deb_dir"
        sed -i "s/#VDR_VERSION#/$(_vdr_version)/g" "$deb_dir/control"
    fi
    
    echo "$deb_dir"
}

_main $@
