#!/usr/bin/env bash

# Input directory (default to current dir if not provided)
ROOT_DIR="${1:-.}"

# Output file
OUTPUT_FILE="./.github/dependabot.yml"

# Clear output file (or comment this out if you want to append)
> "$OUTPUT_FILE"

# Optional: write header if needed
cat <<EOF >> "$OUTPUT_FILE"
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    commit-message:
      prefix: "Dependabot (repo and reusable workflows): "
    labels:
      - "DevOps"
      - "dependencies"

EOF

# Loop through all subdirectories
for dir in "$ROOT_DIR"/*/; do
    # Remove trailing slash and extract folder name

    # Skip if not a directory
    [ -d "$dir" ] || continue

    dir_name="$(basename "$dir")"

    # Append template block
    cat <<EOF >> "$OUTPUT_FILE"
  - package-ecosystem: "github-actions"
    directory: "/$dir_name"
    schedule:
      interval: "weekly"
    commit-message:
      prefix: "Dependabot ($dir_name): "
    labels:
      - "DevOps"
      - "dependencies"

EOF

done

echo "Dependabot config generated in $OUTPUT_FILE"
