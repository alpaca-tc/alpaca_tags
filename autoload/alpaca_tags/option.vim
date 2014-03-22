" g:alpaca_tags#config

function! alpaca_tags#option#new(options)
  return s:Option.new(a:options)
endfunction

let s:Option = {}
function! s:Option.new(options)
  let instance = copy(s:Option)
  call remove(instance, 'new')
  let instance.options = []

  " Set default option to g:alpaca_tags#config._
  let options = alpaca_tags#util#flatten(a:options)
  call instance.parse(options)
  call instance.add_option_if_exists('_')

  return instance
endfunction

function! s:Option.add_option_if_exists(key)
  let option = get(g:alpaca_tags#config, a:key, '')

  if !empty(option)
    call self.add_option(option)
  endif
endfunction

function! s:Option.add_option(option)
  call add(self.options, a:option)
endfunction

function! s:Option.parse(options) "{{{
  let options = alpaca_tags#util#flatten(a:options)
endfunction"}}}

function! s:Option.build()
  return join(self.options)
endfunction
