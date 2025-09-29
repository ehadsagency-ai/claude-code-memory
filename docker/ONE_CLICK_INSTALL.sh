#!/bin/bash
# Claude Code CEO System - One-Click Installation
# Version: 2.0
# Date: 2025-09-29

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Banner
echo -e "${BLUE}"
cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                            ║
║    Claude Code CEO System v2.0                            ║
║    Complete Package Installation                          ║
║                                                            ║
║    Features:                                              ║
║    ✅ Dashboard (Real-time monitoring)                    ║
║    ✅ Auto-save (GitHub sync every 2 min)                ║
║    ✅ Multi-agent (13 agents configured)                 ║
║    ✅ MCP servers (ref-tools, filesystem)                ║
║                                                            ║
╚═══════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Check if Docker is installed
echo -e "${YELLOW}Checking prerequisites...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed${NC}"
    echo -e "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}❌ docker-compose is not installed${NC}"
    echo -e "Please install docker-compose first: https://docs.docker.com/compose/install/"
    exit 1
fi

echo -e "${GREEN}✅ Docker and docker-compose are installed${NC}"

# Check Docker daemon
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker daemon is not running${NC}"
    echo -e "Please start Docker first"
    exit 1
fi

echo -e "${GREEN}✅ Docker daemon is running${NC}"

# Clone or update repository
INSTALL_DIR="$HOME/claude-code-ceo"
echo ""
echo -e "${YELLOW}Installation directory: ${INSTALL_DIR}${NC}"

if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}Directory exists. Updating...${NC}"
    cd "$INSTALL_DIR"
    git pull origin main
else
    echo -e "${YELLOW}Cloning repository...${NC}"
    git clone https://github.com/ehadsagency-ai/claude-code-memory.git "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# Check if in docker directory
cd docker

# Configuration
echo ""
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${YELLOW}Configuration${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo ""

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}Creating .env file...${NC}"
    cat > .env << 'ENVEOF'
# GitHub Configuration (Optional - for auto-save to GitHub)
GITHUB_USER=ehadsagency-ai
GITHUB_EMAIL=ehads.agency@gmail.com
GITHUB_TOKEN=
GITHUB_REPO=claude-code-memory

# System Configuration
AUTO_SAVE_ENABLED=true
AUTO_SAVE_INTERVAL=120
ENVEOF
    echo -e "${GREEN}✅ .env file created${NC}"
    echo ""
    echo -e "${YELLOW}Edit .env to configure GitHub auto-save (optional)${NC}"
    echo -e "${YELLOW}Set GITHUB_TOKEN to enable automatic GitHub sync${NC}"
else
    echo -e "${GREEN}✅ .env file already exists${NC}"
fi

# Build and start
echo ""
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${YELLOW}Building Docker image...${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo ""

docker-compose -f docker-compose.complete.yml build

echo ""
echo -e "${GREEN}✅ Docker image built successfully${NC}"

echo ""
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${YELLOW}Starting Claude Code CEO System...${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo ""

docker-compose -f docker-compose.complete.yml up -d

echo ""
echo -e "${GREEN}✅ System started successfully!${NC}"

# Wait for system to be ready
echo ""
echo -e "${YELLOW}Waiting for system to be ready...${NC}"
sleep 5

# Check health
if docker-compose -f docker-compose.complete.yml ps | grep -q "Up"; then
    echo -e "${GREEN}✅ Container is running${NC}"
else
    echo -e "${RED}❌ Container failed to start${NC}"
    echo -e "${YELLOW}Check logs with: docker-compose -f docker-compose.complete.yml logs${NC}"
    exit 1
fi

# Display access information
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}║    🎉 Installation Complete!                              ║${NC}"
echo -e "${GREEN}║                                                            ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📍 Access Points:${NC}"
echo -e "  Dashboard:  ${GREEN}http://localhost:3000${NC}"
echo -e "  API:        ${GREEN}http://localhost:3000/api/*${NC}"
echo ""
echo -e "${BLUE}📋 Agent System:${NC}"
echo -e "  • CEO Orchestrator (Strategic + Global Memory)"
echo -e "  • CTO Technical Lead (DevOps, DevSecOps, Fullstack)"
echo -e "  • CRO Research Lead (Compliance, Legal, RGPD)"
echo -e "  + 10 specialist agents"
echo ""
echo -e "${BLUE}📚 Documentation:${NC}"
echo -e "  Inside container: /root/.claude/global_memory/"
echo -e "  • CLAUDE_CODE.md - Technical documentation"
echo -e "  • SESSION_RESTART_GUIDE.md - User guide"
echo -e "  • VERIFICATION_REPORT_2025-09-29.md - System verification"
echo ""
echo -e "${BLUE}🔧 Useful Commands:${NC}"
echo -e "  View logs:       ${YELLOW}docker-compose -f docker-compose.complete.yml logs -f${NC}"
echo -e "  Stop system:     ${YELLOW}docker-compose -f docker-compose.complete.yml down${NC}"
echo -e "  Restart system:  ${YELLOW}docker-compose -f docker-compose.complete.yml restart${NC}"
echo -e "  Enter container: ${YELLOW}docker exec -it claude-code-ceo-system bash${NC}"
echo ""
echo -e "${GREEN}✅ System is ready to use!${NC}"
echo ""