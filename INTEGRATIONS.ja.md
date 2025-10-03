# Memory Layer - AI ツール連携ガイド

様々な AI 開発ツールやアシスタントと Memory Layer を連携するための完全ガイド。

**[English version is here](INTEGRATIONS.md)**

## 🎯 概要

Memory Layer は、複数のプラットフォーム間で AI 会話を保存・取得するための汎用 API を提供します。Claude Desktop、ChatGPT、Cursor、その他の AI ツールのどれを使用していても、知識を一元管理できます。

## 🛠️ 対応ツール

### ✅ 完全統合サポート

| ツール | 連携タイプ | ガイド |
|------|------------|--------|
| **Claude Desktop** | MCP サーバー | [CLAUDE_APP_SETUP.ja.md](CLAUDE_APP_SETUP.ja.md) |
| **ChatGPT** | Custom Instructions / GPT Actions | [CHATGPT_SETUP.ja.md](CHATGPT_SETUP.ja.md) |
| **Gemini CLI** | Python/Shell スクリプト | [GEMINI_CLI_SETUP.ja.md](GEMINI_CLI_SETUP.ja.md) |
| **Cursor** | .cursorrules / Python 拡張 | [CURSOR_SETUP.ja.md](CURSOR_SETUP.ja.md) |
| **Windsurf** | AI 設定 / スクリプト | [AI_TOOLS_SETUP.ja.md](AI_TOOLS_SETUP.ja.md#-windsurf-ide) |
| **Devin** | タスク設定 / API | [AI_TOOLS_SETUP.ja.md](AI_TOOLS_SETUP.ja.md#-devin-ai-agent) |

### 🔄 API 互換ツール

HTTP リクエストが可能なツールなら Memory Layer と連携できます:

- Aider
- GitHub Copilot Chat
- Cody (Sourcegraph)
- Continue.dev
- カスタムスクリプトと自動化

## 🚀 ツール別クイックスタート

### Claude Desktop（Claude ユーザーに推奨）

**最適**: Claude アプリとネイティブ MCP サポートでの直接連携

```bash
git clone https://github.com/ext-sakamoro/MemoryLayerMCP.git
cd MemoryLayerMCP
./install-linux.sh  # または install-macos.sh / install-windows.ps1
```

Claude で: `「この会話を Memory Layer に保存して」`

**→ [完全ガイド](CLAUDE_APP_SETUP.ja.md)**

---

### ChatGPT

**最適**: ChatGPT Plus/Team ユーザー、GPT ビルダー

**セットアップ**: Custom Instructions に追加

```
「保存」と言われたら、Memory Layer に保存:
POST https://back.memory-layer.emotiai.ai/v1/memories
Authorization: Bearer YOUR_API_KEY
```

**→ [完全ガイド](CHATGPT_SETUP.ja.md)**

---

### Gemini CLI

**最適**: コマンドラインユーザー、自動化ワークフロー

```bash
# 保存ヘルパースクリプト
python3 memory_layer_save.py "セッションタイトル" conversation.txt

# シェルヘルパー使用
source gemini-save.sh
gemini_with_save "トピック" "プロンプト"
```

**→ [完全ガイド](GEMINI_CLI_SETUP.ja.md)**

---

### Cursor / Windsurf

**最適**: コード中心の AI 会話

**セットアップ**: `.cursorrules` に追加:

```markdown
コーディングセッション完了時、Memory Layer API に保存
含める内容: 変更ファイル、コードスニペット、議論の要約
```

**→ [Cursor ガイド](CURSOR_SETUP.ja.md)** | **[Windsurf ガイド](AI_TOOLS_SETUP.ja.md)**

---

### Devin

**最適**: 自律エージェントタスク追跡

**セットアップ**: `.devin/config.yml` でタスクの自動保存を設定

**→ [完全ガイド](AI_TOOLS_SETUP.ja.md#-devin-ai-agent)**

---

## 📊 機能比較

| 機能 | Claude MCP | ChatGPT | Gemini CLI | Cursor | その他 |
|------|-----------|---------|------------|--------|--------|
| 会話の自動保存 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 過去の会話検索 | ✅ | ✅ | ✅ | ✅ | ✅ |
| コードスニペット対応 | ✅ | ✅ | ✅ | ✅ | ✅ |
| カスタムメタデータ | ✅ | ✅ | ✅ | ✅ | ✅ |
| タグ管理 | ✅ | ✅ | ✅ | ✅ | ✅ |
| ネイティブ統合 | ✅ MCP | ⚠️ 手動 | ⚠️ スクリプト | ⚠️ 設定 | ⚠️ API |
| インストール複雑度 | 簡単 | 中 | 中 | 簡単 | 様々 |

**凡例**: ✅ 完全サポート | ⚠️ 設定が必要

---

## 🔑 はじめに

### 1. API キーを取得

1. https://memory-layer.emotiai.ai にアクセス
2. サインアップ / ログイン
3. Settings → API Keys に移動
4. 新しい API キーを生成
5. キーをコピー（形式: `ml_...`）

### 2. ツールを選択

最も使用するツールを選択:

- **主要 AI アシスタント**: Claude、ChatGPT、または Gemini
- **コードエディタ**: Cursor、Windsurf、VS Code
- **自動化**: スクリプト、CLI ツール

### 3. 連携ガイドに従う

各ツール専用のセットアップガイド（上記リンク参照）

### 4. 保存開始

すべてのツールで AI 会話を保存し始めましょう！

---

## 💡 ユースケース

### 開発者向け

```
🔧 コードレビュー → コードスニペット付きの技術議論を保存
🐛 バグ修正 → 問題解決アプローチを文書化
🏗️ アーキテクチャ → 設計決定と理由を保存
📚 学習 → チュートリアルと説明を保存
```

### チーム向け

```
👥 知識共有 → AI インタラクションの中央リポジトリ
📋 オンボーディング → 新メンバーが過去の議論を検索可能
🎯 ベストプラクティス → 実証済みソリューションを捕捉・参照
📊 プロジェクトメモリ → プロジェクト決定の進化を追跡
```

### 個人利用向け

```
💭 学習ジャーナル → 教育的会話を保存
🤔 問題解決 → 過去のソリューションを参照
💡 アイデア → クリエイティブなブレインストーミングセッションを保存
🎨 創作活動 → AI 支援のライティング/デザインセッションを保存
```

---

## 🔐 セキュリティとプライバシー

### ベストプラクティス

1. **API キー管理**
   - 環境変数に保存
   - バージョン管理にコミットしない
   - 定期的にローテーション
   - ツール/プロジェクト毎に別のキーを使用

2. **機密データ**
   - 認証情報を含む会話は保存しない
   - 本番コードは保存前にレビュー
   - タグで機密レベルをマーク
   - 必要時に削除を有効化

3. **アクセス制御**
   - 自分だけがメモリにアクセス可能
   - 保存時にエンドツーエンド暗号化
   - Bearer トークンで API を保護
   - オプション: チームワークスペース（近日公開）

---

## 📈 高度な使用方法

### ツール横断ワークフロー

**例**: ChatGPT でリサーチ → Cursor でコーディング → Claude でレビュー

1. **ChatGPT**: ベストプラクティスをリサーチ、Memory Layer に保存
2. **Cursor**: コード実装、保存したリサーチを参照、セッションを保存
3. **Claude**: コードレビュー、両方の過去セッションを検索、最終レビューを保存

すべての会話が一箇所で検索可能！

### 自動化

```python
# 毎日すべての AI 会話を自動保存
import schedule
from memory_layer_api import save_conversation

def daily_backup():
    # 複数ソースから会話を収集
    # タイムスタンプ付きで Memory Layer に保存
    pass

schedule.every().day.at("23:00").do(daily_backup)
```

### チーム知識ベース

- チーム全体でタグを標準化
- プロジェクトベースのメタデータを使用
- 定期的な知識監査
- Memory Layer ベストプラクティスを共有

---

## 🆘 トラブルシューティング

### よくある問題

**API キーエラー**
```
❌ 401 Unauthorized
→ API キーが正しいか確認
→ キーが期限切れでないか検証
→ Authorization ヘッダーに Bearer プレフィックスがあるか確認
```

**接続エラー**
```
❌ Connection timeout
→ インターネット接続を確認
→ API URL を検証: https://back.memory-layer.emotiai.ai
→ ping/curl テストを試す
```

**保存失敗**
```
❌ 400 Bad Request
→ リクエストボディ形式を検証
→ 必須フィールドを確認: name, content
→ JSON 構文を検証
```

### ヘルプ

- 📖 API ドキュメント: https://back.memory-layer.emotiai.ai/docs
- 💬 サポート: https://memory-layer.emotiai.ai/support
- 🐛 GitHub Issues: https://github.com/ext-sakamoro/MemoryLayerMCP/issues

---

## 🎉 Memory Layer を最大限活用

### 成功のためのヒント

1. **一貫した命名**: 明確で検索可能なタイトルを使用
2. **豊富なタグ付け**: プロジェクト、言語、トピック、日付でタグ付け
3. **定期的レビュー**: 保存した会話を月次で監査
4. **チーム標準**: 共有規則を開発
5. **検索練習**: 素早い取得のため検索構文をマスター

### ワークフロー例

```
朝: ダッシュボードで昨日の保存をレビュー
作業中: 重要な会話を随時保存
終業時: 新しい保存にタグ付けと整理
週次: パターンと洞察を検索
月次: 古い会話をアーカイブまたは削除
```

---

## 🚀 次のステップ

1. ✅ 主要 AI ツールの統合をセットアップ
2. ✅ 最初の会話を保存
3. ✅ 保存した会話の検索を試す
4. ✅ 必要に応じて副次的ツールを追加
5. ✅ 個人的なワークフローを開発

**AI 知識ベースを構築する準備はできましたか？** 上記のツールを選択して始めましょう！ 🎯

---

## 📞 追加リソース

- **メインリポジトリ**: https://github.com/ext-sakamoro/MemoryLayerMCP
- **Memory Layer ウェブサイト**: https://memory-layer.emotiai.ai
- **API プレイグラウンド**: https://back.memory-layer.emotiai.ai/docs
- **コミュニティ**: GitHub Discussions で議論に参加
