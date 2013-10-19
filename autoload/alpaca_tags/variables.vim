function! alpaca_tags#variables#init()
  if exists('s:loaded_init')
    return
  endif
  let s:loaded_init = 1

  let g:alpaca_tags_cache_directory =
        \ get(g:, 'alpaca_tags_cache_directory', g:unite_data_directory . '/alpaca_tags')
  call alpaca_tags#variables#check_deprecated_variables()
endfunction

function! alpaca_tags#variables#check_deprecated_variables()
  if exists('g:alpaca_tags_config')
    echomsg 'g:alpaca_tags_config is deprecated. Please use g:alpaca_update_tags_config instead'
    let g:alpaca_update_tags_config = g:alpaca_tags_config
  endif

  if !exists('g:alpaca_update_tags_config')
    let g:alpaca_update_tags_config = {
          \ '_' : '-R --sort=yes --languages=-js,css',
          \ }
  endif

  if !exists('g:alpaca_tags_print_to_console')
    let g:alpaca_tags_print_to_console = {
          \ 'debug' : 0,
          \ 'setted tags' : 0,
          \ 'created/updated tags' : 1,
          \ }
  endif

  if !exists('g:alpaca_tags_ctags_bin')
    if executable('/Applications/MacVim.app/Contents/MacOS/ctags')
      let g:alpaca_tags_ctags_bin = '/Applications/MacVim.app/Contents/MacOS/ctags'
    elseif executable('ctags')
      let g:alpaca_tags_ctags_bin = 'ctags'
    else
      echomsg "[alpaca_tags] Error occurred: Please install ctags"
      finish
    endif
  endif

  let g:alpaca_tags_disable = get(g:, 'alpaca_tags_disable', 0)
endfunction
