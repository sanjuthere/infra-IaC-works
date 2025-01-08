#!/bin/bash

# Update the package list
echo "Updating package list..."
sudo apt update -y
sudo apt install -y openjdk-11-jdk
java -version

# Install Nginx
echo "Installing Nginx..."
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
echo "Nginx installation completed. Access it at http://<server-ip>."

# Install Elasticsearch
echo "Installing Elasticsearch..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt install -y apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update -y
sudo apt install -y elasticsearch
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch
echo "Elasticsearch installation completed."

# Install Logstash
echo "Installing Logstash..."
sudo apt install -y logstash
sudo systemctl enable logstash
sudo systemctl start logstash
echo "Logstash installation completed."

# Install Prometheus
echo "Installing Prometheus..."
PROM_VERSION="2.46.0"
wget https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz
tar -xzf prometheus-${PROM_VERSION}.linux-amd64.tar.gz
sudo mv prometheus-${PROM_VERSION}.linux-amd64/prometheus /usr/local/bin/
sudo mv prometheus-${PROM_VERSION}.linux-amd64/promtool /usr/local/bin/
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo mv prometheus-${PROM_VERSION}.linux-amd64/{consoles,console_libraries,prometheus.yml} /etc/prometheus/
sudo useradd --no-create-home --shell /bin/false prometheus
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

# Create Prometheus systemd service
echo "Creating Prometheus service..."
cat <<EOL | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus Monitoring System
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
  --config.file=/etc/prometheus/prometheus.yml \
  --storage.tsdb.path=/var/lib/prometheus \
  --web.console.templates=/etc/prometheus/consoles \
  --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
echo "Prometheus installation completed. Access it at http://<server-ip>:9090."

# Cleanup downloaded files
echo "Cleaning up installation files..."
rm -rf prometheus-${PROM_VERSION}.linux-amd64 prometheus-${PROM_VERSION}.linux-amd64.tar.gz

# Completion message
echo "Nginx, Elasticsearch, Logstash, and Prometheus installation completed successfully!"
