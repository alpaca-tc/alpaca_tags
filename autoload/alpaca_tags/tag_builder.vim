let s:TagBuilder = {}
let s:TagBuilder.superclass = [s:TagBuilder]
let s:tag_builders = {}

" s:TagBuilder"{{{
function! s:TagBuilder.super()
  return self.superclass[-1]
endfunction

function! s:TagBuilder.new(path, ...)
  let instance = copy(self)
  call remove(instance, 'new')

  let instance.path = a:path
  let options = alpaca_tags#util#flatten(a:000)
  let instance.option = alpaca_tags#option#new(options)

  return instance
endfunction

function! s:TagBuilder.tagname()
  return expand(alpaca_tags#cache#get_tagname(self.rootpath(), self.name), '%:p')
endfunction

function! s:TagBuilder.tempname()
  return expand(alpaca_tags#cache#get_tempname(self.rootpath(), self.name), '%:p')
endfunction

function! s:TagBuilder.replace_tag2newtag()
  if filereadable(self.tempname())
    call rename(self.tempname(), self.tagname())
  endif
endfunction

function! s:TagBuilder.available()
  return !get(b:, 'alpaca_tags#disable', g:alpaca_tags#disable)
endfunction

function! s:TagBuilder.rootpath()
  if empty(self.path)
    return ''
  else
    return alpaca_tags#filepath#path2project_root(self.path)
  endif
endfunction

function! s:TagBuilder.fmt_rootpath()
  return fnamemodify(self.rootpath(), ':~')
endfunction

function! s:TagBuilder.build()
endfunction

function! s:TagBuilder.exists()
  return filereadable(self.tagname())
endfunction

function! s:TagBuilder.build_option()
  return self.option.build()
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

function! s:available_builders(...)
  let path = expand('%:p')

  let builders = []

  for [name, Builder] in items(s:tag_builders)
    let builder = Builder.new(path, a:000)
    if builder.available()
      call add(builders, builder)
    endif
  endfor

  return builders
endfunction

function! s:current_path()
  let path = expand('%:p')
  if empty(path) || !filereadable(path)
    let path = getcwd()
  endif

  return path
endfunction

function! alpaca_tags#tag_builder#build(name, ...)
  let path = s:current_path()
  let builder = s:tag_builders[a:name].new(path, a:000)

  if builder.available()
    call builder.build()
  endif
endfunction

function! alpaca_tags#tag_builder#build_all(...)
  call map(s:available_builders(a:000), 'v:val.build()')
endfunction

function! alpaca_tags#tag_builder#set_tags()
  for builder in s:available_builders()
    if builder.exists() " tagfile is exists?
      execute 'setl tags+=' . builder.tagname()
    endif
  endfor
endfunction

call alpaca_tags#tag_builder#gemfile#define()
call alpaca_tags#tag_builder#default#define()
