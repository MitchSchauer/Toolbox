# 03-python-env-tools

This module provides tools to efficiently manage Python environments in WSL and convert Python projects into Dockerized deployments.

---

## 📦 Tools Included

### 1. `detect-reqs.py`
Scans a project directory for all Python files and extracts external (non-stdlib) dependencies, writing them to a `requirements.txt`.

```bash
python3 detect-reqs.py /path/to/project > requirements.txt
```

### 2. `project-to-docker.sh`
Automates the process of:
- Detecting project requirements
- Generating a `Dockerfile`
- Optionally building a Docker image

```bash
./project-to-docker.sh /path/to/project
```

### 3. `Dockerfile.template`
Minimal Dockerfile template used by `project-to-docker.sh`.

---

## 🧪 Common Workflows

### 🧬 Create a Virtual Environment
```bash
python3 -m venv .venv
source .venv/bin/activate
```

### 📦 Install Packages
```bash
pip install requests pandas
```

### 🧾 Save Your Environment
```bash
pip freeze > requirements.txt
```

### 📥 Restore from Requirements
```bash
pip install -r requirements.txt
```

---

## 🐳 Convert a Python Project to a Docker Container

```bash
cd /path/to/project
/path/to/toolbox/03-python-env-tools/project-to-docker.sh .
```

This will:
- Generate a `requirements.txt` if missing
- Add a Dockerfile from the template
- Optionally build the Docker image on the spot

---

## 🧠 Tips

### 🔄 Switching Python Versions (with `pyenv`)
```bash
pyenv install 3.11.6
pyenv global 3.11.6
```

### 📁 Recommended Structure
```bash
my-project/
├── .venv/
├── app.py
├── requirements.txt
├── Dockerfile  ← generated
└── ...
```

---

## 📘 Cheatsheet
See `cheatsheet.md` for command references.

---

*This module is part of the modular Toolbox project for automating dev and deployment workflows in WSL.*
