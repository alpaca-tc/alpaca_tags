function! alpaca_tags#ruby#initialize() "{{{
  if !has('ruby')
    return 0
  endif

  let cacher = unite#sources#tags#cacher()
  let default_directory = cacher.directory

  ruby << EOF
  plugin_current_dir = VIM.evaluate('g:alpaca_update_tags_root_dir')
  require "#{plugin_current_dir}/lib/vim"
  require "#{plugin_current_dir}/lib/alpaca_tags"

  AlpacaTags::TagsManager.initialize!
  AlpacaTags::TagsManager::Parser.default_parser = AlpacaTags::TagsManager::Parser::Vim
  AlpacaTags::Cacher.default_cacher = AlpacaTags::Cacher::Vim
  AlpacaTags::Cacher::Base.default_directory = VIM.evaluate('default_directory')
EOF
endfunction"}}}
