#!/bin/bash


if [ $# -eq 0 ]; then
  echo "Usage: $0 data.md"
  exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
  echo "Error: File $1 does not exist"
  exit 1
fi

if [ -z "${BACKEND_URL:-}" ]; then
  echo "Error: BACKEND_URL environment variable not set."
  echo "Example: export BACKEND_URL=http://localhost:8000"
  exit 1
fi

FILE="$1"
current_target=""
current_goal=""

while IFS= read -r line; do
  if [[ $line == \|*target* ]]; then
    current_target=$(echo "$line" | cut -d '|' -f3 | xargs | sed 's/%//')
    # Validate that it's a number
    if ! [[ $current_target =~ ^[0-9]+$ ]]; then
      current_target=""
      current_goal=""
      continue
    fi
  elif [[ $line == \|*goal* ]]; then
    current_goal=$(echo "$line" | cut -d '|' -f3 | xargs)

    if [[ -n $current_target && -n $current_goal ]]; then
      json="{\"name\": \"$current_goal\", \"targetPercentage\": $current_target}"

      curl -s -X POST "$BACKEND_URL/api/goals" \
        -H "Content-Type: application/json" \
        -d "$json"
      current_target=""
      current_goal=""
    fi
  fi
done < "$FILE"
