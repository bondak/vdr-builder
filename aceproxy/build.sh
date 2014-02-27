#!/bin/sh
set -e

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
SRC_URL='https://github.com/ValdikSS/aceproxy.git'

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local version=$(git --git-dir="$SRC_DIR/.git" describe | awk -F '[v-]' '{print $2}')
    _pkg_version "$version"
}

_main $@
