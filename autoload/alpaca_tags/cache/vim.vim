function! alpaca_tags#cache#vim#new(name)
  return s:Caching.new(a:name)
endfunction

let s:Caching = {
      \ '_data' : {}
      \ }

function! s:Caching.new(name) "{{{
  let instance = deepcopy(self)

  call instance.constructor(a:name)
  call remove(instance, 'new')
  call remove(instance, 'constructor')

  return instance
endfunction"}}}

function! s:Caching.constructor(name) "{{{
  let self._data['name'] = a:name
  let self._data['cache'] = {}
  let self.cache = self._data['cache']
endfunction"}}}

function! s:Caching.save(name, value) "{{{
  let self.cache[a:name] = deepcopy(a:value)
endfunction"}}}

function! s:Caching.get(name) "{{{
  if has_key(self.cache, a:name)
    return deepcopy(self.cache[a:name])
  endif
endfunction"}}}

function! s:Caching.keys() "{{{
  return keys(self.cache)
endfunction"}}}

function! s:Caching.has_key(name) "{{{
  return has_key(self.cache, a:name)
endfunction"}}}
