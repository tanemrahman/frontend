#!/bin/bash

# Screenshot Helper Script for Module 6 Assignment
# This script helps organize and document screenshots

SCREENSHOT_DIR="screenshots"
mkdir -p $SCREENSHOT_DIR/{setup,installation,configuration,verification,dashboards}

echo "📸 Module 6 Screenshot Helper"
echo "=============================="
echo ""
echo "This script will help you take organized screenshots."
echo "Screenshots will be saved in: $SCREENSHOT_DIR"
echo ""

# Function to prompt for screenshot
take_screenshot() {
    local category=$1
    local name=$2
    local description=$3
    
    echo ""
    echo "📷 Screenshot: $name"
    echo "   Description: $description"
    echo "   Category: $category"
    echo ""
    echo "Press Enter when you've taken the screenshot..."
    read
    
    echo "✅ Screenshot noted: $SCREENSHOT_DIR/$category/$name"
    echo "$description" > "$SCREENSHOT_DIR/$category/${name}.txt"
}

echo "Starting screenshot checklist..."
echo ""

# Part 1: Frontend Deployment
echo "=== PART 1: Frontend Deployment ==="
take_screenshot "setup" "01_node_version" "Node.js version check (node --version)"
take_screenshot "setup" "02_npm_version" "npm version check (npm --version)"
take_screenshot "installation" "03_frontend_install" "Frontend dependencies installation (npm install)"
take_screenshot "installation" "04_frontend_build" "Frontend build process (npm run build)"
take_screenshot "verification" "05_frontend_browser" "Frontend application in browser (http://localhost:3000)"
take_screenshot "verification" "06_health_endpoint" "Health endpoint response (/api/health)"

# Part 2: Monitoring Stack
echo ""
echo "=== PART 2: Monitoring Stack ==="
take_screenshot "installation" "07_prometheus_install" "Prometheus installation/startup"
take_screenshot "configuration" "08_prometheus_config" "Prometheus configuration file (prometheus.yml)"
take_screenshot "verification" "09_prometheus_ui" "Prometheus UI (http://localhost:9090)"
take_screenshot "verification" "10_prometheus_targets" "Prometheus targets page (all UP)"
take_screenshot "installation" "11_grafana_install" "Grafana installation/startup"
take_screenshot "verification" "12_grafana_login" "Grafana login page (http://localhost:3001)"
take_screenshot "configuration" "13_grafana_datasources" "Grafana datasources configuration"
take_screenshot "installation" "14_node_exporter_install" "Node Exporter installation/startup"
take_screenshot "verification" "15_node_exporter_metrics" "Node Exporter metrics endpoint (http://localhost:9100/metrics)"
take_screenshot "dashboards" "16_node_exporter_dashboard" "Node Exporter dashboard in Grafana"
take_screenshot "dashboards" "17_app_metrics_dashboard" "Application metrics dashboard in Grafana"

# Part 3: Log Configuration
echo ""
echo "=== PART 3: Log Configuration ==="
take_screenshot "configuration" "18_winston_loki_config" "Winston-Loki configuration in server.js"
take_screenshot "verification" "19_prometheus_log_metrics" "Prometheus query showing log-based metrics"
take_screenshot "dashboards" "20_grafana_log_panel" "Grafana panel with log-based metrics"

# Part 4: TSDB Concepts
echo ""
echo "=== PART 4: TSDB Concepts ==="
take_screenshot "verification" "21_prometheus_storage" "Prometheus storage/data information"
take_screenshot "verification" "22_promql_queries" "PromQL queries in Prometheus UI"
take_screenshot "dashboards" "23_time_series_graphs" "Time-series graphs in Grafana"

# Part 5: Loki & SIEM
echo ""
echo "=== PART 5: Loki & SIEM ==="
take_screenshot "installation" "24_loki_install" "Loki installation/startup"
take_screenshot "configuration" "25_loki_config" "Loki configuration file (loki-config.yml)"
take_screenshot "verification" "26_loki_ready" "Loki readiness check (http://localhost:3100/ready)"
take_screenshot "configuration" "27_loki_datasource" "Loki datasource in Grafana"
take_screenshot "dashboards" "28_log_stream" "Log stream in Grafana Explore"
take_screenshot "dashboards" "29_logql_queries" "LogQL queries in Grafana"
take_screenshot "dashboards" "30_log_visualization" "Log-based visualizations in Grafana"

echo ""
echo "✅ Screenshot checklist complete!"
echo ""
echo "All screenshot notes saved in: $SCREENSHOT_DIR"
echo "Review the .txt files for descriptions."
echo ""
echo "Next steps:"
echo "1. Take all screenshots as noted"
echo "2. Organize them in the respective folders"
echo "3. Use them in your submission document"
echo ""

