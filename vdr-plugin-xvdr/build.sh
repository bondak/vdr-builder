#!/bin/sh
set -e

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
SRC_URL='https://github.com/pipelka/vdr-plugin-xvdr.git'

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local delta='14'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:src/xvdr/xvdr.h | grep 'static const char \*VERSION *=' | awk '{ print $6 }' | tr -d '[";]')
    _pkg_version "$version" "$delta"
}

_main $@
