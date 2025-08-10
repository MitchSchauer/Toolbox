# base-n8n
## n8n + PostgreSQL + Adminer Stack

This setup is designed to run inside a Proxmox LXC container. It includes:
- **PostgreSQL** for n8n database storage
- **n8n** automation platform
- **Adminer** for lightweight database management

## Installation
1. Copy this folder to your Proxmox LXC container (Debian preferred).
2. Install Docker & Docker Compose:
   ```bash
   apt update && apt install -y docker.io docker-compose
   ```
3. Navigate to the folder:
   ```bash
   cd /opt/base-n8n
   ```
4. Start the stack:
   ```bash
   docker-compose up -d
   ```

## Access
- n8n: `http://<server-IP>:5678`
- Adminer: `http://<server-IP>:8080`

## PostgreSQL Connection (for Supabase Studio)
- Host: `<Server-IP>`
- Port: `5432`
- User: `n8n`
- Password: `POSTGRES_PASSWORD`
- Database: `n8n`

## Files
- **docker-compose.yml** → service definitions
- **.env** → credentials and variables
- **init.sql** → optional initial database schema

### Note
- Copy `example.env` and rename to `.env` and update values
- setup one liner on cloudflared tunnel and paste into `cloudflare.md`
