# Memory Layer MCP Extension for Claude Desktop App

MCP extension to automatically save conversations in Claude Desktop app to Memory Layer API.

**[日本語版はこちら](CLAUDE_APP_SETUP.ja.md)**

## 📦 Supported Platforms

- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🚀 Setup Instructions

### 1. Get Memory Layer API Key

1. Visit https://memory-layer.emotiai.ai
2. Create account or login
3. Go to **Settings** → **API Keys**
4. Click **Generate New API Key**
5. Copy the generated API Key (format: `ml_...`)

### 2. Edit Claude App Configuration File

#### **Windows**

Create `%APPDATA%\Claude\claude_desktop_config.json` with:

```json
{
  "mcpServers": {
    "memory-layer": {
      "command": "node",
      "args": [
        "C:\\Users\\YOUR_USERNAME\\mcp-servers\\memory-layer-mcp\\index.js"
      ],
      "env": {
        "MEMORY_LAYER_API_KEY": "ml_your_api_key_here"
      }
    }
  }
}
```

**Update paths**:
- Replace `YOUR_USERNAME` with your actual Windows username
- Replace API Key with your actual key

#### **macOS**

Create `~/Library/Application Support/Claude/claude_desktop_config.json` with:

```json
{
  "mcpServers": {
    "memory-layer": {
      "command": "node",
      "args": [
        "/Users/YOUR_USERNAME/mcp-servers/memory-layer-mcp/index.js"
      ],
      "env": {
        "MEMORY_LAYER_API_KEY": "ml_your_api_key_here"
      }
    }
  }
}
```

**Update paths**:
- Replace `YOUR_USERNAME` with your actual macOS username
- Replace API Key with your actual key

#### **Linux**

Create `~/.config/Claude/claude_desktop_config.json` with:

```json
{
  "mcpServers": {
    "memory-layer": {
      "command": "node",
      "args": [
        "/home/YOUR_USERNAME/mcp-servers/memory-layer-mcp/index.js"
      ],
      "env": {
        "MEMORY_LAYER_API_KEY": "ml_your_api_key_here"
      }
    }
  }
}
```

**Update paths**:
- Replace `YOUR_USERNAME` with your actual Linux username
- Replace API Key with your actual key

### 3. Place MCP Server Files

#### **All Platforms**

1. Verify Node.js is installed:
```bash
node --version
npm --version
```

2. Create MCP server directory:

**Windows (PowerShell)**:
```powershell
mkdir C:\Users\YOUR_USERNAME\mcp-servers\memory-layer-mcp
cd C:\Users\YOUR_USERNAME\mcp-servers\memory-layer-mcp
```

**macOS/Linux**:
```bash
mkdir -p ~/mcp-servers/memory-layer-mcp
cd ~/mcp-servers/memory-layer-mcp
```

3. Create the following files:

**package.json**:
```json
{
  "name": "memory-layer-mcp",
  "version": "1.0.0",
  "description": "MCP server for Memory Layer API integration with Claude",
  "main": "index.js",
  "type": "module",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.19.1"
  },
  "keywords": ["mcp", "memory-layer", "claude"],
  "author": "",
  "license": "MIT"
}
```

**index.js**: (Copy `index.js` from this repository)

4. Install dependencies:
```bash
npm install
```

### 4. Restart Claude App

After saving the configuration file, completely close and restart Claude Desktop app.

## 💬 Usage

### Save Conversations

In Claude app during conversation, simply instruct:

```
Save this conversation to Memory Layer
```

or

```
Save this conversation to Memory Layer with title "Today's Development Work"
```

Claude will automatically:
1. Format the entire conversation
2. Send to Memory Layer API
3. Notify you of save result

### Save Examples

**Example 1: Simple Save**
```
Save this conversation
```

**Example 2: Specify Title**
```
Save this conversation to Memory Layer with title "Learning React Hooks"
```

**Example 3: Save with Tags**
```
Save this conversation to Memory Layer with tags "Claude Learning" and "Programming"
```

### Search Past Conversations

```
Search Memory Layer for conversations about "React"
```

## 🔧 Troubleshooting

### MCP Server Not Recognized

1. **Verify configuration file path**
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Linux: `~/.config/Claude/claude_desktop_config.json`

2. **Check JSON syntax errors**
   - Validate JSON at https://jsonlint.com/

3. **Verify Node.js installation**
   ```bash
   node --version
   ```

   If not installed: https://nodejs.org/

### API Key Error

1. **Verify API Key format**
   - Correct format: `ml_...` or `sk_live_...`
   - Check at https://memory-layer.emotiai.ai/settings/api-keys

2. **Test API connection**
   ```bash
   curl -H "Authorization: Bearer YOUR_API_KEY" \
     https://back.memory-layer.emotiai.ai/health
   ```

### Check Claude App Logs

**Windows**:
```
%APPDATA%\Claude\logs\
```

**macOS**:
```
~/Library/Logs/Claude/
```

**Linux**:
```
~/.config/Claude/logs/
```

## 🎯 Advanced Usage

### Add Custom Metadata

```
Save this conversation to Memory Layer with the following metadata:
- Project: "WebApp Development"
- Priority: "High"
- Category: "Bug Fix"
```

### Auto-Tagging

Set default tags in configuration file:

```json
{
  "mcpServers": {
    "memory-layer": {
      "command": "node",
      "args": ["..."],
      "env": {
        "MEMORY_LAYER_API_KEY": "...",
        "DEFAULT_TAGS": "Claude Desktop,Daily Conversations"
      }
    }
  }
}
```

## 📊 Use Cases

### For Developers
- Code review conversations
- Bug investigation records
- Architecture discussions

### For Business
- Brainstorming sessions
- Project planning records
- Decision history

### For Personal
- Learning notes
- AI companion conversations
- Idea organization

## 🔐 Privacy

- 🔒 All conversations encrypted
- 👤 Only you can access
- 🗑️ Delete anytime
- 🚫 Never shared with third parties

## 📞 Support

If you encounter issues:
1. Check troubleshooting in this README
2. Contact https://memory-layer.emotiai.ai/support
3. GitHub Issues: https://github.com/ext-sakamoro/MemoryLayerMCP/issues

## 📝 License

MIT License
