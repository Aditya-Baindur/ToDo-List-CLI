#!/bin/zsh

# Supabase configuration
SUPABASE_URL=""
SUPABASE_API_KEY=""
TABLE_NAME="tasks"

# Priority queue file (local storage)
TODO_FILE="$HOME/.todo_queue"

# Ensure the file exists
touch "$TODO_FILE"

# Function to add a task
todo_add() {
    local message="$1"
    echo "$message" >> "$TODO_FILE"
    echo "✅ Added to local queue: $message"
    
    # Push to Supabase
    curl -X POST "$SUPABASE_URL/rest/v1/$TABLE_NAME" \
        -H "apikey: $SUPABASE_API_KEY" \
        -H "Content-Type: application/json" \
        -H "Prefer: return=minimal" \
        --data-binary "{\"message\": \"$message\"}"
    echo "🚀 Task pushed to Supabase."
}

# Function to list all tasks
todo_list() {
    echo "\n📌 Local Task Queue:\n----------------------"
    cat "$TODO_FILE" | nl -w2 -s'. '
    
    echo "\n🌍 Fetching tasks from Supabase..."
    RESPONSE=$(curl -s -X GET "$SUPABASE_URL/rest/v1/$TABLE_NAME" \
        -H "apikey: $SUPABASE_API_KEY" \
        -H "Content-Type: application/json")
    
    if [[ $(echo "$RESPONSE" | jq type) == '"array"' ]]; then
        echo "\n📝 Tasks from Supabase:\n----------------------"
        echo "$RESPONSE" | jq -r '.[] | "🆔 \(.id) | 📅 \(.created_at) | ✏️  \(.message)"'
    else
        echo "⚠️ Error fetching tasks from Supabase or no tasks found."
        echo "$RESPONSE"
    fi
}

# Function to delete a task from local
todo_delete_local() {
    local task_id="$1"
    
    # Remove from local file by deleting the line that matches the task_id
    sed -i '' "/^$task_id /d" "$TODO_FILE"  # Ensure matching the task ID at the beginning of the line
    echo "✅ Task ID $task_id removed from local queue."
}


# Function to delete a task from Supabase
todo_delete_supabase() {
    local task_id="$1"
    
    # Remove from Supabase
    curl -X DELETE "$SUPABASE_URL/rest/v1/$TABLE_NAME?id=eq.$task_id" \
        -H "apikey: $SUPABASE_API_KEY" \
        -H "Content-Type: application/json"
    echo "🚀 Task ID $task_id deleted from Supabase."
}

# Function to delete all tasks locally
todo_delete_all_local() {
    > "$TODO_FILE"  # Empty the local task file
    echo "✅ All tasks removed from local queue."
}

# Function to delete all tasks from Supabase
todo_delete_all_supabase() {
    curl -X DELETE "$SUPABASE_URL/rest/v1/$TABLE_NAME" \
        -H "apikey: $SUPABASE_API_KEY" \
        -H "Content-Type: application/json"
    echo "🚀 All tasks deleted from Supabase."
}

# Alias command parsing
if [[ "$1" == "commit-m" && -n "$2" ]]; then
    todo_add "$2"
elif [[ "$1" == "list" ]]; then
    todo_list
elif [[ "$1" == "delete" && -n "$2" ]]; then
    if [[ "$2" == "local" && "$3" == "-a" ]]; then
        todo_delete_all_local
    elif [[ "$2" == "local" && -n "$3" ]]; then
        todo_delete_local "$3"
    else
        todo_delete_supabase "$2"
    fi
elif [[ "$1" == "delete" && "$2" == "all" ]]; then
    todo_delete_all_local
    todo_delete_all_supabase
else
    filename= pwd
    echo "Usage: ${filename%.*} commit-m \"Your task message\", ${filename%.*} list, ${filename%.*} delete <task_id>, ${filename%.*} delete local -a or ${filename%.*} delete local <task_id>"
fi
