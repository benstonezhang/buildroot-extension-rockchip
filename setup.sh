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
    echo 'patch buildroot sources:'
    echo 'mask rockchip-mali and rockchip-rkbin'
    sed -E 's|^(\s+source "package/rockchip)|#\1|' -i "$BUILDROOT_DIR/package/Config.in"
    find "$BUILDROOT_DIR/package" -type f -name 'rockchip-*.mk' | while read -r; do
        mv "$REPLY" "${REPLY}.sav"
    done

    echo 'patch ext2 image size'
    grep -q 'y-auto' "$BUILDROOT_DIR/fs/ext2/ext2.mk" > /dev/null || \
    patch -d "$BUILDROOT_DIR" -p1 < "$ROCKCHIP_DIR/patches/0001-ext2-auto-size.patch"

    echo 'patch libv4l'
    grep -q 'v4l-builtin-plugins' "$BUILDROOT_DIR/package/libv4l/libv4l.mk" > /dev/null || \
        patch -d "$BUILDROOT_DIR" -p1 < "$ROCKCHIP_DIR/patches/0002-libv4l-builtin-plugins.patch"
    install -C -m 644 -t "$BUILDROOT_DIR/package/libv4l" "${TOP_DIR}/package/libv4l"/*.patch

    echo 'patch uboot'
    install -C -m 644 -t "$BUILDROOT_DIR/boot/uboot/" "$ROCKCHIP_DIR/patches/0003-uboot-edid-cmd.patch"

    echo 'add ffmpeg-rockchip'
    grep -q BR2_PACKAGE_ROCKCHIP "$BUILDROOT_DIR/package/ffmpeg/Config.in" > /dev/null || \
        patch -d "$BUILDROOT_DIR" -p1 < "$ROCKCHIP_DIR/patches/0010-ffmpeg-mpp-rga.patch"
    grep -q '633e912db087a91a84a2fd7b931ff79662457215dfedac88008dd6a4e2a80ef9' "$BUILDROOT_DIR/package/ffmpeg/ffmpeg.hash" 2>/dev/null || \
    echo 'sha256  633e912db087a91a84a2fd7b931ff79662457215dfedac88008dd6a4e2a80ef9  ffmpeg-7.1.tar.gz' >> "$BUILDROOT_DIR/package/ffmpeg/ffmpeg.hash"
    find "$BUILDROOT_DIR/package/ffmpeg" -type f -name '*.patch' | while read -r; do
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
    # echo "merge file: $ROCKCHIP_DIR/configs/$1"
    while read -r; do
        if check_include "$REPLY"; then
            merge_defconfig "$(echo "$REPLY" | sed 's/^#include *"//; s/".*//')"
        elif ! check_comment "$REPLY"; then
            echo "$REPLY"
        fi
    done < "$ROCKCHIP_DIR/configs/$1"
}

function generate_defconfig() {
    while read -r; do
        if check_include "$REPLY"; then
            merge_defconfig "$(echo "$REPLY" | sed 's/^#include *"//; s/".*//')"
        elif ! check_comment "$REPLY"; then
            echo "$REPLY"
        fi
    done < "$ROCKCHIP_DIR/defconfigs/$RK_BOARD"
}

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 buildroot_dir output_dir [board_name]"
    exit 1
fi

TOP_DIR="$(dirname "$(realpath "$0")")"
BUILDROOT_DIR="$(realpath "$1")"
OUTPUT_DIR="$2"

echo "Top of tree: $TOP_DIR"
echo "Buildroot:   $BUILDROOT_DIR"
echo "Output:      $OUTPUT_DIR"

ROCKCHIP_DIR="${TOP_DIR}/rockchip"
mapfile -t RK_BOARD_ARRAY < <(cd "${ROCKCHIP_DIR}/defconfigs/" && ls -1 rockchip_*_defconfig | sort)
RK_BOARD_ARRAY_LEN=${#RK_BOARD_ARRAY[@]}

if [ "$RK_BOARD_ARRAY_LEN" -eq 0 ]; then
    echo "No available configs in ${ROCKCHIP_DIR}/defconfigs"
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

echo "Done."
echo
echo "Available defconfigs:"
(cd "$TOP_DIR/configs/" && ls -1 rockchip_*_defconfig | sort)
echo
echo "To apply config for $RK_BOARD:"
echo "make -C \"$BUILDROOT_DIR\" BR2_EXTERNAL=\"$TOP_DIR\" O=\"$OUTPUT_DIR\" $RK_BOARD"
