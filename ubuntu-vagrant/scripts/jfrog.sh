#!/bin/bash
sudo apt update -y

# Function to install Docker
install_docker() {
    if command -v docker &> /dev/null; then
        echo "Docker is already installed. Skipping installation."
    else
        echo "Docker is not installed. Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        echo "Docker installation completed."
    fi
}

# Function to set up JFrog Artifactory container
setup_jfrog() {
    echo "Setting up JFrog Artifactory container..."
    sudo docker container run -dt \
    --name jfrog-artifactory \
    --restart=always \
    -p 8082:8081 \
    docker.bintray.io/jfrog/artifactory-oss:latest
    echo "JFrog Artifactory container is running on port 8082."
}

# Display JFrog default credentials
display_jfrog_credentials() {
    echo "JFrog default credentials:"
    echo "Username: admin"
    echo "Password: password"
    echo "Note: Change the default password upon first login."
}

# Main execution
echo "Starting Docker and JFrog Artifactory setup..."
install_docker
setup_jfrog
display_jfrog_credentials
echo "Setup completed successfully!"