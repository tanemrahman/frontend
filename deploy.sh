#!/bin/bash

# Module 6 - Deployment Script
# This script sets up the complete monitoring stack

set -e

echo "🚀 Starting Module 6 Deployment..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Install Node.js dependencies
echo -e "${BLUE}Step 1: Installing Node.js dependencies...${NC}"
npm install

# Step 2: Build frontend
echo -e "${BLUE}Step 2: Building frontend application...${NC}"
cd frontend
npm install
npm run build
cd ..

# Step 3: Create necessary directories
echo -e "${BLUE}Step 3: Creating directories...${NC}"
mkdir -p prometheus/data
mkdir -p grafana/data
mkdir -p loki/data

# Step 4: Set permissions
echo -e "${BLUE}Step 4: Setting permissions...${NC}"
chmod -R 777 prometheus/data
chmod -R 777 grafana/data
chmod -R 777 loki/data

# Step 5: Start services with Docker Compose
echo -e "${BLUE}Step 5: Starting monitoring stack with Docker Compose...${NC}"
docker-compose up -d

# Wait for services to be ready
echo -e "${YELLOW}Waiting for services to start...${NC}"
sleep 10

# Step 6: Verify services
echo -e "${BLUE}Step 6: Verifying services...${NC}"

check_service() {
    if curl -f -s "$1" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ $2 is running${NC}"
    else
        echo -e "${YELLOW}⚠ $2 is not yet ready${NC}"
    fi
}

check_service "http://localhost:3000/api/health" "Node.js Application"
check_service "http://localhost:9090" "Prometheus"
check_service "http://localhost:3001" "Grafana"
check_service "http://localhost:3100/ready" "Loki"
check_service "http://localhost:9100/metrics" "Node Exporter"

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo ""
echo "Access points:"
echo "  - Frontend: http://localhost:3000"
echo "  - Prometheus: http://localhost:9090"
echo "  - Grafana: http://localhost:3001 (admin/admin)"
echo "  - Loki: http://localhost:3100"
echo "  - Node Exporter: http://localhost:9100/metrics"
echo ""
echo "To view logs: docker-compose logs -f"
echo "To stop services: docker-compose down"

