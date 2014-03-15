function! alpaca_tags#tag_builder#gemfile#define()
endfunction

let s:Builder = alpaca_tags#tag_builder#new('Gemfile')
call alpaca_tags#tag_builder#register(s:Builder)

function! s:Builder.available()
  return filereadable(self.rootpath() . '/Gemfile')
endfunction

function! s:Builder.build()
  " bundle show --paths | xargs ctags ... -R -f cache_dir/...Gemfile
  let commands = [
        \ 'bundle show --paths | xargs',
        \ g:alpaca_tags_ctags_bin,
        \ self.build_option(),
        \ '-R -f',
        \ self.tagname(),
        \ ]
  let command = join(commands, ' ')

  call alpaca_tags#util#system(command, self.rootpath(), self.messages())
endfunction

function! s:Builder.messages()
  let gempath = self.rootpath() . '/Gemfile'
  return {
        \ 'done': 'Done! Create tag: ' . gempath,
        \ 'in_process': 'Creating tag: ' . gempath . '...',
        \ }
endfunction
