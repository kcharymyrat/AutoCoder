#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Get inputs from the environment
GITHUB_TOKEN="$1"
REPOSITORY="$2"
ISSUE_NUMBER="$3"
OPENAI_API_KEY="$4"

# Function to generate random JSON content
generate_random_json() {
  cat <<EOF
{
  "id": "$(uuidgen)",
  "name": "$(head /dev/urandom | tr -dc A-Za-z | head -c 10)",
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "value": "$(shuf -i 1-100 -n 1)"
}
EOF
}

# Generate the random JSON content
RANDOM_JSON=$(generate_random_json)

# Save the JSON content to a file
ARTIFACT_DIR="autocoder-artifact"
mkdir -p "$ARTIFACT_DIR"
JSON_FILE="$ARTIFACT_DIR/random_data.json"
echo "$RANDOM_JSON" > "$JSON_FILE"

# List all the files ensuring to list directories and files recursively
echo "Listing all files in $ARTIFACT_DIR:"
find "$ARTIFACT_DIR"
