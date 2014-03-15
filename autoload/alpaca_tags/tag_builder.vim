let s:TagBuilder = {}
let s:tag_builders = {}

" s:TagBuilder"{{{
function! s:TagBuilder.new(path)
  let instance = copy(self)
  call remove(instance, 'new')

  let instance.path = a:path

  return instance
endfunction

function! s:TagBuilder.tagname()
  return alpaca_tags#cache#get_tagname(self.rootpath(), self.name)
endfunction

function! s:TagBuilder.available()
  return 1
endfunction

function! s:TagBuilder.rootpath()
  return alpaca_tags#filepath#path2project_root(self.path)
endfunction

function! s:TagBuilder.build()
endfunction

function! s:TagBuilder.exists()
  return filereadable(self.tagname())
endfunction

function! alpaca_tags#tag_builder#new(name)
  let Builder = copy(s:TagBuilder)
  let Builder.name = a:name

  return Builder
endfunction
"}}}

function! alpaca_tags#tag_builder#register(tag_builder)
  let s:tag_builders[a:tag_builder.name] = a:tag_builder
endfunction

function! s:avaliable_tag_builders()
  let builders = []
  let path = expand('%:p')

  for [name, Builder] in items(s:tag_builders)
    let builder = Builder.new(path)

    if builder.available()
      call add(builders, builder)
    endif
  endfor

  return builders
endfunction

function! alpaca_tags#tag_builder#build()
  call map(s:avaliable_tag_builders(), 'v:val.build()')
endfunction

function! alpaca_tags#tag_builder#set()
  for builder in s:avaliable_tag_builders()
    if builder.exists()
      execute 'setl tags+=' . builder.tagname()
    endif
  endfor
endfunction

call alpaca_tags#tag_builder#gemfile#define()
