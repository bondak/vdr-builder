#!/bin/sh
set -e

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
SRC_URL='https://github.com/pipelka/vdr-plugin-wirbelscan.git'

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:wirbelscan.c | awk '/const char \*VERSION/ {print $6}' | tr -d '[";]')
    _pkg_version "$version"
}

_main $@
