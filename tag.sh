#!/bin/bash
set -e

VERSION="${1:?Usage: ./tag.sh VERSION MESSAGE  (e.g. ./tag.sh 3.0.0 \"Release v3.0.0\")}"
MESSAGE="${2:-Release v${VERSION}}"
MAJOR="$(echo "$VERSION" | cut -d. -f1)"

git tag -a "v${VERSION}" -m "${MESSAGE}"
git tag -fa "v${MAJOR}" -m "${MESSAGE}"
git push origin "v${VERSION}"
git push origin "v${MAJOR}" --force
