# Gemini CLI と Memory Layer の連携

Gemini CLI の会話を自動的に Memory Layer API に保存します。

**[English version is here](GEMINI_CLI_SETUP.md)**

## 🚀 セットアップ

### 前提条件

- Python 3.8 以降
- Gemini CLI がインストール済み
- Memory Layer API キー

### インストール

1. https://memory-layer.emotiai.ai から Memory Layer API キーを取得
2. 下記のヘルパースクリプトを保存
3. Gemini CLI でそれを使用するよう設定

## 📝 Python ヘルパースクリプト

これを `memory_layer_save.py` として保存:

```python
#!/usr/bin/env python3
"""
Memory Layer Save Helper for Gemini CLI
Gemini の会話を Memory Layer API に保存
"""

import os
import sys
import json
import requests
from datetime import datetime

# 設定
MEMORY_LAYER_API = "https://back.memory-layer.emotiai.ai"
API_KEY = os.getenv("MEMORY_LAYER_API_KEY", "YOUR_API_KEY_HERE")

def save_conversation(title, content, tags=None, metadata=None):
    """会話を Memory Layer に保存"""

    url = f"{MEMORY_LAYER_API}/v1/memories"
    headers = {
        "Authorization": f"Bearer {API_KEY}",
        "Content-Type": "application/json"
    }

    # メタデータを準備
    meta = {
        "source": "Gemini CLI",
        "ai_model": "Gemini",
        "date": datetime.now().isoformat(),
        **(metadata or {})
    }

    # リクエストボディを準備
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
        print(f"✅ 会話を Memory Layer に保存しました！")
        print(f"   ID: {result.get('id')}")
        print(f"   タイトル: {title}")
        return result

    except requests.exceptions.RequestException as e:
        print(f"❌ Memory Layer への保存エラー: {e}", file=sys.stderr)
        return None

def read_from_file(filepath):
    """ファイルから会話を読み込む"""
    with open(filepath, 'r', encoding='utf-8') as f:
        return f.read()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("使用方法: python memory_layer_save.py <タイトル> <コンテンツファイル> [タグ...]")
        sys.exit(1)

    title = sys.argv[1]
    content_file = sys.argv[2]
    tags = sys.argv[3:] if len(sys.argv) > 3 else ["Gemini", "CLI"]

    content = read_from_file(content_file)
    save_conversation(title, content, tags)
```

実行可能にする:
```bash
chmod +x memory_layer_save.py
```

## 🔧 シェルヘルパースクリプト

これを `gemini-save.sh` として保存:

```bash
#!/bin/bash
# Gemini CLI - Memory Layer 保存ヘルパー

# 設定
export MEMORY_LAYER_API_KEY="YOUR_API_KEY_HERE"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 会話用の一時ファイル
TEMP_FILE="/tmp/gemini_conversation_$(date +%s).txt"

# 会話を保存する関数
save_to_memory_layer() {
    local title="$1"
    local content_file="$2"
    shift 2
    local tags=("$@")

    echo "Memory Layer に保存中..."
    python3 "$SCRIPT_DIR/memory_layer_save.py" "$title" "$content_file" "${tags[@]}"
}

# Gemini の出力をキャプチャ
gemini_with_save() {
    local title="${1:-Gemini 会話 $(date +%Y-%m-%d)}"
    shift

    # Gemini を実行して出力をキャプチャ
    gemini "$@" | tee "$TEMP_FILE"

    # ユーザーに保存するか確認
    echo ""
    read -p "この会話を Memory Layer に保存しますか？ (y/n): " choice
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        read -p "タイトル [${title}]: " custom_title
        title="${custom_title:-$title}"

        read -p "タグ (スペース区切り) [Gemini CLI]: " custom_tags
        tags=(${custom_tags:-Gemini CLI})

        save_to_memory_layer "$title" "$TEMP_FILE" "${tags[@]}"
    fi

    # クリーンアップ
    rm -f "$TEMP_FILE"
}

# 関数をエクスポート
export -f gemini_with_save

# 使用方法の情報
if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "使用方法: source gemini-save.sh"
    echo "その後: gemini_with_save [タイトル] [gemini の引数...]"
    echo ""
    echo "例:"
    echo "  gemini_with_save 'Python 学習' 'Python デコレータについて説明して'"
    exit 0
fi

echo "Gemini-Memory Layer 連携を読み込みました！"
echo "使用方法: gemini_with_save [タイトル] [プロンプト]"
```

実行可能にする:
```bash
chmod +x gemini-save.sh
```

## 💬 使用例

### Python スクリプトを直接使用

```bash
# ファイルから会話を保存
python3 memory_layer_save.py "Gemini AI ディスカッション" conversation.txt

# カスタムタグ付き
python3 memory_layer_save.py "Python チュートリアル" tutorial.txt プログラミング Python 学習
```

### シェルヘルパーを使用

```bash
# ヘルパーを読み込む
source gemini-save.sh

# 自動保存オプション付きで Gemini を使用
gemini_with_save "Python デコレータ" "例を含めて Python デコレータを説明して"

# スクリプトは応答後に保存するか尋ねます
```

### Gemini CLI 設定との統合

`.zshrc` または `.bashrc` に追加:

```bash
# Gemini 用 Memory Layer 連携
export MEMORY_LAYER_API_KEY="your_api_key_here"
source ~/path/to/gemini-save.sh

# クイックアクセス用のエイリアス
alias gsave='gemini_with_save'
```

使用方法:
```bash
gsave "Rust 学習" "Rust の所有権について説明して"
```

## 🔍 高度な使用方法

### すべての会話を自動保存

`~/.gemini/hooks/post-response.sh` を作成:

```bash
#!/bin/bash
# すべての Gemini 会話を自動保存

CONVERSATION_FILE="$1"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M")

python3 ~/memory_layer_save.py \
    "Gemini - $TIMESTAMP" \
    "$CONVERSATION_FILE" \
    "Gemini" "自動保存" "$(date +%Y-%m-%d)"
```

### 保存した会話を検索

`memory_layer_search.py` を作成:

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
    print(f"\n📚 {results.get('total', 0)} 件の会話が見つかりました:\n")

    for memory in results.get('data', []):
        print(f"📝 {memory['name']}")
        print(f"   ID: {memory['id']}")
        print(f"   日付: {memory['created_at']}")
        print(f"   タグ: {', '.join(memory.get('tags', []))}")
        print()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("使用方法: python memory_layer_search.py <クエリ>")
        sys.exit(1)

    search_memories(" ".join(sys.argv[1:]))
```

使用方法:
```bash
python3 memory_layer_search.py "Python デコレータ"
```

## 🔑 環境変数

シェル設定にこれらを設定:

```bash
# Memory Layer API キー
export MEMORY_LAYER_API_KEY="ml_your_api_key_here"

# オプション: カスタム API エンドポイント
export MEMORY_LAYER_API_URL="https://back.memory-layer.emotiai.ai"
```

## 📊 機能

- ✅ Gemini CLI の会話を保存
- ✅ カスタムタイトルとタグ
- ✅ 自動メタデータ（タイムスタンプ、ソース、AI モデル）
- ✅ インタラクティブな保存プロンプト
- ✅ 保存した会話を検索
- ✅ バッチ操作のサポート

## 🔐 セキュリティ

- API キーは環境変数に保存
- API キーをバージョン管理にコミットしない
- ローカル開発には `.env` ファイルを使用
- API キーを定期的にローテーション

## 📞 サポート

問題や質問がある場合:
- https://memory-layer.emotiai.ai/support にアクセス
- API ドキュメント: https://back.memory-layer.emotiai.ai/docs

---

**Gemini CLI の会話を保存する準備はできましたか？** 上記のスクリプトをセットアップして、AI とのやり取りを保存しましょう！ 🚀
