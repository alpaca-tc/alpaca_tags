function! alpaca_tags#ruby#initialize() "{{{
  if !has('ruby')
    return 0
  endif
  ruby << EOF
  plugin_current_dir = VIM.evaluate('g:alpaca_update_tags_root_dir')
  require "#{plugin_current_dir}/lib/vim"
EOF
endfunction"}}}
