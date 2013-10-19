function! alpaca_tags#set() "{{{
  let current_git_root = alpaca_tags#util#current_git()

  let tag_list = [
        \ current_git_root . '/.git/working_dir.tags',
        \ current_git_root . '/.git/gem.tags'
        \ ]

  for tag in tag_list
    let tag = fnamemodify(tag, ":p")

    if filereadable(tag)
      execute 'setl tags+=' . tag

      if g:alpaca_tags_print_to_console['setted tags']
        echomsg 'set tags+=' . tag
      endif
    endif
  endfor
endfunction"}}}

function! alpaca_tags#clear_cache() "{{{
  call unite#sources#tags#taglist#clean_cache()
  call alpaca_tags#util#clean_current_git_cache()
endfunction"}}}
