#!/bin/bash
# generate-ssh.sh - Generate SSH key and upload to GitHub, configure Git to use it

echo "🔐 SSH Key Setup for GitHub"

read -p "Enter your GitHub email: " email
read -p "Enter a name for this key (e.g. wsl, dev-laptop): " key_name

echo "Create a GitHub PAT (classic, with write:public_key) here:"
echo "   👉 https://github.com/settings/tokens"
read -s -p "Enter your GitHub Personal Access Token (PAT): " pat
echo ""

KEY_PATH="$HOME/.ssh/id_rsa_$key_name"

# 🧪 Generate SSH key if it doesn't exist
if [ -f "$KEY_PATH" ]; then
    echo "⚠️ SSH key already exists at $KEY_PATH"
else
    echo "📌 Generating new SSH key..."
    ssh-keygen -t ed25519 -C "$email" -f "$KEY_PATH" -N ""
fi

# 🔐 Ensure ssh-agent is running and add key
eval "$(ssh-agent -s)" > /dev/null
ssh-add "$KEY_PATH"

# 🧷 Trust GitHub fingerprint (prevent interactive prompt)
echo "📎 Adding GitHub to known_hosts..."
mkdir -p ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null

# 🌐 Upload public key to GitHub
PUB_KEY=$(cat "$KEY_PATH.pub")
echo "☁️ Uploading key to GitHub..."

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

# 🛠️ Update SSH config to use this key for GitHub
CONFIG_LINE="IdentityFile ~/.ssh/id_rsa_$key_name"
if ! grep -q "$CONFIG_LINE" ~/.ssh/config 2>/dev/null; then
    echo "🛠 Updating ~/.ssh/config for GitHub..."
    {
        echo ""
        echo "Host github.com"
        echo "  HostName github.com"
        echo "  User git"
        echo "  IdentityFile $KEY_PATH"
        echo "  IdentitiesOnly yes"
    } >> ~/.ssh/config
fi

# 🔄 Convert current repo remote to SSH (if inside a Git repo with HTTPS remote)
REPO_SSH_EXAMPLE=""
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    CURRENT_REMOTE=$(git remote get-url origin 2>/dev/null)
    if [[ "$CURRENT_REMOTE" == https://github.com/* ]]; then
        SSH_REMOTE=$(echo "$CURRENT_REMOTE" | sed 's|https://github.com/|git@github.com:|' | sed 's|\.git$||').git
        git remote set-url origin "$SSH_REMOTE"
        echo "🔁 Updated Git remote to use SSH: $SSH_REMOTE"
        REPO_SSH_EXAMPLE="$SSH_REMOTE"
    fi
fi

# ✅ Final output
echo "📍 SSH key saved at: $KEY_PATH"
if [ -n "$REPO_SSH_EXAMPLE" ]; then
    echo "➡️ You can now use SSH-based Git URLs like:"
    echo "   $REPO_SSH_EXAMPLE"
else
    echo "➡️ You can now use SSH-based Git URLs like:"
    echo "   git@github.com:<your-username>/<repo>.git"
fi
echo "🔗 Manage your keys at: https://github.com/settings/keys"

# Clean up
rm -f /tmp/github_upload_response.json
