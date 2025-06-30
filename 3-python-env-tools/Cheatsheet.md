# cheatsheet.md
# 🧪 Python Environment Cheatsheet (WSL Edition)

## ✅ Create virtual environment
```bash
python3 -m venv .venv
source .venv/bin/activate
```

## 📦 Install packages
```bash
pip install requests pandas  # example
```

## 🧾 Freeze environment
```bash
pip freeze > requirements.txt
```

## 📥 Install from requirements
```bash
pip install -r requirements.txt
```

## 🐳 Convert project to Docker container
```bash
./project-to-docker.sh /path/to/project
```

## 🧠 Detect requirements from source
```bash
python3 detect-reqs.py /path/to/project > requirements.txt
```

## 🔁 Switch Python version with pyenv
```bash
pyenv install 3.11.6
pyenv global 3.11.6
```

---

*Use this module to streamline and containerize Python projects easily from WSL.*