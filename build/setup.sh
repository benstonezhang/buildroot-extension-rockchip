#!/bin/bash -e

function choose_board() {
	echo
	echo "Pick a board:"
	for i in $(seq 0 "$(($RK_BOARD_ARRAY_LEN - 1))"); do
	    echo "  $i. ${RK_BOARD_ARRAY[$i]}"
	done

	local INDEX
	while true; do
		read -p "Which would you like? [0]: " INDEX
		INDEX=${INDEX:-0}

		if echo $INDEX | grep -vq '[^0-9]'; then
			RK_BOARD="${RK_BOARD_ARRAY[$INDEX]}"
			[ -z "$RK_BOARD" ] || break
		fi

		echo "Choice not available. Please try again."
	done
}

function patch_buildroot() {
    sed -E 's|^(\s+source "package/rockchip.*)$|#\1|' -i "$BUILDROOT_DIR/package/Config.in"
    find "$BUILDROOT_DIR/package" -type f -name 'rockchip-*.mk' | while read -r; do
        mv "$REPLY" "${REPLY}.sav"
    done
}

function check_include() {
    echo "$1" | grep '^#include' >/dev/null
}

function check_comment() {
    [ "_$1" == "_" ] || echo "$1" | grep '^#' >/dev/null
}

function merge_defconfig() {
    # echo "merge file: $SCRIPTS_DIR/rockchip/$1"
    while read -r; do
        if check_include "$REPLY"; then
            merge_defconfig "$(echo "$REPLY" | sed 's/^#include *"//; s/".*//')"
        elif ! check_comment "$REPLY"; then
            echo "$REPLY"
        fi
    done < "$SCRIPTS_DIR/rockchip/$1"
}

function generate_defconfig() {
    while read -r; do
        if check_include "$REPLY"; then
            merge_defconfig "$(echo "$REPLY" | sed 's/^#include *"//; s/".*//')"
        elif ! check_comment "$REPLY"; then
            echo "$REPLY"
        fi
    done < "$SCRIPTS_DIR/defconfigs/$RK_BOARD"
}

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 buildroot_dir output_dir [board_name]"
    exit 1
fi

SCRIPTS_DIR="$(dirname "$(realpath "$0")")"
BUILDROOT_DIR="$(realpath "$1")"
TOP_DIR="$(realpath "${SCRIPTS_DIR}/..")"
OUTPUT_DIR="$2"

echo "Top of tree: $TOP_DIR"
echo "Buildroot:   $BUILDROOT_DIR"
echo "Output:      $OUTPUT_DIR"

RK_BOARD_ARRAY=($(cd "${SCRIPTS_DIR}/defconfigs/" && ls -1 rockchip_*_defconfig | sort))
RK_BOARD_ARRAY_LEN=${#RK_BOARD_ARRAY[@]}

if [ "$RK_BOARD_ARRAY_LEN" -eq 0 ]; then
    echo "No available configs in ${SCRIPTS_DIR}/defconfigs"
    exit 1
fi

if [ "$#" -eq 3 ]; then
    RK_BOARD="rockchip_${3}_defconfig"
else
    choose_board
fi

patch_buildroot

mkdir -p "$TOP_DIR/configs" "$OUTPUT_DIR"
generate_defconfig > "$TOP_DIR/configs/$RK_BOARD"

echo "Done. To apply defconfig: "
echo "make -C \"$BUILDROOT_DIR\" BR2_EXTERNAL=\"$TOP_DIR\" O=\"$OUTPUT_DIR\" $RK_BOARD"
