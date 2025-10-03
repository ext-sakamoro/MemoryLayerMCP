# Memory Layer MCP Server

Model Context Protocol (MCP) server for Memory Layer API integration with Claude Desktop.

Save and retrieve your conversations with Claude seamlessly!

**[日本語版 README はこちら](README.ja.md)**

## 🚀 Features

### 💾 Save Conversations
- **save_conversation_to_memory_layer**: Auto-save conversations
  - Automatic title and metadata generation
  - Importance scoring
  - Tag support

### 🔍 Search & Retrieve
- **get_memories**: Search conversations by keywords and tags
  - Full-text search
  - Tag filtering
  - Sort by date, importance, etc.

- **get_memory_by_id**: Retrieve specific conversations
  - Direct access by Memory ID
  - Full conversation content

- **search_memories_advanced**: AI-powered search
  - Natural language queries
  - Relevance scoring
  - Context-aware results

## 📦 Installation

### Quick Install

**Linux:**
```bash
git clone https://github.com/ext-sakamoro/MemoryLayerMCP.git
cd MemoryLayerMCP
chmod +x install-linux.sh
./install-linux.sh
```

**macOS:**
```bash
git clone https://github.com/ext-sakamoro/MemoryLayerMCP.git
cd MemoryLayerMCP
chmod +x install-macos.sh
./install-macos.sh
```

**Windows (PowerShell):**
```powershell
git clone https://github.com/ext-sakamoro/MemoryLayerMCP.git
cd MemoryLayerMCP
.\install-windows.ps1
```

### Requirements

- Node.js 18.0.0 or later
- Claude Desktop app
- Memory Layer API Key (get from https://memory-layer.emotiai.ai)

## 📝 Usage

After installation, simply tell Claude:

```
Save this conversation to Memory Layer
```

Claude will automatically save the conversation using the MCP server!

### Search Conversations

```
Search Memory Layer for "React" conversations
```

### Retrieve Specific Conversation

```
Show me Memory ID [your-id-here]
```

### AI-Powered Search

```
What did I learn about programming?
```

## 🔑 API Key

1. Visit https://memory-layer.emotiai.ai
2. Go to Settings → API Keys
3. Generate a new API key
4. Enter it during installation

## 🛠️ Other AI Tools Support

This repository provides MCP server for Claude Desktop, but Memory Layer API works with **all AI tools**:

### Supported Integrations

- **ChatGPT** - Custom Instructions / GPT Actions → [Setup Guide](CHATGPT_SETUP.md)
- **Gemini CLI** - Python/Shell scripts → [Setup Guide](GEMINI_CLI_SETUP.md)
- **Cursor** - .cursorrules configuration → [Setup Guide](CURSOR_SETUP.md)
- **Windsurf** - AI configuration → [Setup Guide](AI_TOOLS_SETUP.md)
- **Devin** - Task automation → [Setup Guide](AI_TOOLS_SETUP.md)
- **Any tool with API access** → [Integration Guide](INTEGRATIONS.md)

**→ [Complete Integration Guide for All Tools](INTEGRATIONS.md)**

## 📚 Documentation

### Claude Desktop (MCP Server)
- [Quick Start Guide](QUICK_START.md) | [日本語版](QUICK_START.ja.md)
- [Usage Guide](USAGE_GUIDE.md) | [日本語版](USAGE_GUIDE.ja.md)
- [Claude App Setup](CLAUDE_APP_SETUP.md) | [日本語版](CLAUDE_APP_SETUP.ja.md)

### Other AI Tools
- [ChatGPT Setup](CHATGPT_SETUP.md) | [日本語版](CHATGPT_SETUP.ja.md)
- [Gemini CLI Setup](GEMINI_CLI_SETUP.md) | [日本語版](GEMINI_CLI_SETUP.ja.md)
- [Cursor Setup](CURSOR_SETUP.md) | [日本語版](CURSOR_SETUP.ja.md)
- [Windsurf & Devin Setup](AI_TOOLS_SETUP.md) | [日本語版](AI_TOOLS_SETUP.ja.md)
- [Complete Integration Guide](INTEGRATIONS.md) | [日本語版](INTEGRATIONS.ja.md)

## 🔧 Technical Details

- **MCP SDK**: @modelcontextprotocol/sdk v1.19.1
- **Protocol**: stdio
- **API**: https://back.memory-layer.emotiai.ai

## 🌐 Memory Layer

Memory Layer is a professional LLM conversation storage service.

- **Website**: https://memory-layer.emotiai.ai
- **Features**: AI-powered search, conversation management, API integration
- **Plans**: Free tier available

## 📄 License

MIT

## 🤝 Support

For issues or questions:
- Visit https://memory-layer.emotiai.ai
- Check documentation in this repository
