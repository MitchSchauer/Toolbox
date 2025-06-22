#!/bin/bash

# toolbox.sh - Bootstrap script for dev or server environment
# Usage: ./toolbox.sh [dev|server|help]

set -e

MODE=$1

BOLD=$(tput bold)
NORMAL=$(tput sgr0)

log() {
  echo "${BOLD}[Toolbox]${NORMAL} $1"
}

if [[ "$MODE" == "dev" ]]; then
  log "Starting local development setup..."

  bash 01-bash-wsl-setup/dev-setup.sh
  bash 02-git-ssh-tools/generate-ssh.sh

  if [ -f 03-python-envs/setup.sh ]; then
    bash 03-python-envs/setup.sh
  fi

  if [ -f 05-vscode-setup/install.sh ]; then
    bash 05-vscode-setup/install.sh
  fi

  log "✅ Dev setup complete. Open with: code ~/projects/Toolbox"

elif [[ "$MODE" == "server" ]]; then
  log "Starting remote/server setup..."

  bash 01-bash-wsl-setup/server-setup.sh
  bash 02-git-ssh-tools/generate-ssh.sh

  if [ -f 04-docker-setup/docker-setup.sh ]; then
    bash 04-docker-setup/docker-setup.sh
  fi

  log "✅ Server setup complete. Reboot or relog to enable Docker group."

else
  echo "Usage: ./toolbox.sh [dev|server|help]"
  echo
  echo "  dev     Run full local development setup (WSL, Git, Python, VS Code, etc.)"
  echo "  server  Run full Ubuntu server setup (Docker, SSH, Git, etc.)"
  echo "  help    Show this message"
  exit 1
fi
