" Configration
let s:min_key_length = 3
let s:filename_length = 80

function! unite#sources#tags#taglist#clean_cache() "{{{
  let s:source = unite#sources#tags#define()
  let s:cache_of_candidates = alpaca_tags#cache#vim#new('candidates')
  let s:cache_of_taglist = alpaca_tags#cache#vim#new('taglist')
endfunction"}}}
call unite#sources#tags#taglist#clean_cache()

function! s:get_cache_of_candidates(input) "{{{
  let input = a:input

  if !empty(input)
    for key in s:cache_of_candidates.keys()
      if input =~ key
        return s:cache_of_candidates.get(key)
      endif
    endfor
  endif

  return 0
endfunction"}}}

function! s:taglist2candidates(args, context) "{{{
  let input = s:context2input(a:context)

  let cache = s:get_cache_of_candidates(input)
  if !empty(cache)
    return cache
  endif

  let taglist = s:taglist(input)

  let candidates = []
  let candidate_len = 0

  for tag in taglist
    " TODO Remove slow function from here.
    let candidate = unite#sources#tags#taglist#vim#tag2candidate(tag, s:filename_length)
    " let candidate = unite#sources#tags#taglist#ruby#tag2candidate(tag, s:filename_length)
    call add(candidates, candidate)

    let candidate_len = candidate_len + 1
    if candidate_len > s:source.max_candidates
      break
    endif
  endfor

  if len(candidates) < s:source.max_candidates
    call s:cache_of_candidates.save(input, candidates)
  endif

  return candidates
endfunction"}}}

function! s:taglist(expr) "{{{
  if !s:cache_of_taglist.has_key(a:expr)
    let taglist = taglist(a:expr)
    call s:cache_of_taglist.save(a:expr, taglist)
  endif

  return s:cache_of_taglist.get(a:expr)
endfunction"}}}

function! s:candidates_from_taglist(args, context) "{{{
  let candidates = s:taglist2candidates(a:args, a:context)
  if empty(candidates)
    return [{ 'word' : 'Not Found!', 'is_dummy' : 1, 'is_matched' : 1 }]
  endif

  return candidates
endfunction"}}}

function! s:context2input(context) "{{{
  let input_list = split(substitute(a:context.input, '^\s*', '', 'g'))
  return empty(a:context.input) ? '' : input_list[0]
endfunction"}}}

function! s:check_ignore_pattern(args, context) "{{{
  let input = s:context2input(a:context)

  if len(input) < s:min_key_length
    return [{ 'word' : 'You should input more than 3 characters', 'is_dummy' : 1, 'is_matched' : 1 }]
  endif

  let match_tags = s:taglist(input)
  if type(match_tags) == type(0)
    return [{ 'word' : 'Not Found!', 'is_dummy' : 1 }]
  endif
endfunction"}}}

function! unite#sources#tags#taglist#gather_candidates(args, context) "{{{
  let error_message = s:check_ignore_pattern(a:args, a:context)
  if !empty(error_message)
    return error_message
  endif

  " Get candidates from taglist
  let candidates = s:candidates_from_taglist(a:args, a:context)
  return candidates
endfunction"}}}

