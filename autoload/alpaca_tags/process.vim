let s:PM = vital#of('alpaca_tags').import('ProcessManager')

function! alpaca_tags#process#PM()
  return s:PM
endfunction

let s:Watch = {
      \ 'stdout_all' : '',
      \ 'stderr_all' : '',
      \ }

function! alpaca_tags#process#new(command, callbacks) "{{{
  return s:Watch.new(a:command, a:callbacks)
endfunction"}}}

function! s:Watch.new(command, callbacks) "{{{
  let instance = copy(self)
  call instance.constructor(a:command, a:callbacks)

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
  call self.do_callback('done')
endfunction"}}}

function! s:Watch.in_process() "{{{
  call self.do_callback('in_process')
endfunction"}}}

function! s:Watch.kill() "{{{
  call s:PM.kill(self.pid)
endfunction"}}}

function! s:Watch.read_all() "{{{
  call self.read()
  return [get(self, 'stdout_all', ''), get(self, 'stderr_all', ''), get(self, 'status', 'not_found')]
endfunction"}}}

function! s:Watch.do_callback(action) "{{{
  if !g:alpaca_tags#console.report
    return
  endif

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

function! s:Watch.status() "{{{
  return s:PM.status(self.pid)
endfunction"}}}
