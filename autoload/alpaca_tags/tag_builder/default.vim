function! alpaca_tags#tag_builder#default#define()
  return s:Builder
endfunction

let s:Builder = alpaca_tags#tag_builder#new('Default')
call alpaca_tags#tag_builder#register(s:Builder)

function! s:Builder.build()
  let ctags = g:alpaca_tags#ctags_bin
  let commands = [
        \ ctags,
        \ self.build_option(),
        \ '-f',
        \ self.tempname(),
        \ self.rootpath()
        \ ]
  let command = join(commands, ' ')

  call alpaca_tags#util#system(command, self.rootpath(), self.messages(), self)
endfunction

function! s:Builder.messages()
  return {
        \ 'done': 'Created tag: ' . self.fmt_rootpath(),
        \ 'in_process': 'Creating tag: ' . self.fmt_rootpath() . '...',
        \ }
endfunction
