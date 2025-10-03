# ChatGPT と Memory Layer の連携

ChatGPT の会話を自動的に Memory Layer API に保存します。

**[English version is here](CHATGPT_SETUP.md)**

## 🚀 セットアップ方法

### 方法 1: Custom Instructions（推奨）

1. ChatGPT の設定 → Custom Instructions を開く
2. **"How would you like ChatGPT to respond?"** に以下を追加:

```
「この会話を保存」と言われたとき、または重要な議論の終わりに、Memory Layer API を使って会話を自動保存してください:

API エンドポイント: https://back.memory-layer.emotiai.ai/v1/memories
メソッド: POST
ヘッダー:
  Authorization: Bearer YOUR_API_KEY_HERE
  Content-Type: application/json

リクエストボディの形式:
{
  "name": "[会話のトピックからタイトルを自動生成]",
  "type": "support",
  "content": "[マークダウン形式の会話全文、ユーザー/アシスタントのラベル付き]",
  "metadata": {
    "source": "ChatGPT",
    "ai_model": "GPT-4",
    "date": "[現在の日付]",
    "tags": ["ChatGPT", "AI アシスタント"]
  }
}

保存後は「✅ 会話を Memory Layer に保存しました！」と確認してください。
```

3. `YOUR_API_KEY_HERE` を https://memory-layer.emotiai.ai で取得した実際の API キーに置き換える

### 方法 2: GPT Action（GPT Builder 用）

1. 新しい GPT を作成、または既存の GPT を編集
2. "Configure" → "Actions" に移動
3. 以下のスキーマで新しいアクションを追加:

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
      summary: Memory Layer に会話を保存
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                name:
                  type: string
                  description: 会話のタイトル
                type:
                  type: string
                  enum: [support, development, learning, personal]
                content:
                  type: string
                  description: 会話の全内容
                metadata:
                  type: object
                  description: 追加のメタデータ
      responses:
        '201':
          description: メモリが正常に作成されました
```

4. 認証設定:
   - Type: API Key
   - Header: `Authorization`
   - Value: `Bearer YOUR_API_KEY_HERE`

## 💬 使用例

### 基本的な保存
```
ユーザー: この会話を Memory Layer に保存して
ChatGPT: [会話を自動的に整形して保存]
✅ 会話を Memory Layer に保存しました！
```

### カスタムタイトルで保存
```
ユーザー: 「Python 学習セッション」というタイトルでこの会話を保存
ChatGPT: [指定されたタイトルで保存]
✅ 会話「Python 学習セッション」を Memory Layer に保存しました！
```

### タグ付きで保存
```
ユーザー: 「プログラミング」「Python」「チュートリアル」というタグでこの会話を保存
ChatGPT: [指定されたタグで保存]
✅ タグ「プログラミング, Python, チュートリアル」で会話を保存しました
```

## 🔍 保存した会話を検索

保存した会話を検索するには、Memory Layer のウェブインターフェースを使用:
https://memory-layer.emotiai.ai/dashboard

または、ChatGPT に API のクエリを依頼:

```
ユーザー: Memory Layer で「Python」に関する会話を検索して
ChatGPT: [API にクエリして結果を表示]
```

検索機能を有効にするには、Custom Instructions に以下を追加:

```
Memory Layer を検索するよう依頼されたら、この API を使用してください:

GET https://back.memory-layer.emotiai.ai/v1/memories?search=[クエリ]
ヘッダー:
  Authorization: Bearer YOUR_API_KEY_HERE

結果をタイトル、日付、関連度を含む整形されたリストで表示してください。
```

## 🎯 高度な設定

### 重要な会話の自動保存

Custom Instructions に追加:

```
重要な会話（問題解決、学習、クリエイティブな作業など）を自動検出し、
自然な区切りのタイミングで Memory Layer への保存を提案してください。
```

### カスタムメタデータ

```
Memory Layer に保存する際、以下のメタデータフィールドを含めてください:
- conversation_type: [technical/creative/personal/business]
- main_topic: [会話から抽出]
- key_insights: [主要なポイントのリスト]
- action_items: [言及された TODO]
```

## 🔑 API キーの取得

1. https://memory-layer.emotiai.ai にアクセス
2. サインアップまたはログイン
3. Settings → API Keys に移動
4. 新しい API キーを生成
5. 上記の設定にコピーして使用

## 📊 API 機能

ChatGPT 連携で利用可能:

- ✅ 会話の保存
- ✅ キーワード検索
- ✅ タグでフィルタリング
- ✅ AI powered セマンティック検索
- ✅ ID による特定の会話の取得
- ✅ 既存のメモリの更新
- ✅ 会話の削除

## 🔐 プライバシーとセキュリティ

- すべての会話は暗号化されます
- 保存した会話にアクセスできるのはあなただけです
- API キーはいつでも無効化できます
- 第三者とのデータ共有はありません

## 📞 サポート

問題や質問がある場合:
- https://memory-layer.emotiai.ai/support にアクセス
- API ドキュメント: https://back.memory-layer.emotiai.ai/docs

## 💡 ヒント

1. **明確なタイトルを使用**: ChatGPT が説明的なタイトルを生成できるようにする
2. **一貫したタグ付け**: 会話全体で同じタグを使用して整理を改善
3. **定期的にレビュー**: ダッシュボードで保存した会話を確認
4. **重要なデータのバックアップ**: 定期的に会話をエクスポート

---

**ChatGPT の会話を保存する準備はできましたか？** 上記のセットアップに従って、AI とのやり取りを保存しましょう！ 🚀
