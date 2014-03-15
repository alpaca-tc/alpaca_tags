function! alpaca_tags#tag_builder#gemfile#define()
endfunction

let s:Builder = alpaca_tags#tag_builder#new('Gemfile')
call alpaca_tags#tag_builder#register(s:Builder)

function! s:Builder.available()
  return filereadable(self.rootpath() . '/Gemfile')
endfunction

function! s:Builder.build()
  let args = ''
  let commands = [
        \ 'bundle show --paths | xargs',
        \ g:alpaca_tags_ctags_bin,
        \ args,
        \ '-R -f',
        \ self.tagname(),
        \ ]
  let command = join(commands, ' ')

  call alpaca_tags#util#system(command, self.rootpath(), s:Builder.messages())
endfunction

function! s:Builder.messages()
  return {
        \ 'done': 'Create tag: Gemfile',
        \ 'in_process': 'Creating tag: Gemfile...',
        \ }
endfunction
