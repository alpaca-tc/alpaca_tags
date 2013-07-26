"=============================================================================
" FILE: create_tags.vim
" AUTHOR:  Hiroyuki Ishii <alprhcp666@gmail.com>
" Last Modified: 2013-07-26
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

" Get command path
function! s:get_command(name) "{{{
  let command_path = g:alpaca_tags_root_dir . '/bin/' . a:name

  if executable(command_path)
    return command_path
  else
    throw printf('Error occurd. "%s" is not found.', command_path)
  endif
endfunction"}}}

" For option"{{{
function! s:parse_options(args) "{{{
  return split(a:args, ' ')
endfunction"}}}

function! s:get_tags_options(keys) "{{{
  let options = []

  " Append common option.
  call add(options, s:get_tags_option_by('_'))

  " Append each of option.
  for key in a:keys
    let option_by_key = s:get_tags_option_by(key)
    if !empty(option_by_key)
      call add(options, option_by_key)
    elseif type(key) == type('')
      call add(options, key)
    endif
  endfor

  let option = join(options, ' ')

  return option
endfunction"}}}

function! s:get_tags_option_by(key) "{{{
  if has_key(g:alpaca_tags_config, a:key)
    return g:alpaca_tags_config[a:key]
  else
    return ''
  endif
endfunction"}}}
"}}}

function! alpaca_tags#create_tags#update(args) "{{{
  let git_root_dir = alpaca_tags#util#current_git()

  if empty(git_root_dir)
    echomsg 'Updating tags failed'
    return 0
  endif

  let command = s:get_command('create_tags_into_git')
  let parse_opt = s:parse_options(a:args)
  let option = s:get_tags_options(parse_opt)

  return alpaca_tags#util#system(command, option, 'Created ' . git_root_dir . '/.git/working_dir.tags')
endfunction"}}}

function! alpaca_tags#create_tags#update_bundle(args) "{{{
  let parse_opt = s:parse_options(a:args)
  if empty(parse_opt)
    let parse_opt = ["bundle"]
  endif
  let option = s:get_tags_options(parse_opt)
  let command = s:get_command("create_bundle_tags_into_git")

  return alpaca_tags#util#system(command, option, 'Created ' . git_root_dir . '/.git/gem.tags')
endfunction"}}}

function! alpaca_tags#create_tags#complete_source(arglead, cmdline, cursorpos) "{{{
  if !exists('s:options_cache')
    let options = copy(g:alpaca_tags_config)
    if has_key(options, '_')
      call remove(options, '_')
    endif
    let s:options_cache = sort(keys(options))
  endif

  let arglead = a:arglead
  if empty(arglead)
    return s:options_cache
  endif

  return filter(copy(s:options_cache), 'v:val =~ "^' . arglead . '"')
endfunction"}}}
