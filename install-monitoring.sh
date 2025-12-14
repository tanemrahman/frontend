#!/bin/bash

# Manual Installation Script for Monitoring Stack
# Use this if you prefer manual installation over Docker

set -e

echo "📦 Installing Monitoring Stack Components..."

# Update system
sudo apt-get update

# Install Prometheus
echo "Installing Prometheus..."
PROMETHEUS_VERSION="2.48.0"
wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
tar xvfz prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
sudo mv prometheus-${PROMETHEUS_VERSION}.linux-amd64 /opt/prometheus
sudo cp prometheus/prometheus.yml /opt/prometheus/
sudo useradd --no-create-home --shell /bin/false prometheus
sudo chown -R prometheus:prometheus /opt/prometheus

# Create systemd service for Prometheus
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/opt/prometheus/prometheus \\
  --config.file=/opt/prometheus/prometheus.yml \\
  --storage.tsdb.path=/opt/prometheus/data \\
  --web.console.libraries=/opt/prometheus/console_libraries \\
  --web.console.templates=/opt/prometheus/consoles \\
  --storage.tsdb.retention.time=200h \\
  --web.enable-lifecycle

[Install]
WantedBy=multi-user.target
EOF

# Install Node Exporter
echo "Installing Node Exporter..."
NODE_EXPORTER_VERSION="1.7.0"
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
tar xvfz node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz
sudo mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter /usr/local/bin/
sudo useradd --no-create-home --shell /bin/false node_exporter

# Create systemd service for Node Exporter
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Install Grafana
echo "Installing Grafana..."
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y grafana

# Install Loki
echo "Installing Loki..."
LOKI_VERSION="2.9.2"
wget https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip
unzip loki-linux-amd64.zip
sudo mv loki-linux-amd64 /usr/local/bin/loki
sudo mkdir -p /etc/loki
sudo cp loki/loki-config.yml /etc/loki/

# Create systemd service for Loki
sudo tee /etc/systemd/system/loki.service > /dev/null <<EOF
[Unit]
Description=Loki
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/loki -config.file /etc/loki/loki-config.yml

[Install]
WantedBy=multi-user.target
EOF

# Enable and start services
echo "Starting services..."
sudo systemctl daemon-reload
sudo systemctl enable prometheus node_exporter grafana-server loki
sudo systemctl start prometheus
sudo systemctl start node_exporter
sudo systemctl start grafana-server
sudo systemctl start loki

echo "✅ Installation complete!"
echo ""
echo "Services status:"
sudo systemctl status prometheus --no-pager
sudo systemctl status node_exporter --no-pager
sudo systemctl status grafana-server --no-pager
sudo systemctl status loki --no-pager

