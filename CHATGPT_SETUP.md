# ChatGPT Integration with Memory Layer

Save your ChatGPT conversations automatically to Memory Layer API.

**[日本語版はこちら](CHATGPT_SETUP.ja.md)**

## 🚀 Setup Methods

### Method 1: Custom Instructions (Recommended)

1. Go to ChatGPT Settings → Custom Instructions
2. Add the following to **"How would you like ChatGPT to respond?"**:

```
When I say "save this conversation" or at the end of important discussions, automatically save the conversation to Memory Layer using this API:

API Endpoint: https://back.memory-layer.emotiai.ai/v1/memories
Method: POST
Headers:
  Authorization: Bearer YOUR_API_KEY_HERE
  Content-Type: application/json

Request Body Format:
{
  "name": "[Auto-generate title from conversation topic]",
  "type": "support",
  "content": "[Full conversation in markdown format with clear user/assistant labels]",
  "metadata": {
    "source": "ChatGPT",
    "ai_model": "GPT-4",
    "date": "[Current date]",
    "tags": ["ChatGPT", "AI Assistant"]
  }
}

After saving, confirm with: "✅ Conversation saved to Memory Layer!"
```

3. Replace `YOUR_API_KEY_HERE` with your actual API key from https://memory-layer.emotiai.ai

### Method 2: GPT Action (For GPT Builder)

1. Create a new GPT or edit existing one
2. Go to "Configure" → "Actions"
3. Add new action with this schema:

```yaml
openapi: 3.0.0
info:
  title: Memory Layer API
  version: 1.0.0
servers:
  - url: https://back.memory-layer.emotiai.ai
paths:
  /v1/memories:
    post:
      operationId: saveMemory
      summary: Save conversation to Memory Layer
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                name:
                  type: string
                  description: Title of the conversation
                type:
                  type: string
                  enum: [support, development, learning, personal]
                content:
                  type: string
                  description: Full conversation content
                metadata:
                  type: object
                  description: Additional metadata
      responses:
        '201':
          description: Memory created successfully
```

4. Set Authentication:
   - Type: API Key
   - Header: `Authorization`
   - Value: `Bearer YOUR_API_KEY_HERE`

## 💬 Usage Examples

### Basic Save
```
User: Save this conversation to Memory Layer
ChatGPT: [Automatically formats and saves the conversation]
✅ Conversation saved to Memory Layer!
```

### Save with Custom Title
```
User: Save this conversation with title "Python Learning Session"
ChatGPT: [Saves with specified title]
✅ Conversation "Python Learning Session" saved to Memory Layer!
```

### Save with Tags
```
User: Save this conversation with tags "Programming", "Python", and "Tutorial"
ChatGPT: [Saves with specified tags]
✅ Conversation saved with tags: Programming, Python, Tutorial
```

## 🔍 Search Saved Conversations

To search your saved conversations, use the Memory Layer web interface:
https://memory-layer.emotiai.ai/dashboard

Or ask ChatGPT to query the API:

```
User: Search my Memory Layer for conversations about "Python"
ChatGPT: [Queries the API and shows results]
```

Add this to Custom Instructions for search capability:

```
When I ask to search Memory Layer, use this API:

GET https://back.memory-layer.emotiai.ai/v1/memories?search=[query]
Headers:
  Authorization: Bearer YOUR_API_KEY_HERE

Show the results in a formatted list with titles, dates, and relevance.
```

## 🎯 Advanced Configuration

### Auto-Save Important Conversations

Add to Custom Instructions:

```
Automatically detect when a conversation is important (e.g., problem-solving, learning, creative work) and suggest saving to Memory Layer at natural breakpoints.
```

### Custom Metadata

```
When saving to Memory Layer, include these metadata fields:
- conversation_type: [technical/creative/personal/business]
- main_topic: [extracted from conversation]
- key_insights: [list of main takeaways]
- action_items: [any TODOs mentioned]
```

## 🔑 Get API Key

1. Visit https://memory-layer.emotiai.ai
2. Sign up or login
3. Go to Settings → API Keys
4. Generate a new API key
5. Copy and use in the configurations above

## 📊 API Features

Available via ChatGPT integration:

- ✅ Save conversations
- ✅ Search by keywords
- ✅ Filter by tags
- ✅ AI-powered semantic search
- ✅ Retrieve specific conversations by ID
- ✅ Update existing memories
- ✅ Delete conversations

## 🔐 Privacy & Security

- All conversations are encrypted
- Only you can access your saved conversations
- API keys can be revoked anytime
- No data sharing with third parties

## 📞 Support

For issues or questions:
- Visit https://memory-layer.emotiai.ai/support
- Check API documentation at https://back.memory-layer.emotiai.ai/docs

## 💡 Tips

1. **Use clear titles**: Help ChatGPT generate descriptive titles
2. **Tag consistently**: Use the same tags across conversations for better organization
3. **Review regularly**: Check your saved conversations at the dashboard
4. **Backup important data**: Export conversations periodically

---

**Ready to save your ChatGPT conversations?** Follow the setup above and start preserving your AI interactions! 🚀
