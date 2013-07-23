"=============================================================================
" FILE: vim.vim
" AUTHOR: Ishii Hiroyuki <alprhcp666@gmail.com>
" Last Modified: 2013-07-24
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

" Cache variable is shared
let s:caching = {}


" Define Accessor"{{{
function! alpaca_tags#cache#vim#new(values) "{{{
  return alpaca_tags#cache#base#extends(s:VimCacheAccessor).new(values)
endfunction"}}}

let s:VimCacheAccessor = {
      \ 'cache' : s:caching,
      \ }

function! s:VimCacheAccessor.exists() "{{{
  return has_key(self.cache, self.key)
endfunction"}}}

function! s:VimCacheAccessor.find() "{{{
  return self.cache[self.key]
endfunction"}}}

function! s:VimCacheAccessor.create() "{{{
  " Override in instance.
  " let self.cache[self.key] = data
endfunction"}}}
"}}}

