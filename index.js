#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from '@modelcontextprotocol/sdk/types.js';
import fetch from 'node-fetch';

const MEMORY_LAYER_API = process.env.MEMORY_LAYER_API_URL || 'https://back.memory-layer.emotiai.ai';

class MemoryLayerServer {
  constructor() {
    this.server = new Server(
      {
        name: 'memory-layer-mcp',
        version: '1.0.0',
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    this.setupToolHandlers();

    this.server.onerror = (error) => console.error('[MCP Error]', error);
    process.on('SIGINT', async () => {
      await this.server.close();
      process.exit(0);
    });
  }

  setupToolHandlers() {
    this.server.setRequestHandler(ListToolsRequestSchema, async () => ({
      tools: [
        {
          name: 'save_conversation_to_memory_layer',
          description: 'Save a conversation to Memory Layer API. Use this when the user wants to save their conversation with Claude.',
          inputSchema: {
            type: 'object',
            properties: {
              api_key: {
                type: 'string',
                description: 'Memory Layer API key (Bearer token)',
              },
              title: {
                type: 'string',
                description: 'Title of the conversation',
              },
              content: {
                type: 'string',
                description: 'Full conversation content',
              },
              tags: {
                type: 'array',
                items: { type: 'string' },
                description: 'Tags for categorization (e.g., ["Claude Code", "conversation"])',
              },
              metadata: {
                type: 'object',
                description: 'Additional metadata (e.g., { "source": "Claude Code", "date": "2025-10-03" })',
              },
            },
            required: ['api_key', 'title', 'content'],
          },
        },
        {
          name: 'get_memories',
          description: 'Retrieve memories from Memory Layer with search and filtering',
          inputSchema: {
            type: 'object',
            properties: {
              api_key: {
                type: 'string',
                description: 'Memory Layer API key',
              },
              limit: {
                type: 'number',
                description: 'Number of memories to retrieve (1-100)',
                default: 20,
              },
              search: {
                type: 'string',
                description: 'Search query (searches in title and content)',
              },
              tags: {
                type: 'string',
                description: 'Filter by tags (comma-separated, e.g., "AI彼女,日常会話")',
              },
              sort_by: {
                type: 'string',
                description: 'Sort field: created_at, updated_at, importance_score, or title',
                default: 'created_at',
              },
              sort_order: {
                type: 'string',
                description: 'Sort order: asc or desc',
                default: 'desc',
              },
            },
            required: ['api_key'],
          },
        },
        {
          name: 'get_memory_by_id',
          description: 'Retrieve a specific memory by its ID',
          inputSchema: {
            type: 'object',
            properties: {
              api_key: {
                type: 'string',
                description: 'Memory Layer API key',
              },
              memory_id: {
                type: 'string',
                description: 'Memory ID (UUID)',
              },
            },
            required: ['api_key', 'memory_id'],
          },
        },
        {
          name: 'search_memories_advanced',
          description: 'Advanced search with AI-powered query using Memory Layer AI',
          inputSchema: {
            type: 'object',
            properties: {
              api_key: {
                type: 'string',
                description: 'Memory Layer API key',
              },
              question: {
                type: 'string',
                description: 'Natural language question about your memories (e.g., "What did we talk about regarding programming?")',
              },
              limit: {
                type: 'number',
                description: 'Number of relevant memories to retrieve',
                default: 5,
              },
            },
            required: ['api_key', 'question'],
          },
        },
      ],
    }));

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      switch (request.params.name) {
        case 'save_conversation_to_memory_layer':
          return await this.saveConversation(request.params.arguments);
        case 'get_memories':
          return await this.getMemories(request.params.arguments);
        case 'get_memory_by_id':
          return await this.getMemoryById(request.params.arguments);
        case 'search_memories_advanced':
          return await this.searchMemoriesAdvanced(request.params.arguments);
        default:
          throw new Error(`Unknown tool: ${request.params.name}`);
      }
    });
  }

  async saveConversation(args) {
    try {
      const response = await fetch(`${MEMORY_LAYER_API}/v1/memories`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${args.api_key}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          title: args.title,
          content: args.content,
          memory_type: 'text',
          tags: args.tags || ['Claude Code', 'conversation'],
          metadata: {
            source: 'Claude Code',
            date: new Date().toISOString(),
            ...args.metadata,
          },
        }),
      });

      if (!response.ok) {
        const error = await response.text();
        throw new Error(`API Error: ${response.status} - ${error}`);
      }

      const data = await response.json();

      return {
        content: [
          {
            type: 'text',
            text: `✅ 会話をMemory Layerに保存しました！\n\nMemory ID: ${data.memory?.id}\nTitle: ${data.memory?.title}\nImportance Score: ${data.memory?.importance_score}`,
          },
        ],
      };
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: `❌ 保存に失敗しました: ${error.message}`,
          },
        ],
        isError: true,
      };
    }
  }

  async getMemories(args) {
    try {
      const params = new URLSearchParams({
        limit: args.limit || 20,
        ...(args.search && { search: args.search }),
        ...(args.tags && { tags: args.tags }),
        ...(args.sort_by && { sort_by: args.sort_by }),
        ...(args.sort_order && { sort_order: args.sort_order }),
      });

      const response = await fetch(`${MEMORY_LAYER_API}/v1/memories?${params}`, {
        headers: {
          'Authorization': `Bearer ${args.api_key}`,
        },
      });

      if (!response.ok) {
        throw new Error(`API Error: ${response.status}`);
      }

      const data = await response.json();

      // Format the response in a user-friendly way
      if (data.memories && data.memories.length > 0) {
        const formattedMemories = data.memories.map((m, i) =>
          `${i + 1}. **${m.title}**\n` +
          `   ID: ${m.id}\n` +
          `   作成日: ${new Date(m.created_at).toLocaleDateString('ja-JP')}\n` +
          `   タグ: ${m.tags?.join(', ') || 'なし'}\n` +
          `   重要度: ${m.importance_score || 'N/A'}\n`
        ).join('\n');

        return {
          content: [
            {
              type: 'text',
              text: `📚 ${data.pagination?.total || data.memories.length}件の会話が見つかりました\n\n${formattedMemories}\n\n💡 特定の会話を読むには「Memory ID [ID] の会話を見せて」と言ってください。`,
            },
          ],
        };
      } else {
        return {
          content: [
            {
              type: 'text',
              text: '😔 該当する会話が見つかりませんでした。\n\n別のキーワードで検索するか、「すべての会話を表示」と言ってください。',
            },
          ],
        };
      }
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: `❌ 検索エラー: ${error.message}`,
          },
        ],
        isError: true,
      };
    }
  }

  async getMemoryById(args) {
    try {
      const response = await fetch(`${MEMORY_LAYER_API}/v1/memories/${args.memory_id}`, {
        headers: {
          'Authorization': `Bearer ${args.api_key}`,
        },
      });

      if (!response.ok) {
        if (response.status === 404) {
          throw new Error('この会話は見つかりませんでした。');
        }
        throw new Error(`API Error: ${response.status}`);
      }

      const data = await response.json();
      const memory = data.memory;

      return {
        content: [
          {
            type: 'text',
            text: `📖 **${memory.title}**\n\n` +
                  `📅 作成日: ${new Date(memory.created_at).toLocaleDateString('ja-JP', { year: 'numeric', month: 'long', day: 'numeric' })}\n` +
                  `🏷️ タグ: ${memory.tags?.join(', ') || 'なし'}\n` +
                  `⭐ 重要度: ${memory.importance_score || 'N/A'}\n` +
                  `👀 閲覧回数: ${memory.access_count || 0}回\n\n` +
                  `---\n\n${memory.content}\n\n---\n\n` +
                  `💡 この会話について質問するには「[質問内容]」と聞いてください。`,
          },
        ],
      };
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: `❌ エラー: ${error.message}`,
          },
        ],
        isError: true,
      };
    }
  }

  async searchMemoriesAdvanced(args) {
    try {
      const response = await fetch(`${MEMORY_LAYER_API}/v1/memories/query`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${args.api_key}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          question: args.question,
          limit: args.limit || 5,
        }),
      });

      if (!response.ok) {
        throw new Error(`API Error: ${response.status}`);
      }

      const data = await response.json();

      let responseText = `🤖 **AI回答**\n\n${data.answer}\n\n`;

      if (data.sources && data.sources.length > 0) {
        responseText += `\n📚 **参照した会話:**\n\n`;
        data.sources.forEach((source, i) => {
          responseText += `${i + 1}. ${source.title}\n`;
          responseText += `   関連度: ${(source.relevance_score * 100).toFixed(0)}%\n`;
          responseText += `   ID: ${source.memory_id}\n\n`;
        });
      }

      responseText += `\n💡 特定の会話を読むには「Memory ID [ID] の会話を見せて」と言ってください。`;

      return {
        content: [
          {
            type: 'text',
            text: responseText,
          },
        ],
      };
    } catch (error) {
      return {
        content: [
          {
            type: 'text',
            text: `❌ AI検索エラー: ${error.message}`,
          },
        ],
        isError: true,
      };
    }
  }

  async run() {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error('Memory Layer MCP server running on stdio');
  }
}

const server = new MemoryLayerServer();
server.run().catch(console.error);
