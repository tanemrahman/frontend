# Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Prerequisites Check

```bash
# Check Node.js version (need 18+)
node --version

# Check Docker (if using Docker)
docker --version
docker-compose --version
```

### Option 1: Docker Compose (Easiest)

```bash
# 1. Install dependencies and build frontend
npm install
cd frontend && npm install && npm run build && cd ..

# 2. Start all services
docker-compose up -d

# 3. Wait for services to start (10-15 seconds)
sleep 15

# 4. Verify everything is running
docker-compose ps
```

**Access Points:**
- Frontend: http://localhost:3000
- Grafana: http://localhost:3001 (admin/admin)
- Prometheus: http://localhost:9090
- Loki: http://localhost:3100

### Option 2: Manual Setup

```bash
# 1. Install Node.js dependencies
npm install
cd frontend && npm install && npm run build && cd ..

# 2. Install monitoring stack
chmod +x install-monitoring.sh
sudo ./install-monitoring.sh

# 3. Start Node.js application
npm start
```

## 📊 First Steps in Grafana

1. **Login to Grafana**
   - URL: http://localhost:3001
   - Username: `admin`
   - Password: `admin` (change on first login!)

2. **Verify Data Sources**
   - Go to Configuration → Data Sources
   - Prometheus should be configured (green checkmark)
   - Loki should be configured (green checkmark)

3. **Import Node Exporter Dashboard**
   - Go to Dashboards → Import
   - Enter dashboard ID: `1860`
   - Select Prometheus datasource
   - Click Import

4. **Create Application Dashboard**
   - Create new dashboard
   - Add panel with query: `rate(http_requests_total[5m])`
   - Save dashboard

## 🧪 Test the Setup

### Generate Test Data

```bash
# Generate test logs
curl http://localhost:3000/api/logs/test

# Make some API calls
for i in {1..10}; do
  curl http://localhost:3000/api/health
  sleep 1
done
```

### Verify Metrics

```bash
# Check application metrics
curl http://localhost:3000/api/metrics

# Check Prometheus targets
open http://localhost:9090/targets
```

### Check Logs in Grafana

1. Go to Grafana → Explore
2. Select Loki datasource
3. Query: `{job="nodejs-app"}`
4. Click "Run query"

## 🛠️ Troubleshooting

### Services Not Starting?

```bash
# Check Docker logs
docker-compose logs [service-name]

# Check if ports are in use
netstat -tulpn | grep -E '3000|3001|9090|9100|3100'
```

### Can't Access Grafana?

- Check if Grafana container is running: `docker-compose ps`
- Check logs: `docker-compose logs grafana`
- Verify port 3001 is not blocked by firewall

### No Metrics Appearing?

1. Check Prometheus targets: http://localhost:9090/targets
2. Verify all targets are "UP"
3. Check Prometheus logs: `docker-compose logs prometheus`

### Logs Not Showing in Loki?

1. Verify Loki is running: `curl http://localhost:3100/ready`
2. Generate test logs: `curl http://localhost:3000/api/logs/test`
3. Check Loki logs: `docker-compose logs loki`

## 📚 Next Steps

1. **Read the Documentation:**
   - [README.md](./README.md) - Complete overview
   - [docs/DEPLOYMENT.md](./docs/DEPLOYMENT.md) - Detailed deployment
   - [docs/MONITORING.md](./docs/MONITORING.md) - Monitoring guide
   - [docs/COMPARISON.md](./docs/COMPARISON.md) - Stack comparison

2. **Customize Dashboards:**
   - Create custom panels for your metrics
   - Set up alerts
   - Configure notification channels

3. **Production Deployment:**
   - Set up SSL/TLS
   - Configure security groups
   - Set up backups
   - Configure log retention

## 🎯 Assignment Checklist

- [x] Frontend deployed and accessible
- [x] Prometheus installed and configured
- [x] Grafana installed with datasources
- [x] Node Exporter collecting system metrics
- [x] Application metrics exposed
- [x] Loki installed and configured
- [x] Logs forwarding to Loki
- [x] Grafana dashboards created
- [x] Documentation complete

## 💡 Tips

- Use `docker-compose logs -f` to follow logs in real-time
- Grafana dashboards can be exported/imported as JSON
- Prometheus queries can be tested in the Prometheus UI
- Use LogQL in Grafana Explore for log queries
- Set up alerts for production use

## 🆘 Need Help?

1. Check the documentation in `docs/` folder
2. Review service logs
3. Verify all services are running
4. Check network connectivity
5. Verify configuration files

Happy Monitoring! 🎉

