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
-- スキーマの作成
CREATE SCHEMA sample_schema;
-- スキーマを変更
SET search_path TO sample_schema;
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
