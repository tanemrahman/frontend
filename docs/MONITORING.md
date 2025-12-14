# Monitoring Guide

## Overview

This guide covers monitoring setup, dashboard creation, and best practices for the Module 6 monitoring stack.

## Prometheus Metrics

### Available Metrics

#### Application Metrics

**HTTP Request Metrics:**
- `http_requests_total` - Total HTTP requests (counter)
  - Labels: `method`, `route`, `status_code`
- `http_request_duration_seconds` - Request duration (histogram)
  - Labels: `method`, `route`, `status_code`
  - Buckets: 0.1, 0.3, 0.5, 0.7, 1, 3, 5, 7, 10 seconds

**Node.js Metrics (Default):**
- `process_cpu_user_seconds_total` - CPU user time
- `process_cpu_system_seconds_total` - CPU system time
- `process_resident_memory_bytes` - Resident memory
- `nodejs_heap_size_total_bytes` - Heap size
- `nodejs_heap_size_used_bytes` - Heap used
- `nodejs_eventloop_lag_seconds` - Event loop lag

#### System Metrics (Node Exporter)

**CPU Metrics:**
- `node_cpu_seconds_total` - CPU time per mode
- `node_load1`, `node_load5`, `node_load15` - Load average

**Memory Metrics:**
- `node_memory_MemTotal_bytes` - Total memory
- `node_memory_MemAvailable_bytes` - Available memory
- `node_memory_MemFree_bytes` - Free memory
- `node_memory_Cached_bytes` - Cached memory

**Disk Metrics:**
- `node_disk_io_time_seconds_total` - Disk I/O time
- `node_disk_read_bytes_total` - Disk read bytes
- `node_disk_write_bytes_total` - Disk write bytes
- `node_filesystem_avail_bytes` - Available filesystem space

**Network Metrics:**
- `node_network_receive_bytes_total` - Received bytes
- `node_network_transmit_bytes_total` - Transmitted bytes
- `node_network_receive_packets_total` - Received packets

## PromQL Queries

### Application Queries

**Request Rate:**
```promql
rate(http_requests_total[5m])
```

**Request Rate by Status Code:**
```promql
sum(rate(http_requests_total[5m])) by (status_code)
```

**Average Request Duration:**
```promql
rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m])
```

**95th Percentile Request Duration:**
```promql
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

**Error Rate:**
```promql
sum(rate(http_requests_total{status_code=~"5.."}[5m]))
```

### System Queries

**CPU Usage Percentage:**
```promql
100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

**Memory Usage Percentage:**
```promql
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
```

**Disk Usage Percentage:**
```promql
(1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100
```

**Network Receive Rate:**
```promql
rate(node_network_receive_bytes_total[5m])
```

## Grafana Dashboards

### Creating Dashboards

#### 1. Application Metrics Dashboard

**Panel 1: Request Rate**
- Type: Time series
- Query: `sum(rate(http_requests_total[5m])) by (status_code)`
- Legend: `{{status_code}}`

**Panel 2: Request Duration (P95)**
- Type: Time series
- Query: `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))`
- Unit: seconds

**Panel 3: Error Rate**
- Type: Stat
- Query: `sum(rate(http_requests_total{status_code=~"5.."}[5m]))`
- Thresholds: 0 (green), 0.1 (yellow), 1 (red)

**Panel 4: Active Requests**
- Type: Gauge
- Query: `sum(http_requests_total)`

#### 2. System Metrics Dashboard

**Panel 1: CPU Usage**
- Type: Time series
- Query: `100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)`
- Unit: percent

**Panel 2: Memory Usage**
- Type: Time series
- Query: `(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100`
- Unit: percent

**Panel 3: Disk I/O**
- Type: Time series
- Query: `rate(node_disk_io_time_seconds_total[5m])`
- Unit: ops/sec

**Panel 4: Network Traffic**
- Type: Time series
- Query: `rate(node_network_receive_bytes_total[5m])` and `rate(node_network_transmit_bytes_total[5m])`
- Unit: bytes/sec

#### 3. Log Dashboard

**Panel 1: Log Stream**
- Type: Logs
- Data source: Loki
- Query: `{job="nodejs-app"}`

**Panel 2: Error Logs**
- Type: Logs
- Data source: Loki
- Query: `{job="nodejs-app"} |= "error"`

**Panel 3: Log Rate**
- Type: Time series
- Data source: Loki
- Query: `sum(rate({job="nodejs-app"}[5m]))`

### Importing Pre-built Dashboards

1. Go to Grafana → Dashboards → Import
2. Enter dashboard ID:
   - Node Exporter: `1860`
   - Node.js Application: `11159`
3. Select Prometheus datasource
4. Click Import

## LogQL Queries (Loki)

### Basic Queries

**All Application Logs:**
```logql
{job="nodejs-app"}
```

**Error Logs:**
```logql
{job="nodejs-app"} |= "error"
```

**Logs with Specific Status Code:**
```logql
{job="nodejs-app"} | json | statusCode >= 400
```

**Logs by Level:**
```logql
{job="nodejs-app", level="error"}
```

### Advanced Queries

**Log Rate:**
```logql
sum(rate({job="nodejs-app"}[5m]))
```

**Error Rate:**
```logql
sum(rate({job="nodejs-app"} |= "error" [5m]))
```

**Parse JSON and Filter:**
```logql
{job="nodejs-app"} | json | statusCode = 500
```

**Extract Fields:**
```logql
{job="nodejs-app"} | json | line_format "{{.method}} {{.path}} {{.statusCode}}"
```

## Alerting

### Grafana Alerts

#### Create Alert Rule

1. Go to Alerting → Alert rules
2. Create new rule
3. Configure:
   - **Name**: High Error Rate
   - **Query**: `sum(rate(http_requests_total{status_code=~"5.."}[5m])) > 0.1`
   - **Condition**: When last is above 0.1
   - **Evaluation**: Every 1m, For 5m

#### Notification Channels

1. Go to Alerting → Notification channels
2. Add channel:
   - **Type**: Email, Slack, PagerDuty, etc.
   - **Settings**: Configure credentials
3. Link to alert rules

### Prometheus Alerts (Advanced)

Create `prometheus/alerts.yml`:

```yaml
groups:
  - name: application
    interval: 30s
    rules:
      - alert: HighErrorRate
        expr: sum(rate(http_requests_total{status_code=~"5.."}[5m])) > 0.1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value }} errors/sec"

      - alert: HighRequestLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High request latency"
          description: "P95 latency is {{ $value }}s"

      - alert: HighCPUUsage
        expr: 100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage"
          description: "CPU usage is {{ $value }}%"

      - alert: HighMemoryUsage
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage"
          description: "Memory usage is {{ $value }}%"
```

Update `prometheus.yml`:
```yaml
rule_files:
  - "alerts.yml"
```

## Best Practices

### Metrics Collection

1. **Label Cardinality:**
   - Avoid high-cardinality labels
   - Use consistent label names
   - Limit label values

2. **Scrape Intervals:**
   - Balance between detail and resource usage
   - 15s for critical metrics
   - 1m for less critical metrics

3. **Retention:**
   - Configure appropriate retention
   - Use remote storage for long-term
   - Archive old data

### Dashboard Design

1. **Organization:**
   - Group related panels
   - Use row folders
   - Clear naming conventions

2. **Visualization:**
   - Use appropriate chart types
   - Set meaningful thresholds
   - Add descriptions

3. **Performance:**
   - Limit query time ranges
   - Use query optimization
   - Cache queries when possible

### Logging

1. **Structured Logging:**
   - Use JSON format
   - Include relevant context
   - Consistent field names

2. **Log Levels:**
   - Use appropriate levels
   - Avoid verbose logging in production
   - Include error details

3. **Log Retention:**
   - Configure retention policies
   - Archive old logs
   - Monitor log volume

## Troubleshooting

### Metrics Not Appearing

1. Check Prometheus targets: http://localhost:9090/targets
2. Verify scrape configuration
3. Check network connectivity
4. Review Prometheus logs

### Logs Not Appearing

1. Verify Loki is running
2. Check Winston-Loki configuration
3. Test log generation endpoint
4. Review Loki logs

### Dashboard Issues

1. Verify datasource connectivity
2. Check query syntax
3. Verify time range
4. Review Grafana logs

