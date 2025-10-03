# Claude デスクトップアプリ向け Memory Layer MCP 拡張機能

Claudeデスクトップアプリで会話を自動的にMemory Layer APIに保存できるようにする拡張機能です。

## 📦 対応プラットフォーム

- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🚀 セットアップ手順

### 1. Memory Layer API Keyの取得

1. https://memory-layer.emotiai.ai にアクセス
2. アカウント作成またはログイン
3. **Settings** → **API Keys** に移動
4. **Generate New API Key** をクリック
5. 生成されたAPI Key（`ml_...` 形式）をコピー

### 2. Claude アプリの設定ファイルを編集

#### **Windows の場合**

`%APPDATA%\Claude\claude_desktop_config.json` を以下の内容で作成:

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

**パスを変更**:
- `YOUR_USERNAME` を実際のWindowsユーザー名に変更
- API Keyを実際の値に変更

#### **macOS の場合**

`~/Library/Application Support/Claude/claude_desktop_config.json` を以下の内容で作成:

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

**パスを変更**:
- `YOUR_USERNAME` を実際のmacOSユーザー名に変更
- API Keyを実際の値に変更

#### **Linux の場合**

`~/.config/Claude/claude_desktop_config.json` を以下の内容で作成:

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

**パスを変更**:
- `YOUR_USERNAME` を実際のLinuxユーザー名に変更
- API Keyを実際の値に変更

### 3. MCPサーバーファイルの配置

#### **すべてのプラットフォーム共通**

1. Node.jsがインストールされていることを確認:
```bash
node --version
npm --version
```

2. MCPサーバーのディレクトリを作成:

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

3. 以下のファイルを作成:

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
    "@modelcontextprotocol/sdk": "^1.0.4",
    "node-fetch": "^3.3.2"
  },
  "keywords": ["mcp", "memory-layer", "claude"],
  "author": "",
  "license": "MIT"
}
```

**index.js**: (このリポジトリの`index.js`をコピー)

4. 依存関係をインストール:
```bash
npm install
```

### 4. Claude アプリを再起動

設定ファイルを保存したら、Claudeデスクトップアプリを完全に終了して再起動します。

## 💬 使い方

### 会話を保存する

Claude アプリで会話中に、以下のように指示するだけです:

```
この会話をMemory Layerに保存してください
```

または

```
Save this conversation to Memory Layer with title "今日の開発作業"
```

Claudeが自動的に:
1. 会話全体を整形
2. Memory Layer APIに送信
3. 保存結果を通知

### 保存例

**例1: シンプルな保存**
```
この会話を保存して
```

**例2: タイトル指定**
```
この会話を "Reactフックの学習" というタイトルでMemory Layerに保存
```

**例3: タグ付き保存**
```
この会話を「Claude学習」「プログラミング」というタグでMemory Layerに保存
```

### 過去の会話を検索

```
Memory Layerから「React」に関する会話を検索して
```

## 🔧 トラブルシューティング

### MCPサーバーが認識されない

1. **設定ファイルのパスを確認**
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Linux: `~/.config/Claude/claude_desktop_config.json`

2. **JSON構文エラーをチェック**
   - https://jsonlint.com/ でJSONを検証

3. **Node.jsインストール確認**
   ```bash
   node --version
   ```

   未インストールの場合: https://nodejs.org/

### API Key エラー

1. **API Key形式確認**
   - 正しい形式: `ml_...` または `sk_live_...`
   - https://memory-layer.emotiai.ai/settings/api-keys で確認

2. **API接続テスト**
   ```bash
   curl -H "Authorization: Bearer YOUR_API_KEY" \
     https://memory-layer-back-production.up.railway.app/health
   ```

### Claude アプリのログ確認

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

## 🎯 高度な使い方

### カスタムメタデータ追加

```
この会話を以下のメタデータでMemory Layerに保存:
- プロジェクト: "WebApp開発"
- 優先度: "高"
- カテゴリ: "バグ修正"
```

### 自動タグ付け

設定ファイルでデフォルトタグを設定:

```json
{
  "mcpServers": {
    "memory-layer": {
      "command": "node",
      "args": ["..."],
      "env": {
        "MEMORY_LAYER_API_KEY": "...",
        "DEFAULT_TAGS": "Claude Desktop,日常会話"
      }
    }
  }
}
```

## 📊 使用例

### 開発者向け
- コードレビュー会話の保存
- バグ調査の記録
- アーキテクチャ議論の保存

### ビジネス向け
- ブレインストーミングセッション
- プロジェクト計画の記録
- 意思決定の履歴

### 個人向け
- 学習ノートの保存
- AI彼氏・彼女との会話記録
- アイデアメモの整理

## 🔐 プライバシー

- 🔒 すべての会話は暗号化されて保存
- 👤 あなた以外アクセス不可
- 🗑️ いつでも削除可能
- 🚫 第三者と共有されません

## 📞 サポート

問題が発生した場合:
1. このREADMEのトラブルシューティングを確認
2. https://memory-layer.emotiai.ai/support に問い合わせ
3. GitHub Issues: https://github.com/your-repo/memory-layer-mcp/issues

## 📝 ライセンス

MIT License
