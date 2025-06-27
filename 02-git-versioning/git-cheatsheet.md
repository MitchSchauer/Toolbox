# 📘 Git Cheatsheet

## 🛠️ Setup
```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

### 📁 Clone Repo
```bash
git clone git@github.com:yourname/repo.git
```

### 🚧 Common Workflow
```bash
git status
git add .
git commit -m "describe changes"
git push origin main
```

### 🌿 Branching
```bash
git checkout -b feature-xyz    # create and switch to new branch
git checkout main              # switch back
git merge feature-xyz          # merge changes
```

### 🧽 Undo & Reset
```bash
git restore filename           # undo local changes
git reset --hard HEAD~1        # remove last commit
```

### 📂 Stashing
```bash
git stash
git stash pop
```
### 🧪 Rebase

```bash
git rebase -i HEAD~3
```

---

### 📖 `README.md`

## 🧰 02 Git Versioning Tools

This folder helps automate and standardize Git configuration and GitHub authentication across machines.

---

### 🔐 SSH Key Setup

Use `generate-ssh.sh` to create and upload a new SSH key:

```bash
chmod +x generate-ssh.sh
./generate-ssh.sh
```