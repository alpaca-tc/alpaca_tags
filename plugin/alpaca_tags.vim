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

" 初期化
if !exists('g:alpaca_update_tags_config')
  let g:alpaca_update_tags_config = {
        \ '_' : '-R --sort=yes',
        \ }
endif

let g:alpaca_tags_root_dir = expand("<sfile>:p:h:h")

command! -nargs=* -complete=customlist,alpaca_tags#complete_source
      \ AlpacaTagsUpdate call alpaca_tags#update_tags(<q-args>)
command! -nargs=* -complete=customlist,alpaca_tags#complete_source
      \ AlpacaTagsBundle call alpaca_tags#update_bundle_tags(<q-args>)
command! -nargs=0 AlpacaTagsSet call alpaca_tags#set_tags()
command! -nargs=0 AlpacaTagsCleanCache call unite#sources#tags#taglist#clean_cache()

let &cpo = s:save_cpo
unlet s:save_cpo
