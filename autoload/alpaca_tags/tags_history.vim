function! s:initialize() "{{{
  let s:history = []
  let s:current_index = 0
  call unite#util#set_default('g:unite_source_alpaca_tags_file',
        \ g:unite_data_directory . '/alpaca_tags')
  let s:alpaca_tags_file_mtime = -1
endfunction"}}}
call s:initialize()

function! alpaca_tags#tags_history#get_history() "{{{
  return s:load()
endfunction"}}}

function! alpaca_tags#tags_history#append(candidate) "{{{
  let history = alpaca_tags#tags_history#get_history()
  call add(history, a:candidate)
  call s:save_history(history)
endfunction"}}}

function! alpaca_tags#tags_history#clean() "{{{
  call s:save_history([])
endfunction"}}}

function! alpaca_tags#tags_history#open(index) "{{{
  let index = a:index
  let histories = alpaca_tags#tags_history#get_history()

  try
    let history = histories[index]
    let s:current_index = index
    call unite#kinds#tags#open(history)
  catch
    call unite#print_error('Not found index:' . string(a:index))
  endtry
endfunction"}}}

function! alpaca_tags#tags_history#next() "{{{
  let index = s:current_index + 1
  call alpaca_tags#tags_history#open(index)
endfunction"}}}

function! alpaca_tags#tags_history#previous() "{{{
  let index = s:current_index - 1
  call alpaca_tags#tags_history#open(index)
endfunction"}}}

function! alpaca_tags#tags_history#current() "{{{
  call alpaca_tags#tags_history#open(s:current_index)
endfunction"}}}

function! s:unique(histories) "{{{
  let already_exists = {}
  let result = []

  for candidate in a:histories
    let key = candidate.action__pattern . candidate.action__path
    if !has_key(already_exists, key)
      let already_exists[key] = 1
      call add(result, candidate)
    endif
  endfor

  return result
endfunction"}}}

function! s:save_history(history) "{{{
  let s:history = s:unique(a:history)

  if g:unite_source_alpaca_tags_file == ''
    return
  endif

  call writefile([string(s:history)], g:unite_source_alpaca_tags_file)
  let s:alpaca_tags_file_mtime = getftime(g:unite_source_alpaca_tags_file)
endfunction"}}}

function! s:load()  "{{{
  if !filereadable(g:unite_source_alpaca_tags_file)
    \ || s:alpaca_tags_file_mtime == getftime(g:unite_source_alpaca_tags_file)
    return s:history
  endif

  let file = readfile(g:unite_source_alpaca_tags_file)
  if empty(file)
    return
  endif

  try
    sandbox let s:history = eval(file[0])

    " Type check.
    let history = s:history[0].word
  catch
    let s:history = []
  endtry

  let s:alpaca_tags_file_mtime = getftime(g:unite_source_alpaca_tags_file)

  return s:history
endfunction"}}}
