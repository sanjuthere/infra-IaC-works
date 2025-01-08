#!/bin/bash
sudo apt update -y

# Function to install Docker
install_docker() {
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    echo "Docker installation completed."
}

# Function to set up SonarQube container
setup_sonarqube() {
    echo "Setting up SonarQube container..."
    sudo docker container run -dt \
        --name sonarqube \
        --restart=always \
        -p 9000:9000 \
        sonarqube
    echo "SonarQube container is running on port 9000."
}

# Function to set up Nexus container
setup_nexus() {
    echo "Setting up Nexus container..."
    sudo docker container run -dt \
        --name nexus \
        --restart=always \
        -p 8081:8081 \
        sonatype/nexus3
    echo "Nexus container is running on port 8081."
# Display the Nexus admin password
    echo "Fetching Nexus admin password..."
    sleep 10  # Wait a few seconds to allow the container to initialize
    sudo docker container exec nexus cat /nexus-data/admin.password
}

# Main execution
echo "Starting Docker, SonarQube, and Nexus setup..."
install_docker
setup_sonarqube
setup_nexus
echo "Setup completed successfully!"
