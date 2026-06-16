#!/usr/bin/env bash

# Input directory (default to current dir if not provided)
ROOT_DIR="${1:-.}"

# Output file
README_FILE="README.md"

# Clear file
> "$README_FILE"

# Write header
cat <<EOF >> "$README_FILE"
# DfE GitHub-Actions

Welcome to the central repository for GitHub Actions at the DfE!

## Contents

### Actions in this repository

EOF

# Loop through all subdirectories
for dir in "$ROOT_DIR"/*/; do
    [ -d "$dir" ] || continue

    dir_name="$(basename "$dir")"

    echo "* [$dir_name]($dir_name)" >> "$README_FILE"

done

# Append footer
cat <<EOF >> "$README_FILE"

### External actions

These are actions that we support and maintain but are kept in their own repositories!

* [keyvault-yaml-secret](https://github.com/DFE-Digital/keyvault-yaml-secret)

## Source

[github.com/DFE-Digital/github-actions](https://github.com/DFE-Digital/github-actions)

EOF

echo "README generated in $README_FILE"
