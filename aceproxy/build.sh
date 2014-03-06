#!/bin/sh
set -e

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
SRC_URL='https://github.com/ValdikSS/aceproxy.git'

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

version() {
    local delta='235'
    local ci_count="$(git --git-dir="$SRC_DIR/.git" log --format='%H' $REV -- "$RELATIVE_SRC_DIR" | wc -l)"
    local sha="$(git --git-dir="$SRC_DIR/.git" log --format='%h' -n1 $REV -- "$RELATIVE_SRC_DIR")"
    local bs_ci_count="$(git --git-dir="$DIR/../.git" log --format='%H' -- "$PKG_NAME" | wc -l)"
    local version=$(git --git-dir="$SRC_DIR/.git" describe | awk -F '[v-]' '{print $2}')
    echo "${version}-$(($ci_count + $bs_ci_count + $delta))~${sha}"
}

_main $@
