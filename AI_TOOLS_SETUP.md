# AI Development Tools Integration with Memory Layer

Integration guides for Windsurf, Devin, and other AI development tools with Memory Layer API.

**[日本語版はこちら](AI_TOOLS_SETUP.ja.md)**

## 🌊 Windsurf IDE

### Setup

Windsurf uses similar configuration to Cursor. Add to your project's AI configuration:

**`.windsurfrules` or AI Settings:**

```markdown
# Memory Layer Integration

When completing significant coding sessions or when I say "save this session", save to Memory Layer:

API: https://back.memory-layer.emotiai.ai/v1/memories
Method: POST
Headers:
  Authorization: Bearer YOUR_API_KEY_HERE
  Content-Type: application/json

Body:
{
  "name": "[Session title from context]",
  "type": "development",
  "content": "[Conversation + code in markdown]",
  "metadata": {
    "source": "Windsurf",
    "project": "[project name]",
    "files": "[modified files]"
  },
  "tags": ["Windsurf", "Development", "[tech stack]"]
}

Confirm with: "✅ Session saved to Memory Layer!"
```

### Usage

```
You: Save this refactoring session to Memory Layer
Windsurf: [Saves automatically] ✅ Session saved!

You: Search Memory Layer for "API optimization discussions"
Windsurf: [Queries and displays results]
```

### Python Helper

```python
# windsurf_save.py
import os
import requests
from datetime import datetime

API_KEY = os.getenv("MEMORY_LAYER_API_KEY")
API_URL = "https://back.memory-layer.emotiai.ai/v1/memories"

def save_windsurf_session(title, content, tags=None):
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    }

    data = {
        "name": title,
        "type": "development",
        "content": content,
        "tags": tags or ["Windsurf", "Development"],
        "metadata": {
            "source": "Windsurf",
            "date": datetime.now().isoformat()
        }
    }

    response = requests.post(API_URL, headers=headers, json=data)
    response.raise_for_status()
    print(f"✅ Saved: {title}")
    return response.json()
```

---

## 🤖 Devin AI Agent

### Setup

Configure Devin's task memory to integrate with Memory Layer:

**Devin Task Configuration:**

```yaml
# .devin/config.yml

memory_layer:
  enabled: true
  api_url: https://back.memory-layer.emotiai.ai
  api_key: ${MEMORY_LAYER_API_KEY}

  auto_save:
    - on_task_complete: true
    - on_milestone: true
    - on_error_resolution: true

  metadata:
    source: Devin
    agent_version: "1.0"
```

### API Integration Script

```python
# devin_memory_integration.py
import os
import requests
from typing import Dict, List

class DevinMemoryLayer:
    def __init__(self):
        self.api_key = os.getenv("MEMORY_LAYER_API_KEY")
        self.api_url = "https://back.memory-layer.emotiai.ai"

    def save_task(self, task_name: str, description: str,
                  outcome: str, files_modified: List[str]):
        """Save completed Devin task to Memory Layer"""

        content = f"""# Devin Task: {task_name}

## Description
{description}

## Outcome
{outcome}

## Files Modified
{chr(10).join(f'- {f}' for f in files_modified)}
"""

        data = {
            "name": f"Devin Task: {task_name}",
            "type": "development",
            "content": content,
            "tags": ["Devin", "Autonomous", "Task"],
            "metadata": {
                "source": "Devin",
                "task_name": task_name,
                "files_modified": files_modified
            }
        }

        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }

        response = requests.post(
            f"{self.api_url}/v1/memories",
            headers=headers,
            json=data
        )
        response.raise_for_status()
        return response.json()

    def search_similar_tasks(self, query: str):
        """Search for similar past tasks"""

        headers = {"Authorization": f"Bearer {self.api_key}"}
        params = {"search": query, "tags": "Devin"}

        response = requests.get(
            f"{self.api_url}/v1/memories",
            headers=headers,
            params=params
        )
        response.raise_for_status()
        return response.json()

# Usage in Devin scripts
if __name__ == "__main__":
    memory = DevinMemoryLayer()

    # Save a task
    memory.save_task(
        task_name="Implement User Authentication",
        description="Add JWT-based auth to API",
        outcome="Successfully implemented with tests",
        files_modified=["auth.py", "middleware.py", "tests/test_auth.py"]
    )

    # Search past tasks
    similar = memory.search_similar_tasks("authentication implementation")
    print(f"Found {len(similar.get('data', []))} similar tasks")
```

### Usage

Devin will automatically:
- Save completed tasks to Memory Layer
- Reference past solutions before starting new tasks
- Learn from previous implementations
- Build institutional knowledge over time

---

## 🔧 Other AI Tools

### Aider

```python
# .aider.conf.yml
memory_layer:
  api_key: ${MEMORY_LAYER_API_KEY}
  auto_save: true

# Hook script
post_edit_hook: |
  python3 save_to_memory_layer.py --title "Aider Edit Session"
```

### GitHub Copilot Chat

Add to Copilot Chat instructions:

```
When I say "save this", save the conversation to Memory Layer API at:
https://back.memory-layer.emotiai.ai/v1/memories

Use Authorization header with: Bearer [API_KEY]
Include source: "GitHub Copilot" in metadata
```

### Cody (Sourcegraph)

```json
// .vscode/settings.json
{
  "cody.customCommands": {
    "Save to Memory Layer": {
      "prompt": "Save this conversation to Memory Layer API",
      "context": {
        "currentFile": true,
        "selection": true
      }
    }
  }
}
```

### Continue.dev

```javascript
// config.json
{
  "models": [...],
  "customCommands": [{
    "name": "save-to-memory-layer",
    "description": "Save conversation to Memory Layer",
    "prompt": "Save this to Memory Layer API..."
  }]
}
```

---

## 🔑 Environment Variables

For all tools, set:

```bash
export MEMORY_LAYER_API_KEY="ml_your_api_key_here"
```

Or in `.env`:

```
MEMORY_LAYER_API_KEY=ml_your_api_key_here
MEMORY_LAYER_API_URL=https://back.memory-layer.emotiai.ai
```

---

## 📊 Common Features Across Tools

All integrations support:

- ✅ **Auto-save**: Automatically save important sessions
- ✅ **Search**: Query past conversations and code sessions
- ✅ **Metadata**: Rich context about projects, files, languages
- ✅ **Tagging**: Organize by tool, project, topic
- ✅ **Retrieval**: Reference past solutions in new tasks

---

## 💡 Best Practices

1. **Consistent naming**: Use clear, searchable titles
2. **Rich metadata**: Include file names, languages, frameworks
3. **Strategic tagging**: Develop team-wide tag conventions
4. **Regular review**: Audit saved sessions monthly
5. **Privacy**: Never save sensitive credentials or secrets

---

## 📞 Support

- Documentation: https://memory-layer.emotiai.ai/docs
- API Reference: https://back.memory-layer.emotiai.ai/docs
- Support: https://memory-layer.emotiai.ai/support

---

**Start preserving your AI development sessions across all your tools!** 🚀
