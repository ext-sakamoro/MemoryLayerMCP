#!/bin/bash

# Memory Layer MCP Server - Linux Installer

echo "========================================"
echo "Memory Layer MCP Server Installer"
echo "========================================"
echo ""

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# 1. Check Node.js
echo -e "${YELLOW}[1/5] Checking Node.js version...${NC}"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓ Node.js detected: $NODE_VERSION${NC}"
else
    echo -e "${RED}✗ Node.js is not installed${NC}"
    echo -e "${RED}Please install Node.js using the following commands:${NC}"
    echo -e "${GRAY}Ubuntu/Debian: sudo apt-get install nodejs npm${NC}"
    echo -e "${GRAY}Fedora: sudo dnf install nodejs npm${NC}"
    echo -e "${GRAY}Arch: sudo pacman -S nodejs npm${NC}"
    exit 1
fi

# 2. Create installation directory
echo ""
echo -e "${YELLOW}[2/5] Creating installation directory...${NC}"
INSTALL_DIR="$HOME/.memory-layer/mcp-server"
mkdir -p "$INSTALL_DIR"
echo -e "${GREEN}✓ Directory created: $INSTALL_DIR${NC}"

# 3. Copy files
echo ""
echo -e "${YELLOW}[3/5] Copying files...${NC}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/package.json" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/index.js" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/README.md" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/index.js"
echo -e "${GREEN}✓ Files copied${NC}"

# 4. Install npm dependencies
echo ""
echo -e "${YELLOW}[4/5] Installing dependencies...${NC}"
cd "$INSTALL_DIR"
npm install --silent
echo -e "${GREEN}✓ Dependencies installed${NC}"

# 5. Create Claude configuration file
echo ""
echo -e "${YELLOW}[5/5] Creating Claude configuration file...${NC}"

# API Key input
echo ""
echo -e "${CYAN}Please enter your Memory Layer API Key:${NC}"
echo -e "${GRAY}(Get it from https://memory-layer.emotiai.ai/settings/api-keys)${NC}"
read -p "API Key: " API_KEY

if [ -z "$API_KEY" ]; then
    echo -e "${YELLOW}⚠ API Key was not entered. You can set it manually later.${NC}"
    API_KEY="YOUR_API_KEY_HERE"
fi

CLAUDE_CONFIG_DIR="$HOME/.config/Claude"
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"

# Create directory
mkdir -p "$CLAUDE_CONFIG_DIR"

# Create configuration file
cat > "$CLAUDE_CONFIG_FILE" <<EOF
{
  "mcpServers": {
    "memory-layer": {
      "command": "node",
      "args": [
        "$INSTALL_DIR/index.js"
      ],
      "env": {
        "MEMORY_LAYER_API_KEY": "$API_KEY"
      }
    }
  }
}
EOF

echo -e "${GREEN}✓ Configuration file created: $CLAUDE_CONFIG_FILE${NC}"

# Completion message
echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}Installation completed!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Restart Claude Desktop app"
echo -e "2. In a conversation, say 'Save this conversation to Memory Layer'"
echo ""
echo -e "${GRAY}Config file: $CLAUDE_CONFIG_FILE${NC}"
echo -e "${GRAY}Installation directory: $INSTALL_DIR${NC}"
echo ""

# Ask if user wants to open config file in editor
read -p "Do you want to open the configuration file in an editor? (y/n): " OPEN_CONFIG
if [ "$OPEN_CONFIG" = "y" ] || [ "$OPEN_CONFIG" = "Y" ]; then
    if command -v code &> /dev/null; then
        code "$CLAUDE_CONFIG_FILE"
    elif command -v nano &> /dev/null; then
        nano "$CLAUDE_CONFIG_FILE"
    elif command -v vim &> /dev/null; then
        vim "$CLAUDE_CONFIG_FILE"
    else
        cat "$CLAUDE_CONFIG_FILE"
    fi
fi

echo ""
echo -e "${GRAY}Press any key to exit...${NC}"
read -n 1 -s
