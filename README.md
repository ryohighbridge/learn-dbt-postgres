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

```sql
-- スキーマの確認
\dn
-- 現在のスキーマ
SELECT current_schema();
-- スキーマの作成
CREATE SCHEMA sample_schema;
-- スキーマを変更
SET search_path = sample_schema;
```
