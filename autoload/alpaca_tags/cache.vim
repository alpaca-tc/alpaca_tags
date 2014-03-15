let s:Cache = vital#of('alpaca_tags').import('System.Cache')
let s:cache_dir = g:alpaca_tags#cache_dir

function! alpaca_tags#cache#get_tagname(path, tagname)
  let tagname = a:path . '/' . a:tagname
  return s:Cache.getfilename(s:cache_dir, tagname)
endfunction

function! alpaca_tags#cache#clean_cache()
  for file in split(globpath(g:alpaca_tags#cache_dir, '*'), '\n')
    call delete(file)
  endfor
endfunction
