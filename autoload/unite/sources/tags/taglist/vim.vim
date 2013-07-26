function! unite#sources#tags#taglist#vim#tag2candidate(tag, filename_length) 
  let tag = a:tag

  " TODO I can't discriminate between ClassMethod and InstanceMethod from taglist.
  let tagname = has_key(tag, 'class') ? substitute(tag['class'], '\.', '::', 'g') . '#' . tag['name'] : tag['name']
  " let filename_pattern = '.\{,'.a:filename_length.'}$'
  " let filename = matchstr(tag['filename'], filename_pattern)

  let command = has_key(tag, 'cmd') ? tag['cmd'] : ''
  let pattern_for_abbr = empty(command) ? '' : substitute(command, '\v\/\^\s*(.*)\$\/$', '\1', 'g')
  let command_for_abbr = empty(pattern_for_abbr) ? '' : 'pattern: '.pattern_for_abbr
  " let filepath = unite#util#substitute_path_separator(
  "         \ fnamemodify(filename, g:unite_source_file_mru_filename_format))
  let filepath = fnamemodify(tag['filename'], ':~:.')

  let abbr = printf("%s       %s\n            @%s", tagname, command_for_abbr, filepath)

  let candidate = {
        \ 'word': substitute(abbr, '\n', ' ', 'g'),
        \ 'abbr': abbr,
        \ 'kind': 'jump_list',
        \ 'action__path': fnamemodify(tag['filename'], '%:p'),
        \ 'action__directory': fnamemodify(tag['filename'], '%:h'),
        \ 'action__tagname': tag['name'],
        \ 'unite__source_kind': tag['kind'],
        \ 'is_multiline' : 1
        \ }

  let linenr = 0
  let pattern = ''
  if command =~ '^\d\+$'
    let linenr = str2nr(command)
    let candidate.action__line = linenr
  else
    let pattern = matchstr(command, '^\([/?]\)\?\zs.*\ze\1$')
    let pattern = substitute(pattern, '\\\/', '/', 'g')
    let pattern = '\M' . pattern
    let candidate.action__pattern = pattern
  endif

  return candidate
endfunction

