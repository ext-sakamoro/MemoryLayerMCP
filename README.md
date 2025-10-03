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

## 📚 Documentation

- [Quick Start Guide](QUICK_START.md) | [日本語版](QUICK_START.ja.md)
- [Usage Guide](USAGE_GUIDE.md) | [日本語版](USAGE_GUIDE.ja.md)
- [Claude App Setup](CLAUDE_APP_SETUP.md) | [日本語版](CLAUDE_APP_SETUP.ja.md)

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
