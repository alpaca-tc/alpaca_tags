"=============================================================================
" FILE: tags.vim
" AUTHOR: Ishii Hiroyuki <alprhcp666@gmail.com>
" Last Modified: 2013-07-21
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================
" Define source {{{
let s:source = {
      \ 'name': 'tags',
      \ 'action_table': {},
      \ 'hooks': {},
      \ 'is_volatile': 1,
      \ 'syntax': 'uniteSource__Tag',
      \ 'max_candidates' : 100,
      \ 'converters': 'converter_relative_word'
      \}
let s:caching = {}

function! unite#sources#tags#define() "{{{
  return has('ruby') ? s:source : {}
endfunction"}}}

function! s:source.hooks.on_syntax(args, context) "{{{
  syntax match uniteSource__Tag_File /  @.\{-}  /ms=s+2,me=e-2 containedin=uniteSource__Tag contained nextgroup=uniteSource__Tag_Pat,uniteSource__Tag_Line skipwhite
  syntax match uniteSource__Tag_Pat /pat:.\{-}\ze\s*$/ contained
  syntax match uniteSource__Tag_Line /line:.\{-}\ze\s*$/ contained
  highlight default link uniteSource__Tag_File Type
  highlight default link uniteSource__Tag_Pat Special
  highlight default link uniteSource__Tag_Line Constant
endfunction"}}}

function! s:source.hooks.on_init(args, context) "{{{
  call alpaca_tags#ruby#initialize()
endfunction"}}}

function! s:source.gather_candidates(args, context) "{{{
  let input_list = split(substitute(a:context.input, '^\s*', '', 'g'))
  let input = empty(a:context.input) ? '' : input_list[0]

  let cache = s:use_cache(input)
  if !empty(cache)
    return cache
  endif

  if len(input) < 3 
    return [{ 'word' : '', 'abbr' : 'You should input more than 3 characters', 'is_dummy' : 1 }]
  endif

  let match_tags = taglist(input)
  if type(match_tags) == type(0)
    return [{'word' : 'Not Found!', 'is_dummy' : 1}]
  endif

  " Checking cache
  let candidates = s:candidates_from_taglist(a:args, a:context)
  " let candidates = s:candidates_from_cache(a:args, a:context)
  echo 'Create new taglist'

  if len(candidates) < s:source.max_candidates
    echo 'Save cache : key is ' . input
    let s:caching[input] = deepcopy(candidates)
  endif

  return candidates
endfunction"}}}
"}}}

function! s:use_cache(input) "{{{
  let input = a:input

  if !empty(input)
    for key in keys(s:caching)
      if input =~ key
        echo 'Use cache : key is ' . key
        return deepcopy(s:caching[key])
      endif
    endfor
  endif

  return 0
endfunction"}}}

function! s:candidates_from_taglist(args, context) "{{{
  return s:taglist2candidates(a:args, a:context)
endfunction"}}}

function! s:taglist2candidates(args, context) "{{{
  let input = s:context2input(a:context)
  let match_tags = taglist(input)

  ruby << EOF
  max_candidates = VIM.get('s:source')['max_candidates']
  match_tags = VIM.get('match_tags')

  candidates = match_tags.lazy.map { |tag|
    method = tag['class'].nil? ? tag['name'] : "#{tag['class']}##{tag['name']}"
    filename_len = tag['filename'].length

    /(?<filename>.{,60})$/ =~ tag['filename']
    abbr_command = tag['cmd'] ? tag['cmd'].gsub(/\/\^\s+/, '') : ''
    abbr = sprintf('%s  @%s  %s', tag['name'], filename, "pat: #{abbr_command}" )

    command = tag['cmd']
    linenr, pattern = 0, ''
    if command =~ /^\d\+$/
      linenr = command - 0
    else
      pattern = command
      # remove / or ? at the head and the end
      pattern.gsub!(/^([\/?])?(.*)\1$/, '\2')
      # unescape /
      pattern.gsub!(/\//, '\\/')
      # use 'nomagic'
      pattern = '\M' + pattern
    end

    candidate = {
      word: tag['name'],
      abbr: abbr.to_s,
      kind: 'jump_list',
      action__path: tag['filename'].to_s,
      action__directory: File.dirname(tag['filename']).to_s,
      action__tagname: tag['name'].to_s,
      unite__source_kind: tag['kind'].to_s,
    }

    if linenr != 0
      candidate['action__line'] = linenr
    else
      candidate['action__pattern'] = pattern
    end

    candidate
  }.first(max_candidates)

  VIM.let('candidates', candidates)
EOF

  return candidates
endfunction"}}}

function! s:context2input(context) "{{{
  let input_list = split(substitute(a:context.input, '^\s*', '', 'g'))
  return empty(a:context.input) ? '' : input_list[0]
endfunction"}}}

" No used...
function! s:candidates_from_cache(args, context) "{{{
  let exist_tags = alpaca_tags#tag#exist_tags()
  let cache_key = string(exist_tags)

  if has_key(s:caching, cache_key)
    return s:caching[cache_key]
  endif

  let cacher = alpaca_tags#cache#new('')
  let candidates = []
  for tag in exist_tags
    let tags = cacher.read(tag)
    call extend(candidates, tags)
  endfor

  let s:caching[cache_key] = candidates
  return candidates
endfunction"}}}
