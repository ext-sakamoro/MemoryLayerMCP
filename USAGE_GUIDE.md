# Memory Layer MCP - Complete Usage Guide

**[日本語版はこちら](USAGE_GUIDE.ja.md)**

## 💾 Save Conversations

### Basic Save
```
Save this conversation to Memory Layer
```

### Specify Title
```
Save this conversation to Memory Layer with title "React Learning Notes"
```

### Save with Tags
```
Save this conversation to Memory Layer with tags "Programming", "React", and "Learning"
```

---

## 🔍 Retrieve & Search Conversations

### 1. Display All Conversations
```
Show me conversations saved in Memory Layer
```
or
```
Show me the latest 10 conversations
```

**Example Result:**
```
📚 Found 150 conversations

1. **React Learning Notes**
   ID: 123e4567-e89b-12d3-a456-426614174000
   Created: 2025/10/3
   Tags: Programming, React, Learning
   Importance: 0.85

2. **Daily Chat with AI Companion**
   ID: 234e5678-e89b-12d3-a456-426614174001
   Created: 2025/10/2
   Tags: AI Companion, Daily Chat
   Importance: 0.72

...

💡 To read a specific conversation, say "Show me conversation with Memory ID [ID]"
```

### 2. Keyword Search
```
Search for conversations about "React"
```
or
```
Search for "Programming"
```

### 3. Filter by Tags
```
Show conversations with tag "AI Companion"
```
or
```
Filter by tags "Daily Chat" and "Encouragement"
```

### 4. Read Specific Conversation
```
Show me conversation with Memory ID 123e4567-e89b-12d3-a456-426614174000
```

**Example Result:**
```
📖 **React Learning Notes**

📅 Created: October 3, 2025
🏷️ Tags: Programming, React, Learning
⭐ Importance: 0.85
👀 Views: 3 times

---

You: Tell me about React's useState hook
Claude: useState is a hook for managing state in function components...

(Full conversation content displayed here)

---

💡 To ask about this conversation, just say "[your question]"
```

### 5. AI-Powered Search (Natural Language Questions)
```
What have I learned about programming?
```
or
```
What did I discuss with my AI companion?
```

**Example Result:**
```
🤖 **AI Response**

You learned about React's useState hook, useEffect hook, and custom hooks.
Especially for useState, you studied state management basics in detail and tried practical examples.
You also asked about combining it with TypeScript.

📚 **Referenced Conversations:**

1. React Learning Notes
   Relevance: 95%
   ID: 123e4567-e89b-12d3-a456-426614174000

2. Combining TypeScript and React
   Relevance: 82%
   ID: 234e5678-e89b-12d3-a456-426614174001

💡 To read a specific conversation, say "Show me conversation with Memory ID [ID]"
```

---

## 📊 Advanced Search

### Sort by Importance
```
Show conversations sorted by importance
```

### Sort by Date
```
Show the latest 10 conversations
```
or
```
Show conversations from oldest to newest
```

### Multiple Filter Conditions
```
Show 5 conversations tagged "Programming" containing "React", sorted by importance
```

---

## 💡 Useful Tips

### Daily Review
```
Show conversations saved today
```

### Monthly Review
```
Show conversations tagged "AI Companion" from October
```

### Deep Dive on Specific Topics
```
Use AI search to tell me what I discussed about "React"
```

### Recall Memories
```
Show conversations tagged "Encouragement" from oldest to newest
```

---

## 🎯 Practical Examples

### Example 1: Programming Learning Records

**Save:**
```
Save this conversation to Memory Layer with title "Python Basics" and tags "Programming", "Python", and "Learning"
```

**Search:**
```
Tell me what I learned about "Python"
```

**Result:**
```
🤖 You learned Python basics including variables, data types, conditionals, loops, and functions...
```

### Example 2: AI Companion Conversations

**Save:**
```
Save this conversation to Memory Layer with title "Today's Events" and tags "AI Companion" and "Daily Chat"
```

**Search:**
```
Show me conversations where my AI companion encouraged me
```

**Result:**
```
📚 Found 15 conversations tagged "Encouragement" and "AI Companion"...
```

### Example 3: Project Discussion Records

**Save:**
```
Save this conversation to Memory Layer with title "Web App DB Design" and tags "Work", "Design", and "Database"
```

**Search:**
```
What discussions did I have about database design?
```

---

## ⚙️ Available MCP Tools

Memory Layer MCP Server provides 4 tools:

### 1. `save_conversation_to_memory_layer`
Save conversations

**Parameters:**
- `api_key` (required): Memory Layer API Key
- `title` (required): Conversation title
- `content` (required): Conversation content
- `tags` (optional): Array of tags
- `metadata` (optional): Additional metadata

### 2. `get_memories`
Get/search conversation list

**Parameters:**
- `api_key` (required): Memory Layer API Key
- `limit` (optional): Number of results (default: 20)
- `search` (optional): Search keyword
- `tags` (optional): Tag filter
- `sort_by` (optional): Sort field (created_at, importance_score, etc.)
- `sort_order` (optional): Sort order (asc, desc)

### 3. `get_memory_by_id`
Get specific conversation

**Parameters:**
- `api_key` (required): Memory Layer API Key
- `memory_id` (required): Memory ID (UUID)

### 4. `search_memories_advanced`
AI-powered natural language search

**Parameters:**
- `api_key` (required): Memory Layer API Key
- `question` (required): Natural language question
- `limit` (optional): Number of results (default: 5)

---

## 🔑 API Key Setup

### Set via Environment Variable (Recommended)
```bash
export MEMORY_LAYER_API_KEY="your_api_key_here"
```

### Set via Configuration File
`~/.config/Claude/claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "memory-layer": {
      "env": {
        "MEMORY_LAYER_API_KEY": "your_api_key_here"
      }
    }
  }
}
```

---

## 🎉 Summary

With Memory Layer MCP you can:

- ✅ **Save**: Just say "Save this conversation"
- ✅ **Search**: Easy search by keywords and tags
- ✅ **Retrieve**: Read past conversations anytime
- ✅ **AI Search**: Ask questions in natural language to find related conversations

**Never lose important conversations - recall them anytime!** 💕
