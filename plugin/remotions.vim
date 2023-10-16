" Setting sections:
if !exists("g:remotions_direction")
  " If set to one the forward and the backward (';', ',') repetitions are made in the
  " direction of the document
  " Otherwise the forward and the backward (';', ',') repetitions are made in
  " the direction of the original move (the standard behavior of ';', ',')
  let g:remotions_direction = 1
endif

if !exists("g:remotions_moves")
  let g:remotions_moves = {
        \ 'para' : { 'backward' : '{', 'forward' : '}' },
        \ 'class' : { 'backward' : '[[', 'forward' : ']]' },
        \ 'method' : { 'backward' : '[m', 'forward' : ']m' },
        \ 'Method' : { 'backward' : '[M', 'forward' : ']M' },
        \ 'quickfix' : { 'backward' : '[q', 'forward' : ']q' },
        \ }
endif

" The document forward sequence associated to the last move or '' if the last
" move is among 'f', 'F', 't' or 'T'
let g:remotions_forward_plug = ''

" The document backward sequence associated to the last move or '' if the last
" move is among 'f', 'F', 't' or 'T'
let g:remotions_backward_plug = ''

" Set to 1 if the document forward move is not the forward move
let g:remotions_inverted = 0


function! s:RepeatMove(forward)
  let ret = ""
  if xor(a:forward, g:remotions_inverted)
    if g:remotions_forward_plug != ''
      let ret = g:remotions_forward_plug 
    else
      " let ret = "<cmd>normal! ;\<CR>"
      let ret = ":silent normal! ;\<CR>"
    endif
  else
    if g:remotions_backward_plug != ''
      let ret = g:remotions_backward_plug
    else
      " let ret = "<cmd>normal! ,\<CR>"
      let ret = ":silent normal! ,\<CR>"
    endif
  endif
  return ret
endfunction

nnoremap <silent> <expr> ; <SID>RepeatMove(1)
nnoremap <silent> <expr> , <SID>RepeatMove(0)

function! s:StandardMove(key)
  let g:remotions_backward_plug = '' 
  let g:remotions_forward_plug = ''

  let forward = a:key ==# 'f' || a:key ==# 't'
  let g:remotions_inverted = 0
  if !forward && g:remotions_direction
    let g:remotions_inverted = 1
  endif

  return a:key
endfunction

nnoremap <expr> f <SID>StandardMove('f')
nnoremap <expr> F <SID>StandardMove('F')
nnoremap <expr> t <SID>StandardMove('t')
nnoremap <expr> T <SID>StandardMove('T')

function! CustomMove(forward, backward_plug, forward_plug)
  let g:remotions_forward_plug = a:forward_plug
  let g:remotions_backward_plug = a:backward_plug

  let g:remotions_inverted = 0
  if !a:forward && g:remotions_direction
    let g:remotions_inverted = 1
  endif

  if a:forward
    return a:forward_plug
  else
    return a:backward_plug
endfunction

function! s:HijackMove(move, key)
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

function! s:HijackMoves(backward, forward, key)
  let backward_plug = s:HijackMove(a:backward, "backward" .. a:key)
  let forward_plug = s:HijackMove(a:forward, "forward" .. a:key)

  let mapping = {}
  let mapping.lhs = a:backward
  let mapping.mode = 'n'
  let mapping.buffer = 1
  call add(b:added_mappings, mapping)
  execute 'nmap <buffer> <silent> <expr> ' .. a:backward .. " CustomMove(0, '" .. backward_plug .. "', '" .. forward_plug .. "')"

  let mapping = {}
  let mapping.lhs = a:forward
  let mapping.mode = 'n'
  let mapping.buffer = 1
  call add(b:added_mappings, mapping)
  execute 'nmap <buffer> <silent> <expr> ' .. a:forward .. " CustomMove(1, '" .. backward_plug  .. "', '" .. forward_plug .. "')"
endfunction

function! ResetMappings()
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

function! SetMappings()
  if exists("b:added_mappings") || exists("b:deleted_mappings")
    call ResetMappings()
  else
    " List of the buffer mappings that have been added:
    let b:added_mappings =  []

    " List of the buffer mapping that have been deleted:
    let b:deleted_mappings = []
  endif

  for name in keys(g:remotions_moves)
    call s:HijackMoves(g:remotions_moves[name].backward, g:remotions_moves[name].forward, name)
  endfor
  " call s:HijackMoves('[[', ']]', 'class')
  " call s:HijackMoves('{', '}', 'para')
endfunction

autocmd BufRead,BufNew * call SetMappings()
autocmd FileType * call SetMappings()

