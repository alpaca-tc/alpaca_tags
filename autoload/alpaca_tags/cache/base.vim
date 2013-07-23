function! alpaca_tags#cache#base#extends(other)
  return extend(s:Base, a:other)
endfunction

" Base {{{
let s:Base = {
      \ 'data': {}
      \ }

function! s:error_message()
  echomsg 'Not implemented'
endfunction

function! s:Base.new(values_as_hash) "{{{
  let instance = copy(self)
  call instance.constructor(a:values_as_hash)
  call remove(instance, 'new')
  call remove(instance, 'constructor')

  return instance
endfunction"}}}

" As interface
function! s:Base.constructor(values_as_hash) "{{{
  call extend(self.data, values_as_hash)
endfunction"}}}
function! s:Base.find() "{{{
  call s:error_message()
endfunction"}}}
function! s:Base.create() "{{{
  " Creating data and Save one as caching
  call s:error_message()
endfunction"}}}
function! s:Base.exists() "{{{
  " Does the cache exist?
  " Return 0 or 1
  call s:error_message()
endfunction"}}}
function! s:Base.find_or_create() "{{{
  if self.exists()
    return self.read()
  else
    return self.create()
  endif
endfunction"}}}
"}}}
