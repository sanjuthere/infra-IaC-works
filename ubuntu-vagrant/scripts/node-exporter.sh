# 3. Install Node Exporter
echo "Installing Node Exporter..."
NODE_EXPORTER_VERSION="1.6.0"
wget https://github.com/prometheus/node_exporter/releases/download/v$NODE_EXPORTER_VERSION/node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz
tar -xvzf node_exporter-$NODE_EXPORTER_VERSION.linux-amd64.tar.gz
sudo mv node_exporter-$NODE_EXPORTER_VERSION.linux-amd64/node_exporter /usr/local/bin/
sudo rm -rf node_exporter-$NODE_EXPORTER_VERSION.linux-amd64*

# Create a Node Exporter service
echo "Setting up Node Exporter as a systemd service..."
sudo bash -c 'cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter
echo "Node Exporter installed and running on port 9100."

# Final output
echo "Installation completed successfully!"
echo "Services and ports:"
echo "  - Node Exporter: Port 9100"