#!/bin/bash

# ==========================================
# Configuration
# ==========================================
NAMESPACE="amaranto"
MINIKUBE_PROFILE="minikube"
DRIVER="docker"

# Colors for output readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting Minikube Initialization...${NC}"

# ==========================================
# 1. Prerequisite & Version Checks
# ==========================================
echo -e "\n${YELLOW}--- Checking Prerequisites ---${NC}"

# Function to check command existence and print version
check_tool() {
    local cmd=$1
    if ! command -v $cmd &> /dev/null; then
        echo -e "${RED}Error: $cmd is not installed.${NC}"
        exit 1
    else
        echo -e "${GREEN}✓ Found $cmd${NC}"
    fi
}

# Check Docker
check_tool docker
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}Error: Docker daemon is not running. Please start Docker first.${NC}"
    exit 1
fi
echo "  Docker Version: $(docker --version | awk '{print $3}' | tr -d ',')"

# Check Minikube
check_tool minikube
echo "  Minikube Version: $(minikube version --short)"

# Check Kubectl
check_tool kubectl
# extracting client version specifically
client_version=$(kubectl version --client --output=json | grep -o '"gitVersion": "[^"]*"' | cut -d'"' -f4)
echo "  Kubectl Client Version: $client_version"

# ==========================================
# 2. Start Minikube (Docker Driver)
# ==========================================
echo -e "\n${YELLOW}--- Starting Cluster ---${NC}"

if minikube status | grep -q "Running"; then
    echo -e "${GREEN}Minikube is already running.${NC}"
else
    echo "Starting Minikube using Docker driver..."
    # We enable ingress immediately as it is often needed for localhost routing
    minikube start \
        --driver=$DRIVER \
        --profile=$MINIKUBE_PROFILE \
        --addons=ingress
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to start Minikube.${NC}"
        exit 1
    fi
fi

# ==========================================
# 4. Localhost Access Setup (Tunnel)
# ==========================================
echo -e "\n${YELLOW}--- Accessing Pods via Localhost ---${NC}"
echo "To access services via localhost (LoadBalancer), 'minikube tunnel' is required."
echo "Note: This command requires sudo and will run in the background."

read -p "Do you want to start the minikube tunnel now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # We check if a tunnel is already running to avoid duplicates
    if pgrep -f "minikube tunnel" > /dev/null; then
        echo -e "${GREEN}Tunnel is already running in the background.${NC}"
    else
        # Run tunnel in background and log output to /tmp/minikube-tunnel.log
        nohup minikube tunnel > /tmp/minikube-tunnel.log 2>&1 &
        echo -e "${GREEN}✓ Minikube tunnel started in background (PID: $!).${NC}"
        echo "Logs are available at /tmp/minikube-tunnel.log"
    fi
else
    echo -e "${YELLOW}Skipping tunnel.${NC} When you need localhost access, run: 'minikube tunnel'"
fi

echo -e "\n${GREEN}Initialization Complete!${NC}"