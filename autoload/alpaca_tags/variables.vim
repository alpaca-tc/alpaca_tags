function! alpaca_tags#variables#init()
  if exists('s:loaded_init')
    return
  endif
  let s:loaded_init = 1

  let g:alpaca_tags_cache_directory = get(g:, 'alpaca_tags_cache_directory', g:unite_data_directory . '/alpaca_tags')
endfunction
