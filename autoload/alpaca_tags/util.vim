let s:PM = vital#of('alpaca_tags').import('ProcessManager')

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

function! alpaca_tags#util#system(command, path, callbacks) "{{{
  if !isdirectory(a:path)
    echomsg "Couldn't find base directory! - " . a:path
    return
  endif

  let current_dir = getcwd()

  if s:skip_if_single_task_enable()
    return
  endif

  try
    lcd `=a:path`
    if g:alpaca_tags#console.report
      return s:Watch.new(a:command, a:callbacks)
    else
      return vimproc#plineopen3(a:command)
    endif
  " catch /.*/
  finally
    lcd `=current_dir`
  endtry
endfunction"}}}

function! s:skip_if_single_task_enable() "{{{
  if g:alpaca_tags#single_task && len(s:Watch.instances) > 0
    return 1
  endif

  return 0
endfunction"}}}

" Watch"{{{
let s:Watch = {
      \ 'instances' : {},
      \ 'stdout_all' : '',
      \ 'stderr_all' : '',
      \ }

function! s:Watch.new(command, callbacks) "{{{
  let instance = copy(self)
  call instance.constructor(a:command, a:callbacks)
  let s:Watch.instances[instance.pid] = instance

  return instance
endfunction"}}}

function! s:Watch.constructor(command, callbacks) "{{{
  let self.pid = join(reltime(), '') " Dummy
  call s:PM.touch(self.pid, a:command)
  let self.command    = a:command
  let self.callbacks  = a:callbacks
endfunction"}}}

function! s:Watch.read() "{{{
  try
    call s:PM.status(self.pid)
  catch "^ProcessManager doesn't know about.*"
    return [
          \ get(self, 'stdout_all', ''),
          \ get(self, 'stderr_all', ''),
          \ get(self, 'status', 'not_exists')]
  endtry

  let [self.stdout, self.stderr, self.status] = s:PM.read(self.pid, [''])
  let self.stdout_all .= self.stdout
  let self.stderr_all .= self.stderr

  return [self.stdout_all, self.stderr_all, self.status]
endfunction"}}}

function! s:Watch.done() "{{{
  call remove(s:Watch.instances, self.pid)
  call self.do_callback('done')
  call s:PM.kill(self.pid)
endfunction"}}}

function! s:Watch.in_process() "{{{
  call self.do_callback('in_process')
endfunction"}}}

function! s:Watch.destroy() "{{{
  call tags#message#print('Timeout: ' . self.command)
  call remove(s:Watch.instances, self.pid)
  call s:PM.kill(self.pid)
endfunction"}}}

function! s:Watch.read_all() "{{{
  call self.read()
  return [get(self, 'stdout_all', ''), get(self, 'stderr_all', ''), get(self, 'status', 'not_found')]
endfunction"}}}

function! s:Watch.do_callback(action) "{{{
  let callbacks = get(self, 'callbacks', {})
  if type(callbacks) == type({}) && has_key(callbacks, a:action)
    let callback = callbacks[a:action]
    if exists('*' . callback)
      call {callbacks[a:action]}(self.read_all(), self)
    elseif type(callback) == type('')
      echo callback
    endif
    return 1
  else
    return 0
  endif
endfunction"}}}
"}}}

" Watching process for sync
function! s:check_status() "{{{
  if empty(s:Watch.instances)
    return 0
  endif

  let in_processes = []
  for pid in keys(s:Watch.instances)
    let instance = s:Watch.instances[pid]
    let status = s:PM.status(pid)

    if status == 'active'
      call instance.in_process()
      call add(in_processes, instance)
    elseif status == 'inactive'
      call instance.done()
    elseif status == 'timeout'
      call instance.destroy()
    endif
  endfor
endfunction"}}}

function! alpaca_tags#util#check_status() "{{{
  call s:check_status()
endfunction"}}}

function! s:start_watching() "{{{
  if exists('s:loaded_start_watching')
    return
  endif
  let s:loaded_start_watching = 1

  augroup AlpacaTagsWatching
    autocmd!
    autocmd CursorHold,CursorHoldI * call s:check_status()
    autocmd VimLeavePre * call alpaca_tags#util#killall()
  augroup END
endfunction"}}}
call s:start_watching()

function! alpaca_tags#util#killall() "{{{
  let pids = keys(s:Watch.instances)
  let s:Watch.instances = {}
  for pid in pids
    call s:PM.kill(pid)
  endfor
endfunction"}}}
