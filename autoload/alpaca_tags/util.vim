function! alpaca_tags#util#current_git() "{{{
  if !exists('s:git_root_cache')
    let s:git_root_cache = {}
  endif

  let current_dir = getcwd()
  if !has_key(s:git_root_cache, current_dir)
    let git_root = system("git rev-parse --show-toplevel")
    if git_root =~ "fatal: Not a git repository"
      " throw "No a git repository."
      return 0
    endif

    let s:git_root_cache[current_dir] = substitute(git_root, '\n', '', 'g')
  endif

  return s:git_root_cache[current_dir]
endfunction"}}}

function! alpaca_tags#util#filetype() "{{{
  if empty(&filetype) | return '' | endif

  return split( &filetype, '\.' )[0]
endfunction"}}}

function! alpaca_tags#util#system(command, args) "{{{
  let command = join([a:command, a:args], ' ')
  if g:alpaca_tags_print_to_console['system']
    echomsg printf('Execute command: %s', command)
  endif

  return vimproc#system_bg(command)
endfunction"}}}
