let s:action_table = {}
let s:kind = {
      \ 'name' : 'tags',
      \ 'action_table' : s:action_table,
      \ 'default_action' : 'open_tag',
      \ }

function! unite#kinds#tags#define() "{{{
  return s:kind
endfunction"}}}

let s:action_table.open_tag = { 'description': 'open_tag'}
function! s:action_table.open_tag.func(candidate) "{{{
  return unite#kinds#tags#open(a:candidate)
endfunction"}}}

function! unite#kinds#tags#open(candidate) "{{{
  call alpaca_tags#tags_history#append(a:candidate)

  let jump_list = unite#kinds#jump_list#define()
  call jump_list.action_table.open.func([a:candidate])
endfunction"}}}
