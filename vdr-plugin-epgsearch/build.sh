#!/bin/sh
set -e

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
SRC_URL='git://projects.vdr-developer.org/vdr-plugin-epgsearch.git'

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:epgsearch.c | awk -F '[=\\-"]' '/static const char VERSION/ {print $3}')
    _pkg_version "$version"
}

_main $@
