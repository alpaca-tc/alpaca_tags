function! alpaca_tags#util#current_git() "{{{
  if !exists('s:git_root_cache')
    call alpaca_tags#util#clean_current_git_cache()
  endif

  let current_dir = getcwd()
  if !has_key(s:git_root_cache, current_dir)
    let git_root = system("git rev-parse --show-toplevel")
    if git_root =~ "fatal: Not a git repository"
      " throw "No a git repository."
      return 0
    endif

    let s:git_root_cache[current_dir] = substitute(git_root, '\n', '', 'g')
  endif

  return s:git_root_cache[current_dir]
endfunction"}}}
function! alpaca_tags#util#clean_current_git_cache()
  let s:git_root_cache = {}
endfunction

function! alpaca_tags#util#filetype() "{{{
  if empty(&filetype) | return '' | endif

  return split( &filetype, '\.' )[0]
endfunction"}}}

function! alpaca_tags#util#system(command, args, message) "{{{
  let ctags_path = '--ctags_path '.g:alpaca_tags_ctags_bin
  let args = '--ctags_args "'.a:args.'"'
  let command = join([a:command, args, ctags_path], ' ')

  if g:alpaca_tags_print_to_console['debug']
    echomsg printf('Execute command: %s', command)
  endif

  if g:alpaca_tags_print_to_console['created/updated tags']
    return s:Watch.new(vimproc#popen2(command), a:message)
  else
    return vimproc#system_bg(command)
  endif
endfunction"}}}

" Watching process"{{{
let s:Watch = {}
let s:watch_list = {}

function! s:get_augroup(pid) "{{{
  return 'TagsWatchProcessPid' . a:pid
endfunction"}}}

function! s:Watch.new(process, message) "{{{
  let instance = deepcopy(self)
  call instance.constructor(a:process, a:message)
  call remove(instance, 'new')
  call remove(instance, 'constructor')

  return instance
endfunction"}}}

function! s:Watch.constructor(process, message) "{{{
  let s:watch_list[a:process.pid] = self
  let self.process = a:process
  let self.message = a:message
  let self.pid = self.process.pid
  let self.augroup_name = s:get_augroup(self.pid)
  execute 'augroup' self.augroup_name
  call self.start()
endfunction"}}}

function! s:Watch.start() "{{{
  let self.start_time = reltime()
  execute 'autocmd ' self.augroup_name ' CursorHold * call s:Watch.check('.self.pid.')'
endfunction"}}}

function! s:Watch.done() "{{{
  call self.remove_autocmd(self.pid)
  call unite#sources#tags#taglist#clean_cache()
  echomsg self.message
endfunction"}}}

function! s:Watch.remove_autocmd(pid) "{{{
  execute 'autocmd!' s:get_augroup(a:pid)
  execute 'augroup!' s:get_augroup(a:pid)
endfunction"}}}

let g:watch_list = s:watch_list
function! s:Watch.check(pid) "{{{
  let pid = a:pid

  if has_key(s:watch_list, pid)
    let instance = s:watch_list[pid]
    let [status, code] =  instance.process.checkpid()

    if status != 'run'
      call instance.done()
      call remove(s:watch_list, pid)
      call instance.process.waitpid()
    " elseif status == 'error'
    " elseif status == 'exit'
    endif
  else
    call self.remove_autocmd(pid)
    call remove(s:watch_list, pid)
    throw 'Not found process:' . pid
  endif
endfunction"}}}
"}}}
