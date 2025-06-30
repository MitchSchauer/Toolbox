#!/usr/bin/env bash
set -e

# 1. Prepare .env
ENV_FILE="$(dirname "$0")/.env"
if [ ! -f "$ENV_FILE" ]; then
  read -p "Git user name: " GIT_USER_NAME
  read -p "Git email: "    GIT_USER_EMAIL
  read -p "Server name (optional): " SERVER_NAME

  cat > "$ENV_FILE" <<EOF
GIT_USER_NAME="$GIT_USER_NAME"
GIT_USER_EMAIL="$GIT_USER_EMAIL"
SERVER_NAME="$SERVER_NAME"
EOF
  echo ".env created."
fi
source "$ENV_FILE"

# 2. Update & prerequisites
sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg lsb-release git

# 3. Configure Git
#git config --global user.name  "$GIT_USER_NAME"
#git config --global user.email "$GIT_USER_EMAIL"
#git config --global init.defaultBranch main

# 4. Install Docker
sudo mkdir -p /usr/share/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 5. Add to Docker group
if [ "$USER" != "root" ]; then
  sudo usermod -aG docker "$USER"
  echo "Added $USER to docker group."
else
  echo "⚠️ Run as non-root user to auto‑add to docker group."
fi

# 6. Optional hostname
if [ -n "$SERVER_NAME" ]; then
  sudo hostnamectl set-hostname "$SERVER_NAME"
  echo "Hostname set to $SERVER_NAME."
fi

echo "✅ Setup complete. Log out and back in or reboot for changes to take effect."
