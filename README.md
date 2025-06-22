# 🧰 Dev Toolbox

This repository houses a collection of reusable scripts, configurations, and templates for rapidly setting up development environments, automating tasks, and building AI/data-driven software systems.

## 📦 Contents

| Folder | Description |
|--------|-------------|
| `01-bash-wsl-setup/` | WSL + Ubuntu setup scripts, terminal tools, and system initialization |
| `02-git-versioning/` | Git/GitHub workflows, alias scripts, and version control tooling |
| `03-vscode-envs/` | VS Code settings, extensions, and devcontainer configurations |
| `04-docker-stacks/` | Dockerfiles and Compose stacks for local development environments |
| `05-python-utilities/` | Python CLI tools, scripting utilities, and automation helpers |
| `06-pytorch-base/` | PyTorch base templates and reusable model training pipelines |

---

## 🐧 01 - Bash & WSL Setup

This folder includes a setup script to bootstrap a fresh WSL Ubuntu environment with essential tools and config.

### ▶️ Run the Dev-Setup and/or Server-Setup Script

#### 🧰 WSL Dev Environment

```bash
cd 01-bash-wsl-setup
chmod +x dev-setup.sh
./dev-setup.sh
```

#### 🐳 Remote Docker Server

```bash
cd 01-bash-wsl-setup
chmod +x server-setup.sh
./server-setup.sh
```

## 🧰 02 - Git Versioning Tools

This folder helps automate and standardize Git configuration and GitHub authentication across machines.

---

### 🔐 SSH Key Setup

Use `generate-ssh.sh` to create and upload a new SSH key:

```bash
cd 02-git-versioning
chmod +x generate-ssh.sh
./generate-ssh.sh
```