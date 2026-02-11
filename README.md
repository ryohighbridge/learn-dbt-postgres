# learn-dbt-postgres

## セットアップ

```sh
# 環境変数ファイルの作成
$ cp .envrc.sample .envrc
# 仮想環境の作成
$ python -m venv .venv
# 仮想環境の有効化
$ source .venv/bin/activate
# 仮想環境の無効化
$ deactivate

# パッケージのインストール
$ python -m pip install --upgrade pip
$ python -m pip install -r requirements.txt

# パッケージの管理
$ python -m pip freeze > requirements.txt
```

```sh
# dbコンテナ接続
$ docker compose exec db psql -U $DB_USER -d $DB_NAME
```

```sql
-- PostgreSQLバージョンアップ後やOSのロケール設定変更後に実行
-- 照合順序の警告が出た場合の対応
REINDEX DATABASE sample_db;
ALTER DATABASE sample_db REFRESH COLLATION VERSION;
```

```sql
-- スキーマの確認
\dn
-- 現在のスキーマ
SELECT current_schema();
-- スキーマを変更
SET search_path TO dev_raw;
```

```sh
# dbt接続確認
$ dbt debug
# dbt実行
$ dbt build
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
