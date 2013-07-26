function! s:get_root_dir() "{{{
  if exists('b:rails_root')
    return b:rails_root
  elseif !empty(alpaca_tags#util#current_git())
    return alpaca_tags#util#current_git()
  else
    return 0
  endif
endfunction "}}}

function! alpaca_tags#tag#caching() "{{{
  call s:cache_tags(0)
endfunction"}}}

function! alpaca_tags#tag#async_caching() "{{{
  call s:cache_tags(1)
endfunction"}}}

function! alpaca_tags#tag#exist_tags() "{{{
  let tags = map(tagfiles(), "fnamemodify(v:val, ':p')")
  return filter(tags, 'filereadable(v:val)')
endfunction"}}}

function! s:cache_tags(async) "{{{
  let root_dir = s:get_root_dir()
  if empty(root_dir) || empty(tagfiles())
    return 0
  endif

  call alpaca_tags#ruby#initialize()
  let tag_list = alpaca_tags#tag#exist_tags()
  let tempname = tempname()

  ruby << EOF
  root_dir = VIM.get('root_dir')
  tags = VIM.get('tag_list')

  th = Thread.new do
    tag_set = AlpacaTags::Manager.create(root_dir, tags)
    tag_set.load
  end

  th.join if VIM.get('a:async') == 0
EOF
endfunction"}}}
