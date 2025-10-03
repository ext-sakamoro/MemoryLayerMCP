# Cursor IDE と Memory Layer の連携

Cursor AI の会話とコーディングセッションを自動的に Memory Layer API に保存します。

**[English version is here](CURSOR_SETUP.md)**

## 🚀 セットアップ

### 方法 1: `.cursorrules` 設定（推奨）

1. プロジェクトルートに `.cursorrules` を作成または編集
2. Memory Layer 連携ルールを追加:

```
# Cursor 用 Memory Layer 連携

## 重要な会話を自動保存

「この会話を保存」と言われたとき、または重要なコーディングセッション完了時に、Memory Layer API を使って自動保存してください:

**API 設定:**
- エンドポイント: https://back.memory-layer.emotiai.ai/v1/memories
- メソッド: POST
- ヘッダー:
  - Authorization: Bearer YOUR_API_KEY_HERE
  - Content-Type: application/json

**リクエスト形式:**
{
  "name": "[セッショントピックまたは作業中のファイルから自動生成]",
  "type": "development",
  "content": "[会話 + コードスニペットをマークダウン形式で]",
  "metadata": {
    "source": "Cursor",
    "project": "[現在のプロジェクト名]",
    "files": "[議論されたファイルのリスト]",
    "language": "[主要な言語]",
    "date": "[現在の日付]"
  },
  "tags": ["Cursor", "Development", "[言語]", "[フレームワーク]"]
}

**自動保存のタイミング:**
- 重要なコードレビューの完了時
- 複雑なバグの解決時
- アーキテクチャまたは設計の議論
- 新しいパターンやテクニックの学習
- リファクタリングセッション

保存後は「✅ セッションを Memory Layer に保存しました！」と確認してください。

## 過去のセッションを検索

「Memory Layer を検索」または「X についての以前の議論を思い出して」と言われたら、以下をクエリ:

GET https://back.memory-layer.emotiai.ai/v1/memories?search=[クエリ]&tags=Cursor,Development

結果を以下の形式で表示:
- タイトル
- 日付
- 関連ファイル
- 議論の要約
- 関連コードスニペット
```

3. `YOUR_API_KEY_HERE` を実際の API キーに置き換える

### 方法 2: グローバル Cursor 設定

1. Cursor 設定を開く（Cmd/Ctrl + ,）
2. "AI Rules" または "Custom Instructions" を検索
3. 上記の Memory Layer 連携ルールを追加

### 方法 3: Python 拡張スクリプト

プロジェクトに `cursor_memory_layer.py` を作成:

```python
#!/usr/bin/env python3
"""
Cursor - Memory Layer 連携
コーディングセッションを Memory Layer に保存
"""

import os
import json
import requests
from datetime import datetime
from pathlib import Path

API_KEY = os.getenv("MEMORY_LAYER_API_KEY", "YOUR_API_KEY_HERE")
API_URL = "https://back.memory-layer.emotiai.ai"

def get_project_info():
    """現在のプロジェクト情報を取得"""
    cwd = Path.cwd()
    return {
        "project": cwd.name,
        "path": str(cwd),
        "git_repo": (cwd / ".git").exists()
    }

def save_session(title, content, files=None, language=None, tags=None):
    """Cursor セッションを Memory Layer に保存"""

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
        print(f"✅ セッションを Memory Layer に保存しました！")
        print(f"   ID: {result.get('id')}")
        print(f"   タイトル: {title}")
        return result

    except requests.exceptions.RequestException as e:
        print(f"❌ エラー: {e}")
        return None

def search_sessions(query, limit=10):
    """保存されたセッションを検索"""

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
        print(f"\n📚 {results.get('total', 0)} 件のセッションが見つかりました:\n")

        for memory in results.get('data', []):
            print(f"📝 {memory['name']}")
            print(f"   プロジェクト: {memory.get('metadata', {}).get('project', 'N/A')}")
            print(f"   日付: {memory['created_at']}")
            print(f"   ファイル: {memory.get('metadata', {}).get('files', 'N/A')}")
            print()

        return results

    except requests.exceptions.RequestException as e:
        print(f"❌ エラー: {e}")
        return None

if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("使用方法:")
        print("  保存: python cursor_memory_layer.py save <タイトル> <コンテンツファイル>")
        print("  検索: python cursor_memory_layer.py search <クエリ>")
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

## 💬 使用例

### 現在のセッションを保存

Cursor で AI に伝える:

```
「認証モジュールのリファクタリング」というタイトルでこのコーディングセッションを Memory Layer に保存して
```

AI は以下を実行:
1. 会話とコードスニペットを収集
2. ファイル名と言語を抽出
3. 適切なメタデータと共に Memory Layer に保存
4. 成功メッセージで確認

### 過去のセッションを検索

```
「React フックの実装」についてのセッションを Memory Layer から検索して
```

### 特定のコードレビューを保存

```
このコードレビューを Memory Layer に保存:
- タイトル: "API エンドポイントのセキュリティレビュー"
- ファイル: auth.py, middleware.py
- タグ: セキュリティ, API, Python
```

## 🎯 高度な使用方法

### Git コミット時に自動保存

`.git/hooks/post-commit` を作成:

```bash
#!/bin/bash
# コミット詳細を Memory Layer に自動保存

COMMIT_MSG=$(git log -1 --pretty=%B)
CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r HEAD)

cat > /tmp/commit_session.txt <<EOF
# Git コミットセッション

## コミットメッセージ
$COMMIT_MSG

## 変更されたファイル
$CHANGED_FILES

## Diff
$(git show HEAD)
EOF

python3 cursor_memory_layer.py save \
    "コミット: $COMMIT_MSG" \
    /tmp/commit_session.txt
```

### ファイル保存時に保存

`.cursorrules` に追加:

```
重要なファイル保存時（50 行以上の変更）、Memory Layer へのセッション保存を提案:
- タイトル: "[ファイル名] - [変更の簡単な説明]"
- コンテンツ: 変更の要約 + 関連コードスニペット
- タグ: ファイルタイプと目的に基づく
```

### プロジェクト固有のルール

React プロジェクトの場合、`.cursorrules` に追加:

```
この React プロジェクトで Memory Layer に保存する際:
- 常にコンポーネント名をタグに含める
- 分類: Component, Hook, Utility, Style
- メタデータに関連コンポーネントファイルを含める
- タグ付け: React, TypeScript, [機能名]
```

## 🔑 環境設定

シェル設定または `.env` に追加:

```bash
# Memory Layer API キー
export MEMORY_LAYER_API_KEY="ml_your_api_key_here"
```

または VS Code 設定を使用:

```json
{
  "cursor.env": {
    "MEMORY_LAYER_API_KEY": "ml_your_api_key_here"
  }
}
```

## 📊 機能

- ✅ コーディングセッションの自動保存
- ✅ コードスニペットとファイルコンテキストを含む
- ✅ プロジェクト認識メタデータ
- ✅ 言語とフレームワークの検出
- ✅ 過去のセッション検索
- ✅ Git 連携
- ✅ カスタムタグシステム

## 🔐 セキュリティ

- API キーを環境変数に安全に保存
- API キーを git にコミットしない
- 機密ファイルには `.gitignore` を使用
- API キーを定期的にローテーション

## 💡 ヒント

1. **説明的なタイトル**: 検索しやすいよう明確なセッションタイトルを使用
2. **一貫したタグ付け**: チーム用のタグ戦略を開発
3. **定期的なレビュー**: 学習のため週次で保存セッションをレビュー
4. **コードスニペット**: ファイル全体ではなく関連するコードコンテキストを含める
5. **コミットへのリンク**: セッションコンテンツにコミット SHA を参照

## 📞 サポート

問題や質問がある場合:
- https://memory-layer.emotiai.ai/support にアクセス
- API ドキュメント: https://back.memory-layer.emotiai.ai/docs

---

**Cursor セッションを保存する準備はできましたか？** 上記の連携をセットアップして、コーディング知識ベースの構築を始めましょう！ 🚀
