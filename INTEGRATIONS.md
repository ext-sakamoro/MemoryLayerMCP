# Memory Layer - AI Tools Integration Guide

Complete guide for integrating Memory Layer with various AI development tools and assistants.

**[日本語版はこちら](INTEGRATIONS.ja.md)**

## 🎯 Overview

Memory Layer provides a universal API for saving and retrieving AI conversations across multiple platforms. Whether you're using Claude Desktop, ChatGPT, Cursor, or any other AI tool, you can preserve your knowledge in one centralized location.

## 🛠️ Supported Tools

### ✅ Full Integration Support

| Tool | Integration Type | Guide |
|------|-----------------|-------|
| **Claude Desktop** | MCP Server | [CLAUDE_APP_SETUP.md](CLAUDE_APP_SETUP.md) |
| **ChatGPT** | Custom Instructions / GPT Actions | [CHATGPT_SETUP.md](CHATGPT_SETUP.md) |
| **Gemini CLI** | Python/Shell Scripts | [GEMINI_CLI_SETUP.md](GEMINI_CLI_SETUP.md) |
| **Cursor** | .cursorrules / Python Extension | [CURSOR_SETUP.md](CURSOR_SETUP.md) |
| **Windsurf** | AI Configuration / Scripts | [AI_TOOLS_SETUP.md](AI_TOOLS_SETUP.md#-windsurf-ide) |
| **Devin** | Task Configuration / API | [AI_TOOLS_SETUP.md](AI_TOOLS_SETUP.md#-devin-ai-agent) |

### 🔄 API-Compatible Tools

Any tool that can make HTTP requests can integrate with Memory Layer:

- Aider
- GitHub Copilot Chat
- Cody (Sourcegraph)
- Continue.dev
- Custom scripts and automation

## 🚀 Quick Start by Tool

### Claude Desktop (Recommended for Claude users)

**Best for**: Direct Claude app integration with native MCP support

```bash
git clone https://github.com/ext-sakamoro/MemoryLayerMCP.git
cd MemoryLayerMCP
./install-linux.sh  # or install-macos.sh / install-windows.ps1
```

Then in Claude: `"Save this conversation to Memory Layer"`

**→ [Full Guide](CLAUDE_APP_SETUP.md)**

---

### ChatGPT

**Best for**: ChatGPT Plus/Team users, GPT builders

**Setup**: Add to Custom Instructions

```
When I say "save this", save to Memory Layer:
POST https://back.memory-layer.emotiai.ai/v1/memories
Authorization: Bearer YOUR_API_KEY
```

**→ [Full Guide](CHATGPT_SETUP.md)**

---

### Gemini CLI

**Best for**: Command-line users, automated workflows

```bash
# Save helper script
python3 memory_layer_save.py "Session Title" conversation.txt

# With shell helper
source gemini-save.sh
gemini_with_save "Topic" "Your prompt"
```

**→ [Full Guide](GEMINI_CLI_SETUP.md)**

---

### Cursor / Windsurf

**Best for**: Code-focused AI conversations

**Setup**: Add to `.cursorrules`:

```markdown
When completing coding sessions, save to Memory Layer API
Include: files modified, code snippets, discussion summary
```

**→ [Cursor Guide](CURSOR_SETUP.md)** | **[Windsurf Guide](AI_TOOLS_SETUP.md)**

---

### Devin

**Best for**: Autonomous agent task tracking

**Setup**: Configure `.devin/config.yml` for automatic task saving

**→ [Full Guide](AI_TOOLS_SETUP.md#-devin-ai-agent)**

---

## 📊 Feature Comparison

| Feature | Claude MCP | ChatGPT | Gemini CLI | Cursor | Others |
|---------|-----------|---------|------------|--------|--------|
| Auto-save conversations | ✅ | ✅ | ✅ | ✅ | ✅ |
| Search past conversations | ✅ | ✅ | ✅ | ✅ | ✅ |
| Code snippet support | ✅ | ✅ | ✅ | ✅ | ✅ |
| Custom metadata | ✅ | ✅ | ✅ | ✅ | ✅ |
| Tag management | ✅ | ✅ | ✅ | ✅ | ✅ |
| Native integration | ✅ MCP | ⚠️ Manual | ⚠️ Scripts | ⚠️ Config | ⚠️ API |
| Installation complexity | Easy | Medium | Medium | Easy | Varies |

**Legend**: ✅ Full support | ⚠️ Requires configuration

---

## 🔑 Getting Started

### 1. Get API Key

1. Visit https://memory-layer.emotiai.ai
2. Sign up / Login
3. Go to Settings → API Keys
4. Generate new API key
5. Copy the key (format: `ml_...`)

### 2. Choose Your Tool(s)

Select the tools you use most:

- **Primary AI Assistant**: Claude, ChatGPT, or Gemini
- **Code Editor**: Cursor, Windsurf, VS Code
- **Automation**: Scripts, CLI tools

### 3. Follow Integration Guide

Each tool has a dedicated setup guide (see links above)

### 4. Start Saving

Begin preserving your AI conversations across all tools!

---

## 💡 Use Cases

### For Developers

```
🔧 Code Reviews → Save technical discussions with code snippets
🐛 Bug Fixes → Document problem-solving approaches
🏗️ Architecture → Preserve design decisions and rationale
📚 Learning → Save tutorials and explanations
```

### For Teams

```
👥 Knowledge Sharing → Central repository of AI interactions
📋 Onboarding → New members can search past discussions
🎯 Best Practices → Capture and reference proven solutions
📊 Project Memory → Track evolution of project decisions
```

### For Personal Use

```
💭 Learning Journal → Save educational conversations
🤔 Problem Solving → Reference past solutions
💡 Ideas → Preserve creative brainstorming sessions
🎨 Creative Work → Save AI-assisted writing/design sessions
```

---

## 🔐 Security & Privacy

### Best Practices

1. **API Key Management**
   - Store in environment variables
   - Never commit to version control
   - Rotate keys regularly
   - Use separate keys per tool/project

2. **Sensitive Data**
   - Don't save conversations with credentials
   - Review before saving production code
   - Use tags to mark sensitivity level
   - Enable deletion when needed

3. **Access Control**
   - Only you can access your memories
   - End-to-end encryption at rest
   - Secure API with Bearer tokens
   - Optional: Team workspaces (coming soon)

---

## 📈 Advanced Usage

### Cross-Tool Workflows

**Example**: Research in ChatGPT → Code in Cursor → Review in Claude

1. **ChatGPT**: Research best practices, save to Memory Layer
2. **Cursor**: Implement code, reference saved research, save session
3. **Claude**: Review code, search both previous sessions, save final review

All conversations searchable in one place!

### Automation

```python
# Auto-save all AI conversations daily
import schedule
from memory_layer_api import save_conversation

def daily_backup():
    # Collect conversations from multiple sources
    # Save to Memory Layer with timestamp
    pass

schedule.every().day.at("23:00").do(daily_backup)
```

### Team Knowledge Base

- Standardize tags across team
- Use project-based metadata
- Regular knowledge audits
- Share Memory Layer best practices

---

## 🆘 Troubleshooting

### Common Issues

**API Key Errors**
```
❌ 401 Unauthorized
→ Check API key is correct
→ Verify key hasn't expired
→ Ensure Bearer prefix in Authorization header
```

**Connection Errors**
```
❌ Connection timeout
→ Check internet connection
→ Verify API URL: https://back.memory-layer.emotiai.ai
→ Try ping/curl test
```

**Save Failures**
```
❌ 400 Bad Request
→ Verify request body format
→ Check required fields: name, content
→ Validate JSON syntax
```

### Getting Help

- 📖 API Documentation: https://back.memory-layer.emotiai.ai/docs
- 💬 Support: https://memory-layer.emotiai.ai/support
- 🐛 GitHub Issues: https://github.com/ext-sakamoro/MemoryLayerMCP/issues

---

## 🎉 Getting the Most from Memory Layer

### Tips for Success

1. **Consistent Naming**: Use clear, searchable titles
2. **Rich Tagging**: Tag by project, language, topic, date
3. **Regular Review**: Audit saved conversations monthly
4. **Team Standards**: Develop shared conventions
5. **Search Practice**: Master search syntax for quick retrieval

### Example Workflow

```
Morning: Review yesterday's saves in dashboard
During Work: Save important conversations as you go
End of Day: Tag and organize new saves
Weekly: Search for patterns and insights
Monthly: Archive or delete obsolete conversations
```

---

## 🚀 Next Steps

1. ✅ Set up your primary AI tool integration
2. ✅ Save your first conversation
3. ✅ Try searching saved conversations
4. ✅ Add secondary tools as needed
5. ✅ Develop your personal workflow

**Ready to build your AI knowledge base?** Choose a tool above and get started! 🎯

---

## 📞 Additional Resources

- **Main Repository**: https://github.com/ext-sakamoro/MemoryLayerMCP
- **Memory Layer Website**: https://memory-layer.emotiai.ai
- **API Playground**: https://back.memory-layer.emotiai.ai/docs
- **Community**: Join discussions in GitHub Discussions
