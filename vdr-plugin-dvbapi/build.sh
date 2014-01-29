#!/bin/sh
set -e

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
SRC_URL='https://github.com/manio/vdr-plugin-dvbapi.git'
REV='9b4ddce97beb0bbccd733d82510092dd7a6b9bb2'

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local delta='55'
    local version=$(git --git-dir="$SRC_DIR/.git" show $REV:DVBAPI.h | awk '/static const char \*VERSION *=/ {print $6}' | tr -d '[";]')
    _pkg_version "2.0.0" "$delta"
}

_main $@
