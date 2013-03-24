#!/bin/sh

: ${PPA:='vdr'}
: ${PPA_URL:='http://ppa.launchpad.net/aap'}
: ${DIR:="$(cd "$(dirname "$0")" && pwd)"}

[ ! -f "$HOME/.build.config" ] || . "$HOME/.build.config" && IGNORE_GLOBAL_CONFIG='true'
[ ! -f "$DIR/build.config" ]   || . "$DIR/build.config" && IGNORE_CONFIG='true'

: ${PPA_BUILDER:="$DIR/../ppa-builder"}
: ${PPA_BUILDER_URL:='https://github.com/AndreyPavlenko/ppa-builder.git'}

DEPENDS="$DEPENDS git"
: ${RELATIVE_SRC_DIR:=''}

[ -d "$PPA_BUILDER" ] || git clone "$PPA_BUILDER_URL" "$PPA_BUILDER"
. "$PPA_BUILDER/build.sh"

: ${VDR_SRC_DIR:="$SOURCES_DIR/vdr"}
: ${VDR_SRC_URL:='git://projects.vdr-developer.org/vdr.git'}
: ${VDR_REV:='origin/master'}

update_vdr() {
    _git_update "$VDR_SRC_URL" "$VDR_SRC_DIR" ${VDR_REV#*/} ${VDR_REV%%/*}
}

update() {
    update_vdr
    _git_update "$SRC_URL"
}

_changelog() {
    local cur_version="$(_cur_version "$1")"
    _git_changelog "${cur_version##*~}" "$REV" "$SRC_DIR" "$RELATIVE_SRC_DIR"
}

_checkout() {
    local dest="$1"
    _git_checkout "$dest" "$REV" "$SRC_DIR" "$RELATIVE_SRC_DIR"
}

_vdr_version() {
    git --git-dir="$VDR_SRC_DIR/.git" show $VDR_REV:config.h | grep 'define VDRVERSION' | awk '{print $3}' | tr -d '"'
}

_pkg_version() {
    local version="$1"
    local delta="${2:-"0"}"
    local ci_count="${3:-"$(git --git-dir="$SRC_DIR/.git" log --format='%H' $REV -- "$RELATIVE_SRC_DIR" | wc -l)"}"
    local sha="${4:-"$(git --git-dir="$SRC_DIR/.git" log --format='%h' -n1 $REV -- "$RELATIVE_SRC_DIR")"}"
    local bs_ci_count=$(git --git-dir="$DIR/../.git" log --format='%H' -- "$PKG_NAME" | wc -l)
    local vdr_ci_count=$(git --git-dir="$VDR_SRC_DIR/.git" log --format=%H $VDR_REV | wc -l)
    echo "${version}-$(($ci_count + $vdr_ci_count + $bs_ci_count + $delta))~${sha}"
}

_deb_dir() {
    local deb_dir="$BUILD_DIR/debian"
    
    if [ ! -d "$deb_dir" ]
    then
        cp -r "$DIR/debian" "$deb_dir"
        sed -i "s/#VDR_VERSION#/$(_vdr_version)/g" "$deb_dir/control"
    fi
    
    echo "$deb_dir"
}
