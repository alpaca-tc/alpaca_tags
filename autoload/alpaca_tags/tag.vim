function! s:current_git() "{{{
  let current_dir = getcwd()
  if !exists("s:git_root_cache") | let s:git_root_cache = {} | endif
  if has_key(s:git_root_cache, current_dir)
    return s:git_root_cache[current_dir]
  endif

  let git_root = system('git rev-parse --show-toplevel')
  if git_root =~ "fatal: Not a git repository"
    " throw "No a git repository."
    return ""
  endif

  let s:git_root_cache[current_dir] = substitute(git_root, '\n', '', 'g')

  return s:git_root_cache[current_dir]
endfunction"}}}

function! s:get_root_dir() "{{{
  if exists('b:rails_root')
    return b:rails_root
  elseif !empty(s:current_git())
    return s:current_git()
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
