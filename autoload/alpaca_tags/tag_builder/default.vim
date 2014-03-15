function! alpaca_tags#tag_builder#default#define()
endfunction

let s:Builder = alpaca_tags#tag_builder#new('Default')

function! s:Builder.build()
  let ctags = g:alpaca_tags_ctags_bin
  let commands = [
        \ ctags,
        \ self.build_option(),
        \ '-f',
        \ self.tagname(),
        \ self.rootpath()
        \ ]
  let command = join(commands, ' ')

  call alpaca_tags#util#system(command, self.rootpath(), s:Builder.messages())
endfunction

function! s:Builder.messages()
  return {
        \ 'done': 'Done! Create tag: ' . self.rootpath(),
        \ 'in_process': 'Creating tag: ' . self.rootpath() . '...',
        \ }
endfunction
