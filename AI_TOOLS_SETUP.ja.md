# AI 開発ツールと Memory Layer の連携

Windsurf、Devin、その他の AI 開発ツールと Memory Layer API の連携ガイド。

**[English version is here](AI_TOOLS_SETUP.md)**

## 🌊 Windsurf IDE

### セットアップ

Windsurf は Cursor と同様の設定を使用します。プロジェクトの AI 設定に追加:

**`.windsurfrules` または AI Settings:**

```markdown
# Memory Layer 連携

重要なコーディングセッション完了時、または「このセッションを保存」と言われたら、Memory Layer に保存:

API: https://back.memory-layer.emotiai.ai/v1/memories
メソッド: POST
ヘッダー:
  Authorization: Bearer YOUR_API_KEY_HERE
  Content-Type: application/json

ボディ:
{
  "name": "[コンテキストからセッションタイトル]",
  "type": "development",
  "content": "[会話 + コードをマークダウンで]",
  "metadata": {
    "source": "Windsurf",
    "project": "[プロジェクト名]",
    "files": "[変更されたファイル]"
  },
  "tags": ["Windsurf", "Development", "[技術スタック]"]
}

「✅ セッションを Memory Layer に保存しました！」と確認。
```

### 使用方法

```
あなた: このリファクタリングセッションを Memory Layer に保存して
Windsurf: [自動保存] ✅ セッションを保存しました！

あなた: 「API 最適化の議論」を Memory Layer から検索して
Windsurf: [クエリして結果を表示]
```

### Python ヘルパー

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
    print(f"✅ 保存: {title}")
    return response.json()
```

---

## 🤖 Devin AI Agent

### セットアップ

Devin のタスクメモリを Memory Layer と連携するよう設定:

**Devin タスク設定:**

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

### API 連携スクリプト

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
        """完了した Devin タスクを Memory Layer に保存"""

        content = f"""# Devin タスク: {task_name}

## 説明
{description}

## 結果
{outcome}

## 変更されたファイル
{chr(10).join(f'- {f}' for f in files_modified)}
"""

        data = {
            "name": f"Devin タスク: {task_name}",
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
        """類似の過去タスクを検索"""

        headers = {"Authorization": f"Bearer {self.api_key}"}
        params = {"search": query, "tags": "Devin"}

        response = requests.get(
            f"{self.api_url}/v1/memories",
            headers=headers,
            params=params
        )
        response.raise_for_status()
        return response.json()

# Devin スクリプトでの使用
if __name__ == "__main__":
    memory = DevinMemoryLayer()

    # タスクを保存
    memory.save_task(
        task_name="ユーザー認証の実装",
        description="API に JWT ベースの認証を追加",
        outcome="テスト付きで正常に実装",
        files_modified=["auth.py", "middleware.py", "tests/test_auth.py"]
    )

    # 過去のタスクを検索
    similar = memory.search_similar_tasks("認証実装")
    print(f"{len(similar.get('data', []))} 件の類似タスクが見つかりました")
```

### 使用方法

Devin は自動的に:
- 完了したタスクを Memory Layer に保存
- 新しいタスク開始前に過去の解決策を参照
- 以前の実装から学習
- 時間をかけて組織的知識を構築

---

## 🔧 その他の AI ツール

### Aider

```python
# .aider.conf.yml
memory_layer:
  api_key: ${MEMORY_LAYER_API_KEY}
  auto_save: true

# フックスクリプト
post_edit_hook: |
  python3 save_to_memory_layer.py --title "Aider 編集セッション"
```

### GitHub Copilot Chat

Copilot Chat の指示に追加:

```
「保存」と言われたら、会話を Memory Layer API に保存:
https://back.memory-layer.emotiai.ai/v1/memories

Authorization ヘッダーに: Bearer [API_KEY] を使用
メタデータに source: "GitHub Copilot" を含める
```

### Cody (Sourcegraph)

```json
// .vscode/settings.json
{
  "cody.customCommands": {
    "Memory Layer に保存": {
      "prompt": "この会話を Memory Layer API に保存",
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
    "description": "会話を Memory Layer に保存",
    "prompt": "これを Memory Layer API に保存..."
  }]
}
```

---

## 🔑 環境変数

すべてのツールで設定:

```bash
export MEMORY_LAYER_API_KEY="ml_your_api_key_here"
```

または `.env` で:

```
MEMORY_LAYER_API_KEY=ml_your_api_key_here
MEMORY_LAYER_API_URL=https://back.memory-layer.emotiai.ai
```

---

## 📊 ツール横断の共通機能

すべての連携がサポート:

- ✅ **自動保存**: 重要なセッションを自動保存
- ✅ **検索**: 過去の会話とコードセッションをクエリ
- ✅ **メタデータ**: プロジェクト、ファイル、言語に関する豊富なコンテキスト
- ✅ **タグ付け**: ツール、プロジェクト、トピックで整理
- ✅ **取得**: 新しいタスクで過去の解決策を参照

---

## 💡 ベストプラクティス

1. **一貫した命名**: 明確で検索可能なタイトルを使用
2. **豊富なメタデータ**: ファイル名、言語、フレームワークを含める
3. **戦略的タグ付け**: チーム全体のタグ規則を開発
4. **定期的レビュー**: 保存されたセッションを月次で監査
5. **プライバシー**: 機密情報や認証情報を決して保存しない

---

## 📞 サポート

- ドキュメント: https://memory-layer.emotiai.ai/docs
- API リファレンス: https://back.memory-layer.emotiai.ai/docs
- サポート: https://memory-layer.emotiai.ai/support

---

**すべてのツールで AI 開発セッションを保存し始めましょう！** 🚀
