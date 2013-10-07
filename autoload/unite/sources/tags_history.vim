"=============================================================================
" FILE: tags_history.vim
" AUTHOR: Ishii Hiroyuki <alprhcp666@gmail.com>
" Last Modified: 2013-07-21
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

" Define source 
let s:source = {
      \ 'name': 'tags/history',
      \ 'hooks': {},
      \ 'is_volatile': 1,
      \ 'syntax': 'uniteSource__Tag',
      \ 'max_candidates' : 100,
      \ 'default_action' : 'open_tag',
      \ 'is_multiline' : 1,
      \ 'converters': 'converter_relative_word'
      \ }

function! unite#sources#tags_history#define() "{{{
  return has('ruby') ? s:source : {}
endfunction"}}}

function! s:source.hooks.on_syntax(args, context) "{{{
  syntax region uniteSource__Conceal_Word 
        \ matchgroup=neosnippetExpandSnippets 
        \ start='\(pattern\|line\)' end=': ' 
        \ containedin=ALL concealends oneline
  syntax match uniteSource__Tag_Pattern /pattern:.\{-}\s*$/ms=s,me=e-1 containedin=uniteSource__Tag contained skipwhite
  syntax match uniteSource__Tag_File /@.\{-}\s*$/ms=s-1,me=e-1 containedin=uniteSource__Tag contains=uniteSource__TagDirectory skipwhite
  syntax match uniteSource__Tag_Directory /.*\// containedin=uniteSource__Tag_File contained
  syntax match uniteSource__Tag_Line /line:.\{-}\ze\s*$/ containedin=uniteSource__Tag contained

  highlight default link uniteSource__Tag_Directory Directory
  highlight default link uniteSource__Tag_Pattern Tag
  " highlight default link uniteSource__Tag_Line Constant
  highlight default link uniteSource__Tag_Line Tag
  highlight default link uniteSource__Tag_File Normal
endfunction"}}}

function! s:source.hooks.on_init(args, context) "{{{
  " call alpaca_tags#ruby#initialize()
  call alpaca_tags#variables#init()
endfunction"}}}

function! s:source.gather_candidates(args, context) "{{{
  return alpaca_tags#tags_history#get_history()
endfunction"}}}
