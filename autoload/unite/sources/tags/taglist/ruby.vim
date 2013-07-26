function! unite#sources#tags#taglist#ruby#tag2candidate(tag, filename_length) 
  call alpaca_tags#ruby#initialize()

  ruby << EOF
  tag = VIM.get('a:tag')
  filename_length = VIM.get('a:filename_length')

  method = tag['class'].nil? ? tag['name'] : "#{tag['class']}##{tag['name']}"

  # TODO Why don't run this code?
  # %r!(?<filename>.{,#{filename_length}})$! =~ tag['filename']
  %r!(?<filename>.{,60})$! =~ tag['filename']
  abbr_command = tag['cmd'] ? tag['cmd'].gsub(/\/\^\s+/, '') : ''
  abbr = sprintf('%s  @%s  %s', tag['name'], filename, "pat: #{abbr_command}" )

  candidate = {
    word: "#{tag['name']} #{tag['filename'].to_s}" ,
    abbr: abbr.to_s,
    kind: 'jump_list',
    action__path: tag['filename'].to_s,
    action__directory: File.dirname(tag['filename']).to_s,
    action__tagname: tag['name'].to_s,
    unite__source_kind: tag['kind'].to_s,
  }

  command = tag['cmd']
  linenr, pattern = 0, ''
  if command =~ /^\d\+$/
    linenr = command - 0
    candidate['action__line'] = linenr
  else
    pattern = command
    # remove / or ? at the head and the end
    pattern.gsub!(/^([\/?])?(.*)\1$/, '\2')
    # unescape /
    pattern.gsub!(/\//, '\\/')
    # use 'nomagic'
    pattern = '\M' + pattern
    candidate['action__pattern'] = pattern
  end

  VIM.let('candidate', candidate)
EOF

  return candidate
endfunction
