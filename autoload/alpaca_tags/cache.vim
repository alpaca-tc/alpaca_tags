"=============================================================================
" FILE: cache.vim
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

let V = vital#of('unite.vim')
let s:C = V.import('System.Cache')
let s:cache_dir = g:unite_data_directory . '/alpaca_tags'

function! s:fname2cachename(fname) "{{{
  return substitute(a:fname, '[\/]', '+=', 'g')
endfunction"}}}

" Define Cache"{{{
function! alpaca_tags#cache#new(source) "{{{
  return s:Cache.new(a:source)
endfunction"}}}

let s:Cache = {
      \ 'name' : '',
      \ 'directory' : '',
      \ 'cache' : {},
      \ }

function! s:Cache.new(source) "{{{
  let instance = copy(self)
  call instance.constructor(a:source)
  call remove(instance, 'new')
  call remove(instance, 'constructor')

  return instance
endfunction"}}}

function! s:Cache.constructor(source) "{{{
  let self.source = a:source
  let name = self.source.name
  let self.name = name
  let self.directory = self.get_directory()

  if !isdirectory(self.directory)
    call mkdir(self.directory, 'p')
  endif
endfunction"}}}

function! s:Cache.get_directory() "{{{
  return s:cache_dir . '/' . s:fname2cachename(self.name)
endfunction"}}}

function! s:Cache.read(fname) "{{{
  let fname = a:fname
  if !s:C.check_old_cache(self.directory, fname)
    let data = s:C.readfile(self.directory, fname)
    sandbox let self.cache[fname] = eval(data[0])
  endif

  return self.cache[fname]
endfunction"}}}

function! s:Cache.write(fname, data) "{{{
  if type(a:data) != type('')
    let data = [string(a:data)]
  else
    let data = a:data
  endif

  let self.cache[a:fname] = data

  return s:C.writefile(self.directory, a:fname, data)
endfunction"}}}
"}}}
