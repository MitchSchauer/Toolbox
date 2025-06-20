#!/bin/bash
# server-setup.sh - Ubuntu server setup for Docker with .env support

ENV_FILE="$(dirname "$0")/.env"

# 🧪 Check for .env and create it if missing
if [ ! -f "$ENV_FILE" ]; then
    echo "⚙️ .env not found. Let's create it..."
    read -p "Enter your Git user name: " GIT_USER_NAME
    read -p "Enter your Git email: " GIT_USER_EMAIL
    read -p "Optional: Server name (for hostname): " SERVER_NAME

    echo "GIT_USER_NAME=\"$GIT_USER_NAME\"" > "$ENV_FILE"
    echo "GIT_USER_EMAIL=\"$GIT_USER_EMAIL\"" >> "$ENV_FILE"
    echo "SERVER_NAME=\"$SERVER_NAME\"" >> "$ENV_FILE"

    echo "✅ .env created at $ENV_FILE"
fi

# 🔁 Load .env variables
source "$ENV_FILE"

echo "🔧 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing dependencies..."
sudo apt install -y \
    apt-transport-https ca-certificates curl \
    gnupg lsb-release git

echo "🔗 Configuring Git with $GIT_USER_NAME <$GIT_USER_EMAIL>"
git config --global user.name "$GIT_USER_NAME"
git config --global user.email "$GIT_USER_EMAIL"
git config --global init.defaultBranch main

echo "🐳 Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "🔐 Adding user to docker group..."
sudo usermod -aG docker $USER

# Optionally set hostname
if [ -n "$SERVER_NAME" ]; then
    echo "🖥️ Setting hostname to '$SERVER_NAME'"
    sudo hostnamectl set-hostname "$SERVER_NAME"
fi

echo "✅ Docker Server Setup Complete"
echo "🔁 Reboot or re-login to apply Docker group changes"
