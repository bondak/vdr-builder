#!/bin/sh
set -e

PKG_NAME="$(cd "$(dirname "$0")"; basename "$PWD")"
WICARD_URL='http://sat-forum.info/download/index.php?directory=WICARD'

DIR="$(cd "$(dirname "$0")" && pwd)"
. "$DIR/../commons.sh"

wicard_dir_url() {
    local dir="$(curl "$WICARD_URL" 2>/dev/null | grep -Eo "directory=WICARD/wicardd-[a-zA-Z_0-9\.]+")"
    echo "$WICARD_URL" | sed "s;directory=WICARD;$dir;"
}

version() {
	local bs_ci_count=$(git --git-dir="$DIR/../.git" log --format='%H' -- "$PKG_NAME" | wc -l)
    local version="$(curl "$WICARD_URL" 2>/dev/null | grep -Eo "directory=WICARD/wicardd-[a-zA-Z_0-9\.]+" | awk -F '[-_]' '{print $2}')"
    echo "$version-$bs_ci_count"
}

_checkout() {
    local dest="$1"
    mkdir -p "$dest"
    cp -r "$DIR/data"/* "$dest"
}

_deb_dir() {
    local deb_dir="$BUILD_DIR/debian"
    
    if [ ! -d "$deb_dir" ]
    then
        cp -r "$DIR/debian" "$deb_dir"
        sed -i "s;@WICARD_URL_PATTERN@;$(wicard_dir_url)\&filename=@FILENAME@\&action=downloadfile;g" "$deb_dir/rules"
    fi
    
    echo "$deb_dir"
}

_changelog() {
	echo "  * Version $(version)"
}

update() {
    echo
}

_main $@
