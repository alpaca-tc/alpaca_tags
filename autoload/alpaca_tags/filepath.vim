let s:save_cpo = &cpo
set cpo&vim

let s:is_windows = has('win16') || has('win32') || has('win64') || has('win95')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \   (!isdirectory('/proc') && executable('sw_vers')))
let s:is_unix = has('unix')
let s:root_directory_caching = {}

let s:project_files = [
      \ 'build.xml', 'prj.el', '.project', 'pom.xml', 'package.json',
      \ 'Makefile', 'configure', 'Rakefile', 'NAnt.build', 'Gemfile',
      \ 'P4CONFIG',
      \ ]

function! s:escape_file_searching(buffer_name)
  return escape(a:buffer_name, '*[]?{}, ')
endfunction

function! s:substitute_path_separator(path)
  return s:is_windows ? substitute(a:path, '\\', '/', 'g') : a:path
endfunction

function! s:path2directory(path)
  return s:substitute_path_separator(isdirectory(a:path) ? a:path : fnamemodify(a:path, ':p:h'))
endfunction

function! s:_path2project_directory_git(path)
  let parent = a:path

  while 1
    let path = parent . '/.git'
    if isdirectory(path) || filereadable(path)
      return parent
    endif
    let next = fnamemodify(parent, ':h')
    if next == parent
      return ''
    endif
    let parent = next
  endwhile
endfunction

function! s:_path2project_directory_svn(path)
  let search_directory = a:path
  let directory = ''

  let find_directory = s:escape_file_searching(search_directory)
  let d = finddir('.svn', find_directory . ';')
  if d == ''
    return ''
  endif

  let directory = fnamemodify(d, ':p:h:h')

  " Search parent directories.
  let parent_directory = s:path2directory(
        \ fnamemodify(directory, ':h'))

  if parent_directory != ''
    let d = finddir('.svn', parent_directory . ';')
    if d != ''
      let directory = s:_path2project_directory_svn(parent_directory)
    endif
  endif
  return directory
endfunction

function! s:_path2project_directory_others(vcs, path)
  let vcs = a:vcs
  let search_directory = a:path
  let directory = ''

  let find_directory = s:escape_file_searching(search_directory)
  let d = finddir(vcs, find_directory . ';')
  if d == ''
    return ''
  endif
  return fnamemodify(d, ':p:h:h')
endfunction

function! s:path2project_root(path, is_allow_empty)
  let search_directory = s:path2directory(a:path)
  let directory = ''

  " Search VCS directory.
  for vcs in ['.git', '.bzr', '.hg', '.svn']
    if vcs ==# '.git'
      let directory = s:_path2project_directory_git(search_directory)
    elseif vcs ==# '.svn'
      let directory = s:_path2project_directory_svn(search_directory)
    else
      let directory = s:_path2project_directory_others(vcs, search_directory)
    endif
    if directory != ''
      break
    endif
  endfor

  " Search project file.
  if directory == ''
    for d in s:project_files
      let d = findfile(d, s:escape_file_searching(search_directory) . ';')
      if d != ''
        let directory = fnamemodify(d, ':p:h')
        break
      endif
    endfor
  endif

  if directory == ''
    " Search /src/ directory.
    let base = s:substitute_path_separator(search_directory)
    if base =~# '/src/'
      let directory = base[: strridx(base, '/src/') + 3]
    endif
  endif

  if directory == '' && !a:is_allow_empty
    " Use original path.
    let directory = search_directory
  endif

  return s:substitute_path_separator(directory)
endfunction

function! alpaca_tags#filepath#path2project_root(path, ...)
  if has_key(s:root_directory_caching, a:path)
    return s:root_directory_caching[a:path]
  endif

  let is_allow_empty = get(a:000, 0, 0)
  let s:root_directory_caching[a:path] = s:path2project_root(a:path, is_allow_empty)

  return s:root_directory_caching[a:path]
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
