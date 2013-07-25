"=============================================================================
" FILE: tags.vim
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

" Define source {{{
let s:source = {
      \ 'name': 'tags',
      \ 'hooks': {},
      \ 'is_volatile': 1,
      \ 'syntax': 'uniteSource__Tag',
      \ 'max_candidates' : 100,
      \ 'converters': 'converter_relative_word'
      \}

function! unite#sources#tags#define() "{{{
  return has('ruby') ? s:source : {}
endfunction"}}}

function! s:source.hooks.on_syntax(args, context) "{{{
  syntax match uniteSource__Tag_File /  @.\{-}  /ms=s+2,me=e-2 containedin=uniteSource__Tag contained nextgroup=uniteSource__Tag_Pat,uniteSource__Tag_Line skipwhite
  syntax match uniteSource__Tag_Line /line:.\{-}\ze\s*$/ contained
  syntax match uniteSource__Tag_Pat /pat:.\{-}\ze\s*$/ contained
  highlight default link uniteSource__Tag_File Type
  highlight default link uniteSource__Tag_Pat Special
  highlight default link uniteSource__Tag_Line Constant
endfunction"}}}

function! s:source.hooks.on_init(args, context) "{{{
  " call alpaca_tags#ruby#initialize()
  call alpaca_tags#variables#init()
endfunction"}}}

function! s:source.gather_candidates(args, context) "{{{
  let function_name = 'taglist'
  return unite#sources#tags#{function_name}#gather_candidates(a:args, a:context)
endfunction"}}}
"}}}
