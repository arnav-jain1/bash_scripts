#!/bin/bash

# Check if a commit message was provided
if [ "$#" -eq 0 ]; then
    echo "Error: No commit message provided."
    echo "Usage: ./gitpush.sh \"Your commit message\""
    exit 1
fi

# Assign the first argument as the commit message
COMMIT_MESSAGE="$1"

# Ask for confirmation
read -p "The commit message is \"$COMMIT_MESSAGE\". Type 'y' to continue: " CONFIRMATION

# Check if the user confirmed
if [ "$CONFIRMATION" != "y" ]; then
    echo "Commit aborted."
    exit 1
fi

# Pull all changes
git pull

# Add all changes
git add -A

# Commit the changes
git commit -m "$COMMIT_MESSAGE"

# Push the changes
git push
