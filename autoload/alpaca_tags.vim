function! alpaca_tags#complete_source(arglead, cmdline, cursorpos)
  if !exists('s:options_cache')
    let options = copy(g:alpaca_tags#config)
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
endfunction
