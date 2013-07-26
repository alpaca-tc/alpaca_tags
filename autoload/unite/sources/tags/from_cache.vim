" No used...
function! s:candidates_from_cache(args, context) "{{{
  let exist_tags = alpaca_tags#tag#exist_tags()
  let cache_key = string(exist_tags)

  if has_key(s:caching, cache_key)
    return s:caching[cache_key]
  endif

  let cacher = alpaca_tags#cache#new('')
  let candidates = []
  for tag in exist_tags
    let tags = cacher.read(tag)
    call extend(candidates, tags)
  endfor

  let s:caching[cache_key] = candidates
  return candidates
endfunction"}}}
