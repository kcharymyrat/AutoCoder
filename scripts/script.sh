#!/bin/bash

# Function to simulate fetching issue details from GitHub API
fetch_issue_details() {
    # Simulate fetching data from an API (hardcoded sample data)
    echo '{"body": "This is a sample issue body."}'
}

# Function to simulate sending prompt to the ChatGPT model (OpenAI API)
send_prompt_to_chatgpt() {
    # Simulate sending prompt and receiving response from the model (hardcoded sample data)
    echo '{"choices": [{"message": {"content": "{\"file1\": \"sample code 1\", \"file2\": \"sample code 2\"}"}}]}'
}

# Function to save code snippet to file
save_to_file() {
    local filename="autocoder-bot/$1"
    local code_snippet="$2"

    mkdir -p "$(dirname "$filename")"
    echo -e "$code_snippet" > "$filename"
    echo "The code has been written to $filename"
}

# Fetch and process issue details (simulated)
RESPONSE=$(fetch_issue_details)
ISSUE_BODY=$(echo "$RESPONSE" | jq -r .body)

if [[ -z "$ISSUE_BODY" ]]; then
    echo 'Error: Issue body is empty or not found in the simulated response.'
    exit 1
else
    echo "Issue body: $ISSUE_BODY"
fi

# Define clear, additional instructions for GPT regarding the response format
INSTRUCTIONS="Based on the description below, please generate a JSON object where the keys represent file paths and the values are the corresponding code snippets for a production-ready application. The response should be a valid strictly JSON object without any additional formatting, markdown, or characters outside the JSON structure."

# Combine the instructions with the issue body to form the full prompt
FULL_PROMPT="$INSTRUCTIONS\n\n$ISSUE_BODY"

# Prepare the messages array for the ChatGPT API, including the instructions
MESSAGES_JSON=$(jq -n --arg body "$FULL_PROMPT" '[{"role": "user", "content": $body}]')

# Simulate sending the prompt to the ChatGPT model and receiving a response
RESPONSE=$(send_prompt_to_chatgpt)

if [[ -z "$RESPONSE" ]]; then
    echo "Error: No response received from the simulated ChatGPT model."
    exit 1
else
    echo "Response from simulated ChatGPT model: $RESPONSE"
fi

# Extract the JSON dictionary from the response
FILES_JSON=$(echo "$RESPONSE" | jq -r '.choices[0].message.content')

if [[ -z "$FILES_JSON" ]]; then
    echo "Error: No valid JSON dictionary found in the simulated response."
    exit 1
fi

# Iterate over each key-value pair in the JSON dictionary and save to file
for key in $(echo "$FILES_JSON" | jq -r 'keys[]'); do
    FILENAME=$key
    CODE_SNIPPET=$(echo "$FILES_JSON" | jq -r --arg key "$key" '.[$key]')
    CODE_SNIPPET=$(echo "$CODE_SNIPPET" | sed 's/\r$//') # Normalize line endings
    save_to_file "$FILENAME" "$CODE_SNIPPET"
done

echo "All files have been processed successfully."
