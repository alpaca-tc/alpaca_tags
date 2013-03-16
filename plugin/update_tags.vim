"=============================================================================
" FILE: update_tags.vim
" AUTHOR:  Hiroyuki Ishii <alprhcp666@gmail.com>
" Last Modified: 2013-03-17
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

if !exists('g:alpaca_update_tags_config')
  let g:alpaca_update_tags_config = {
        \ '_' : '-R --sort=yes',
        \ }
endif

if !exists('g:alpaca_update_tags_bin') && exists('g:neobundle#default_options')
  let g:alpaca_update_tags_bin =
        \ neobundle#get_neobundle_dir() . '/alpaca_update_tags/bin/create_tags_into_git'
else
  echohl Error | echomsg 'g:alpaca_update_tags_binを設定してください' | echohl None
endif

command! AlpacaUpdateTags call update_tags#update_tags()
command! AlpacaSetTags call update_tags#set_tags()
