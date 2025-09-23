#!/bin/sh

tag=$1
date="$(git show "$tag" --format=%cD --no-patch)"
GIT_COMMITTER_DATE="$date" git tag -a -f "$tag" "$tag"
