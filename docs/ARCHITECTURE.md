# Architecture Documentation

## System Architecture

### High-Level Overview

```
┌─────────────────────────────────────────────────────────────┐
│                        Client Browser                         │
└───────────────────────────┬───────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    Nginx Reverse Proxy                        │
│                  (Port 80/443 - Optional)                    │
└───────────────────────────┬───────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│              Node.js Application (Express)                   │
│                      Port: 3000                              │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Frontend: React SPA (Static Files)                   │  │
│  │  API Endpoints: /api/health, /api/metrics, /api/logs │  │
│  └──────────────────────────────────────────────────────┘  │
└───────────┬───────────────────────────────┬──────────────────┘
            │                               │
            │ Metrics                       │ Logs
            ▼                               ▼
┌───────────────────────┐      ┌───────────────────────┐
│    Prometheus         │      │        Loki           │
│    Port: 9090         │      │    Port: 3100         │
│  ┌─────────────────┐  │      │  ┌─────────────────┐  │
│  │  TSDB Storage   │  │      │  │  Log Storage    │  │
│  │  - Metrics      │  │      │  │  - Application  │  │
│  │  - Time Series  │  │      │  │  - Structured   │  │
│  └─────────────────┘  │      │  └─────────────────┘  │
└───────────┬───────────┘      └───────────────────────┘
            │
            │ Scrapes
            ▼
┌───────────────────────┐
│   Node Exporter       │
│   Port: 9100          │
│  ┌─────────────────┐  │
│  │  System Metrics │  │
│  │  - CPU          │  │
│  │  - Memory       │  │
│  │  - Disk         │  │
│  │  - Network      │  │
│  └─────────────────┘  │
└───────────────────────┘
            │
            │ Queries
            ▼
┌───────────────────────┐
│      Grafana          │
│    Port: 3001         │
│  ┌─────────────────┐  │
│  │  Dashboards     │  │
│  │  - Metrics      │  │
│  │  - Logs         │  │
│  │  - Alerts       │  │
│  └─────────────────┘  │
└───────────────────────┘
```

## Component Details

### 1. Frontend Application

**Technology Stack:**
- React 18
- Vite (Build tool)
- Axios (HTTP client)

**Build Process:**
1. Development: `npm run dev` (Vite dev server)
2. Production: `npm run build` (Creates `dist/` folder)
3. Serving: Express serves static files from `frontend/dist/`

**Features:**
- Health status monitoring
- Real-time application status
- Links to monitoring dashboards
- Test log generation

### 2. Node.js Backend

**Technology Stack:**
- Express.js (Web framework)
- Prometheus Client (Metrics)
- Winston (Logging)
- Winston-Loki (Log forwarding)

**Endpoints:**
- `GET /` - Frontend application
- `GET /api/health` - Health check
- `GET /api/metrics` - Prometheus metrics
- `GET /api/logs/test` - Generate test logs

**Metrics Exposed:**
- `http_request_duration_seconds` - Request latency histogram
- `http_requests_total` - Request counter
- Default Node.js metrics (CPU, memory, etc.)

**Logging:**
- Structured JSON logs
- Forwarded to Loki via Winston-Loki transport
- Console output for development

### 3. Prometheus

**Role:** Time Series Database and Metrics Collection

**Configuration:**
- Scrape interval: 15 seconds
- Retention: 200 hours
- Storage: Local TSDB

**Scrape Targets:**
1. **prometheus** (self-monitoring)
   - Endpoint: `localhost:9090`
   
2. **node-exporter** (system metrics)
   - Endpoint: `localhost:9100`
   - Metrics: CPU, memory, disk, network
   
3. **nodejs-app** (application metrics)
   - Endpoint: `localhost:3000/api/metrics`
   - Metrics: HTTP requests, response times, errors

**Data Model:**
```
metric_name{label1="value1", label2="value2"} value timestamp
```

**Example Metrics:**
```
http_requests_total{method="GET", route="/api/health", status_code="200"} 42
http_request_duration_seconds{method="GET", route="/api/health", status_code="200"} 0.023
node_cpu_seconds_total{cpu="0", mode="idle"} 12345.67
```

### 4. Node Exporter

**Role:** System Metrics Collection

**Metrics Collected:**
- **CPU**: Usage per core, idle time, I/O wait
- **Memory**: Total, available, used, cached, buffers
- **Disk**: I/O operations, space usage, read/write rates
- **Network**: Bytes sent/received, packets, errors
- **System**: Load average, uptime, processes

**Exposed Endpoint:**
- `http://localhost:9100/metrics` (Prometheus format)

### 5. Grafana

**Role:** Visualization and Dashboards

**Data Sources:**
1. **Prometheus**
   - URL: `http://localhost:9090`
   - Default datasource
   - Used for metrics visualization

2. **Loki**
   - URL: `http://localhost:3100`
   - Used for log visualization
   - LogQL queries

**Features:**
- Pre-configured datasources (via provisioning)
- Custom dashboards
- Alerting rules
- User authentication

**Access Control:**
- Default user: `admin/admin`
- Security group restrictions (cloud deployment)
- IP whitelisting recommended

### 6. Loki

**Role:** Log Aggregation System

**Architecture:**
- Label-based indexing (not full-text search)
- Object storage backend (filesystem in this setup)
- Efficient storage and querying

**Log Sources:**
- Node.js application (via Winston-Loki)
- Structured JSON logs
- Labeled by job, environment, level

**Query Language (LogQL):**
```logql
# Filter logs
{job="nodejs-app"} |= "error"

# Parse JSON and filter
{job="nodejs-app"} | json | statusCode >= 400

# Calculate rates
rate({job="nodejs-app"}[5m])
```

**Storage:**
- Chunks directory: `/tmp/loki/chunks`
- Index directory: `/tmp/loki/index`
- Retention: Configurable

## Data Flow

### Metrics Flow

1. **Application Metrics:**
   ```
   Node.js App → /api/metrics (Prometheus format)
                ↓
            Prometheus (scrapes every 15s)
                ↓
            Grafana (queries for visualization)
   ```

2. **System Metrics:**
   ```
   Node Exporter → /metrics (Prometheus format)
                  ↓
              Prometheus (scrapes every 15s)
                  ↓
              Grafana (queries for visualization)
   ```

### Logs Flow

1. **Application Logs:**
   ```
   Node.js App → Winston Logger
                ↓
            Winston-Loki Transport
                ↓
            Loki (HTTP push)
                ↓
            Grafana (LogQL queries)
   ```

## Deployment Architecture

### Docker Compose Deployment

All services run as containers:
- **Network**: `monitoring` (bridge network)
- **Volumes**: Persistent data for Prometheus, Grafana, Loki
- **Ports**: Exposed to host for access

### Manual Deployment

Services run as systemd services:
- Individual service files
- System-level installation
- Direct port binding

## Security Considerations

1. **Grafana Access:**
   - Security group restrictions
   - IP whitelisting
   - Strong passwords

2. **Prometheus:**
   - Internal network access only
   - No authentication (internal use)

3. **Application:**
   - Rate limiting (can be added)
   - Input validation
   - Error handling

4. **Network:**
   - Firewall rules
   - VPN access for sensitive endpoints
   - HTTPS (production recommendation)

## Scalability

### Horizontal Scaling

- **Prometheus**: Federation for multiple instances
- **Loki**: Distributed mode with object storage
- **Grafana**: Multiple instances with shared database
- **Application**: Load balancer with multiple instances

### Vertical Scaling

- Increase resources for each service
- Optimize retention policies
- Adjust scrape intervals

## Monitoring Strategy

1. **Infrastructure Monitoring:**
   - Node Exporter metrics
   - System health dashboards

2. **Application Monitoring:**
   - Custom application metrics
   - Request/response tracking
   - Error rates

3. **Log Monitoring:**
   - Application logs in Loki
   - Error log analysis
   - Security event logging

4. **Alerting:**
   - Grafana alerting rules
   - Prometheus alerting (can be extended)
   - Notification channels

