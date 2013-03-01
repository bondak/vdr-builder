#!/bin/sh
set -e

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
SRC_URL='https://github.com/manio/vdr-plugin-dvbapi.git'

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local delta='9'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:DVBAPI.h | awk '/static const char \*VERSION *=/ {print $6}' | tr -d '[";]')
    _pkg_version "$version" "$delta"
}

_main $@
