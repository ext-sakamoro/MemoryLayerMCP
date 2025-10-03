# Memory Layer MCP Server

Claude デスクトップ向け Memory Layer API 連携用 Model Context Protocol (MCP) サーバー

Claude との会話をシームレスに保存・呼び出し！

**[English README is here](README.md)**

## 🚀 機能

### 💾 会話の保存
- **save_conversation_to_memory_layer**: 会話の自動保存
  - タイトルとメタデータの自動生成
  - 重要度スコアリング
  - タグサポート

### 🔍 検索・呼び出し
- **get_memories**: キーワードとタグで会話を検索
  - 全文検索
  - タグフィルタリング
  - 日付・重要度でソート

- **get_memory_by_id**: 特定の会話を取得
  - Memory ID による直接アクセス
  - 会話の全内容を表示

- **search_memories_advanced**: AI powered 検索
  - 自然言語クエリ
  - 関連度スコアリング
  - コンテキストを考慮した結果

## 📦 インストール

### クイックインストール

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

### 必要な環境

- Node.js 18.0.0 以降
- Claude デスクトップアプリ
- Memory Layer API Key (https://memory-layer.emotiai.ai で取得)

## 📝 使い方

インストール後、Claude にこう話しかけるだけ:

```
この会話を Memory Layer に保存して
```

Claude が自動的に MCP サーバーを使って会話を保存します！

### 会話を検索

```
Memory Layer から「React」に関する会話を検索して
```

### 特定の会話を呼び出し

```
Memory ID [your-id-here] の会話を見せて
```

### AI powered 検索

```
プログラミングについて何を学んだか教えて
```

## 🔑 API Key

1. https://memory-layer.emotiai.ai にアクセス
2. Settings → API Keys に移動
3. 新しい API key を生成
4. インストール時に入力

## 🛠️ 他の AI ツール対応

このリポジトリは Claude Desktop 用 MCP サーバーを提供していますが、Memory Layer API は**すべての AI ツール**で動作します:

### 対応連携

- **ChatGPT** - Custom Instructions / GPT Actions → [セットアップガイド](CHATGPT_SETUP.ja.md)
- **Gemini CLI** - Python/Shell スクリプト → [セットアップガイド](GEMINI_CLI_SETUP.ja.md)
- **Cursor** - .cursorrules 設定 → [セットアップガイド](CURSOR_SETUP.ja.md)
- **Windsurf** - AI 設定 → [セットアップガイド](AI_TOOLS_SETUP.ja.md)
- **Devin** - タスク自動化 → [セットアップガイド](AI_TOOLS_SETUP.ja.md)
- **API アクセス可能な任意のツール** → [連携ガイド](INTEGRATIONS.ja.md)

**→ [すべてのツール向け完全連携ガイド](INTEGRATIONS.ja.md)**

## 📚 ドキュメント

### Claude Desktop (MCP サーバー)
- [クイックスタートガイド](QUICK_START.ja.md) | [English](QUICK_START.md)
- [使い方ガイド](USAGE_GUIDE.ja.md) | [English](USAGE_GUIDE.md)
- [Claude アプリ設定方法](CLAUDE_APP_SETUP.ja.md) | [English](CLAUDE_APP_SETUP.md)

### 他の AI ツール
- [ChatGPT セットアップ](CHATGPT_SETUP.ja.md) | [English](CHATGPT_SETUP.md)
- [Gemini CLI セットアップ](GEMINI_CLI_SETUP.ja.md) | [English](GEMINI_CLI_SETUP.md)
- [Cursor セットアップ](CURSOR_SETUP.ja.md) | [English](CURSOR_SETUP.md)
- [Windsurf & Devin セットアップ](AI_TOOLS_SETUP.ja.md) | [English](AI_TOOLS_SETUP.md)
- [完全連携ガイド](INTEGRATIONS.ja.md) | [English](INTEGRATIONS.md)

## 🔧 技術詳細

- **MCP SDK**: @modelcontextprotocol/sdk v1.19.1
- **プロトコル**: stdio
- **API**: https://back.memory-layer.emotiai.ai

## 🌐 Memory Layer

Memory Layer は、プロフェッショナル向け LLM 会話ストレージサービスです。

- **ウェブサイト**: https://memory-layer.emotiai.ai
- **機能**: AI powered 検索、会話管理、API 連携
- **プラン**: 無料プランあり

## 📄 ライセンス

MIT

## 🤝 サポート

問題や質問がある場合:
- https://memory-layer.emotiai.ai にアクセス
- このリポジトリのドキュメントを確認
