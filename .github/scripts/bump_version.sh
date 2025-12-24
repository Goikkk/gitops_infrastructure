#!/bin/bash

BUMP_TYPE="$1"
TAGS="$2"

if [ -z "$BUMP_TYPE" ] || [ -z "$TAGS" ]; then
    echo "Usage: $0 <bump_type> <tags>"
    exit 1
fi

HIGHEST="0.0.0"
for TAG in $TAGS; do
  if [[ $TAG =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    if [ "$(printf '%s\n' "$HIGHEST" "$TAG" | sort -V | tail -n1)" = "$TAG" ]; then
      HIGHEST=$TAG
    fi
  fi
done

IFS='.' read -r MAJOR MINOR PATCH <<< "$HIGHEST"

case $BUMP_TYPE in
  major) echo "$((MAJOR + 1)).0.0" ;;
  minor) echo "$MAJOR.$((MINOR + 1)).0" ;;
  patch) echo "$MAJOR.$MINOR.$((PATCH + 1))" ;;
  *) echo "Error: BUMP_TYPE must be 'major', 'minor', or 'patch'. Provided value: '$BUMP_TYPE'" && exit 1 ;;
esac
