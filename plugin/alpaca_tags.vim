"=============================================================================
" FILE: alpaca_tags.vim
" AUTHOR: Ishii Hiroyuki <alpaca-tc@alpaca.tc>
" Last Modified: 2014-03-15
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

if exists('g:loaded_update_tags')
  finish
endif
let g:loaded_update_tags = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:alpaca_tags#config')
  let g:alpaca_update_tags#config = {
        \ '_' : '-R --sort=yes',
        \ }
endif

if !exists('g:alpaca_tags#console')
  let g:alpaca_tags#console = {
        \ 'report' : 1,
        \ }
endif

if !exists('g:alpaca_tags#ctags_bin')
  let s:macvim_ctags = '/Applications/MacVim.app/Contents/MacOS/ctags'
  if executable(s:macvim_ctags)
    let g:alpaca_tags#ctags_bin = s:macvim_ctags
  elseif executable('ctags')
    let g:alpaca_tags#ctags_bin = 'ctags'
  else
    echomsg '[alpaca_tags] Error occurred: Please install ctags'
    finish
  endif
endif

let g:alpaca_tags#cache_dir =
      \ get(g:, 'alpaca_tags#cache_dir', expand('~') . '/.alpaca_tags')
let g:alpaca_tags#disable = get(g:, 'alpaca_tags#disable', 0)
let g:alpaca_tags#single_task = get(g:, 'alpaca_tags#single_task', !exists('*vimproc#system'))

command! -nargs=* -complete=customlist,alpaca_tags#complete_source
      \ AlpacaTagsUpdate call alpaca_tags#tag_builder#build('Default', <q-args>)
command! -nargs=* -complete=customlist,alpaca_tags#complete_source
      \ AlpacaTagsBundle call alpaca_tags#tag_builder#build('Gemfile', <q-args>)
command! AlpacaTagsSet call alpaca_tags#tag_builder#set_tags()
command! AlpacaTagsCleanCache call alpaca_tags#cache#clean_cache()
command! AlpacaTagsDisable let g:alpaca_tags#disable = 1
command! AlpacaTagsEnable let g:alpaca_tags#disable = 0
command! AlpacaTagsEnable let g:alpaca_tags#disable = 0
command! AlpacaTagsKillProcess call alpaca_tags#process_manager#reset()
command! AlpacaTagsProcessStatus call alpaca_tags#process_manager#status()

let g:alpaca_tags#temp_path = g:alpaca_tags#cache_dir . '/tmp'
if !isdirectory(g:alpaca_tags#temp_path)
  call mkdir(g:alpaca_tags#temp_path, 'p')
endif

let &cpo = s:save_cpo
unlet s:save_cpo
