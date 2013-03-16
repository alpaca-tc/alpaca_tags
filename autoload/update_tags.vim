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

" figitiveが必要
" common
function! s:current_git() "{{{
  if !exists('b:git_dir')
    return ''
  endif

  return substitute(b:git_dir, '/.git$', '', 'g')
endfunction"}}}
function! s:iconv(expr, from, to) "{{{
  if a:from == '' || a:to == '' || a:from ==? a:to
    return a:expr
  endif
  let result = iconv(a:expr, a:from, a:to)
  return result != '' ? result : a:expr
endfunction"}}}
function! s:has_vimproc() "{{{
  if !exists('s:exists_vimproc')
    let s:exists_vimproc = exists('g:loaded_vimproc')
  endif

  return s:exists_vimproc
endfunction"}}}
function! s:filetype() "{{{
  if empty(&filetype) | return '' | endif

  return split( &filetype, '\.' )[0]
endfunction"}}}
function! s:system(...) "{{{
  let command = g:alpaca_update_tags_bin
  let input = a:0 >= 1 ? a:1 : ''
  let command = s:iconv(command, &encoding, 'char')
  let input = s:iconv(input, &encoding, 'char')

  let command_and_option = join([command, input], ' ')
  let output = s:has_vimproc() ?
        \ vimproc#system_bg(command_and_option) : system(command_and_option)

  let output = substitute(s:iconv(output, 'char', &encoding), '\n$', '', '')
  return output
endfunction"}}}

" update_tags
function! s:get_value(key) "{{{
  if has_key(g:alpaca_update_tags_config, a:key)
    return g:alpaca_update_tags_config[a:key]
  else
    return ''
  endif
endfunction"}}}
function! s:get_options() "{{{
  let options = []

  call add(options, s:get_value('_'))
  call add(options, s:get_value(s:filetype()))

  let option = join(options, ' ')

  if option =~ '^\s*$' && s:get_value('default')
    let option = s:get_value('default')
  endif

  return option
endfunction"}}}
function! update_tags#update_tags() "{{{
  let git_root_dir = s:current_git()
  if git_root_dir == ''
    return -1
  endif

  call s:system(s:get_options())
endfunction"}}}

" set_tags
function! update_tags#set_tags() "{{{
  let current_git_root = s:current_git()

  if filereadable(current_git_root.'tags')
    execute "setl tags+=" . expand(current_git_root.'tags')
  endif
  if filereadable(current_git_root.'.git/tags')
    execute "setl tags+=" . expand(current_git_root.'.git/tags')
  endif
endfunction"}}}
