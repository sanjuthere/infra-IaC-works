#!/bin/bash

# Update and install dependencies
echo "Updating system and installing required packages..."
sudo apt update -y
sudo apt install -y postgresql nodejs git nginx curl

# Setup PostgreSQL
echo "Setting up PostgreSQL..."
sudo su - postgres -c "psql -c \"ALTER USER postgres WITH PASSWORD 'admin1234';\""

# Install Node.js (v16.x)
echo "Installing Node.js..."
curl -sL https://deb.nodesource.com/setup_16.x | sudo bash -
sudo apt-get install -y nodejs
echo "Node.js version: $(node -v)"
echo "NPM version: $(npm -v)"

# Clone LMS repository
echo "Cloning LMS repository..."
git clone -b dev https://github.com/ravi2krishna/lms.git ~/lms

# Backend setup
echo "Setting up backend..."
cd ~/lms/api
cat > .env <<EOF
MODE=dev
PORT=8080
DATABASE_URL=postgresql://postgres:admin1234@localhost:5432/postgres
EOF

npm install
sudo npx prisma generate
sudo npx prisma db push
npm run build
sudo npm install -g pm2
pm2 startup build/index.js

# Test backend
echo "Testing backend..."
curl http://localhost:8080/api

# Frontend setup
echo "Setting up frontend..."
cd ~/lms/webapp
cat > .env <<EOF
VITE_API_URL=http://public-ip:8080/api
EOF

npm install
npm run build

# Configure NGINX for frontend
echo "Configuring NGINX..."
sudo rm -rf /var/www/html/*
sudo cp -r ~/lms/webapp/dist/* /var/www/html/

echo "Setup complete!"
