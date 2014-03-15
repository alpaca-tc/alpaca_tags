let s:Cache = vital#of('alpaca_tags').import('System.Cache')

function! alpaca_tags#cache#get_tagname(path, tagname)
  let tagname = a:path . '/' . a:tagname
  return s:Cache.getfilename(g:alpaca_tags_cache_dir, tagname)
endfunction
