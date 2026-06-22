#!/bin/bash
# Auto-sync latest CedarX libraries and demo binaries from TinaSDK build rootfs
# Usage:
#   ./update_cedar_libs.sh [ROOTFS_DIR]
#
# If ROOTFS_DIR is not given, default is:
#   ../out/r818-sc3917/compile_dir/target/rootfs

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

ROOTFS_DIR="${1:-"${PROJECT_ROOT}/out/r818-sc3917/compile_dir/target/rootfs"}"
LIB_SRC="${ROOTFS_DIR}/usr/lib"
BIN_SRC="${ROOTFS_DIR}/usr/bin"

LIB_DST="${SCRIPT_DIR}/lib"
BIN_DST="${SCRIPT_DIR}/bin"

if [[ ! -d "${LIB_SRC}" || ! -d "${BIN_SRC}" ]]; then
    echo "[ERR] ROOTFS_DIR seems invalid: ${ROOTFS_DIR}" >&2
    echo "      Expected directories: ${LIB_SRC} and ${BIN_SRC}" >&2
    exit 1
fi

mkdir -p "${LIB_DST}" "${BIN_DST}"

echo "[INFO] Using ROOTFS_DIR = ${ROOTFS_DIR}" 
echo "[INFO] Updating libs in   ${LIB_DST}" 
echo "[INFO] Updating binaries in ${BIN_DST}" 

# Update libraries: only for libraries that already exist in cedar_libs/lib
if compgen -G "${LIB_DST}/*.so*" > /dev/null; then
    echo "[INFO] Updating libraries..."
    for dst in "${LIB_DST}"/*.so*; do
        base="$(basename "${dst}")"
        src="${LIB_SRC}/${base}"
        if [[ -e "${src}" ]]; then
            echo "  copy ${base}"
            cp -av "${src}" "${LIB_DST}/" >/dev/null
        else
            echo "  [WARN] ${base} not found in ${LIB_SRC}, skip" >&2
        fi
    done
else
    echo "[INFO] No existing *.so in ${LIB_DST}, nothing to update."
fi

# Update executables: only for files that already exist in cedar_libs/bin
if compgen -G "${BIN_DST}/*" > /dev/null; then
    echo "[INFO] Updating binaries..."
    for dst in "${BIN_DST}"/*; do
        base="$(basename "${dst}")"
        src="${BIN_SRC}/${base}"
        if [[ -x "${src}" ]]; then
            echo "  copy ${base}"
            cp -av "${src}" "${BIN_DST}/" >/dev/null
        else
            echo "  [WARN] ${base} not found or not executable in ${BIN_SRC}, skip" >&2
        fi
    done
else
    echo "[INFO] No existing files in ${BIN_DST}, nothing to update."
fi

echo "[INFO] Done."
