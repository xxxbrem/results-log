#!/bin/bash

cp -r ../snow-spider-agent/methods/spider-self-refine/output ./

TARGET_DIR="./" 
COMMIT_MESSAGE="Auto commit and push at $(date +"%Y-%m-%d %H:%M:%S")"

cd "$TARGET_DIR" || exit

if [ ! -d .git ]; then
    echo "Error: $TARGET_DIR is not a Git repository."
    exit 1
fi

git add .

if git diff --cached --quiet; then
    echo "No changes to commit."
    exit 0
fi

git commit -m "$COMMIT_MESSAGE"

git push || echo "Git push failed. Check your network or credentials."
