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

# Converts scan-s2 list of transponders to the __sat_transponder structure
transponders() {
    sed -e 's/#.*//g; s/S1/SYS_DVBS/g; s/S2/SYS_DVBS2/g; s/ H / POLARIZATION_HORIZONTAL /g; s/ V / POLARIZATION_VERTICAL /g; s/ R / POLARIZATION_CIRCULAR_RIGHT /g; s/ L / POLARIZATION_CIRCULAR_LEFT /g; s/8PSK/PSK_8/g; s/\//_/g' \
    | grep -vE '^\s*$' \
    | awk '{print "{"$1 ", "$2/1000 ", "$3 ", "$4/1000 ", FEC_"$5 ", ROLLOFF_"$6 ", "$7 "},"}' \
    | sort -u
}

_main $@
