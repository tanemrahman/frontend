# Module 6 Assignment - Full Monitoring Stack

Complete monitoring solution with Prometheus, Grafana, Node Exporter, and Loki for frontend application deployment and system monitoring.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Part 1: Frontend Deployment](#part-1-frontend-deployment)
- [Part 2: Monitoring Stack Setup](#part-2-monitoring-stack-setup)
- [Part 3: Node Exporter Log Configuration](#part-3-node-exporter-log-configuration)
- [Part 4: Time Series Database Concepts](#part-4-time-series-database-concepts)
- [Part 5: Loki & SIEM](#part-5-loki--siem)
- [Configuration](#configuration)
- [Access Points](#access-points)
- [Documentation](#documentation)

## 🎯 Overview

This project implements a complete monitoring stack for a Node.js application with:

- **Frontend**: React application served via Express
- **Prometheus**: Time Series Database for metrics collection
- **Grafana**: Visualization and dashboard platform
- **Node Exporter**: System metrics collection
- **Loki**: Log aggregation system

## 🏗️ Architecture

```
┌─────────────────┐
│   Frontend      │
│  (React App)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Node.js App    │───► Prometheus Metrics (/api/metrics)
│   (Express)     │───► Loki Logs (Winston-Loki)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Node Exporter   │───► System Metrics
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Prometheus    │◄─── Grafana (Dashboards)
│     (TSDB)      │
└─────────────────┘
         │
         ▼
┌─────────────────┐
│      Loki       │◄─── Grafana (Logs)
│  (Log Agg)      │
└─────────────────┘
```

## 📦 Prerequisites

- Node.js 18+ and npm
- Docker and Docker Compose (for containerized deployment)
- OR Linux server with systemd (for manual installation)
- Ports available: 3000, 3001, 9090, 9100, 3100

## 🚀 Quick Start

### Option 1: Docker Compose (Recommended)

```bash
# Make deploy script executable
chmod +x deploy.sh

# Run deployment
./deploy.sh
```

### Option 2: Manual Installation

```bash
# Install monitoring stack
chmod +x install-monitoring.sh
sudo ./install-monitoring.sh

# Install Node.js dependencies
npm install
cd frontend && npm install && npm run build && cd ..

# Start Node.js application
npm start
```

## 📝 Part 1: Frontend Deployment

### Steps Completed

1. **Server Environment Preparation**
   - Node.js runtime environment
   - Express server for serving static files
   - Production build configuration

2. **Frontend Project Setup**
   - React application with Vite
   - Production build configuration
   - Static file serving via Express

3. **Dependencies Installation**
   - Frontend: React, Vite, Axios
   - Backend: Express, Prometheus client, Winston logger

4. **Production Build**
   ```bash
   cd frontend
   npm install
   npm run build
   ```

5. **Web Server Configuration**
   - Express serves static files from `frontend/dist`
   - API endpoints for health checks and metrics
   - Reverse proxy ready (nginx configuration available)

6. **Verification**
   - Access frontend at `http://localhost:3000`
   - Health endpoint: `http://localhost:3000/api/health`
   - Metrics endpoint: `http://localhost:3000/api/metrics`

## 📊 Part 2: Monitoring Stack Setup

### Prometheus Installation

**Docker Method:**
```bash
docker-compose up -d prometheus
```

**Manual Method:**
- Download from [Prometheus releases](https://github.com/prometheus/prometheus/releases)
- Extract and configure `prometheus/prometheus.yml`
- Start as systemd service

**Configuration:**
- Scrape interval: 15 seconds
- Retention: 200 hours
- Targets: Prometheus self, Node Exporter, Node.js app

### Grafana Installation

**Docker Method:**
```bash
docker-compose up -d grafana
```

**Manual Method:**
```bash
sudo apt-get install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
```

**Access:**
- URL: `http://localhost:3001`
- Default credentials: `admin/admin`
- Prometheus datasource auto-configured

### Node Exporter Installation

**Docker Method:**
```bash
docker-compose up -d node-exporter
```

**Manual Method:**
- Download from [Node Exporter releases](https://github.com/prometheus/node_exporter/releases)
- Install as systemd service
- Exposes metrics on port 9100

**Metrics Collected:**
- CPU usage
- Memory usage
- Disk I/O
- Network statistics
- File system metrics

### Security Configuration

**Grafana Security Group (AWS/Cloud):**
```json
{
  "Type": "AWS::EC2::SecurityGroup",
  "Properties": {
    "SecurityGroupIngress": [
      {
        "IpProtocol": "tcp",
        "FromPort": 3001,
        "ToPort": 3001,
        "CidrIp": "YOUR_IP_ADDRESS/32"
      }
    ]
  }
}
```

**Firewall Rules (UFW):**
```bash
sudo ufw allow from YOUR_IP_ADDRESS to any port 3001
sudo ufw allow 3000/tcp  # Application
sudo ufw allow 9090/tcp  # Prometheus
sudo ufw allow 9100/tcp  # Node Exporter
```

### Verification

1. **Prometheus Targets:**
   - Navigate to `http://localhost:9090/targets`
   - All targets should show as "UP"

2. **Grafana Dashboards:**
   - Import Node Exporter dashboard (ID: 1860)
   - Create custom dashboard for application metrics

## 📝 Part 3: Node Exporter Log Configuration

### Log Exporting Setup

The Node.js application uses Winston logger with Loki transport to send logs to Prometheus/Loki:

```javascript
// server.js
const logger = createLogger({
  transports: [
    new LokiTransport({
      host: process.env.LOKI_HOST || 'http://localhost:3100',
      labels: { job: 'nodejs-app', environment: 'production' }
    })
  ]
});
```

### Metrics from Logs

Logs are converted to metrics:
- HTTP request counts
- Error rates
- Response times
- Application events

### Validation

1. **Check Prometheus:**
   ```promql
   rate(http_requests_total[5m])
   ```

2. **Check Grafana:**
   - Create panel with log-based metrics
   - Query: `sum(rate(http_requests_total[5m])) by (status_code)`

3. **Generate Test Logs:**
   - Visit `http://localhost:3000/api/logs/test`
   - Verify logs appear in Loki

## 🗄️ Part 4: Time Series Database & Monitoring Concepts

### Time Series Database (TSDB)

**Definition:**
A Time Series Database is optimized for storing and querying data points indexed by time. Each data point consists of:
- Timestamp
- Metric name
- Value
- Labels/tags

**Key Characteristics:**
- Efficient storage of time-sequenced data
- Fast queries over time ranges
- Compression for historical data
- Retention policies

### Prometheus as TSDB

**Storage:**
- Local time-series database (TSDB)
- Stores data in chunks
- Compression for efficiency
- Configurable retention

**Data Model:**
```
metric_name{label1="value1", label2="value2"} value timestamp
```

**Query Language (PromQL):**
```promql
# Rate of requests per second
rate(http_requests_total[5m])

# CPU usage percentage
100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes
```

**Storage Architecture:**
- Head block: Recent data in memory
- Persistent blocks: Compressed on disk
- Retention: Configurable (default 15 days, configured to 200h)

### Comparison with Other Monitoring Stacks

| Feature | Prometheus | InfluxDB | Graphite | Datadog |
|---------|-----------|----------|----------|---------|
| Data Model | Pull-based | Push/Pull | Push-based | SaaS |
| Storage | Local TSDB | Local/Cloud | Whisper | Cloud |
| Query Language | PromQL | InfluxQL | Graphite API | Custom |
| Scalability | Horizontal | Horizontal | Vertical | Managed |
| Cost | Free | Open-source/Paid | Free | Paid |
| Best For | Kubernetes, Microservices | IoT, High-frequency | Legacy systems | Enterprise |

### Common Monitoring Architectures

1. **Prometheus + Grafana**
   - Self-hosted
   - Pull-based metrics
   - Best for: Kubernetes, microservices

2. **ELK Stack (Elasticsearch, Logstash, Kibana)**
   - Log-centric
   - Push-based
   - Best for: Log analysis, search

3. **Loki + Grafana**
   - Log aggregation
   - Label-based indexing
   - Best for: Logs with metrics

4. **Cloud-native (Datadog, New Relic)**
   - SaaS solution
   - APM included
   - Best for: Enterprise, managed services

## 🔍 Part 5: Loki & SIEM

### Loki Installation

**Docker Method:**
```bash
docker-compose up -d loki
```

**Manual Method:**
- Download from [Loki releases](https://github.com/grafana/loki/releases)
- Configure `loki/loki-config.yml`
- Start as systemd service

### Application Log Forwarding

**Configuration:**
- Winston logger with `winston-loki` transport
- Automatic log forwarding to Loki
- Structured logging with labels

**Log Labels:**
- `job`: Application identifier
- `environment`: Deployment environment
- `level`: Log level (info, warn, error)

### Grafana Integration

1. **Add Loki Data Source:**
   - Grafana → Configuration → Data Sources
   - Add Loki
   - URL: `http://localhost:3100`
   - Auto-configured via provisioning

2. **Create Log Queries:**
   ```logql
   {job="nodejs-app"} |= "error"
   {job="nodejs-app"} | json | statusCode >= 400
   rate({job="nodejs-app"}[5m])
   ```

3. **Build Visualizations:**
   - Log panels for real-time logs
   - Time-series panels for log rates
   - Table panels for log analysis

### SIEM (Security Information and Event Management)

**Definition:**
SIEM tools collect, analyze, and correlate security events from multiple sources to detect threats and provide security insights.

**Key Features:**
- Log aggregation
- Real-time monitoring
- Threat detection
- Incident response
- Compliance reporting

**How Loki Aligns:**
- Centralized log collection
- Fast log queries
- Label-based filtering
- Integration with Grafana for visualization
- Can be extended with alerting rules

**SIEM Capabilities with Loki:**
- Collect security logs
- Detect anomalies
- Correlate events
- Create security dashboards
- Set up alerting rules

### APM (Application Performance Monitoring)

**Definition:**
APM provides deep insights into application performance, including:
- Transaction tracing
- Code-level performance
- Database query analysis
- Error tracking
- User experience monitoring

**APM vs Basic Metrics:**

| Aspect | Basic Metrics | APM |
|--------|--------------|-----|
| Granularity | System/Service level | Code/Transaction level |
| Data | Aggregated metrics | Traces, spans |
| Use Case | Infrastructure monitoring | Application debugging |
| Tools | Prometheus, Node Exporter | Jaeger, Zipkin, New Relic |
| Overhead | Low | Medium-High |

**APM Tools:**
- **Jaeger**: Distributed tracing
- **Zipkin**: Request tracing
- **New Relic**: Full APM suite
- **Datadog APM**: Integrated monitoring

**This Project:**
- Uses Prometheus for metrics (basic monitoring)
- Can be extended with Jaeger for APM
- Winston logs provide application-level insights

### Loki vs ELK Stack

| Feature | Loki | ELK Stack |
|---------|------|-----------|
| Architecture | Label-based indexing | Full-text search |
| Storage | Object storage (S3, etc.) | Elasticsearch |
| Query Language | LogQL | Elasticsearch Query DSL |
| Resource Usage | Lower | Higher |
| Setup Complexity | Simpler | More complex |
| Best For | Logs with metrics | Full-text search, complex queries |
| Scalability | Horizontal | Horizontal (complex) |
| Cost | Lower | Higher (resource-intensive) |

**When to Use Loki:**
- Logs with structured labels
- Integration with Prometheus/Grafana
- Lower resource requirements
- Simple log queries

**When to Use ELK:**
- Full-text search requirements
- Complex log analysis
- Rich query capabilities
- Existing Elasticsearch infrastructure

## ⚙️ Configuration

### Environment Variables

Create `.env` file:
```env
NODE_ENV=production
PORT=3000
LOKI_HOST=http://localhost:3100
```

### Prometheus Configuration

Edit `prometheus/prometheus.yml` to add more scrape targets or adjust intervals.

### Grafana Configuration

- Datasources: Auto-provisioned from `grafana/provisioning/datasources/`
- Default credentials: `admin/admin` (change in production!)

### Loki Configuration

Edit `loki/loki-config.yml` for storage backends, retention, etc.

## 🌐 Access Points

| Service | URL | Credentials |
|---------|-----|-------------|
| Frontend | http://localhost:3000 | - |
| Prometheus | http://localhost:9090 | - |
| Grafana | http://localhost:3001 | admin/admin |
| Loki | http://localhost:3100 | - |
| Node Exporter | http://localhost:9100/metrics | - |
| App Metrics | http://localhost:3000/api/metrics | - |

## 📚 Documentation

### Architecture Diagram

See [ARCHITECTURE.md](./docs/ARCHITECTURE.md) for detailed architecture documentation.

### Deployment Guide

See [DEPLOYMENT.md](./docs/DEPLOYMENT.md) for step-by-step deployment instructions.

### Monitoring Guide

See [MONITORING.md](./docs/MONITORING.md) for monitoring setup and best practices.

### Comparison Document

See [COMPARISON.md](./docs/COMPARISON.md) for detailed comparison of monitoring stacks.

## 🧪 Testing

### Generate Test Logs
```bash
curl http://localhost:3000/api/logs/test
```

### Check Metrics
```bash
curl http://localhost:3000/api/metrics
```

### Verify Prometheus Targets
Visit: http://localhost:9090/targets

### Check Loki Logs
```bash
curl -G -s "http://localhost:3100/loki/api/v1/query_range" \
  --data-urlencode 'query={job="nodejs-app"}' \
  --data-urlencode 'limit=10'
```

## 🛠️ Troubleshooting

### Services not starting
```bash
# Check Docker containers
docker-compose ps
docker-compose logs [service-name]

# Check systemd services (manual install)
sudo systemctl status prometheus
sudo systemctl status grafana-server
sudo systemctl status loki
```

### Port conflicts
- Change ports in `docker-compose.yml` or service configurations
- Update firewall rules accordingly

### Logs not appearing in Loki
- Verify Loki is running: `curl http://localhost:3100/ready`
- Check Winston-Loki configuration
- Verify network connectivity

## 📄 License

MIT

## 👥 Contributors

Module 6 Assignment Submission

