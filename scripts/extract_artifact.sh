#!/usr/bin/env bash
set -euo pipefail

\
# Extract a .tar.zst artifact to a target dir.
# Requires: tar, zstd
#
# Usage:
#   ./scripts/extract_artifact.sh /path/file.tar.zst /models/gguf

ARCHIVE="${1:-}"
DEST="${2:-}"

if [[ -z "${ARCHIVE}" || ! -f "${ARCHIVE}" ]]; then
  echo "ERROR: archive not found: ${ARCHIVE}" >&2
  exit 2
fi
if [[ -z "${DEST}" ]]; then
  echo "ERROR: provide destination dir" >&2
  exit 2
fi

mkdir -p "${DEST}"

echo "Extracting ${ARCHIVE} -> ${DEST}"
tar --use-compress-program=unzstd -xf "${ARCHIVE}" -C "${DEST}"

echo "Done."
