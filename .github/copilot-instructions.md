# GitHub Copilot Instructions

## 言語設定
- すべてのコード提案、PRレビュー、コメント、説明を**日本語**で行ってください
- コード内のコメントも日本語で記述してください

## dbt プロジェクトの基本方針

### モデル構造
- `models/` 配下にレイヤー別（staging, intermediate, marts）でディレクトリを分けて整理
- 1つのモデルファイルには1つのSELECT文のみ
- CTEを活用してクエリを読みやすく構造化

### 命名規則
- モデル名：スネークケース（例：`customer_orders.sql`）
- ステージングモデル：`stg_<source>__<table>` の形式
- 中間モデル：`int_<domain>__<description>` の形式
- マートモデル：`<domain>__<entity>` の形式
  - ファクトテーブル（トランザクション、イベント）：`<domain>__fct_<entity>` (例：`core__fct_orders`)
  - ディメンションテーブル（属性、マスタ）：`<domain>__dim_<entity>` (例：`core__dim_customers`)

### テストとドキュメント
- すべてのモデルに `schema.yml` でテストとドキュメントを記述
- 主キーには `unique` と `not_null` テストを必須とする
- 各カラムに分かりやすい説明を追加

### SQLスタイル
- `.sqlfluff` の設定に従う
- キーワード、関数、リテラルは小文字（select, from, where, count() など）
- インデントは4スペース
- CTEの命名は明確でわかりやすく

### マテリアライゼーション
- デフォルトは `view`
- 頻繁にクエリされる大きなテーブルは `table` または `incremental`
- `dbt_project.yml` で適切なマテリアライゼーション戦略を設定
