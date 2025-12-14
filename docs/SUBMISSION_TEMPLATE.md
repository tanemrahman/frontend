# Module 6 Assignment - Submission Document

**Student Name:** [Your Name]  
**Student ID:** [Your ID]  
**Submission Date:** [Date]  
**Course:** [Course Name]

---

## Executive Summary

This document presents the complete implementation of a full monitoring stack including frontend deployment, Prometheus, Grafana, Node Exporter, and Loki. All components have been successfully deployed, configured, and verified.

---

## Part 1: Frontend Deployment

### 1.1 Server Environment Preparation

**Objective:** Prepare the server environment for hosting the frontend application.

**Steps Taken:**
1. Installed Node.js 18+ on the server
2. Verified Node.js and npm versions
3. Created project directory structure
4. Set up Express server for serving static files

**Screenshot 1.1:** Node.js Installation Verification
```
[Insert screenshot showing: node --version output]
```

**Screenshot 1.2:** Project Structure
```
[Insert screenshot showing: project directory structure]
```

**Verification:**
- Node.js version: v18.x.x or higher
- npm version: 9.x.x or higher
- Project structure created successfully

---

### 1.2 Frontend Project Setup

**Objective:** Clone and set up the frontend project.

**Steps Taken:**
1. Created React application with Vite
2. Installed frontend dependencies
3. Configured build settings for production

**Screenshot 1.3:** Frontend Dependencies Installation
```
[Insert screenshot showing: npm install in frontend directory]
```

**Screenshot 1.4:** Frontend Build Configuration
```
[Insert screenshot showing: vite.config.js or package.json]
```

---

### 1.3 Building Frontend Application

**Objective:** Build the frontend application for production.

**Steps Taken:**
1. Ran production build command: `npm run build`
2. Verified build output in `frontend/dist` directory
3. Checked for build errors

**Screenshot 1.5:** Build Process
```
[Insert screenshot showing: npm run build output]
```

**Screenshot 1.6:** Build Output
```
[Insert screenshot showing: frontend/dist directory contents]
```

**Build Output:**
- Static files generated successfully
- Assets optimized for production
- No build errors or warnings

---

### 1.4 Serving Frontend Application

**Objective:** Serve the built application through Express web server.

**Steps Taken:**
1. Configured Express to serve static files from `frontend/dist`
2. Set up API endpoints for health checks and metrics
3. Started the application server

**Screenshot 1.7:** Server Configuration
```
[Insert screenshot showing: server.js static file serving configuration]
```

**Screenshot 1.8:** Server Running
```
[Insert screenshot showing: npm start output with server running]
```

---

### 1.5 Verification

**Objective:** Verify the frontend is accessible from public URL or server IP.

**Steps Taken:**
1. Accessed frontend at http://localhost:3000
2. Tested health endpoint: http://localhost:3000/api/health
3. Verified all frontend routes work correctly

**Screenshot 1.9:** Frontend Application
```
[Insert screenshot showing: Browser with frontend application loaded]
```

**Screenshot 1.10:** Health Endpoint
```
[Insert screenshot showing: /api/health response in browser or Postman]
```

**Screenshot 1.11:** Network Verification
```
[Insert screenshot showing: Browser DevTools Network tab with successful requests]
```

**Verification Results:**
- ✅ Frontend accessible at http://localhost:3000
- ✅ Health endpoint returns correct status
- ✅ All static assets loading correctly
- ✅ No console errors

---

## Part 2: Monitoring Stack Setup

### 2.1 Prometheus Installation

**Objective:** Install Prometheus on the server instance.

**Steps Taken:**
1. Downloaded Prometheus latest version
2. Extracted and configured Prometheus
3. Created systemd service for Prometheus
4. Started and enabled Prometheus service

**Screenshot 2.1:** Prometheus Installation
```
[Insert screenshot showing: Prometheus installation commands and output]
```

**Screenshot 2.2:** Prometheus Configuration
```
[Insert screenshot showing: prometheus.yml configuration file]
```

**Screenshot 2.3:** Prometheus Service Status
```
[Insert screenshot showing: systemctl status prometheus or docker-compose ps]
```

**Configuration Details:**
- Scrape interval: 15 seconds
- Retention: 200 hours
- Targets configured: Prometheus self, Node Exporter, Node.js app

---

### 2.2 Grafana Installation

**Objective:** Install Grafana on the same instance.

**Steps Taken:**
1. Installed Grafana using package manager or Docker
2. Started Grafana service
3. Configured initial admin credentials
4. Set up datasource provisioning

**Screenshot 2.4:** Grafana Installation
```
[Insert screenshot showing: Grafana installation/startup]
```

**Screenshot 2.5:** Grafana Login Page
```
[Insert screenshot showing: Grafana login page at http://localhost:3001]
```

**Screenshot 2.6:** Grafana Datasources
```
[Insert screenshot showing: Grafana Configuration → Data Sources with Prometheus configured]
```

**Configuration:**
- Default credentials: admin/admin (changed in production)
- Prometheus datasource auto-configured
- Loki datasource auto-configured

---

### 2.3 Node Exporter Installation

**Objective:** Install Node Exporter to collect system metrics.

**Steps Taken:**
1. Downloaded Node Exporter
2. Installed and configured Node Exporter
3. Created systemd service
4. Started Node Exporter service

**Screenshot 2.7:** Node Exporter Installation
```
[Insert screenshot showing: Node Exporter installation]
```

**Screenshot 2.8:** Node Exporter Metrics Endpoint
```
[Insert screenshot showing: http://localhost:9100/metrics in browser]
```

**Screenshot 2.9:** Node Exporter Service Status
```
[Insert screenshot showing: systemctl status node-exporter or docker logs]
```

**Metrics Collected:**
- CPU usage and load average
- Memory usage (total, available, used)
- Disk I/O and space usage
- Network statistics
- System uptime and processes

---

### 2.4 Prometheus Configuration

**Objective:** Configure Prometheus to scrape metrics from Node Exporter.

**Steps Taken:**
1. Updated `prometheus.yml` with Node Exporter target
2. Added Node.js application metrics endpoint
3. Reloaded Prometheus configuration

**Screenshot 2.10:** Prometheus Configuration File
```
[Insert screenshot showing: prometheus.yml with all scrape configs]
```

**Screenshot 2.11:** Prometheus Targets
```
[Insert screenshot showing: http://localhost:9090/targets with all targets UP]
```

**Targets Configured:**
1. **prometheus** (self-monitoring) - localhost:9090
2. **node-exporter** (system metrics) - localhost:9100
3. **nodejs-app** (application metrics) - localhost:3000/api/metrics

**Verification:**
- ✅ All targets showing as UP
- ✅ No scrape errors
- ✅ Metrics being collected successfully

---

### 2.5 Grafana Security Configuration

**Objective:** Deploy Grafana in public-facing environment with IP restrictions.

**Steps Taken:**
1. Configured security group (AWS/Cloud) or firewall rules
2. Set up IP whitelist for Grafana access
3. Configured Nginx reverse proxy with IP restrictions

**Screenshot 2.12:** Security Group Configuration
```
[Insert screenshot showing: AWS Security Group or firewall rules]
```

**Screenshot 2.13:** Nginx Configuration
```
[Insert screenshot showing: nginx.conf with IP restrictions]
```

**Security Measures:**
- Grafana accessible only from whitelisted IPs
- Prometheus restricted to internal network
- Application publicly accessible
- Node Exporter internal only

---

### 2.6 Dashboard Creation

**Objective:** Create working time-series monitoring setup and verify metric ingestion.

**Steps Taken:**
1. Imported Node Exporter dashboard (ID: 1860)
2. Created custom application metrics dashboard
3. Verified metrics are being ingested
4. Created visualizations for key metrics

**Screenshot 2.14:** Node Exporter Dashboard
```
[Insert screenshot showing: Grafana dashboard with Node Exporter metrics]
```

**Screenshot 2.15:** Application Metrics Dashboard
```
[Insert screenshot showing: Custom dashboard with application metrics]
```

**Screenshot 2.16:** Prometheus Query Examples
```
[Insert screenshot showing: Prometheus UI with PromQL queries]
```

**Dashboards Created:**
1. **System Metrics Dashboard:**
   - CPU usage over time
   - Memory usage percentage
   - Disk I/O rates
   - Network traffic

2. **Application Metrics Dashboard:**
   - HTTP request rate
   - Request duration (P95)
   - Error rate
   - Active requests

**Verification:**
- ✅ Metrics appearing in Prometheus
- ✅ Dashboards showing real-time data
- ✅ Time-series graphs updating correctly
- ✅ No data gaps or errors

---

## Part 3: Node Exporter Log Configuration

### 3.1 Log Exporting Setup

**Objective:** Enable log exporting from the application server.

**Steps Taken:**
1. Configured Winston logger in Node.js application
2. Set up Winston-Loki transport for log forwarding
3. Configured structured logging with labels
4. Tested log generation

**Screenshot 3.1:** Winston-Loki Configuration
```
[Insert screenshot showing: server.js with Winston-Loki transport configuration]
```

**Screenshot 3.2:** Log Generation Test
```
[Insert screenshot showing: curl http://localhost:3000/api/logs/test output]
```

**Screenshot 3.3:** Application Logs
```
[Insert screenshot showing: Application console logs or log files]
```

**Configuration:**
- Log format: JSON
- Log levels: info, warn, error
- Labels: job, environment, level
- Transport: Console + Loki

---

### 3.2 Prometheus Log Metrics

**Objective:** Configure log-to-metrics conversion and validate in Prometheus.

**Steps Taken:**
1. Application exposes metrics from log events
2. Prometheus scrapes application metrics endpoint
3. Verified log-based metrics in Prometheus

**Screenshot 3.4:** Application Metrics Endpoint
```
[Insert screenshot showing: http://localhost:3000/api/metrics output]
```

**Screenshot 3.5:** Prometheus Log Metrics Query
```
[Insert screenshot showing: Prometheus query for http_requests_total]
```

**Screenshot 3.6:** Prometheus Graph
```
[Insert screenshot showing: Prometheus graph with log-based metrics over time]
```

**Metrics from Logs:**
- `http_requests_total` - Request count from logs
- `http_request_duration_seconds` - Request duration
- Error rates calculated from log events

**Verification:**
- ✅ Metrics appearing in Prometheus
- ✅ Metrics updating in real-time
- ✅ Queries returning correct data

---

### 3.3 Grafana Log Visualization

**Objective:** Create Grafana panel showing log-based metric visualization.

**Steps Taken:**
1. Created Grafana panel with log-based metrics
2. Used PromQL queries for log metrics
3. Configured visualization options
4. Verified data display

**Screenshot 3.7:** Grafana Log Metrics Panel
```
[Insert screenshot showing: Grafana panel with log-based metrics]
```

**Screenshot 3.8:** PromQL Query in Grafana
```
[Insert screenshot showing: Grafana query editor with PromQL]
```

**Screenshot 3.9:** Log Metrics Visualization
```
[Insert screenshot showing: Time-series graph of log metrics]
```

**Queries Used:**
```promql
# Request rate from logs
rate(http_requests_total[5m])

# Error rate from logs
sum(rate(http_requests_total{status_code=~"5.."}[5m]))

# Request duration from logs
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

**Verification:**
- ✅ Panel displaying log metrics correctly
- ✅ Data updating in real-time
- ✅ Visualization clear and readable

---

## Part 4: Time Series Database & Monitoring Concepts

### 4.1 Time Series Database Explanation

**What is a Time Series Database (TSDB)?**

A Time Series Database is a specialized database optimized for storing and querying data points that are indexed by time. Each data point consists of:
- **Timestamp**: When the data was collected
- **Metric Name**: What is being measured
- **Value**: The actual measurement
- **Labels/Tags**: Additional metadata for filtering and grouping

**Key Characteristics:**
- Efficient storage of time-sequenced data
- Fast queries over time ranges
- Compression for historical data
- Retention policies for data management
- Optimized for write-heavy workloads

**Why Use TSDB for Monitoring?**
- Monitoring data is inherently time-based
- Need to query data over time ranges
- High write volume (many metrics, frequent updates)
- Need efficient storage and retrieval
- Real-time and historical analysis required

**Screenshot 4.1:** TSDB Data Model Example
```
[Insert screenshot showing: Prometheus data model or time-series data structure]
```

---

### 4.2 Prometheus Storage & Querying

**How Prometheus Stores Data:**

1. **Storage Architecture:**
   - **Head Block**: Recent data stored in memory
   - **Persistent Blocks**: Compressed data on disk
   - **Chunks**: Data organized in chunks for efficiency
   - **Index**: Fast lookup of time-series data

2. **Data Model:**
   ```
   metric_name{label1="value1", label2="value2"} value timestamp
   ```
   Example:
   ```
   http_requests_total{method="GET", route="/api/health", status_code="200"} 42 1234567890
   ```

3. **Retention:**
   - Configurable retention period (default: 15 days)
   - In this setup: 200 hours
   - Can use remote storage for longer retention

**Screenshot 4.2:** Prometheus Storage
```
[Insert screenshot showing: Prometheus storage information or data directory]
```

**PromQL (Prometheus Query Language):**

PromQL is a functional query language for time-series data.

**Query Examples:**

1. **Rate Calculation:**
   ```promql
   rate(http_requests_total[5m])
   ```
   Calculates per-second rate over 5 minutes

2. **Aggregation:**
   ```promql
   sum(rate(http_requests_total[5m])) by (status_code)
   ```
   Groups by status code and sums rates

3. **Percentiles:**
   ```promql
   histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
   ```
   Calculates 95th percentile latency

4. **CPU Usage:**
   ```promql
   100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
   ```
   Calculates CPU usage percentage

**Screenshot 4.3:** PromQL Queries
```
[Insert screenshot showing: Prometheus UI with various PromQL queries]
```

**Screenshot 4.4:** Prometheus Graph
```
[Insert screenshot showing: Prometheus graph with time-series visualization]
```

---

### 4.3 Comparison with Other Monitoring Stacks

| Feature | Prometheus | InfluxDB | Graphite | Datadog |
|---------|-----------|----------|----------|---------|
| **Data Model** | Pull-based | Push/Pull | Push-based | SaaS |
| **Storage** | Local TSDB | Local/Cloud | Whisper | Cloud |
| **Query Language** | PromQL | InfluxQL | Graphite API | Custom |
| **Scalability** | Horizontal | Horizontal | Vertical | Managed |
| **Cost** | Free | Open-source/Paid | Free | Paid |
| **Setup Complexity** | Medium | Medium | Low | Low |
| **Best For** | Kubernetes, Microservices | IoT, High-frequency | Legacy systems | Enterprise |
| **Community** | Large | Large | Medium | Commercial |
| **Learning Curve** | Medium | Medium | Low | Low |

**Prometheus Advantages:**
- ✅ Free and open-source
- ✅ Powerful query language (PromQL)
- ✅ Excellent Kubernetes integration
- ✅ Large ecosystem
- ✅ Pull-based model reduces complexity

**Prometheus Disadvantages:**
- ❌ Local storage limitations
- ❌ Not designed for logs
- ❌ Requires learning PromQL
- ❌ Can have cardinality issues

**Screenshot 4.5:** Comparison Visualization
```
[Insert screenshot or table showing comparison]
```

---

### 4.4 Common Monitoring Architectures

**1. Prometheus + Grafana Architecture**

```
Application → Metrics Endpoint
                ↓
            Prometheus (scrapes)
                ↓
            Grafana (visualizes)
```

**Use Cases:**
- Kubernetes and container orchestration
- Microservices architectures
- Self-hosted monitoring
- Cost-effective solutions

**2. ELK Stack (Elasticsearch, Logstash, Kibana)**

```
Logs → Logstash → Elasticsearch
                      ↓
                   Kibana
```

**Use Cases:**
- Log-centric monitoring
- Full-text search requirements
- Security information and event management (SIEM)
- Complex log analysis

**3. Cloud-Native Monitoring (Datadog, New Relic)**

```
Applications → Agents → Cloud Platform
```

**Use Cases:**
- Enterprise environments
- Multi-cloud deployments
- Managed service preference
- All-in-one solution needed

**4. Hybrid Architecture (This Project)**

```
Application → Prometheus (metrics)
Application → Loki (logs)
                ↓
            Grafana (unified view)
```

**Use Cases:**
- Need both metrics and logs
- Cost-effective solution
- Self-hosted preference
- Prometheus ecosystem

**Screenshot 4.6:** Architecture Diagram
```
[Insert screenshot showing: Architecture diagram from docs/ARCHITECTURE.md]
```

---

## Part 5: Loki & SIEM

### 5.1 Loki Installation

**Objective:** Install Loki on the server where Grafana is running.

**Steps Taken:**
1. Downloaded Loki binary or used Docker image
2. Created Loki configuration file
3. Started Loki service
4. Verified Loki is running

**Screenshot 5.1:** Loki Installation
```
[Insert screenshot showing: Loki installation/startup]
```

**Screenshot 5.2:** Loki Configuration
```
[Insert screenshot showing: loki-config.yml configuration file]
```

**Screenshot 5.3:** Loki Readiness Check
```
[Insert screenshot showing: curl http://localhost:3100/ready output]
```

**Configuration Details:**
- HTTP port: 3100
- Storage: Filesystem (can be S3, GCS, etc.)
- Retention: Configurable
- Index: Label-based

---

### 5.2 Application Log Forwarding

**Objective:** Configure application server to forward logs to Loki.

**Steps Taken:**
1. Installed winston-loki package
2. Configured Winston logger with Loki transport
3. Set up log labels and formatting
4. Tested log forwarding

**Screenshot 5.4:** Winston-Loki Configuration
```
[Insert screenshot showing: server.js with Winston-Loki transport]
```

**Screenshot 5.5:** Log Forwarding Test
```
[Insert screenshot showing: Application logs being sent to Loki]
```

**Screenshot 5.6:** Loki API Response
```
[Insert screenshot showing: Loki API query response with logs]
```

**Configuration:**
```javascript
new LokiTransport({
  host: 'http://localhost:3100',
  labels: {
    job: 'nodejs-app',
    environment: 'production'
  }
})
```

**Log Labels:**
- `job`: Application identifier
- `environment`: Deployment environment
- `level`: Log level (info, warn, error)

---

### 5.3 Grafana Loki Integration

**Objective:** Integrate Loki as a data source inside Grafana.

**Steps Taken:**
1. Added Loki datasource in Grafana
2. Configured connection settings
3. Tested datasource connection
4. Verified log queries work

**Screenshot 5.7:** Loki Datasource Configuration
```
[Insert screenshot showing: Grafana datasource configuration for Loki]
```

**Screenshot 5.8:** Datasource Test
```
[Insert screenshot showing: Grafana datasource test successful]
```

**Configuration:**
- URL: http://localhost:3100
- Access: Proxy
- Max lines: 1000
- Timeout: 60s

---

### 5.4 Log Visualizations

**Objective:** Build log-based visualizations and log query panels on Grafana.

**Steps Taken:**
1. Created log stream panel in Grafana
2. Used LogQL queries for filtering
3. Created log-based metric visualizations
4. Set up real-time log monitoring

**Screenshot 5.9:** Log Stream Panel
```
[Insert screenshot showing: Grafana Explore page with log stream]
```

**Screenshot 5.10:** LogQL Query
```
[Insert screenshot showing: LogQL query in Grafana Explore]
```

**Screenshot 5.11:** Log-Based Metrics
```
[Insert screenshot showing: Grafana panel with log rate metrics]
```

**LogQL Queries Used:**

1. **All Application Logs:**
   ```logql
   {job="nodejs-app"}
   ```

2. **Error Logs Only:**
   ```logql
   {job="nodejs-app"} |= "error"
   ```

3. **Logs with Status Code:**
   ```logql
   {job="nodejs-app"} | json | statusCode >= 400
   ```

4. **Log Rate:**
   ```logql
   sum(rate({job="nodejs-app"}[5m]))
   ```

**Screenshot 5.12:** Log Dashboard
```
[Insert screenshot showing: Complete log dashboard in Grafana]
```

---

### 5.5 SIEM Concepts

**What is SIEM (Security Information and Event Management)?**

SIEM tools collect, analyze, and correlate security events from multiple sources to detect threats and provide security insights.

**Key Features:**
- **Log Aggregation**: Centralized collection of security logs
- **Real-time Monitoring**: Continuous monitoring of security events
- **Threat Detection**: Automated detection of security threats
- **Incident Response**: Tools for responding to security incidents
- **Compliance Reporting**: Generate reports for compliance requirements
- **Event Correlation**: Connect related events across systems

**How Loki Aligns with SIEM Concepts:**

1. **Log Aggregation:**
   - Loki collects logs from multiple sources
   - Centralized log storage
   - Efficient log indexing

2. **Real-time Monitoring:**
   - Real-time log streaming
   - Fast log queries
   - Live dashboards

3. **Threat Detection:**
   - LogQL queries for security events
   - Alerting on suspicious patterns
   - Correlation of security events

4. **Integration:**
   - Works with Grafana for visualization
   - Can integrate with alerting systems
   - Supports security dashboards

**SIEM Use Cases with Loki:**
- Security event logging
- Anomaly detection
- Access monitoring
- Compliance auditing
- Incident investigation

**Screenshot 5.13:** Security Dashboard Example
```
[Insert screenshot showing: Security-focused dashboard in Grafana]
```

---

### 5.6 APM (Application Performance Monitoring)

**What is APM?**

APM provides deep insights into application performance, including:
- **Transaction Tracing**: Track requests across services
- **Code-level Performance**: Identify slow code paths
- **Database Query Analysis**: Monitor database performance
- **Error Tracking**: Track and analyze application errors
- **User Experience Monitoring**: Monitor end-user experience

**APM vs Basic Metrics Monitoring:**

| Aspect | Basic Metrics | APM |
|--------|--------------|-----|
| **Granularity** | Service/System level | Code/Transaction level |
| **Data Type** | Aggregated metrics | Traces, spans, events |
| **Use Case** | Infrastructure monitoring | Application debugging |
| **Tools** | Prometheus, Node Exporter | Jaeger, Zipkin, New Relic |
| **Overhead** | Low | Medium-High |
| **Setup** | Simple | More complex |
| **Cost** | Low | Medium-High |

**APM Tools:**

1. **Jaeger:**
   - Distributed tracing
   - Open-source
   - Kubernetes-native
   - Best for: Microservices tracing

2. **Zipkin:**
   - Request tracing
   - Open-source
   - Simple setup
   - Best for: Application tracing

3. **New Relic APM:**
   - Full APM suite
   - SaaS solution
   - Code-level insights
   - Best for: Enterprise APM

4. **Datadog APM:**
   - Integrated with metrics and logs
   - SaaS solution
   - Easy setup
   - Best for: All-in-one monitoring

**When to Use APM:**
- Need code-level performance insights
- Debugging performance issues
- Distributed system tracing
- Database query optimization
- User experience monitoring

**This Project:**
- Uses Prometheus for basic metrics (infrastructure monitoring)
- Can be extended with Jaeger for APM
- Winston logs provide application-level insights
- Ready for APM integration

**Screenshot 5.14:** APM vs Metrics Comparison
```
[Insert screenshot or diagram showing APM vs metrics]
```

---

### 5.7 Loki vs ELK Stack Comparison

| Feature | Loki | ELK Stack |
|---------|------|-----------|
| **Architecture** | Label-based indexing | Full-text search |
| **Storage** | Object storage (S3, GCS, etc.) | Elasticsearch |
| **Query Language** | LogQL | Elasticsearch Query DSL |
| **Resource Usage** | Lower | Higher |
| **Setup Complexity** | Simpler | More complex |
| **Best For** | Logs with metrics correlation | Full-text search, complex queries |
| **Scalability** | Horizontal | Horizontal (complex) |
| **Cost** | Lower | Higher (resource-intensive) |
| **Integration** | Prometheus/Grafana native | Requires additional setup |
| **Learning Curve** | Low (if know Prometheus) | Medium-High |
| **Indexing** | Label-based | Full-text inverted index |
| **Query Performance** | Fast for label queries | Fast for text search |

**Loki Advantages:**
- ✅ Lower resource usage
- ✅ Simpler setup
- ✅ Native Prometheus/Grafana integration
- ✅ Cost-effective
- ✅ Label-based queries are fast
- ✅ Good for metrics correlation

**Loki Disadvantages:**
- ❌ Not full-text search
- ❌ Less flexible than Elasticsearch
- ❌ Newer project (smaller ecosystem)
- ❌ Limited complex query capabilities

**ELK Stack Advantages:**
- ✅ Powerful full-text search
- ✅ Mature ecosystem
- ✅ Flexible querying
- ✅ Rich visualization (Kibana)
- ✅ SIEM capabilities

**ELK Stack Disadvantages:**
- ❌ Resource-intensive
- ❌ Complex setup
- ❌ Higher operational costs
- ❌ Steeper learning curve

**When to Use Loki:**
- Already using Prometheus/Grafana
- Need log aggregation with metrics
- Cost-conscious deployment
- Label-based log queries sufficient
- Kubernetes environments

**When to Use ELK:**
- Need full-text search
- Complex log analysis required
- Enterprise SIEM requirements
- Existing Elasticsearch infrastructure
- Rich query capabilities needed

**Screenshot 5.15:** Comparison Table
```
[Insert screenshot showing: Detailed comparison table]
```

---

## Summary & Conclusion

### Implementation Summary

This assignment successfully implemented a complete monitoring stack including:

1. **Frontend Deployment:**
   - React application built and deployed
   - Served via Express server
   - Accessible and functional

2. **Monitoring Stack:**
   - Prometheus installed and configured
   - Grafana installed with datasources
   - Node Exporter collecting system metrics
   - All components working together

3. **Log Configuration:**
   - Application logs forwarded to Loki
   - Log-based metrics in Prometheus
   - Log visualizations in Grafana

4. **Time Series Database:**
   - Prometheus TSDB storing metrics
   - PromQL queries working
   - Time-series visualizations

5. **Loki & SIEM:**
   - Loki installed and configured
   - Log aggregation working
   - SIEM concepts understood
   - APM concepts explained

### Key Achievements

- ✅ Complete monitoring stack deployed
- ✅ All services integrated and working
- ✅ Dashboards created and functional
- ✅ Logs and metrics both working
- ✅ Security considerations implemented
- ✅ Comprehensive documentation

### Learning Outcomes

- Understanding of monitoring architectures
- Hands-on experience with Prometheus and Grafana
- Knowledge of time-series databases
- Experience with log aggregation
- Understanding of SIEM and APM concepts

### Future Enhancements

- Add distributed tracing (Jaeger)
- Implement alerting rules
- Set up remote storage for Prometheus
- Configure log retention policies
- Add more custom dashboards
- Implement SSL/TLS for production

---

## References

1. Prometheus Documentation: https://prometheus.io/docs/
2. Grafana Documentation: https://grafana.com/docs/
3. Loki Documentation: https://grafana.com/docs/loki/
4. Node Exporter: https://github.com/prometheus/node_exporter
5. Winston-Loki: https://github.com/JaniAnttonen/winston-loki

---

## Appendix

### A. Configuration Files

[Include key configuration files as code blocks]

### B. Architecture Diagrams

[Include architecture diagrams]

### C. Additional Screenshots

[Include any additional relevant screenshots]

---

**End of Submission Document**

