#!/bin/zsh

# Global file to store project root paths
TODO_GLOBAL_DB="$HOME/.todo_projects"
github = "this.github.com" 

# Ensure the global project database exists
touch "$TODO_GLOBAL_DB"

# Function to initialize a project for todo tracking
todo_init() {
    local project_name="$1"
    
    if [[ -z "$project_name" ]]; then
        echo "❌ Please provide a project name."
        return 1
    fi

    local project_path=$(pwd)
    
    # Store the project path in the global database
    echo "$project_name:$project_path" >> "$TODO_GLOBAL_DB"
    
    # Create the todo.md file in the project directory
    touch "$project_path/todo.md"
    
    echo "✅ Initialized todo for project '$project_name' at $project_path"
}

# Function to find the root project directory
find_project_root() {
    local current_dir=$(pwd)
    
    while [[ "$current_dir" != "/" ]]; do
        if [[ -f "$current_dir/todo.md" ]]; then
            echo "$current_dir"
            return 0
        fi
        current_dir=$(dirname "$current_dir")  # Move one directory up
    done

    echo ""
}

# Function to add a task
todo_add() {
    local message="$1"
    
    # Find the root directory where todo.md exists
    local project_root=$(find_project_root)
    
    if [[ -z "$project_root" ]]; then
        echo "⚠️ No todo.md found in this project. Did you run 'todo init <project_name>'?"
        return 1
    fi

    echo "- $message" >> "$project_root/todo.md"
    echo "✅ Added to $project_root/todo.md: $message"
}

# Function to list tasks
todo_list() {
    local project_root=$(find_project_root)

    if [[ -z "$project_root" ]]; then
        echo "⚠️ No todo.md found in this project. Did you run 'todo init <project_name>'?"
        return 1
    fi

    echo "\n📌 Todo List in "$(basename "$project_root")":\n----------------------"
    cat "$project_root/todo.md"
}

todo_help(){
    echo "welcome to the HELP menu :)"
    echo "Here is the project github page if you need more help : $github"
}

# Handle CLI arguments
if [[ "$1" == "init" && -n "$2" ]]; then
    todo_init "$2"
elif [[ "$1" == "commit-m" && -n "$2" ]]; then
    todo_add "$2"
elif [[ "$1" == "list" ]]; then
    todo_list
elif [[ "$1" == "-help" || "$1" == "-h" || "$1" == "--help" ]]; then
    todo_help
else
    echo "Usage: todo init <project_name>, todo commit-m \"Your task message\", todo list"
fi
