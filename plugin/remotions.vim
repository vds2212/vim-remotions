" Setting sections:

        " \ 'sentence' : { 'backward' : '(', 'forward' : ')' },
        " \ 'word' : { 'backward' : 'b', 'forward' : 'w' },
        " \ 'fullword' : { 'backward' : 'B', 'forward' : 'W' },
        " \ 'wordend' : { 'backward' : 'ge', 'forward' : 'e' },
        " \ 'line' : { 'backward' : 'k', 'forward' : 'j' },
        " \ 'cursor' : { 'backward' : 'h', 'forward' : 'l' },
        " \ 'change' : { 'backward' : 'g,', 'forward' : 'g;' },
        " \ 'pos' : { 'backward' : '<C-i>', 'forward' : '<C-o>' },
        " \ 'page' : { 'backward' : '<C-u>', 'forward' : '<C-d>' },
        " \ 'pagefull' : { 'backward' : '<C-b>', 'forward' : '<C-f>' },

if !exists("g:remotions_motions")
  let g:remotions_motions = {
        \ 'para' : { 'backward' : '{', 'forward' : '}' },
        \ 'class' : { 'backward' : '[[', 'forward' : ']]' },
        \ 'classend' : { 'backward' : '[]', 'forward' : '][' },
        \ 'method' : { 'backward' : '[m', 'forward' : ']m' },
        \ 'methodend' : { 'backward' : '[M', 'forward' : ']M' },
        \
        \ 'arg' : { 'backward' : '[a', 'forward' : ']a', 'doc': 'unimpaired' },
        \ 'buffer' : { 'backward' : '[b', 'forward' : ']b', 'doc': 'unimpaired' },
        \ 'location' : { 'backward' : '[l', 'forward' : ']l', 'doc': 'unimpaired' },
        \ 'quickfix' : { 'backward' : '[q', 'forward' : ']q', 'doc': 'unimpaired' },
        \ 'tag' : { 'backward' : '[t', 'forward' : ']t', 'doc': 'unimpaired' },
        \
        \ 'diagnostic' : { 'backward' : '[g', 'forward' : ']g', 'doc': 'coc-diagnostic' },
        \ }
endif

if !exists("g:remotions_direction")
  " If set to one:
  "   The forward and the backward (';', ',') repetitions are made in the
  "   direction of the document
  " Otherwise:
  "   The forward and the backward (';', ',') repetitions are made in the
  "   direction of the original motion (the standard behavior of ';', ',')
  let g:remotions_direction = 1
endif

if !exists("g:remotions_count")
  " If set to one the count of the original motion will also be repeated
  let g:remotions_count = 0
endif

" The document backward sequence associated to the last move or '' if the last
" move is among 'f', 'F', 't' or 'T'
let g:remotions_backward_plug = ''

" The document forward sequence associated to the last move or '' if the last
" move is among 'f', 'F', 't' or 'T'
let g:remotions_forward_plug = ''

" Set to 1 if the document forward move is not the forward move
let g:remotions_inverted = 0

" Keep the count of the original movement
let g:remotions_n = 0


function! s:RepeatMotion(forward)
  " Method called when the motion repetition are used:
  " - ';' calls RepeatMotion(1)
  " - ',' calls RepeatMotion(0)

  let ret = ""
  echom "a:forward" a:forward
  if xor(g:remotions_inverted, a:forward)
    if g:remotions_forward_plug != ''
      let ret = g:remotions_forward_plug 
    else
      let ret = ":silent normal! ;\<CR>"
    endif
  else
    if g:remotions_backward_plug != ''
      let ret = g:remotions_backward_plug
    else
      let ret = ":silent normal! ,\<CR>"
    endif
  endif
  return ret
endfunction

nnoremap <silent> <expr> ; <SID>RepeatMotion(1)
nnoremap <silent> <expr> , <SID>RepeatMotion(0)

function! s:EeFfMotion(key)
  " Method called when the single char motion are used:
  " - 'f' calls EeFfMotion('f')
  let g:remotions_backward_plug = '' 
  let g:remotions_forward_plug = ''

  let forward = a:key ==# 'f' || a:key ==# 't'
  let g:remotions_inverted = 0
  if !forward && g:remotions_direction
    let g:remotions_inverted = 1
  endif

  return a:key
endfunction

nnoremap <expr> f <SID>EeFfMotion('f')
nnoremap <expr> F <SID>EeFfMotion('F')
nnoremap <expr> t <SID>EeFfMotion('t')
nnoremap <expr> T <SID>EeFfMotion('T')

function! CustomMotion(forward, backward_plug, forward_plug)
  if a:forward
    let g:remotions_backward_plug = a:backward_plug
    let g:remotions_forward_plug = a:forward_plug
  else
    let g:remotions_backward_plug = a:forward_plug
    let g:remotions_forward_plug = a:backward_plug
  endif

  let g:remotions_inverted = 0
  if !a:forward && g:remotions_direction
    let g:remotions_inverted = 1
  endif

  if a:forward
    return a:forward_plug
  else
    return a:backward_plug
endfunction

function! s:HijackMotion(move, key)
  " Replace the motion mapping from move to a plugged version
  " Return the plug used to replace it

  let move_mapping = maparg(a:move, 'n', 0, 1)
  let move_key = '<Plug>(' .. a:key .. ')'
  let move_plug = "\<Plug>(" .. a:key .. ')'

  if len(move_mapping) == 0
    let mapping = {}
    let mapping.lhs = move_key
    let mapping.mode = 'n'
    let mapping.buffer = 1
    call add(b:added_mappings, mapping)
    let cmd = 'nnoremap <buffer> <silent> ' .. move_key .. ' ' .. a:move
    execute cmd
  else
    call add(b:deleted_mappings, move_mapping)
    let cmd = 'nunmap '
    if move_mapping.buffer
      let cmd = cmd .. '<buffer> '
    endif
    execute cmd .. a:move

    " Copy the mapping before deleting it:
    let move_mapping = copy(move_mapping)

    let move_mapping.lhs = move_key
    let move_mapping.lhsraw = move_plug
    let move_mapping.buffer = 1
    call add(b:added_mappings, move_mapping)
    call mapset(move_mapping)
  endif

  return move_plug
endfunction

function! s:HijackMotions(backward, forward, key)
  " Introduce a plugged version of the backward and forward mapping
  " Replace the backward and forward mapping by
  " a backward and forward mapping that use the CustomMotion method
  " that use the plugged version of the mapping to make the original move

  let backward_plug = s:HijackMotion(a:backward, "backward" .. a:key)
  let forward_plug = s:HijackMotion(a:forward, "forward" .. a:key)

  let mapping = {}
  let mapping.lhs = a:backward
  let mapping.mode = 'n'
  let mapping.buffer = 1
  call add(b:added_mappings, mapping)
  execute 'nmap <buffer> <silent> <expr> ' .. a:backward .. " CustomMotion(0, '" .. backward_plug .. "', '" .. forward_plug .. "')"

  let mapping = {}
  let mapping.lhs = a:forward
  let mapping.mode = 'n'
  let mapping.buffer = 1
  call add(b:added_mappings, mapping)
  execute 'nmap <buffer> <silent> <expr> ' .. a:forward .. " CustomMotion(1, '" .. backward_plug  .. "', '" .. forward_plug .. "')"
endfunction

function! s:ResetMappings()
  " Delete the mapping that have been added:
  if exists("b:added_mappings")
    for mapping in b:added_mappings
      let cmd = mapping.mode .. 'unmap '
      if mapping.buffer == 1
        let cmd = cmd .. '<buffer> '
      endif
      let cmd = cmd .. mapping.lhs
      execute cmd
    endfor
  endif
  let b:added_mappings = []

  " Restore the mapping that have been deleted:
  if exists("b:deleted_mappings")
    for mapping in b:deleted_mappings
      call mapset(mapping)
    endfor
  endif
  let b:deleted_mappings = []
endfunction

function! s:SetMappings()
  if exists("b:added_mappings") || exists("b:deleted_mappings")
    call ResetMappings()
  else
    " List of the buffer mappings that have been added:
    let b:added_mappings =  []

    " List of the buffer mapping that have been deleted:
    let b:deleted_mappings = []
  endif

  for name in keys(g:remotions_motions)
    call s:HijackMotions(g:remotions_motions[name].backward, g:remotions_motions[name].forward, name)
  endfor
endfunction

autocmd BufRead,BufNew * call <SID>SetMappings()
autocmd FileType * call <SID>SetMappings()

