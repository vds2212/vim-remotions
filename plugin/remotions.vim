" Setting sections:

let g:remotions_version = "0.1"

let g:remotions_debug = 0

        " \ 'line' : { 'backward' : 'k', 'forward' : 'j' },
        " \ 'word' : { 'backward' : 'b', 'forward' : 'w' },
        " \ 'fullword' : { 'backward' : 'B', 'forward' : 'W' },
        " \ 'wordend' : { 'backward' : 'ge', 'forward' : 'e' },
        " \ 'cursor' : { 'backward' : 'h', 'forward' : 'l' },
        " \ 'pos' : { 'backward' : '<C-i>', 'forward' : '<C-o>' },
        " \ 'page' : { 'backward' : '<C-u>', 'forward' : '<C-d>' },
        " \ 'pagefull' : { 'backward' : '<C-b>', 'forward' : '<C-f>' },

if !exists("g:remotions_motions")
  let g:remotions_motions = {
        \ 'para' : { 'backward' : '{', 'forward' : '}' },
        \ 'sentence' : { 'backward' : '(', 'forward' : ')' },
        \ 'change' : { 'backward' : 'g,', 'forward' : 'g;' },
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

if !exists("g:remotions_repeatcount")
  " If set to one the count of the original motion will also be repeated
  let g:remotions_repeatcount = 0
endif

" The document backward sequence associated to the last motion or '' if the last
" motion is among 'f', 'F', 't' or 'T'
let g:remotions_backward_plug = ''

" The document forward sequence associated to the last motion or '' if the last
" motion is among 'f', 'F', 't' or 'T'
let g:remotions_forward_plug = ''

" Set to 1 if the document forward motion is not the forward motion
let g:remotions_inverted = 0

" Keep the count of the original motion
let g:remotions_count = 0

function! s:Log(message)
  if g:remotions_debug
    echom a:message
  endif
endfunction

function! s:RepeatMotion(forward)
  " Method called when the motion repetition are used:
  " - ';' calls RepeatMotion(1)
  " - ',' calls RepeatMotion(0)

  call s:Log('RepeatMotion(' . a:forward . ')')

  let ret = ""
  if xor(g:remotions_inverted, a:forward)
    if g:remotions_forward_plug != ''
      let ret = g:remotions_forward_plug 
    else
      let ret = "\<Cmd>execute 'normal! ;'\<CR>"
    endif
  else
    if g:remotions_backward_plug != ''
      let ret = g:remotions_backward_plug
    else
      let ret = "\<Cmd>execute 'normal! ,'\<CR>"
    endif
  endif

  call s:Log('RepeatMotion(' . a:forward . ') -> ' . ret)
  return ret
endfunction

nmap <silent> <expr> ; <SID>RepeatMotion(1)
vmap <silent> <expr> ; <SID>RepeatMotion(1)

nmap <silent> <expr> , <SID>RepeatMotion(0)
vmap <silent> <expr> , <SID>RepeatMotion(0)

" nnoremap <silent> <expr> ; <SID>RepeatMotion(1) " vim9
" nnoremap <silent> <expr> , <SID>RepeatMotion(0) " vim9

function! s:EeFfMotion(key)
  " Method called when the single char motion are used:
  " - 'f' calls EeFfMotion('f')
  " The method set the variable to be able to replay the motion

  let g:remotions_backward_plug = '' 
  let g:remotions_forward_plug = ''

  let g:remotions_count = v:count

  let forward = a:key ==# 'f' || a:key ==# 't'
  let g:remotions_inverted = 0
  if !forward && g:remotions_direction
    let g:remotions_inverted = 1
  endif

  return a:key
endfunction

nmap <expr> f <SID>EeFfMotion('f')
vmap <expr> f <SID>EeFfMotion('f')

nmap <expr> F <SID>EeFfMotion('F')
vmap <expr> F <SID>EeFfMotion('F')

nmap <expr> t <SID>EeFfMotion('t')
vmap <expr> t <SID>EeFfMotion('t')

nmap <expr> T <SID>EeFfMotion('T')
vmap <expr> T <SID>EeFfMotion('T')

" nnoremap <expr> f <SID>EeFfMotion('f')
" nnoremap <expr> F <SID>EeFfMotion('F')
" nnoremap <expr> t <SID>EeFfMotion('t')
" nnoremap <expr> T <SID>EeFfMotion('T')

function! s:CustomMotion(forward, backward_plug, forward_plug)
  " Method called when the original motion are used.
  " - ']m' calls CustomMotion(1, "\<Plug>forwardmethod", "\<Plug>backwardmethod")
  " The method set the variable to be able to replay the motion

  if a:forward
    let g:remotions_backward_plug = a:backward_plug
    let g:remotions_forward_plug = a:forward_plug
  else
    let g:remotions_backward_plug = a:forward_plug
    let g:remotions_forward_plug = a:backward_plug
  endif

  let g:remotions_count = v:count

  let g:remotions_inverted = 0
  if !a:forward && g:remotions_direction
    let g:remotions_inverted = 1
  endif

  if a:forward
    return a:forward_plug
  else
    return a:backward_plug
endfunction

function! s:HijackMotion(modes, motion, key)
  " Replace the motion mapping from motion to a plugged version
  " Return the plug used to replace it

  let mode_count = 0
  for mode in a:modes
    let mode_count = mode_count + 1

    let motion_mapping = maparg(a:motion, mode, 0, 1)
    let motion_key = '<Plug>(' . a:key . ')'
    let motion_plug = "\<Plug>(" . a:key . ')'

    if len(motion_mapping) == 0
      " There is no mapping for that motion
      " The plug is mapped to the motion itself

      let mapping = {}
      let mapping.lhs = motion_key
      let mapping.mode = mode
      let mapping.buffer = 1
      call add(b:added_mappings, mapping)
      let cmd = mode . 'noremap <buffer> <silent> ' . motion_key . ' ' . a:motion
      execute cmd
    else
      " There is a mapping for the motion

      " The original mapping is deleted
      call add(b:deleted_mappings, motion_mapping)
      if motion_mapping.mode == ' ' || motion_mapping.mode == ''
        let cmd = 'unmap '
        if motion_mapping.buffer
          let cmd = cmd . '<buffer> '
        endif
        execute cmd . a:motion
      else
        for mode in motion_mapping.mode
          let cmd = mode . 'unmap '
          if motion_mapping.buffer
            let cmd = cmd . '<buffer> '
          endif
          execute cmd . a:motion
        endfor
      endif

      " The plug is mapped to the original mapping rhs

      " Remark: Copy the mapping to avoid modifying the backup used for the
      " reset of the mapping
      let motion_mapping = copy(motion_mapping)
      let motion_mapping.lhs = motion_key
      let motion_mapping.lhsraw = motion_plug
      let motion_mapping.buffer = 1

      if motion_mapping.mode == ' ' || motion_mapping.mode == ''
        call add(b:added_mappings, motion_mapping)
        call mapset(motion_mapping.mode, 0, motion_mapping)
        break
      else
        let motion_mapping.mode = mode
        call add(b:added_mappings, motion_mapping)
        call mapset(mode, 0, motion_mapping)
      endif
      " call mapset(motion_mapping) " vim9
    endif
  endfor

  return motion_plug
endfunction

function! s:HijackMotions(modes, backward, forward, key)
  " Introduce a plugged version of the backward and forward mapping
  " Replace the backward and forward mapping by
  " a backward and forward mapping that use the CustomMotion method
  " that use the plugged version of the mapping to make the original motion

  let backward_plug = s:HijackMotion(a:modes, a:backward, "backward" . a:key)
  let forward_plug = s:HijackMotion(a:modes, a:forward, "forward" . a:key)

  for mode in a:modes
    let mapping = {}
    let mapping.lhs = a:backward
    let mapping.mode = mode
    let mapping.buffer = 1
    call add(b:added_mappings, mapping)
    execute mode . 'map <buffer> <silent> <expr> ' . a:backward . " <SID>CustomMotion(0, '" . backward_plug . "', '" . forward_plug . "')"

    let mapping = {}
    let mapping.lhs = a:forward
    let mapping.mode = mode
    let mapping.buffer = 1
    call add(b:added_mappings, mapping)
    execute mode . 'map <buffer> <silent> <expr> ' . a:forward . " <SID>CustomMotion(1, '" . backward_plug  . "', '" . forward_plug . "')"
  endfor
endfunction

function! s:ResetMappings()
  call s:Log('ResetMappings()')
  " Delete the mapping that have been added:
  if exists("b:added_mappings")
    for mapping in b:added_mappings
      for mode in mapping.mode
        if mode ==# 'o'
          continue
        endif
        let cmd = mode . 'unmap '
        if mapping.buffer == 1
          let cmd = cmd . '<buffer> '
        endif
        let cmd = cmd . mapping.lhs
        call s:Log('  ' . cmd)
        execute cmd
      endfor
    endfor
  endif
  let b:added_mappings = []

  " Restore the mapping that have been deleted:
  if exists("b:deleted_mappings")
    for mapping in b:deleted_mappings
      call mapset(mapping.mode, 0, mapping)
      " call mapset(mapping) " vim9
    endfor
  endif
  let b:deleted_mappings = []
  call s:Log('ResetMappings() ->')
endfunction

function! s:SetMappings()
  if exists("b:added_mappings") || exists("b:deleted_mappings")
    call s:ResetMappings()
  else
    " List of the buffer mappings that have been added:
    let b:added_mappings =  []

    " List of the buffer mapping that have been deleted:
    let b:deleted_mappings = []
  endif

  for name in keys(g:remotions_motions)
    call s:HijackMotions('nv', g:remotions_motions[name].backward, g:remotions_motions[name].forward, name)
  endfor
endfunction

autocmd BufRead,BufNew * call <SID>SetMappings()
autocmd FileType * call <SID>SetMappings()

