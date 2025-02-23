#!/bin/bash

# Check if the user is running the script with sudo privileges
if [[ "$EUID" -ne 0 ]]; then
    echo "Please run as root or use sudo."
    exit 1
fi

# Ensure curl and jq are installed
echo "Checking for required dependencies..."

# Install curl if not found
if ! command -v curl &> /dev/null; then
    echo "curl is not installed. Installing..."
    apt-get update && apt-get install -y curl
fi

# Install jq if not found
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Installing..."
    apt-get update && apt-get install -y jq
fi

# Check for zsh installation
if ! command -v zsh &> /dev/null; then
    echo "zsh is not installed. Installing..."
    apt-get update && apt-get install -y zsh
fi

# Move the ToDo_CLI.sh script to /usr/local/bin
main_path=$(pwd)
SCRIPT_PATH="$main_path/ToDo_CLI.sh"
INSTALL_PATH="/usr/local/bin/todo"

echo "Moving ToDo_CLI.sh to $INSTALL_PATH..."

# Ensure the script exists
if [ ! -f "$SCRIPT_PATH" ]; then
    echo "Error: $SCRIPT_PATH not found."
    exit 1
fi

# Copy the script to /usr/local/bin
cp "$SCRIPT_PATH" "$INSTALL_PATH"

# Make the script executable
chmod +x "$INSTALL_PATH"

echo "Task management script has been installed at $INSTALL_PATH"

# Provide instructions to configure the script
echo "Please configure the script by editing $INSTALL_PATH and setting your SUPABASE_URL and SUPABASE_API_KEY."

# Suggest adding an alias to .bashrc or .zshrc for easier access
echo "You can add an alias to your .bashrc or .zshrc for easier access to the script:"
echo "echo 'alias {YOUR SHORTCUT HERE, without the baraces}=\"$INSTALL_PATH\"' >> ~/.bashrc"
echo "source ~/.bashrc"

echo "Installation complete."
