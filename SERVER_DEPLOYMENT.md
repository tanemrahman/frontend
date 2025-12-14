# Server Deployment & Screenshot Guide

## 🚀 Server এ Project Deploy করার Complete Guide

### Step 1: Git Repository Setup

#### Local Machine এ Git Initialize করুন:

```bash
# Project directory তে যান
cd D:\Projects\module6

# Git initialize করুন
git init

# .gitignore check করুন (already আছে)
cat .gitignore

# সব files add করুন
git add .

# First commit করুন
git commit -m "Initial commit - Module 6 Monitoring Stack"

# Remote repository add করুন (GitHub/GitLab/Bitbucket)
git remote add origin https://github.com/yourusername/module6.git

# Push করুন
git push -u origin main
```

#### Alternative: Existing Repository Use করুন

```bash
# যদি already repository থাকে
git remote -v  # Check existing remotes
git add .
git commit -m "Module 6 project files"
git push
```

---

### Step 2: Server এ Project Clone করুন

#### Server এ SSH করুন:

```bash
# SSH to server
ssh username@your-server-ip

# বা Windows থেকে
# Putty, WSL, বা Git Bash use করুন
```

#### Server এ Project Clone করুন:

```bash
# Project directory তৈরি করুন
mkdir -p ~/projects
cd ~/projects

# Repository clone করুন
git clone https://github.com/yourusername/module6.git
# বা
git clone git@github.com:yourusername/module6.git

cd module6
```

---

### Step 3: Server Environment Setup

#### Node.js Install করুন (যদি না থাকে):

```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Check version
node --version
npm --version
```

#### Docker Install করুন (যদি Docker use করবেন):

```bash
# Docker installation
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker --version
docker-compose --version
```

#### Firewall Configure করুন:

```bash
# UFW (Ubuntu)
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 3000/tcp   # Application
sudo ufw allow 3001/tcp   # Grafana (restrict later)
sudo ufw allow 9090/tcp   # Prometheus (restrict later)
sudo ufw allow 9100/tcp   # Node Exporter (internal)
sudo ufw allow 3100/tcp   # Loki (internal)
sudo ufw enable
sudo ufw status
```

---

### Step 4: Project Deploy & Run

#### Option 1: Docker Compose (Recommended)

```bash
# Project directory তে
cd ~/projects/module6

# Dependencies install করুন
npm install

# Frontend build করুন
cd frontend
npm install
npm run build
cd ..

# Docker Compose দিয়ে সব services start করুন
docker-compose up -d

# Services check করুন
docker-compose ps

# Logs দেখুন
docker-compose logs -f
```

#### Option 2: Manual Installation

```bash
# Install monitoring stack
chmod +x install-monitoring.sh
sudo ./install-monitoring.sh

# Start Node.js app
npm install
cd frontend && npm install && npm run build && cd ..
npm start
```

---

### Step 5: Services Verify করুন

```bash
# সব services running check করুন
docker-compose ps

# বা manual installation হলে
sudo systemctl status prometheus
sudo systemctl status grafana-server
sudo systemctl status node-exporter
sudo systemctl status loki

# Ports check করুন
sudo netstat -tulpn | grep -E '3000|3001|9090|9100|3100'
# বা
sudo ss -tulpn | grep -E '3000|3001|9090|9100|3100'
```

---

### Step 6: Screenshots নেওয়ার Methods

#### Method 1: Browser থেকে Screenshot (Best)

**Server IP/Domain দিয়ে Access করুন:**

1. **Frontend:**
   - URL: `http://your-server-ip:3000`
   - Browser এ open করুন
   - Screenshot নিন

2. **Prometheus:**
   - URL: `http://your-server-ip:9090`
   - Screenshot নিন

3. **Grafana:**
   - URL: `http://your-server-ip:3001`
   - Login: admin/admin
   - Screenshot নিন

4. **Node Exporter:**
   - URL: `http://your-server-ip:9100/metrics`
   - Screenshot নিন

5. **Loki:**
   - URL: `http://your-server-ip:3100/ready`
   - Screenshot নিন

**Security Note:**
- Grafana এবং Prometheus এর জন্য IP restriction add করুন
- বা VPN use করুন
- বা temporary access দিয়ে screenshot নিন

#### Method 2: SSH + Terminal Screenshot

**Terminal Commands এর Screenshot:**

```bash
# Node.js version
node --version
# Screenshot নিন

# Services status
docker-compose ps
# Screenshot নিন

# Prometheus targets (curl)
curl http://localhost:9090/api/v1/targets | jq
# Screenshot নিন

# Logs
docker-compose logs prometheus | tail -20
# Screenshot নিন
```

#### Method 3: Remote Desktop/VNC (যদি available)

```bash
# VNC server install করুন (optional)
sudo apt-get install -y tightvncserver
vncserver :1

# VNC client দিয়ে connect করুন
# Browser open করে screenshots নিন
```

#### Method 4: Screenshot Tools on Server

**Server এ screenshot tool install করুন:**

```bash
# Install screenshot tool (if GUI available)
sudo apt-get install -y scrot
# বা
sudo apt-get install -y gnome-screenshot

# Screenshot নিন
scrot screenshot.png
```

**Transfer to local machine:**
```bash
# SCP দিয়ে download করুন
scp username@server-ip:~/screenshot.png ./
```

---

### Step 7: Security Configuration (Important!)

#### Grafana IP Restriction:

**Option 1: Nginx Reverse Proxy**

```bash
# Nginx install করুন
sudo apt-get install -y nginx

# Configuration file তৈরি করুন
sudo nano /etc/nginx/sites-available/monitoring
```

**Nginx Config:**
```nginx
# Grafana with IP restriction
server {
    listen 80;
    server_name your-domain.com;

    # IP Whitelist
    allow YOUR_IP_ADDRESS;  # আপনার IP
    deny all;

    location /grafana/ {
        proxy_pass http://localhost:3001/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

**Option 2: Firewall Rules**

```bash
# Specific IP allow করুন
sudo ufw delete allow 3001/tcp
sudo ufw allow from YOUR_IP_ADDRESS to any port 3001
```

**Option 3: Grafana Configuration**

```bash
# Grafana config edit করুন
sudo nano /etc/grafana/grafana.ini

# [server] section এ:
[server]
http_addr = 127.0.0.1  # Only localhost
# Then use SSH tunnel (see below)
```

---

### Step 8: SSH Tunnel (Secure Access)

**Grafana এবং Prometheus secure access এর জন্য:**

```bash
# Local machine থেকে SSH tunnel তৈরি করুন
ssh -L 3001:localhost:3001 username@server-ip  # Grafana
ssh -L 9090:localhost:9090 username@server-ip  # Prometheus
ssh -L 3100:localhost:3100 username@server-ip  # Loki

# এখন local browser এ:
# http://localhost:3001 (Grafana)
# http://localhost:9090 (Prometheus)
# http://localhost:3100 (Loki)
```

**Windows PowerShell এ:**
```powershell
# SSH tunnel
ssh -L 3001:localhost:3001 username@server-ip
```

---

### Step 9: Screenshot Checklist for Server

#### Setup Screenshots:
- [ ] SSH connection to server
- [ ] `git clone` command
- [ ] Node.js installation/version
- [ ] Docker installation (if using)
- [ ] Project directory structure

#### Installation Screenshots:
- [ ] `npm install` output
- [ ] `npm run build` output
- [ ] `docker-compose up -d` output
- [ ] Services status (`docker-compose ps`)

#### Configuration Screenshots:
- [ ] Configuration files (via `cat` or `nano`)
- [ ] Firewall rules (`sudo ufw status`)
- [ ] Port verification (`netstat` or `ss`)

#### Browser Screenshots (via Server IP):
- [ ] Frontend: `http://server-ip:3000`
- [ ] Prometheus: `http://server-ip:9090`
- [ ] Prometheus Targets: `http://server-ip:9090/targets`
- [ ] Grafana: `http://server-ip:3001`
- [ ] Grafana Dashboards
- [ ] Node Exporter: `http://server-ip:9100/metrics`
- [ ] Loki: `http://server-ip:3100/ready`

#### Terminal Screenshots:
- [ ] Service logs
- [ ] Command outputs
- [ ] Configuration file contents

---

### Step 10: Screenshot Tips for Server

#### 1. Browser Screenshots:
- Server IP use করুন (not localhost)
- Full page screenshot নিন
- URL bar visible রাখুন
- Important data highlight করুন

#### 2. Terminal Screenshots:
- Clear terminal use করুন
- Commands এবং outputs both show করুন
- Enough context রাখুন

#### 3. Quality:
- High resolution maintain করুন
- Text readable হতে হবে
- Important parts visible রাখুন

#### 4. Organization:
- Screenshots name করুন: `part1_01_server_ssh.png`
- Folders organize করুন
- Descriptions add করুন

---

### Step 11: Troubleshooting

#### Services Start হচ্ছে না:

```bash
# Check logs
docker-compose logs [service-name]

# Check ports
sudo lsof -i :3000
sudo lsof -i :3001

# Restart services
docker-compose restart
```

#### Cannot Access from Browser:

```bash
# Firewall check
sudo ufw status

# Service running check
docker-compose ps

# Port listening check
sudo netstat -tulpn | grep 3000
```

#### Git Issues:

```bash
# If authentication needed
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# SSH key setup (recommended)
ssh-keygen -t rsa -b 4096 -C "your.email@example.com"
cat ~/.ssh/id_rsa.pub
# Add to GitHub/GitLab
```

---

### Step 12: Quick Commands Reference

```bash
# Project update (server এ)
cd ~/projects/module6
git pull

# Rebuild frontend
cd frontend && npm run build && cd ..

# Restart services
docker-compose restart

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Start services
docker-compose up -d

# Check status
docker-compose ps
```

---

### Step 13: Screenshot Workflow

#### Recommended Workflow:

1. **Local Machine:**
   - Code complete করুন
   - Git commit & push করুন

2. **Server:**
   - SSH করুন
   - Git pull করুন
   - Services start করুন
   - Verify করুন

3. **Screenshots:**
   - Browser দিয়ে access করুন
   - Terminal commands screenshot নিন
   - Configuration files screenshot নিন
   - Dashboards screenshot নিন

4. **Download:**
   - Screenshots organize করুন
   - Local machine এ transfer করুন (যদি server এ নিয়ে থাকেন)

---

## ✅ Final Checklist

### Before Taking Screenshots:
- [ ] Server এ project deployed
- [ ] সব services running
- [ ] Ports accessible (firewall configured)
- [ ] Browser দিয়ে access করা যায়
- [ ] Security configured (IP restrictions)

### Screenshots Needed:
- [ ] Server setup (SSH, git clone)
- [ ] Installation steps
- [ ] Configuration files
- [ ] Browser access (all URLs)
- [ ] Dashboards and visualizations
- [ ] Terminal commands and outputs

### After Screenshots:
- [ ] Screenshots organized
- [ ] Descriptions added
- [ ] Quality checked
- [ ] Ready for documentation

---

## 🎯 Summary

**Server এ Deploy করার Process:**

1. ✅ Git repository setup (local)
2. ✅ Server এ clone করুন
3. ✅ Environment setup (Node.js, Docker)
4. ✅ Project build & deploy
5. ✅ Services start করুন
6. ✅ Security configure করুন
7. ✅ Browser/SSH দিয়ে access করুন
8. ✅ Screenshots নিন
9. ✅ Documentation তৈরি করুন
10. ✅ Submit করুন!

**Screenshots নেওয়ার Methods:**

- ✅ Browser দিয়ে server IP access (easiest)
- ✅ SSH tunnel (secure)
- ✅ Terminal commands
- ✅ Remote desktop/VNC (if available)

**Good Luck!** 🚀

