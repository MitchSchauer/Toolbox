#!/bin/bash
# generate-ssh.sh - Generate SSH key and upload to GitHub

echo "🔐 SSH Key Setup for GitHub"

read -p "Enter your GitHub email: " email
read -p "Enter a name for this key (e.g. wsl, dev-laptop): " key_name
read -s -p "Enter your GitHub Personal Access Token (PAT with write:public_key): " pat
echo ""

KEY_PATH="$HOME/.ssh/id_rsa_$key_name"

# Check if key already exists
if [ -f "$KEY_PATH" ]; then
    echo "⚠️ SSH key already exists at $KEY_PATH"
else
    echo "📌 Generating new SSH key..."
    ssh-keygen -t ed25519 -C "$email" -f "$KEY_PATH" -N ""
fi

# Ensure ssh-agent is running and add the key
eval "$(ssh-agent -s)" > /dev/null
ssh-add "$KEY_PATH"

# Upload to GitHub
PUB_KEY=$(cat "$KEY_PATH.pub")
echo "🌐 Uploading key to GitHub..."

RESPONSE=$(curl -s -w "%{http_code}" -o /tmp/github_upload_response.json \
    -H "Authorization: token $pat" \
    -H "Content-Type: application/json" \
    -d "{\"title\":\"$key_name\",\"key\":\"$PUB_KEY\"}" \
    https://api.github.com/user/keys)

if [[ "$RESPONSE" == "201" ]]; then
    echo "✅ SSH key successfully uploaded to GitHub."
elif [[ "$RESPONSE" == "422" ]]; then
    echo "⚠️ Key may already exist on GitHub or the title is duplicated."
    cat /tmp/github_upload_response.json
else
    echo "❌ Failed to upload SSH key to GitHub (HTTP $RESPONSE)"
    cat /tmp/github_upload_response.json
    exit 1
fi

# Final instructions
echo "📍 SSH key saved at: $KEY_PATH"
echo "➡️ Use SSH remote URLs like: git@github.com:YourUser/Repo.git"
echo "🔗 You can manage your keys at: https://github.com/settings/keys"
# Uncomment to auto-open key page: xdg-open https://github.com/settings/keys

rm -f /tmp/github_upload_response.json
