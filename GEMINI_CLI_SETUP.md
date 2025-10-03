# Gemini CLI Integration with Memory Layer

Save your Gemini CLI conversations automatically to Memory Layer API.

**[日本語版はこちら](GEMINI_CLI_SETUP.ja.md)**

## 🚀 Setup

### Prerequisites

- Python 3.8 or later
- Gemini CLI installed
- Memory Layer API Key

### Installation

1. Get your Memory Layer API Key from https://memory-layer.emotiai.ai
2. Save the helper script below
3. Configure your Gemini CLI to use it

## 📝 Python Helper Script

Save this as `memory_layer_save.py`:

```python
#!/usr/bin/env python3
"""
Memory Layer Save Helper for Gemini CLI
Saves Gemini conversations to Memory Layer API
"""

import os
import sys
import json
import requests
from datetime import datetime

# Configuration
MEMORY_LAYER_API = "https://back.memory-layer.emotiai.ai"
API_KEY = os.getenv("MEMORY_LAYER_API_KEY", "YOUR_API_KEY_HERE")

def save_conversation(title, content, tags=None, metadata=None):
    """Save conversation to Memory Layer"""

    url = f"{MEMORY_LAYER_API}/v1/memories"
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    }

    # Prepare metadata
    meta = {
        "source": "Gemini CLI",
        "ai_model": "Gemini",
        "date": datetime.now().isoformat(),
        **(metadata or {})
    }

    # Prepare request body
    body = {
        "name": title,
        "type": "support",
        "content": content,
        "tags": tags or ["Gemini", "CLI"],
        "metadata": meta
    }

    try:
        response = requests.post(url, headers=headers, json=body)
        response.raise_for_status()

        result = response.json()
        print(f"✅ Conversation saved to Memory Layer!")
        print(f"   ID: {result.get('id')}")
        print(f"   Title: {title}")
        return result

    except requests.exceptions.RequestException as e:
        print(f"❌ Error saving to Memory Layer: {e}", file=sys.stderr)
        return None

def read_from_file(filepath):
    """Read conversation from file"""
    with open(filepath, 'r', encoding='utf-8') as f:
        return f.read()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python memory_layer_save.py <title> <content_file> [tags...]")
        sys.exit(1)

    title = sys.argv[1]
    content_file = sys.argv[2]
    tags = sys.argv[3:] if len(sys.argv) > 3 else ["Gemini", "CLI"]

    content = read_from_file(content_file)
    save_conversation(title, content, tags)
```

Make it executable:
```bash
chmod +x memory_layer_save.py
```

## 🔧 Shell Helper Script

Save this as `gemini-save.sh`:

```bash
#!/bin/bash
# Gemini CLI - Memory Layer Save Helper

# Configuration
export MEMORY_LAYER_API_KEY="YOUR_API_KEY_HERE"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Temporary file for conversation
TEMP_FILE="/tmp/gemini_conversation_$(date +%s).txt"

# Function to save conversation
save_to_memory_layer() {
    local title="$1"
    local content_file="$2"
    shift 2
    local tags=("$@")

    echo "Saving to Memory Layer..."
    python3 "$SCRIPT_DIR/memory_layer_save.py" "$title" "$content_file" "${tags[@]}"
}

# Capture Gemini output
gemini_with_save() {
    local title="${1:-Gemini Conversation $(date +%Y-%m-%d)}"
    shift

    # Run Gemini and capture output
    gemini "$@" | tee "$TEMP_FILE"

    # Ask if user wants to save
    echo ""
    read -p "Save this conversation to Memory Layer? (y/n): " choice
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        read -p "Title [${title}]: " custom_title
        title="${custom_title:-$title}"

        read -p "Tags (space-separated) [Gemini CLI]: " custom_tags
        tags=(${custom_tags:-Gemini CLI})

        save_to_memory_layer "$title" "$TEMP_FILE" "${tags[@]}"
    fi

    # Cleanup
    rm -f "$TEMP_FILE"
}

# Export function for use
export -f gemini_with_save

# Usage information
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Usage: source gemini-save.sh"
    echo "Then use: gemini_with_save [title] [gemini arguments...]"
    echo ""
    echo "Example:"
    echo "  gemini_with_save 'Python Learning' 'Explain Python decorators'"
    exit 0
fi

echo "Gemini-Memory Layer integration loaded!"
echo "Use: gemini_with_save [title] [your prompt]"
```

Make it executable:
```bash
chmod +x gemini-save.sh
```

## 💬 Usage Examples

### Using Python Script Directly

```bash
# Save a conversation from file
python3 memory_layer_save.py "Gemini AI Discussion" conversation.txt

# With custom tags
python3 memory_layer_save.py "Python Tutorial" tutorial.txt Programming Python Learning
```

### Using Shell Helper

```bash
# Load the helper
source gemini-save.sh

# Use Gemini with auto-save option
gemini_with_save "Python Decorators" "Explain Python decorators with examples"

# The script will ask if you want to save after the response
```

### Integration with Gemini CLI Config

Add to your `.zshrc` or `.bashrc`:

```bash
# Memory Layer integration for Gemini
export MEMORY_LAYER_API_KEY="your_api_key_here"
source ~/path/to/gemini-save.sh

# Alias for quick access
alias gsave='gemini_with_save'
```

Then use:
```bash
gsave "Learning Rust" "Explain Rust ownership"
```

## 🔍 Advanced Usage

### Auto-Save All Conversations

Create `~/.gemini/hooks/post-response.sh`:

```bash
#!/bin/bash
# Auto-save all Gemini conversations

CONVERSATION_FILE="$1"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M")

python3 ~/memory_layer_save.py \
    "Gemini - $TIMESTAMP" \
    "$CONVERSATION_FILE" \
    "Gemini" "Auto-saved" "$(date +%Y-%m-%d)"
```

### Search Saved Conversations

Create `memory_layer_search.py`:

```python
#!/usr/bin/env python3
import os
import sys
import requests

API_KEY = os.getenv("MEMORY_LAYER_API_KEY")
API_URL = "https://back.memory-layer.emotiai.ai"

def search_memories(query):
    url = f"{API_URL}/v1/memories"
    headers = {"Authorization": f"Bearer {API_KEY}"}
    params = {"search": query, "limit": 10}

    response = requests.get(url, headers=headers, params=params)
    response.raise_for_status()

    results = response.json()
    print(f"\n📚 Found {results.get('total', 0)} conversations:\n")

    for memory in results.get('data', []):
        print(f"📝 {memory['name']}")
        print(f"   ID: {memory['id']}")
        print(f"   Date: {memory['created_at']}")
        print(f"   Tags: {', '.join(memory.get('tags', []))}")
        print()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python memory_layer_search.py <query>")
        sys.exit(1)

    search_memories(" ".join(sys.argv[1:]))
```

Usage:
```bash
python3 memory_layer_search.py "Python decorators"
```

## 🔑 Environment Variables

Set these in your shell config:

```bash
# Memory Layer API Key
export MEMORY_LAYER_API_KEY="ml_your_api_key_here"

# Optional: Custom API endpoint
export MEMORY_LAYER_API_URL="https://back.memory-layer.emotiai.ai"
```

## 📊 Features

- ✅ Save Gemini CLI conversations
- ✅ Custom titles and tags
- ✅ Automatic metadata (timestamp, source, AI model)
- ✅ Interactive save prompts
- ✅ Search saved conversations
- ✅ Batch operations support

## 🔐 Security

- Store API key in environment variables
- Never commit API keys to version control
- Use `.env` files for local development
- Rotate API keys regularly

## 📞 Support

For issues or questions:
- Visit https://memory-layer.emotiai.ai/support
- API Documentation: https://back.memory-layer.emotiai.ai/docs

---

**Ready to save your Gemini CLI conversations?** Set up the scripts above and start preserving your AI interactions! 🚀
