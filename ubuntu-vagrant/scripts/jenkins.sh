#!/bin/bash

# Update the system
echo "Updating system packages..."
sudo apt update -y

# Install dependencies for Jenkins
echo "Installing dependencies..."
sudo apt install openjdk-17-jre-headless -y

# Add Jenkins repository key securely
echo "Adding Jenkins GPG key..."
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Add the Jenkins repository
echo "Adding Jenkins repository to sources list..."
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update the package list again to include Jenkins packages
echo "Updating package list for Jenkins..."
sudo apt update -y

# Install Jenkins
echo "Installing Jenkins..."
sudo apt install -y jenkins

# Start and enable Jenkins service
echo "Starting and enabling Jenkins service..."
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Output Jenkins status
echo "Jenkins installation completed. Checking status..."
sudo systemctl status jenkins

# Output Jenkins initial admin password
echo "Jenkins has been installed. You can access it at http://<server-ip>:8080"
echo "Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
