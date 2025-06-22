#!/bin/bash
# generate-ssh.sh - Generate SSH key and upload to GitHub

echo "🔐 SSH Key Setup for GitHub"

read -p "Enter your GitHub email: " email
read -p "Enter a name for this key (e.g. wsl, dev-laptop): " key_name
read -p "Enter your GitHub Personal Access Token (PAT with write:public_key): " pat

KEY_PATH="$HOME/.ssh/id_rsa_$key_name"

# Check if key already exists
if [ -f "$KEY_PATH" ]; then
    echo "⚠️ SSH key already exists at $KEY_PATH"
else
    echo "📌 Generating new SSH key..."
    ssh-keygen -t ed25519 -C "$email" -f "$KEY_PATH" -N ""
fi

# Ensure ssh-agent is running
eval "$(ssh-agent -s)" > /dev/null
ssh-add "$KEY_PATH"

# Upload to GitHub
PUB_KEY=$(cat "$KEY_PATH.pub")
echo "🌐 Uploading key to GitHub..."

curl -s -H "Authorization: token $pat" \
     -H "Content-Type: application/json" \
     -d "{\"title\":\"$key_name\",\"key\":\"$PUB_KEY\"}" \
     https://api.github.com/user/keys > /dev/null

echo "✅ SSH key added to GitHub and available at: $KEY_PATH"
echo "➡️ Use SSH remote URLs like: git@github.com:YourUser/Repo.git"
