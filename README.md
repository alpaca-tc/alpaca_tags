# alpaca_update_tags

## Version2.0

AlpacaTagsが再実装されました

[alpaca_tags v2.0](https://github.com/alpaca-tc/alpaca_tags/tree/v2.0)

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

*`g:alpaca_update_tags_config`で設定している場合は、オプションを省略可能*

`:Tags vim -ruby`

### TagsBundle

Git直下のGemfileを元にtagsを生成する。

`TagsBundle`

## 設定

```.vimrc:vim
" *g:alpaca_update_tags_config*

" 自身でオプションを作る
" '_'では、デフォルトする設定を記述する
let g:alpaca_update_tags_config = {
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
let g:alpaca_update_tags_config = {
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

## TODO

- Gemfile以外のnpm, python ...etcのtags生成機能を追加
