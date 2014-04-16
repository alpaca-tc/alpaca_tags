let s:Cache = vital#of('alpaca_tags').import('System.Cache')
let s:cache_dir = g:alpaca_tags#cache_dir
let s:temp_dir = g:alpaca_tags#temp_path

function! s:cache_name(dir, path, tagname)
  let tagname = a:path . '/' . a:tagname
  return s:Cache.getfilename(a:dir, tagname)
endfunction

function! alpaca_tags#cache#get_tagname(path, tagname)
  return s:cache_name(s:cache_dir, a:path, a:tagname)
endfunction

function! alpaca_tags#cache#get_tempname(path, tagname)
  return s:cache_name(s:temp_dir, a:path, a:tagname)
endfunction

function! alpaca_tags#cache#clean_cache()
  for file in split(globpath(g:alpaca_tags#cache_dir, '*'), '\n')
    call delete(file)
  endfor
endfunction
