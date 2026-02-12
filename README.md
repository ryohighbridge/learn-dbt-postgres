# learn-dbt-postgres

## セットアップ

### 1. 環境変数の設定

```sh
# 環境変数ファイルの作成
$ cp .envrc.sample .envrc
# .envrcを編集して必要な環境変数を設定
# - DB_USER, DB_PASSWORD, DB_NAME
# - DB_SCHEMA (例: dev)

# 環境変数の読み込み
# direnv を使う場合（推奨）
$ direnv allow
# direnv を使わない場合
$ source .envrc
```

### 2. Dockerコンテナの起動

```sh
# PostgreSQLコンテナの起動
$ docker compose up -d
# コンテナの状態確認
$ docker compose ps
```

### 3. Python環境のセットアップ

```sh
# 仮想環境の作成
$ python -m venv .venv
# 仮想環境の有効化
$ source .venv/bin/activate

# パッケージのインストール
$ python -m pip install --upgrade pip
$ python -m pip install -r requirements.txt

# 仮想環境の無効化（必要に応じて）
$ deactivate
```

### 4. dbt接続確認

```sh
# dbtとPostgreSQLの接続確認
$ dbt debug
```

### 5. dbt実行とスキーマ作成

```sh
# 段階的に実行（スキーマは自動的に作成されます）
$ dbt seed   # seedsデータの投入
$ dbt run    # モデルの実行（スキーマが自動作成される）
$ dbt test   # テストの実行
```

**注意**: dbt実行時に、`profiles.yml`と`dbt_project.yml`の設定に基づいて、`dev_raw`、`dev_staging`、`dev_marts`などのスキーマが自動的に作成されます。手動でスキーマを作成する必要はありません。

## データベース管理

### PostgreSQLへの直接接続

```sh
# dbコンテナに接続
$ docker compose exec db psql -U $DB_USER -d $DB_NAME
```

### スキーマの確認

```sql
-- スキーマの一覧
\dn
-- 現在のスキーマ
SELECT current_schema();
-- スキーマを変更
SET search_path TO dev_marts;
```

### メンテナンスコマンド

```sql
-- PostgreSQLバージョンアップ後やOSのロケール設定変更後に実行
-- 照合順序の警告が出た場合の対応
REINDEX DATABASE sample_db;
ALTER DATABASE sample_db REFRESH COLLATION VERSION;
```

## パッケージ管理

```sh
# パッケージ一覧の更新
$ python -m pip freeze > requirements.txt
```

## SQLリンター

```sh
# Lint
$ sqlfluff lint
# Fix
$ sqlfluff fix
```

## DBのスキーマ構成

dbtの3層アーキテクチャに基づいたスキーマ構成を採用しています。
`$DB_SCHEMA`環境変数（例: `dev`）をprefixとして、環境ごとに以下のスキーマが作成されます。

### スキーマ一覧

| スキーマ名 | 用途 | dbt管理 | 説明 |
|-----------|------|---------|------|
| `dev_raw` | ソースデータ | ❌ | 外部から投入される生データ（seeds、外部ETLなど） |
| `dev_staging` | ステージングレイヤー | ✅ | rawデータのクレンジング・型変換・リネーム |
| `dev_marts` | マートレイヤー | ✅ | ビジネスロジックを含む分析用テーブル（fct_*, dim_*） |

### レイヤーの役割

- **raw**: dbtで変換せず、外部システムやseedsから投入されるデータを格納
- **staging**: `stg_<source>__<table>`形式で命名し、1対1でrawデータを整形
- **marts**: ビジネス要件に基づいた分析モデル
  - `fct_*`: ファクトテーブル（トランザクション、イベント）
  - `dim_*`: ディメンションテーブル（マスタ、属性）

### 環境ごとの切り替え

```sh
# 開発環境
export DB_SCHEMA=dev

# 本番環境（将来的に）
export DB_SCHEMA=prod
```
