#!/usr/bin/env bash
set -euo pipefail

\
# Generate sha256 for all files under a directory.
# Usage: ./scripts/make_hashes.sh /path/to/artifacts > manifest.sha256
#
# Why this exists:
# - You need a reliable integrity check for air-gapped model transport.
# - Large files get corrupted more often than you think.

DIR="${1:-}"
if [[ -z "${DIR}" || ! -d "${DIR}" ]]; then
  echo "ERROR: Provide an existing directory. Example: $0 ./artifacts" >&2
  exit 2
fi

# deterministic ordering
find "${DIR}" -type f -maxdepth 5 -print0 \
  | sort -z \
  | xargs -0 sha256sum
