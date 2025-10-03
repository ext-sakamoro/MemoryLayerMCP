# 🚀 Memory Layer MCP - クイックスタート

Claudeデスクトップアプリで会話を自動保存！

## 📦 インストール（3分で完了）

### Windows

1. **PowerShellを管理者権限で開く**
2. 以下を実行:
```powershell
cd path\to\memory-layer-mcp
.\install-windows.ps1
```

### macOS

1. **ターミナルを開く**
2. 以下を実行:
```bash
cd path/to/memory-layer-mcp
chmod +x install-macos.sh
./install-macos.sh
```

### Linux

1. **ターミナルを開く**
2. 以下を実行:
```bash
cd path/to/memory-layer-mcp
chmod +x install-linux.sh
./install-linux.sh
```

## 🔑 API Key取得（1分）

1. https://memory-layer.emotiai.ai を開く
2. アカウント作成/ログイン
3. **Settings** → **API Keys**
4. **Generate New API Key** をクリック
5. キーをコピーしてインストーラーに貼り付け

## ✨ 使い方（超簡単！）

### 会話を保存

Claudeアプリで会話中に:

```
この会話をMemory Layerに保存して
```

これだけ！

### 詳細オプション

**タイトル指定**:
```
「Reactの学習」というタイトルでこの会話を保存
```

**タグ付け**:
```
「プログラミング」「React」というタグでこの会話を保存
```

**過去の会話検索**:
```
Memory Layerから「React」に関する会話を検索
```

## 🎯 こんな使い方ができます

### 開発者
- ✅ コードレビュー記録
- ✅ バグ調査履歴
- ✅ アーキテクチャ議論

### ビジネス
- ✅ ブレスト記録
- ✅ プロジェクト計画
- ✅ 意思決定履歴

### 個人
- ✅ 学習ノート
- ✅ AI彼氏・彼女との会話
- ✅ アイデアメモ

## 🔧 トラブルシューティング

### MCPが認識されない

1. **Claudeアプリを完全再起動**
2. **設定ファイル確認**:
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Linux: `~/.config/Claude/claude_desktop_config.json`

### API Keyエラー

1. API Keyが正しいか確認
2. https://memory-layer.emotiai.ai でログイン状態確認

### Node.jsエラー

```bash
node --version
npm --version
```

なければ https://nodejs.org/ からインストール

## 📞 サポート

- 📖 詳細マニュアル: `CLAUDE_APP_SETUP.md`
- 💬 サポート: https://memory-layer.emotiai.ai/support
- 🐛 バグ報告: GitHub Issues

## 🔐 プライバシー

- 🔒 会話は暗号化保存
- 👤 本人のみアクセス可
- 🗑️ いつでも削除可能

---

**準備完了？Claudeアプリを開いて試してみましょう！** 🚀
