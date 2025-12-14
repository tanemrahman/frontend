# Deployment Guide

## Prerequisites

### System Requirements

- **OS**: Linux (Ubuntu 20.04+ recommended) or Windows with WSL2
- **RAM**: Minimum 4GB (8GB recommended)
- **Disk**: 20GB free space
- **CPU**: 2+ cores

### Software Requirements

- Node.js 18+ and npm
- Docker and Docker Compose (for containerized deployment)
- OR systemd (for manual installation)
- Git

## Deployment Options

### Option 1: Docker Compose (Recommended)

#### Step 1: Clone and Setup

```bash
# Clone the repository (if applicable)
git clone <repository-url>
cd module6

# Make scripts executable
chmod +x deploy.sh
```

#### Step 2: Run Deployment Script

```bash
./deploy.sh
```

This script will:
1. Install Node.js dependencies
2. Build the frontend application
3. Create necessary directories
4. Start all services with Docker Compose
5. Verify service health

#### Step 3: Verify Deployment

```bash
# Check container status
docker-compose ps

# View logs
docker-compose logs -f

# Test endpoints
curl http://localhost:3000/api/health
curl http://localhost:9090/-/healthy
curl http://localhost:3001/api/health
```

### Option 2: Manual Installation

#### Step 1: Install Node.js Application

```bash
# Install dependencies
npm install
cd frontend
npm install
npm run build
cd ..
```

#### Step 2: Install Monitoring Stack

```bash
# Make installation script executable
chmod +x install-monitoring.sh

# Run installation (requires sudo)
sudo ./install-monitoring.sh
```

#### Step 3: Start Services

```bash
# Start Node.js application
npm start

# Services should auto-start, but verify:
sudo systemctl status prometheus
sudo systemctl status node-exporter
sudo systemctl status grafana-server
sudo systemctl status loki
```

#### Step 4: Configure Services

**Prometheus:**
```bash
# Edit configuration
sudo nano /opt/prometheus/prometheus.yml

# Restart service
sudo systemctl restart prometheus
```

**Grafana:**
```bash
# Access Grafana
# URL: http://localhost:3001
# Default: admin/admin
# Change password on first login
```

**Loki:**
```bash
# Edit configuration
sudo nano /etc/loki/loki-config.yml

# Restart service
sudo systemctl restart loki
```

## Cloud Deployment (AWS Example)

### Step 1: Launch EC2 Instance

1. Launch Ubuntu 22.04 LTS instance
2. Instance type: t3.medium or larger
3. Security group configuration:
   - Port 22 (SSH) - Your IP only
   - Port 3000 (Application) - Public
   - Port 3001 (Grafana) - Your IP only
   - Port 9090 (Prometheus) - Your IP only
   - Port 9100 (Node Exporter) - Internal only

### Step 2: Connect and Setup

```bash
# SSH into instance
ssh -i your-key.pem ubuntu@your-instance-ip

# Update system
sudo apt-get update && sudo apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Clone and deploy
git clone <repository-url>
cd module6
./deploy.sh
```

### Step 3: Configure Nginx (Optional)

```bash
# Install Nginx
sudo apt-get install -y nginx

# Create configuration
sudo nano /etc/nginx/sites-available/monitoring

# Add configuration (see nginx.conf)
sudo ln -s /etc/nginx/sites-available/monitoring /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## Nginx Configuration

### Reverse Proxy Setup

Create `/etc/nginx/sites-available/monitoring`:

```nginx
# Frontend and API
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    location /api {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# Grafana (restricted access)
server {
    listen 80;
    server_name grafana.your-domain.com;

    # IP Whitelist
    allow YOUR_IP_ADDRESS;
    deny all;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Verification Steps

### 1. Application Health

```bash
curl http://localhost:3000/api/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2024-01-01T00:00:00.000Z",
  "uptime": 123.45
}
```

### 2. Prometheus Targets

1. Visit: http://localhost:9090/targets
2. All targets should show as "UP"
3. Check scrape errors if any

### 3. Grafana Access

1. Visit: http://localhost:3001
2. Login with `admin/admin`
3. Verify Prometheus datasource is configured
4. Verify Loki datasource is configured

### 4. Node Exporter Metrics

```bash
curl http://localhost:9100/metrics | head -20
```

Should show Prometheus-formatted metrics.

### 5. Loki Logs

```bash
# Check Loki readiness
curl http://localhost:3100/ready

# Query logs
curl -G -s "http://localhost:3100/loki/api/v1/query_range" \
  --data-urlencode 'query={job="nodejs-app"}' \
  --data-urlencode 'limit=10'
```

### 6. Generate Test Data

```bash
# Generate test logs
curl http://localhost:3000/api/logs/test

# Make some requests to generate metrics
for i in {1..10}; do
  curl http://localhost:3000/api/health
  sleep 1
done
```

## Post-Deployment Configuration

### Grafana Dashboards

1. **Import Node Exporter Dashboard:**
   - Dashboard ID: 1860
   - URL: https://grafana.com/grafana/dashboards/1860

2. **Create Application Dashboard:**
   - Add panels for:
     - HTTP request rate
     - Request duration
     - Error rate
     - Application uptime

3. **Create Log Dashboard:**
   - Add log panel with LogQL query:
     ```logql
     {job="nodejs-app"}
     ```

### Prometheus Alerts (Optional)

Create `prometheus/alerts.yml`:

```yaml
groups:
  - name: application
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status_code=~"5.."}[5m]) > 0.1
        for: 5m
        annotations:
          summary: "High error rate detected"
```

### Security Hardening

1. **Change Grafana Password:**
   - Login to Grafana
   - Go to Administration → Users
   - Change admin password

2. **Firewall Rules:**
   ```bash
   sudo ufw allow 22/tcp    # SSH
   sudo ufw allow 3000/tcp  # Application
   sudo ufw allow from YOUR_IP to any port 3001  # Grafana
   sudo ufw enable
   ```

3. **SSL/TLS (Production):**
   - Use Let's Encrypt for SSL certificates
   - Configure Nginx with SSL
   - Redirect HTTP to HTTPS

## Troubleshooting

### Services Not Starting

```bash
# Docker Compose
docker-compose logs [service-name]
docker-compose ps

# Systemd
sudo systemctl status [service-name]
sudo journalctl -u [service-name] -f
```

### Port Conflicts

```bash
# Check port usage
sudo netstat -tulpn | grep :3000
sudo lsof -i :3000

# Change ports in configuration files
```

### Permission Issues

```bash
# Fix Docker permissions
sudo usermod -aG docker $USER
newgrp docker

# Fix file permissions
sudo chown -R $USER:$USER /path/to/project
```

### Logs Not Appearing in Loki

1. Check Loki is running: `curl http://localhost:3100/ready`
2. Verify Winston-Loki configuration in `server.js`
3. Check network connectivity
4. Review Loki logs: `docker-compose logs loki`

## Maintenance

### Backup

```bash
# Backup Prometheus data
docker cp prometheus:/prometheus ./backup/prometheus

# Backup Grafana data
docker cp grafana:/var/lib/grafana ./backup/grafana

# Backup Loki data
docker cp loki:/tmp/loki ./backup/loki
```

### Updates

```bash
# Update Docker images
docker-compose pull
docker-compose up -d

# Update Node.js dependencies
npm update
cd frontend && npm update && npm run build
```

### Monitoring

- Set up Grafana alerts
- Monitor disk usage
- Review log retention policies
- Check service health regularly

