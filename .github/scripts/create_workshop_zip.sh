#!/usr/bin/env bash
# Bundle learner materials from episodes/code and episodes/data into
# episodes/workshop.zip for the lesson site download.
set -euo pipefail

root="$(cd "$(dirname "$0")/../.." && pwd)"
staging="$(mktemp -d)"
trap 'rm -rf "$staging"' EXIT

mkdir -p "$staging/workshop"
rsync -a --exclude '.DS_Store' \
  "$root/episodes/code/" "$staging/workshop/code/"
rsync -a --exclude '.DS_Store' \
  "$root/episodes/data/" "$staging/workshop/data/"

rm -f "$root/episodes/workshop.zip"
(cd "$staging" && zip -r "$root/episodes/workshop.zip" workshop)
