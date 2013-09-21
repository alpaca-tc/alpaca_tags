"=============================================================================
" FILE: update_tags.vim
" AUTHOR:  Hiroyuki Ishii <alprhcp666@gmail.com>
" Last Modified: 2013-05-30
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

if exists('g:loaded_update_tags') && g:loaded_update_tags
  finish
endif
let g:loaded_update_tags = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:alpaca_update_tags_config')
  let g:alpaca_update_tags_config = {
        \ '_' : '-R --sort=yes --languages=-js,css',
        \ }
endif

if !exists('g:alpaca_tags_print_to_console') 
  let g:alpaca_tags_print_to_console = {
        \ 'debug' : 0,
        \ 'setted tags' : 0,
        \ 'created/updated tags' : 1,
        \ }
endif

if !exists('g:alpaca_tags_ctags_bin')
  if executable('/Applications/MacVim.app/Contents/MacOS/ctags')
    let g:alpaca_tags_ctags_bin = '/Applications/MacVim.app/Contents/MacOS/ctags'
  elseif executable('ctags')
    let g:alpaca_tags_ctags_bin = 'ctags'
  else
    echomsg "[alpaca_tags] Error occurred: Please install ctags"
    finish
  endif
endif

let g:alpaca_tags_disable = get(g:, 'alpaca_tags_disable', 0)

let g:alpaca_tags_root_dir = expand("<sfile>:p:h:h")
command! -nargs=* -complete=customlist,alpaca_tags#create_tags#complete_source
      \ Tags call alpaca_tags#create_tags#update(<q-args>)
command! -nargs=* -complete=customlist,alpaca_tags#create_tags#complete_source
      \ TagsUpdate call alpaca_tags#create_tags#update(<q-args>)
command! -nargs=* -complete=customlist,alpaca_tags#create_tags#complete_source
      \ TagsBundle call alpaca_tags#create_tags#update_bundle(<q-args>)
command! -nargs=0 TagsSet call alpaca_tags#set()
command! -nargs=0 TagsCleanCache call alpaca_tags#clear_cache()
command! -nargs=0 TagsDisable let g:alpaca_tags_disable = 1
command! -nargs=0 TagsEnable let g:alpaca_tags_disable = 0

let &cpo = s:save_cpo
unlet s:save_cpo
