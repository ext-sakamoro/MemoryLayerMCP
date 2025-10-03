# 🚀 Memory Layer MCP - クイックスタート

Claude デスクトップアプリで会話を自動保存！

**[English version is here](QUICK_START.md)**

## 📦 インストール（3分で完了）

### Windows

1. **PowerShell を管理者権限で開く**
2. 以下を実行:
```powershell
git clone https://github.com/ext-sakamoro/MemoryLayerMCP.git
cd MemoryLayerMCP
.\install-windows.ps1
```

### macOS

1. **ターミナルを開く**
2. 以下を実行:
```bash
git clone https://github.com/ext-sakamoro/MemoryLayerMCP.git
cd MemoryLayerMCP
chmod +x install-macos.sh
./install-macos.sh
```

### Linux

1. **ターミナルを開く**
2. 以下を実行:
```bash
git clone https://github.com/ext-sakamoro/MemoryLayerMCP.git
cd MemoryLayerMCP
chmod +x install-linux.sh
./install-linux.sh
```

## 🔑 API Key 取得（1分）

1. https://memory-layer.emotiai.ai を開く
2. アカウント作成/ログイン
3. **Settings** → **API Keys**
4. **Generate New API Key** をクリック
5. キーをコピーしてインストーラーに貼り付け

## ✨ 使い方（超簡単！）

### 会話を保存

Claude アプリで会話中に:

```
この会話を Memory Layer に保存して
```

これだけ！

### 詳細オプション

**タイトル指定**:
```
「React の学習」というタイトルでこの会話を Memory Layer に保存
```

**タグ付け**:
```
「プログラミング」「React」というタグでこの会話を Memory Layer に保存
```

**過去の会話検索**:
```
Memory Layer から「React」に関する会話を検索
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
- ✅ AI 彼氏・彼女との会話
- ✅ アイデアメモ

## 🔧 トラブルシューティング

### MCP が認識されない

1. **Claude アプリを完全再起動**
2. **設定ファイル確認**:
   - Windows: `%APPDATA%\Claude\claude_desktop_config.json`
   - macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
   - Linux: `~/.config/Claude/claude_desktop_config.json`

### API Key エラー

1. API Key が正しいか確認
2. https://memory-layer.emotiai.ai でログイン状態確認

### Node.js エラー

```bash
node --version
npm --version
```

なければ https://nodejs.org/ からインストール

## 📞 サポート

- 📖 詳細マニュアル: `CLAUDE_APP_SETUP.ja.md`
- 💬 サポート: https://memory-layer.emotiai.ai/support
- 🐛 バグ報告: GitHub Issues

## 🔐 プライバシー

- 🔒 会話は暗号化保存
- 👤 本人のみアクセス可
- 🗑️ いつでも削除可能

---

**準備完了？Claude アプリを開いて試してみましょう！** 🚀
