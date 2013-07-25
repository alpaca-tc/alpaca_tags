function! alpaca_tags#ruby#initialize() "{{{
  if !has('ruby')
    return 0
  endif
  call alpaca_tags#variables#init()

  ruby << EOF
  plugin_current_dir = VIM.evaluate('g:alpaca_tags_root_dir')
  $:.unshift("#{plugin_current_dir}/lib")
  require 'vim'
  require 'alpaca_tags'

  cache_dir = Vim.get('g:alpaca_tags_cache_directory')

  AlpacaTags.configure do |c|
    c.default_cache_path = cache_dir
    c.default_cache = ::AlpacaTags::Cache::Vim
    c.default_tag_parser = ::AlpacaTags::TagParser::CacheAsVimObject
  end
EOF
endfunction"}}}
