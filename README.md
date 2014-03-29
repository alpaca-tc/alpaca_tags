# alpaca_update_tags

## 概要

*ctagsの生成を便利にしよう！*

- vimprocを使って、非同期でtagsの生成
- Ruby/Bundlerに対応して、必要最低限のtagsのみを非同期生成

![Demo](http://gifzo.net/tIDwHf2ZAp.gif)

## Version2 変更点

### 1. 変数名の変更

- `g:alpaca_tags_config` -> `g:alpaca_tags#config`
- `g:alpaca_tags_ctags_bin` -> `g:alpaca_tags#ctags_bin`
- `g:alpaca_tags_cache_dir` -> `g:alpaca_tags#cache_dir`
- `g:alpaca_tags_disable` -> `g:alpaca_tags#disable`

### 2. コマンド名の変更

:Tagsは他のプラグインとコマンドが被るため、prefixを追加

- `Tags` -> `AlpacaTags`
- `TagsBundle` -> `AlpacaTagsBundle`
- `TagsUpdate` -> `AlpacaTagsUpdate`
- `TagsSet` -> `AlpacaTagsSet`
- `TagsCleanCache` -> `AlpacaTagsCleanCache`

### 3. Git以外に対応

実装を0から書き直しました

- `.git/working_dir.tags`を汚染する -> `g:alpaca_tags#cache_dir`以下に保存するようにした
- 今までは実行ファイルを非同期で呼び出していたが、全てVimScriptで行うようにした
- Gitに依存しなくなった。プロジェクト管理されていない場合は、そのファイルがあるディレクトリを起点に処理を行う
- Unite-tagsを削除。恐らく別のプラグインに切り出すか、Unite-tagを改良する方向で調整しています。
