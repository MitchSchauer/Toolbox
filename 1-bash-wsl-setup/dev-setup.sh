#!/bin/bash
# dev-setup.sh - WSL Ubuntu dev environment setup with .env and GitHub auto-clone

ENV_FILE="$(dirname "$0")/.env"
REPO_URL="https://github.com/MitchSchauer/Toolbox.git"
CLONE_DIR="$HOME/projects/Toolbox"

# 🧪 Create .env if it doesn't exist
if [ ! -f "$ENV_FILE" ]; then
    echo "⚙️ .env not found. Let's create it..."
    read -p "Enter your Git user name: " GIT_USER_NAME
    read -p "Enter your Git email: " GIT_USER_EMAIL

    echo "GIT_USER_NAME=\"$GIT_USER_NAME\"" > "$ENV_FILE"
    echo "GIT_USER_EMAIL=\"$GIT_USER_EMAIL\"" >> "$ENV_FILE"

    echo "✅ .env created at $ENV_FILE"
fi

# 🔁 Load .env variables
source "$ENV_FILE"

echo "🔧 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing essentials..."
sudo apt install -y \
    git curl wget unzip build-essential \
    python3 python3-pip python3-venv \
    software-properties-common

echo "🔗 Configuring Git with $GIT_USER_NAME <$GIT_USER_EMAIL>"
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global init.defaultBranch main

echo "📁 Creating project folder..."
mkdir -p ~/projects

# 🔽 Clone Toolbox repo if not already present
if [ -d "$CLONE_DIR/.git" ]; then
    echo "📂 Toolbox repo exists. Pulling latest changes..."
    cd "$CLONE_DIR" || exit
    git pull origin main
else
    echo "📥 Cloning Toolbox repo from GitHub..."
    git clone "$REPO_URL" "$CLONE_DIR"
fi

echo "✅ Dev environment setup complete!"
