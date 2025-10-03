# 🚀 Memory Layer MCP - Quick Start

Save conversations in Claude Desktop automatically!

**[日本語版はこちら](QUICK_START.ja.md)**

## 📦 Installation (3 minutes)

### Windows

1. **Open PowerShell as Administrator**
2. Run the following:
```powershell
git clone https://github.com/ext-sakamoro/MemoryLayerMCP.git
cd MemoryLayerMCP
.\install-windows.ps1
```

### macOS

1. **Open Terminal**
2. Run the following:
```bash
git clone https://github.com/ext-sakamoro/MemoryLayerMCP.git
cd MemoryLayerMCP
chmod +x install-macos.sh
./install-macos.sh
```

### Linux

1. **Open Terminal**
2. Run the following:
```bash
git clone https://github.com/ext-sakamoro/MemoryLayerMCP.git
cd MemoryLayerMCP
chmod +x install-linux.sh
./install-linux.sh
```

## 🔑 Get API Key (1 minute)

1. Visit https://memory-layer.emotiai.ai
2. Create account / Login
3. Go to **Settings** → **API Keys**
4. Click **Generate New API Key**
5. Copy the key and paste it in the installer

## ✨ Usage (Super Easy!)

### Save Conversation

In Claude app during conversation:

```
Save this conversation to Memory Layer
```

That's it!

### Detailed Options

**Specify Title**:
```
Save this conversation to Memory Layer with title "Learning React"
```

**Add Tags**:
```
Save this conversation to Memory Layer with tags "Programming" and "React"
```

**Search Past Conversations**:
```
Search Memory Layer for conversations about "React"
```

## 🎯 Use Cases

### Developers
- ✅ Code review records
- ✅ Bug investigation history
- ✅ Architecture discussions

### Business
- ✅ Brainstorming sessions
- ✅ Project planning
- ✅ Decision history

### Personal
- ✅ Learning notes
- ✅ AI companion conversations
- ✅ Idea memos

## 🔧 Troubleshooting

### MCP Not Recognized

1. **Fully restart Claude app**
2. **Check configuration file**:
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Linux: `~/.config/Claude/claude_desktop_config.json`

### API Key Error

1. Verify API Key is correct
2. Check login status at https://memory-layer.emotiai.ai

### Node.js Error

```bash
node --version
npm --version
```

If not installed, download from https://nodejs.org/

## 📞 Support

- 📖 Detailed Manual: `CLAUDE_APP_SETUP.md`
- 💬 Support: https://memory-layer.emotiai.ai/support
- 🐛 Bug Reports: GitHub Issues

## 🔐 Privacy

- 🔒 Conversations encrypted
- 👤 Only you can access
- 🗑️ Delete anytime

---

**Ready? Open Claude app and try it out!** 🚀
