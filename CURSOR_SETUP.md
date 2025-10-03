# Cursor IDE Integration with Memory Layer

Save your Cursor AI conversations and code sessions automatically to Memory Layer API.

**[日本語版はこちら](CURSOR_SETUP.ja.md)**

## 🚀 Setup

### Method 1: `.cursorrules` Configuration (Recommended)

1. Create or edit `.cursorrules` in your project root
2. Add Memory Layer integration rules:

```
# Memory Layer Integration for Cursor

## Auto-Save Important Conversations

When I say "save this conversation" or when completing important coding sessions, automatically save to Memory Layer using this API:

**API Configuration:**
- Endpoint: https://back.memory-layer.emotiai.ai/v1/memories
- Method: POST
- Headers:
  - Authorization: Bearer YOUR_API_KEY_HERE
  - Content-Type: application/json

**Request Format:**
{
  "name": "[Auto-generate from session topic or file being worked on]",
  "type": "development",
  "content": "[Conversation + code snippets in markdown format]",
  "metadata": {
    "source": "Cursor",
    "project": "[current project name]",
    "files": "[list of files discussed]",
    "language": "[primary language]",
    "date": "[current date]"
  },
  "tags": ["Cursor", "Development", "[language]", "[framework]"]
}

**When to Auto-Save:**
- Completing a significant code review
- Solving a complex bug
- Architecture or design discussions
- Learning new patterns or techniques
- Refactoring sessions

After saving, confirm with: "✅ Session saved to Memory Layer!"

## Search Past Sessions

When I ask to "search Memory Layer" or "recall previous discussion about X", query:

GET https://back.memory-layer.emotiai.ai/v1/memories?search=[query]&tags=Cursor,Development

Format results showing:
- Title
- Date
- Files involved
- Summary of discussion
- Relevant code snippets
```

3. Replace `YOUR_API_KEY_HERE` with your actual API key

### Method 2: Global Cursor Settings

1. Open Cursor Settings (Cmd/Ctrl + ,)
2. Search for "AI Rules" or "Custom Instructions"
3. Add the Memory Layer integration rules from above

### Method 3: Python Extension Script

Create `cursor_memory_layer.py` in your project:

```python
#!/usr/bin/env python3
"""
Cursor - Memory Layer Integration
Save coding sessions to Memory Layer
"""

import os
import json
import requests
from datetime import datetime
from pathlib import Path

API_KEY = os.getenv("MEMORY_LAYER_API_KEY", "YOUR_API_KEY_HERE")
API_URL = "https://back.memory-layer.emotiai.ai"

def get_project_info():
    """Get current project information"""
    cwd = Path.cwd()
    return {
        "project": cwd.name,
        "path": str(cwd),
        "git_repo": (cwd / ".git").exists()
    }

def save_session(title, content, files=None, language=None, tags=None):
    """Save Cursor session to Memory Layer"""

    project_info = get_project_info()

    metadata = {
        "source": "Cursor",
        "project": project_info["project"],
        "date": datetime.now().isoformat(),
    }

    if files:
        metadata["files"] = files
    if language:
        metadata["language"] = language

    body = {
        "name": title,
        "type": "development",
        "content": content,
        "tags": tags or ["Cursor", "Development"],
        "metadata": metadata
    }

    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    }

    try:
        response = requests.post(
            f"{API_URL}/v1/memories",
            headers=headers,
            json=body
        )
        response.raise_for_status()

        result = response.json()
        print(f"✅ Session saved to Memory Layer!")
        print(f"   ID: {result.get('id')}")
        print(f"   Title: {title}")
        return result

    except requests.exceptions.RequestException as e:
        print(f"❌ Error: {e}")
        return None

def search_sessions(query, limit=10):
    """Search saved sessions"""

    headers = {"Authorization": f"Bearer {API_KEY}"}
    params = {
        "search": query,
        "tags": "Cursor,Development",
        "limit": limit
    }

    try:
        response = requests.get(
            f"{API_URL}/v1/memories",
            headers=headers,
            params=params
        )
        response.raise_for_status()

        results = response.json()
        print(f"\n📚 Found {results.get('total', 0)} sessions:\n")

        for memory in results.get('data', []):
            print(f"📝 {memory['name']}")
            print(f"   Project: {memory.get('metadata', {}).get('project', 'N/A')}")
            print(f"   Date: {memory['created_at']}")
            print(f"   Files: {memory.get('metadata', {}).get('files', 'N/A')}")
            print()

        return results

    except requests.exceptions.RequestException as e:
        print(f"❌ Error: {e}")
        return None

if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage:")
        print("  Save: python cursor_memory_layer.py save <title> <content_file>")
        print("  Search: python cursor_memory_layer.py search <query>")
        sys.exit(1)

    command = sys.argv[1]

    if command == "save":
        title = sys.argv[2]
        content_file = sys.argv[3]
        with open(content_file, 'r') as f:
            content = f.read()
        save_session(title, content)

    elif command == "search":
        query = " ".join(sys.argv[2:])
        search_sessions(query)
```

## 💬 Usage Examples

### Save Current Session

In Cursor, tell the AI:

```
Save this coding session to Memory Layer with title "Refactoring Authentication Module"
```

The AI will:
1. Collect the conversation and code snippets
2. Extract file names and languages
3. Save to Memory Layer with proper metadata
4. Confirm with a success message

### Search Past Sessions

```
Search Memory Layer for sessions about "React hooks implementation"
```

### Save Specific Code Review

```
Save this code review to Memory Layer:
- Title: "API endpoint security review"
- Files: auth.py, middleware.py
- Tags: Security, API, Python
```

## 🎯 Advanced Usage

### Auto-Save on Git Commit

Create `.git/hooks/post-commit`:

```bash
#!/bin/bash
# Auto-save commit details to Memory Layer

COMMIT_MSG=$(git log -1 --pretty=%B)
CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r HEAD)

cat > /tmp/commit_session.txt <<EOF
# Git Commit Session

## Commit Message
$COMMIT_MSG

## Changed Files
$CHANGED_FILES

## Diff
$(git show HEAD)
EOF

python3 cursor_memory_layer.py save \
    "Commit: $COMMIT_MSG" \
    /tmp/commit_session.txt
```

### Save on File Save

Add to your `.cursorrules`:

```
After significant file saves (>50 lines changed), suggest saving the session to Memory Layer with:
- Title: "[filename] - [brief description of changes]"
- Content: Summary of changes + relevant code snippets
- Tags: Based on file type and purpose
```

### Project-Specific Rules

For React projects, add to `.cursorrules`:

```
For this React project, when saving to Memory Layer:
- Always include component names in tags
- Categorize by: Component, Hook, Utility, Style
- Include related component files in metadata
- Tag with: React, TypeScript, [feature-name]
```

## 🔑 Environment Setup

Add to your shell config or `.env`:

```bash
# Memory Layer API Key
export MEMORY_LAYER_API_KEY="ml_your_api_key_here"
```

Or use VS Code settings:

```json
{
  "cursor.env": {
    "MEMORY_LAYER_API_KEY": "ml_your_api_key_here"
  }
}
```

## 📊 Features

- ✅ Auto-save coding sessions
- ✅ Include code snippets and file context
- ✅ Project-aware metadata
- ✅ Language and framework detection
- ✅ Search past sessions
- ✅ Git integration
- ✅ Custom tagging system

## 🔐 Security

- Store API key securely in environment variables
- Never commit API keys to git
- Use `.gitignore` for sensitive files
- Rotate API keys regularly

## 💡 Tips

1. **Descriptive titles**: Use clear session titles for easy searching
2. **Consistent tagging**: Develop a tagging strategy for your team
3. **Regular reviews**: Review saved sessions weekly for learning
4. **Code snippets**: Include relevant code context, not entire files
5. **Link to commits**: Reference commit SHAs in session content

## 📞 Support

For issues or questions:
- Visit https://memory-layer.emotiai.ai/support
- API Documentation: https://back.memory-layer.emotiai.ai/docs

---

**Ready to save your Cursor sessions?** Set up the integration above and start building your coding knowledge base! 🚀
