#!/bin/bash

# Memory Layer MCP Server - macOS インストーラー

echo "========================================"
echo "Memory Layer MCP Server Installer"
echo "========================================"
echo ""

# 色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

# 1. Node.js確認
echo -e "${YELLOW}[1/5] Node.jsのバージョンを確認中...${NC}"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✓ Node.js detected: $NODE_VERSION${NC}"
else
    echo -e "${RED}✗ Node.jsがインストールされていません${NC}"
    echo -e "${RED}https://nodejs.org/ からダウンロードしてインストールしてください${NC}"
    exit 1
fi

# 2. インストール先ディレクトリ作成
echo ""
echo -e "${YELLOW}[2/5] インストール先ディレクトリを作成中...${NC}"
INSTALL_DIR="$HOME/.memory-layer/mcp-server"
mkdir -p "$INSTALL_DIR"
echo -e "${GREEN}✓ Directory created: $INSTALL_DIR${NC}"

# 3. ファイルコピー
echo ""
echo -e "${YELLOW}[3/5] ファイルをコピー中...${NC}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/package.json" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/index.js" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/README.md" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/index.js"
echo -e "${GREEN}✓ Files copied${NC}"

# 4. npm install実行
echo ""
echo -e "${YELLOW}[4/5] 依存関係をインストール中...${NC}"
cd "$INSTALL_DIR"
npm install --silent
echo -e "${GREEN}✓ Dependencies installed${NC}"

# 5. Claude設定ファイル作成
echo ""
echo -e "${YELLOW}[5/5] Claude設定ファイルを作成中...${NC}"

# API Key入力
echo ""
echo -e "${CYAN}Memory Layer API Keyを入力してください:${NC}"
echo -e "${GRAY}(https://memory-layer.emotiai.ai/settings/api-keys で取得)${NC}"
read -p "API Key: " API_KEY

if [ -z "$API_KEY" ]; then
    echo -e "${YELLOW}⚠ API Keyが入力されませんでした。後で手動で設定してください。${NC}"
    API_KEY="YOUR_API_KEY_HERE"
fi

CLAUDE_CONFIG_DIR="$HOME/Library/Application Support/Claude"
CLAUDE_CONFIG_FILE="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"

# ディレクトリ作成
mkdir -p "$CLAUDE_CONFIG_DIR"

# 設定ファイル作成
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

# 完了メッセージ
echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}インストール完了！${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}次のステップ:${NC}"
echo -e "1. Claudeデスクトップアプリを再起動"
echo -e "2. 会話中に「この会話をMemory Layerに保存して」と指示"
echo ""
echo -e "${GRAY}設定ファイル: $CLAUDE_CONFIG_FILE${NC}"
echo -e "${GRAY}インストール先: $INSTALL_DIR${NC}"
echo ""

# エディタで設定ファイルを開くか確認
read -p "設定ファイルをエディタで開きますか？ (y/n): " OPEN_CONFIG
if [ "$OPEN_CONFIG" = "y" ] || [ "$OPEN_CONFIG" = "Y" ]; then
    if command -v code &> /dev/null; then
        code "$CLAUDE_CONFIG_FILE"
    elif command -v nano &> /dev/null; then
        nano "$CLAUDE_CONFIG_FILE"
    else
        open -e "$CLAUDE_CONFIG_FILE"
    fi
fi

echo ""
echo -e "${GRAY}Press any key to exit...${NC}"
read -n 1 -s
