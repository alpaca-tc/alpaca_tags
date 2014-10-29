function! alpaca_tags#util#flatten(array) "{{{
  let new_array = []

  for i in a:array
    if type(i) == type([])
      let new_array += alpaca_tags#util#flatten(i)
    else
      call add(new_array, i)
    endif
  endfor

  return new_array
endfunction"}}}

function! alpaca_tags#util#filetype() "{{{
  if empty(&filetype)
    return ''
  endif

  return split(&filetype, '\.')[0]
endfunction"}}}

function! s:skip_if_single_task_enable() "{{{
  if g:alpaca_tags#single_task && !alpaca_tags#process_manager#is_empty()
    return 1
  endif

  return 0
endfunction"}}}

function! alpaca_tags#util#system(command, path, callbacks, tagbuilder) "{{{
  let current_dir = getcwd()

  if empty(a:path) || s:skip_if_single_task_enable()
    return
  endif

  try
    lcd `=a:path`
    let process = alpaca_tags#process#new(a:command, a:callbacks, a:tagbuilder)

    call alpaca_tags#process_manager#set(a:path, process)
  " catch /.*/
  finally
    lcd `=current_dir`
  endtry
endfunction"}}}
