#!/usr/bin/env bash
set -euo pipefail

\
# Download a single artifact from Artifactory with retries and basic checks.
#
# Required env:
#   ARTIFACTORY_BASE_URL   e.g. https://host/artifactory/llm-models
#   ARTIFACTORY_TOKEN      bearer token
#   URL_PATH               path under base url
#   OUT_FILE               local output file
#   EXPECTED_SHA256        required
#
# Optional env:
#   DRY_RUN=1
#   CURL_CA_BUNDLE=/path/to/ca.pem

: "${ARTIFACTORY_BASE_URL:?missing}"
: "${ARTIFACTORY_TOKEN:?missing}"
: "${URL_PATH:?missing}"
: "${OUT_FILE:?missing}"
: "${EXPECTED_SHA256:?missing}"

if [[ "${DRY_RUN:-0}" == "1" ]]; then
  echo "DRY_RUN: would download ${ARTIFACTORY_BASE_URL}/${URL_PATH} -> ${OUT_FILE}"
  exit 0
fi

tmp="${OUT_FILE}.partial"
mkdir -p "$(dirname "${OUT_FILE}")"

echo "Downloading: ${ARTIFACTORY_BASE_URL}/${URL_PATH}"
curl -fL --retry 5 --retry-delay 2 \
  -H "Authorization: Bearer ${ARTIFACTORY_TOKEN}" \
  "${ARTIFACTORY_BASE_URL}/${URL_PATH}" \
  -o "${tmp}"

echo "Verifying sha256..."
got="$(sha256sum "${tmp}" | awk '{print $1}')"
if [[ "${got}" != "${EXPECTED_SHA256}" ]]; then
  echo "ERROR: sha256 mismatch for ${URL_PATH}" >&2
  echo "  expected: ${EXPECTED_SHA256}" >&2
  echo "  got:      ${got}" >&2
  exit 3
fi

mv -f "${tmp}" "${OUT_FILE}"
echo "OK: ${OUT_FILE}"
