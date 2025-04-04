

# Documentation for Requirement 1: Adding Data to the Backend

This document explains how I implemented the functionality to add data to the backend application and the reasoning behind the design decisions. The goal was to seed the backend with goals by sending JSON-formatted data via a POST request.

## Overview

The task was to read a data file (e.g., `data.md`), extract each goal along with its target percentage, and then send this data to a Laravel backend that accepts JSON at the endpoint `/api/goals`. The solution needed to be configurable, support different data files, and include sufficient error handling.

## Implementation Details

### 1. Accepting a Data File as a Parameter

- **Problem:** We needed to allow the data file to be passed as an argument so that different data files can be used.
- **Solution:**  
  I check the number of arguments provided using the `$#` variable. If no file is provided, the script outputs a usage message and exits. This ensures that the user knows the correct way to run the script.
- **Code Reference:**
  ```bash
  if [ $# -eq 0 ]; then
    echo "Usage: $0 data.md"
    exit 1
  fi
  ```

### 2. Configurable REST Endpoint via Environment Variable

- **Problem:** The REST endpoint for posting data must be configurable, so that the script is not tied to a specific URL.
- **Solution:**  
  The script checks if the `BACKEND_URL` environment variable is set. If it isn’t set, an error is printed, and the script exits. This approach ensures flexibility as the URL can be configured outside the script.
- **Code Reference:**
  ```bash
  if [ -z "${BACKEND_URL:-}" ]; then
    echo "Error: BACKEND_URL environment variable not set."
    echo "Example: export BACKEND_URL=http://localhost:8000"
    exit 1
  fi
  ```

### 3. Reading and Processing the Data File

- **Problem:** The data file, assumed to be in Markdown format with table-like rows, needs to be parsed to extract the goal name and its target percentage.
- **Solution:**  
  The script reads the file line by line. It looks for lines that contain the words "target" and "goal" and uses `cut`, `xargs`, and `sed` to extract and clean the data.
- **Why This Approach:**  
  This method is straightforward for processing structured text files and allows us to validate and sanitize input data.
- **Code Reference:**
  ```bash
  while IFS= read -r line; do
    if [[ $line == \|*target* ]]; then
      current_target=$(echo "$line" | cut -d '|' -f3 | xargs | sed 's/%//')
      if ! [[ $current_target =~ ^[0-9]+$ ]]; then
        current_target=""
        current_goal=""
        continue
      fi
    elif [[ $line == \|*goal* ]]; then
      current_goal=$(echo "$line" | cut -d '|' -f3 | xargs)
      ...
    fi
  done < "$FILE"
  ```

### 4. Posting Data Using Curl

- **Problem:** We need to send each valid goal as a JSON payload to the backend.
- **Solution:**  
  Once both a goal name and a valid target percentage are extracted, the script constructs a JSON object and sends it via a `POST` request using curl.
- **Setting Content-Type:**  
  Even though we format the data as JSON manually, specifying `Content-Type: application/json` in the header ensures the server knows to process the request body as JSON.
- **Code Reference:**
  ```bash
  if [[ -n $current_target && -n $current_goal ]]; then
    json="{\"name\": \"$current_goal\", \"targetPercentage\": $current_target}"
    curl -s -X POST "$BACKEND_URL/api/goals" \
      -H "Content-Type: application/json" \
      -d "$json"
    current_target=""
    current_goal=""
  fi
  ```

### 5. Error Handling

- **Problem:** The script must handle potential errors such as missing parameters or malformed data.
- **Solution:**  
  The script includes checks for:
    - The presence of a command-line argument (data file).
    - The existence of the `BACKEND_URL` environment variable.
    - Validating that the target percentage is a number before proceeding.
- **Why This Matters:**  
  These error handling measures ensure that the script behaves predictably and provides informative messages when something goes wrong, which is essential for maintainability and debugging.

## Conclusion

The Bash script `add_data.sh` meets all the requirements for seeding the backend with goals:

- It reads the data file provided as a command-line argument.
- It uses the `BACKEND_URL` environment variable to determine where to send the data.
- It extracts and validates the data correctly.
- It posts the data to the backend in JSON format with the correct Content-Type header.
- It includes robust error handling to ensure smooth operation.

This approach was chosen for its simplicity, flexibility, and clarity, making it easier to maintain and adapt to future requirements.

---

