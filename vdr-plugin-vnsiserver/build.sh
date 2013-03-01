#!/bin/sh
set -e

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
SRC_DIR_NAME='xbmc-pvr-addons'
SRC_URL='https://github.com/opdenkamp/xbmc-pvr-addons.git'
RELATIVE_SRC_DIR='addons/pvr.vdr.vnsi/vdr-plugin-vnsiserver'

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local delta='406'
    local version=$(git --git-dir="$SRC_DIR/.git" show "$REV:$RELATIVE_SRC_DIR/vnsi.h" | awk '/static const char \*VERSION *=/ { print $6 }' | tr -d '[";]')
    _pkg_version "$version" "$delta"
}

_main $@
