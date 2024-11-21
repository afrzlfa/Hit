#!/bin/bash

GITHUB_TOKEN="your_personal_access_token"
GITHUB_USER="your_github_username"
REPO_NAME="your_repository_name"
BRANCH_NAME="main"
COMMIT_MESSAGE="Empty commit"
REPO_PATH="/path/to/your/repository"
API_URL="https://api.github.com"
REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME"

cd $REPO_PATH || { echo "Repository path not found"; exit 1; }

if [ ! -d ".git" ]; then
    echo "Git repository not initialized in this directory."
    exit 1
fi

LAST_COMMIT_SHA=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
                       -H "Accept: application/vnd.github.v3+json" \
                       -H "User-Agent: GitHub-Bash-Script" \
                       "$API_URL/repos/$GITHUB_USER/$REPO_NAME/branches/$BRANCH_NAME" | \
                       jq -r '.commit.sha')

if [ "$LAST_COMMIT_SHA" == "null" ]; then
    echo "Failed to fetch the latest commit SHA."
    exit 1
fi

echo "Latest commit SHA: $LAST_COMMIT_SHA"

git add .
git commit --allow-empty -m "$COMMIT_MESSAGE"

if [ $? -ne 0 ]; then
    echo "Failed to create an empty commit."
    exit 1
fi

git push origin $BRANCH_NAME

if [ $? -eq 0 ]; then
    echo "Empty commit successfully pushed to GitHub."
else
    echo "Failed to push commit to GitHub."
    exit 1
fi
