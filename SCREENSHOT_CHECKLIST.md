# Screenshot Checklist - Module 6 Assignment

## 📸 Complete Screenshot Checklist

Use this checklist to ensure you have all required screenshots before submission.

---

## Part 1: Frontend Deployment (6 screenshots)

### Setup & Installation
- [ ] **1.1** Node.js version check
  - Command: `node --version`
  - Location: Terminal/Command Prompt
  
- [ ] **1.2** npm version check
  - Command: `npm --version`
  - Location: Terminal/Command Prompt

- [ ] **1.3** Frontend dependencies installation
  - Command: `cd frontend && npm install`
  - Location: Terminal showing installation progress

- [ ] **1.4** Frontend build process
  - Command: `npm run build`
  - Location: Terminal showing build output
  - Should show: "Build completed successfully"

- [ ] **1.5** Build output directory
  - Location: File explorer showing `frontend/dist` folder
  - Should show: Built files (index.html, assets, etc.)

### Verification
- [ ] **1.6** Frontend application in browser
  - URL: http://localhost:3000
  - Should show: React application with monitoring dashboard
  - Full page screenshot

- [ ] **1.7** Health endpoint response
  - URL: http://localhost:3000/api/health
  - Should show: JSON response with status, timestamp, uptime
  - Browser or Postman screenshot

- [ ] **1.8** Network tab (optional but good)
  - Browser DevTools → Network tab
  - Should show: Successful requests, no errors

---

## Part 2: Monitoring Stack Setup (12 screenshots)

### Prometheus
- [ ] **2.1** Prometheus installation/startup
  - Location: Terminal showing `docker-compose up prometheus` or systemctl status
  - Should show: Service running

- [ ] **2.2** Prometheus configuration file
  - File: `prometheus/prometheus.yml`
  - Should show: Scrape configs for all targets

- [ ] **2.3** Prometheus UI (main page)
  - URL: http://localhost:9090
  - Should show: Prometheus web interface

- [ ] **2.4** Prometheus targets page
  - URL: http://localhost:9090/targets
  - Should show: All targets UP (green)
  - Important: Must show all 3 targets UP

- [ ] **2.5** Prometheus query example
  - URL: http://localhost:9090
  - Query: `up` or `rate(http_requests_total[5m])`
  - Should show: Query results/graph

### Grafana
- [ ] **2.6** Grafana installation/startup
  - Location: Terminal showing Grafana starting
  - Should show: Service running

- [ ] **2.7** Grafana login page
  - URL: http://localhost:3001
  - Should show: Grafana login screen

- [ ] **2.8** Grafana datasources configuration
  - Path: Configuration → Data Sources
  - Should show: Prometheus and Loki datasources configured
  - Both should have green checkmarks

- [ ] **2.9** Node Exporter dashboard
  - Path: Dashboards → Import → ID: 1860
  - Should show: Dashboard with system metrics
  - Panels showing: CPU, Memory, Disk, Network

- [ ] **2.10** Application metrics dashboard
  - Path: New dashboard → Add panels
  - Should show: Custom dashboard with app metrics
  - Panels: Request rate, duration, errors

### Node Exporter
- [ ] **2.11** Node Exporter installation/startup
  - Location: Terminal showing Node Exporter running
  - Should show: Service running on port 9100

- [ ] **2.12** Node Exporter metrics endpoint
  - URL: http://localhost:9100/metrics
  - Should show: Prometheus-formatted metrics
  - Should include: node_cpu, node_memory, node_disk, etc.

### Security (if applicable)
- [ ] **2.13** Security group configuration (Cloud)
  - Location: AWS/Cloud console
  - Should show: IP restrictions for Grafana

- [ ] **2.14** Firewall rules (if manual)
  - Command: `sudo ufw status` or firewall config
  - Should show: Port restrictions

---

## Part 3: Node Exporter Log Configuration (4 screenshots)

### Configuration
- [ ] **3.1** Winston-Loki configuration
  - File: `server.js`
  - Should show: Winston logger with LokiTransport
  - Highlight: Loki transport configuration

- [ ] **3.2** Application logs in console
  - Location: Terminal running `npm start`
  - Should show: Logs being generated
  - Optional: Show logs with different levels

### Verification
- [ ] **3.3** Prometheus log-based metrics
  - URL: http://localhost:9090
  - Query: `rate(http_requests_total[5m])`
  - Should show: Metrics graph over time
  - Important: Show it's working

- [ ] **3.4** Grafana log metrics panel
  - Location: Grafana dashboard
  - Panel type: Time series or Stat
  - Query: Log-based PromQL query
  - Should show: Visualization of log metrics

---

## Part 4: Time Series Database Concepts (4 screenshots)

### Prometheus TSDB
- [ ] **4.1** Prometheus storage information
  - URL: http://localhost:9090/status
  - Path: Runtime & Build Information → Storage
  - Should show: Storage stats, retention info

- [ ] **4.2** PromQL query examples
  - URL: http://localhost:9090
  - Queries to show:
    - `rate(http_requests_total[5m])`
    - `sum(rate(http_requests_total[5m])) by (status_code)`
    - `histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))`
  - Should show: Multiple queries with results

- [ ] **4.3** Time-series graph in Prometheus
  - URL: http://localhost:9090/graph
  - Query: Any time-series query
  - Should show: Graph visualization
  - Time range: Last 1 hour or 6 hours

- [ ] **4.4** Time-series graph in Grafana
  - Location: Grafana dashboard
  - Should show: Multiple time-series panels
  - Should show: Data updating over time

---

## Part 5: Loki & SIEM (8 screenshots)

### Loki Installation
- [ ] **5.1** Loki installation/startup
  - Location: Terminal showing Loki starting
  - Should show: Service running on port 3100

- [ ] **5.2** Loki configuration file
  - File: `loki/loki-config.yml`
  - Should show: Configuration with storage, server settings

- [ ] **5.3** Loki readiness check
  - URL: http://localhost:3100/ready
  - Should show: `{"ready":true}` response
  - Browser or curl output

### Grafana Integration
- [ ] **5.4** Loki datasource in Grafana
  - Path: Configuration → Data Sources → Loki
  - Should show: Loki datasource configured
  - Should show: Green "Data source is working" message

- [ ] **5.5** Log stream in Grafana Explore
  - Path: Explore → Select Loki → Query
  - Query: `{job="nodejs-app"}`
  - Should show: Log stream with recent logs
  - Important: Show logs are appearing

- [ ] **5.6** LogQL query examples
  - Location: Grafana Explore
  - Queries to show:
    - `{job="nodejs-app"} |= "error"`
    - `{job="nodejs-app"} | json | statusCode >= 400`
    - `sum(rate({job="nodejs-app"}[5m]))`
  - Should show: Different LogQL queries with results

- [ ] **5.7** Log visualization panel
  - Location: Grafana dashboard
  - Panel type: Logs panel
  - Should show: Log entries with timestamps
  - Should show: Log levels, messages

- [ ] **5.8** Log-based metric visualization
  - Location: Grafana dashboard
  - Panel type: Time series
  - Query: Log rate or log count
  - Should show: Graph of log metrics over time

---

## Additional Screenshots (Optional but Recommended)

### Architecture
- [ ] **A.1** Architecture diagram
  - Can be created in draw.io, Lucidchart, or hand-drawn
  - Should show: All components and data flow

### Code Examples
- [ ] **A.2** Key configuration files
  - `docker-compose.yml` (if using Docker)
  - `server.js` (main application file)
  - `prometheus.yml` (Prometheus config)

### Verification
- [ ] **A.3** All services running
  - Command: `docker-compose ps` or `systemctl status`
  - Should show: All services active/running

- [ ] **A.4** Port verification
  - Command: `netstat -tulpn` or `ss -tulpn`
  - Should show: All required ports listening

---

## Screenshot Quality Checklist

Before including screenshots, verify:

- [ ] **Resolution:** High enough to read text clearly
- [ ] **Focus:** All text is readable
- [ ] **Completeness:** Shows the full relevant area
- [ ] **Labels:** URLs, commands, or important info visible
- [ ] **Context:** Enough context to understand what's shown
- [ ] **No Sensitive Data:** No passwords, API keys, or personal info
- [ ] **Consistent Size:** Similar sizes for similar screenshots
- [ ] **File Format:** PNG or JPG, reasonable file size

---

## Organization Tips

1. **Name Files Clearly:**
   - `part1_01_node_version.png`
   - `part2_04_prometheus_targets.png`
   - `part5_06_logql_queries.png`

2. **Create Folders:**
   ```
   screenshots/
   ├── part1_frontend/
   ├── part2_monitoring/
   ├── part3_logs/
   ├── part4_tsdb/
   └── part5_loki/
   ```

3. **Document Each Screenshot:**
   - What it shows
   - Why it's important
   - What to look for

---

## Quick Reference: Minimum Required Screenshots

**Absolute Minimum (20 screenshots):**
1. Frontend in browser
2. Prometheus UI
3. Prometheus targets (all UP)
4. Grafana login
5. Grafana datasources
6. Node Exporter dashboard
7. Application dashboard
8. Node Exporter metrics
9. Winston-Loki config
10. Prometheus log metrics
11. Grafana log panel
12. PromQL queries
13. Loki installation
14. Loki config
15. Loki datasource
16. Log stream
17. LogQL queries
18. Log visualization
19. Configuration files (2-3)
20. Services status

**Recommended (30+ screenshots):**
- All from minimum list
- Plus installation steps
- Plus verification steps
- Plus comparison examples
- Plus architecture diagrams

---

## Final Check Before Submission

- [ ] All 5 parts have screenshots
- [ ] Each screenshot is clear and readable
- [ ] Screenshots are properly labeled
- [ ] Screenshots are organized in folders
- [ ] Each screenshot has a description
- [ ] No placeholder screenshots
- [ ] All services are running in screenshots
- [ ] URLs and commands are visible
- [ ] Important data is highlighted/visible

---

**Total Screenshots Needed: ~30-35**

Good luck with your submission! 🎉

