# 🔐 SSH Key Setup for GitHub

This guide walks you through using the `generate-ssh.sh` script to securely generate an SSH key, add it to your local SSH agent, and upload the public key to your GitHub account using a Personal Access Token (PAT).
---

## 🚀 Script Overview

The script:
1. Prompts for your GitHub email, a key name, and your PAT.
2. Generates a new `ed25519` SSH key at `~/.ssh/id_rsa_<key_name>`.
3. Adds the private key to your `ssh-agent`.
4. Uploads the public key to your GitHub account via API.

---

## 🧰 Prerequisites

- A GitHub account
- A [Personal Access Token](https://github.com/settings/tokens) (PAT)"classic" with `write:public_key` permission
- A terminal with `ssh-keygen`, `ssh-agent`, and `curl` installed (common in WSL, Linux, and macOS)

---

## 📦 Usage

1. **Make the script executable:**

 ```bash
   chmod +x generate-ssh.sh
```

2. **Run the script:**

```bash
   ./generate-ssh.sh
```

3. **Follow the prompts:**

   - GitHub email (e.g. `you@example.com`)
   - Key name (e.g. `wsl`, `dev-laptop`)
   - PAT with `write:public_key` scope

### You can generate your GitHub Personal Access Token (PAT) by following these steps:

#### 🔗 1. Go to GitHub PAT settings:

  👉 https://github.com/settings/tokens

#### 🛠️ 2. Click "Generate new token" → Choose: "Classic"

  Or use a classic token for simpler use cases, but GitHub recommends fine-grained for better security. Fine-grained will have to be set maually on [GitHub SSH Keys](https://github.com/settings/keys).

#### 🧾 3. Fill in token details:
  Name: something like ssh-key-upload

  Expiration: choose a duration (e.g., 30 days or 90 days)

  Resource access: select "All repositories" or limit to your own

  Permissions:
    Under Account settings, enable:
      public_key: write

#### ✅ 4. Click "Generate token"

  Copy the token immediately — you won’t be able to see it again later!

  Store it in a secure location (e.g., .env file, password manager).

---

## 🗂️ Output

- **Private key:** `~/.ssh/id_rsa_<key_name>`
- **Public key:** `~/.ssh/id_rsa_<key_name>.pub` (uploaded to GitHub)
- **SSH agent:** Private key added automatically via `ssh-add`

---

## 🧭 Post-Setup: Configure SSH

To make sure Git uses the correct SSH key, update (or create) your SSH config file:

```bash
nano ~/.ssh/config
```

Add the following:

```ssh-config
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_<key_name>
    IdentitiesOnly yes
```

Replace `<key_name>` with the name you chose during setup.

---

## ❌ Removal

```bash
ssh-add -D     # removes all loaded keys
```

---

## ✅ Readd

```bash
ssh-add ~/.ssh/id_rsa_<key_name>
```

---

## 💡 Tips

- **Multiple Devices:** Use different key names for different machines (e.g. `wsl`, `laptop`, `home-pc`)
- **Persistent Agent:** If keys are not recognized on reboot, ensure `ssh-agent` starts automatically and re-adds keys.
- **Security:** Never share your private key. Keep it readable only by you (`chmod 600`).

---

## 🛠️ Troubleshooting

- GitHub not recognizing your key? Confirm it was uploaded: [GitHub SSH Keys](https://github.com/settings/keys)
- ^ you can also add the key here 
- Use this to debug SSH issues:

```bash
  ssh -T git@github.com -v
  ```

- Need to re-add the key?

```bash
  ssh-add ~/.ssh/id_rsa_<key_name>
  ```

- Debug

```bash
ssh -vT git@github.com

```
---

## 📚 References

- [GitHub Docs: Connecting via SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [Managing SSH Keys in GitHub](https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account)
- [Generating SSH Keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

---

*This markdown is part of your GitHub automation and version control tools.*
