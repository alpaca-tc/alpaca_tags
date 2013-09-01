function! alpaca_tags#set() "{{{
  let current_git_root = alpaca_tags#util#current_git()

  let tags_list = [
        \ current_git_root.'/.git/working_dir.tags',
        \ current_git_root.'/.git/gem.tags'
        \ ]
  let tags_setted = []

  for tag in tags_list
    if filereadable(tag)
      execute "setl tags+=" . expand(tag)
      call add(tags_setted, tag)
    endif
  endfor

  if !empty(tags_setted) && g:alpaca_tags_print_to_console['setted tags']
    echomsg 'Set:' . join(tags_setted, ', ')
  endif
endfunction"}}}

function! alpaca_tags#clear_cache() "{{{
  call unite#sources#tags#taglist#clean_cache()
  call alpaca_tags#util#clean_current_git_cache()
endfunction"}}}

