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

    if s:is_problematic_process(process)
      call alpaca_tags#process_manager#kill(path)
      continue
    endif

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

" Check process health condition {{{
function! s:is_problematic_process(process)
  " TODO: Separate checker.

  " Check job elapsed time
  let timeout_period = get(g:, 'alpaca_tags#timeout_period', 0)
  if timeout_period && timeout_period < a:process.time()
    return 1
  end

  " Check filesize
  let max_filesize = get(g:, 'alpaca_tags#max_filesize', 0)
  if max_filesize
    let actual_filesize = getfsize(a:process.tag_builder.tempname())

    if max_filesize < actual_filesize
      return 1
    endif
  endif

  return 0
endfunction"}}}

function! s:start_watching() "{{{
  if exists('s:loaded_start_watching')
    return
  endif
  let s:loaded_start_watching = 1

  augroup AlpacaTagsWatching
    autocmd!
    if get(g:, 'alpaca_tags#enable_status_check_on_cursormoved', 0)
      autocmd CursorMoved,CursorMovedI * call s:check_status()
    endif
    autocmd CursorHold,CursorHoldI * call s:check_status()
    autocmd VimLeavePre * call alpaca_tags#process_manager#reset()
  augroup END
endfunction"}}}
call s:start_watching()

function! alpaca_tags#process_manager#all() "{{{
  return get(s:, 'process_manager', {})
endfunction"}}}

function! alpaca_tags#process_manager#status() "{{{
  let processes = get(s:, 'process_manager', {})

  for [path, process] in items(processes)
    echomsg process.pid . ' : ' . process.status() . ' : time(' . process.time() . ')'
  endfor
endfunction"}}}

function! alpaca_tags#process_manager#reset() "{{{
  let processes = get(s:, 'process_manager', {})

  for [path, process] in items(processes)
    call process.kill()
  endfor

  let s:process_manager = {}
endfunction"}}}
call alpaca_tags#process_manager#reset()
