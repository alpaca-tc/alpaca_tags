function! alpaca_tags#tag_builder#gemfile#define()
  return s:Builder
endfunction

let s:Builder = alpaca_tags#tag_builder#new('Gemfile')
call alpaca_tags#tag_builder#register(s:Builder)

function! s:Builder.available()
  return filereadable(self.rootpath() . '/Gemfile') && self.super().available()
endfunction

function! s:Builder.build()
  " bundle show --paths | xargs ctags ... -R -f cache_dir/...Gemfile
  let commands = [
        \ 'bundle show --paths | xargs',
        \ g:alpaca_tags#ctags_bin,
        \ self.build_option(),
        \ '-R -f',
        \ self.tempname(),
        \ ]
  let command = join(commands, ' ')

  call alpaca_tags#util#system(command, self.rootpath(), self.messages(), self)
endfunction

function! s:Builder.messages()
  let gempath = self.fmt_rootpath() . '/Gemfile'
  return {
        \ 'done': 'Created tag: ' . gempath,
        \ 'in_process': 'Creating tag: ' . gempath . '...',
        \ }
endfunction
