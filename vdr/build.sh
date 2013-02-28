#!/bin/sh
set -e

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

REV="$VDR_REV"

version() {
    local delta='42'
    _pkg_version "$(_vdr_version)" "$delta" 0
}

update() {
    update_vdr
}

_deb_dir() {
    local deb_dir="$BUILD_DIR/debian"
    
    if [ ! -d "$deb_dir" ]
    then
        cp -r "$DIR/debian" "$deb_dir"
        cp -r "$DIR/configs" "$deb_dir"
        cp -r "$DIR/scripts" "$deb_dir"
    fi
    
    echo "$deb_dir"
}

_main $@
