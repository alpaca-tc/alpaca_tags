# alpaca_update_tags

## 概要

*ctagsの生成を便利にしよう！*

- vimprocを使って、非同期でtagsの生成
- Ruby/Bundlerに対応して、必要最低限のtagsのみを非同期生成

![Demo](http://gifzo.net/tIDwHf2ZAp.gif)

## コマンド

### TagsSet

setl tagsの自動化
`:TagsSet`

### Tags, TagsUpdate(alias)

Git配下のディレクトリを対象にctagsを実行する

`:Tags -R --languages=-js`

*`g:alpaca_tags_config`で設定している場合は、オプションを省略可能*

`:Tags vim -ruby`

### TagsBundle

Git直下のGemfileを元にtagsを生成する。

`TagsBundle`

## 設定

```.vimrc:vim
" *g:alpaca_tags_config*

" 自身でオプションを作る
" '_'では、デフォルトする設定を記述する
let g:alpaca_tags_config = {
      \ '_' : '-R --sort=yes --languages=+Ruby --languages=-css,scss,html',
      \ 'js' : '--languages=+js',
      \ 'ruby': '--languages=+Ruby',
      \ }

" ctagsのパスを設定
" '/Applications/MacVim.app/Contents/MacOS/ctags'が存在する場合は自動設定
let g:alpaca_tags_ctags_bin = '/path/to/ctags'
```

## オススメの設定

```
" NeoBundle
NeoBundleLazy 'alpaca-tc/alpaca_tags', {
      \ 'rev' : 'development',
      \ 'depends': ['Shougo/vimproc', 'Shougo/unite.vim'],
      \ 'autoload' : {
      \   'commands' : ['Tags', 'TagsUpdate', 'TagsSet', 'TagsBundle', 'TagsCleanCache'],
      \   'unite_sources' : ['tags']
      \ }}

" ~/.ctagsにctagsの設定ファイルを設置します。現在無い人は、このディレクトリ内の.ctagsをコピーしてください。
" 適切なlanguageは`ctags --list-maps=all`で見つけてください。人によりますので。
let g:alpaca_tags_config = {
      \ '_' : '-R --sort=yes --languages=-js,html,css',
      \ 'ruby': '--languages=+Ruby',
      \ }

augroup AlpacaTags
  autocmd!
  if exists(':Tags')
    autocmd BufWritePost * TagsUpdate ruby
    autocmd BufWritePost Gemfile TagsBundle
    autocmd BufEnter * TagsSet
  endif
augroup END

nnoremap <expr>tt  ':Unite tags -horizontal -buffer-name=tags -input='.expand("<cword>").'<CR>'
```

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


