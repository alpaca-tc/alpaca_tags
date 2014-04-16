let s:PM = alpaca_tags#process#PM()

function! alpaca_tags#process_manager#set(key, manager) "{{{
  if has_key(s:process_manager, a:key)
    call s:process_manager[a:key].kill()
  endif

  let s:process_manager[a:key] = a:manager
endfunction"}}}

function! alpaca_tags#process_manager#kill(key) "{{{
  if has_key(s:process_manager, a:key)
    call s:process_manager[a:key].kill()
    call remove(s:process_manager, a:key)
  endif
endfunction"}}}

function! alpaca_tags#process_manager#is_empty() "{{{
  return len(s:process_manager) == 0
endfunction"}}}

" Watching process for sync
function! s:check_status() "{{{
  if empty(s:process_manager)
    return 0
  endif

  for [path, process] in items(s:process_manager)
    let status = process.status()

    if status == 'active'
      call process.in_process()
    elseif status == 'inactive'
      call process.done()
      call alpaca_tags#process_manager#kill(path)
    elseif status == 'timeout'
      call alpaca_tags#process_manager#kill(path)
    endif
  endfor
endfunction"}}}

function! s:start_watching() "{{{
  if exists('s:loaded_start_watching')
    return
  endif
  let s:loaded_start_watching = 1

  augroup AlpacaTagsWatching
    autocmd!
    autocmd CursorHold,CursorHoldI * call s:check_status()
    autocmd VimLeavePre * call alpaca_tags#process_manager#reset()
  augroup END
endfunction"}}}
call s:start_watching()

function! alpaca_tags#process_manager#reset() "{{{
  let processes = get(s:, 'process_manager', {})

  for [path, process] in items(processes)
    call process.kill()
  endfor

  let s:process_manager = {}
endfunction"}}}
call alpaca_tags#process_manager#reset()
