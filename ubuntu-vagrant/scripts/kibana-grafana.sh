#!/bin/bash

# Update package list
echo "Updating package list..."
sudo apt update -y

# Install prerequisites
echo "Installing prerequisites..."
sudo apt install -y curl gnupg apt-transport-https software-properties-common lsb-release wget

# 1. Install Kibana
echo "Installing Kibana..."
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
sudo apt update -y
sudo apt install -y kibana
sudo systemctl enable kibana
sudo systemctl start kibana
echo "Kibana installed and running on port 5601."

# 2. Install Grafana
echo "Installing Grafana..."
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt update -y
sudo apt install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
echo "Grafana installed and running on port 3000."

# Final output
echo "Installation completed successfully!"
echo "Services and ports:"
echo "  - Kibana: Port 5601"
echo "  - Grafana: Port 3000"
