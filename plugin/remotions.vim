" Setting sections:

let g:remotions_version = "0.1"

let g:remotions_debug = 0

if !exists("g:remotions_motions")
  let g:remotions_motions = {
        \ 'TtFf' : {},
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

" let g:remotions_motions = {
"       \ 'TtFf' : {},
"       \ 'para' : { 'backward' : '{', 'forward' : '}' },
"       \ 'sentence' : { 'backward' : '(', 'forward' : ')' },
"       \ 'change' : { 'backward' : 'g,', 'forward' : 'g;', 'direction' : 0 },
"       \ 'class' : { 'backward' : '[[', 'forward' : ']]' },
"       \ 'classend' : { 'backward' : '[]', 'forward' : '][' },
"       \ 'method' : { 'backward' : '[m', 'forward' : ']m' },
"       \ 'methodend' : { 'backward' : '[M', 'forward' : ']M' },
"       \
"       \ 'line' : { 'backward' : 'k', 'forward' : 'j', 'repeat_if_count' : 1, 'repeat_count': 1 },
"       \ 'char' : { 'backward' : 'h', 'forward' : 'l', 'repeat_if_count' : 1, 'repeat_count': 1 },
"       \ 'linescroll' : { 'backward' : '<C-e>', 'forward' : '<C-y>', 'repeat_if_count' : 1, 'repeat_count' : 1, 'direction' : 0 },
"       \ 'charscroll' : { 'backward' : 'zh', 'forward' : 'zl', 'repeat_if_count' : 1, 'repeat_count' : 1, 'direction' : 0 },
"       \ 'word' : { 'backward' : 'b', 'forward' : 'w', 'repeat_count': 1 },
"       \ 'wordend' : { 'backward' : 'ge', 'forward' : 'e', 'repeat_count': 1 },
"       \ 'fullword' : { 'backward' : 'B', 'forward' : 'W', 'repeat_count': 1 },
"       \ 'pos' : { 'backward' : '<C-i>', 'forward' : '<C-o>', 'repeat_count' : 1, 'direction' : 0 },
"       \ 'page' : { 'backward' : '<C-u>', 'forward' : '<C-d>', 'repeat_count' : 1 },
"       \ 'pagefull' : { 'backward' : '<C-b>', 'forward' : '<C-f>', 'repeat_count' : 1},
"       \
"       \ 'vsplit' : { 'backward' : '<C-w><', 'forward' : '<C-w>>', 'direction' : 0 },
"       \ 'hsplit' : { 'backward' : '<C-w>-', 'forward' : '<C-w>+', 'direction' : 0 },
"       \
"       \ 'arg' : { 'backward' : '[a', 'forward' : ']a', 'doc': 'unimpaired' },
"       \ 'buffer' : { 'backward' : '[b', 'forward' : ']b', 'doc': 'unimpaired' },
"       \ 'location' : { 'backward' : '[l', 'forward' : ']l', 'doc': 'unimpaired' },
"       \ 'quickfix' : { 'backward' : '[q', 'forward' : ']q', 'doc': 'unimpaired' },
"       \ 'tag' : { 'backward' : '[t', 'forward' : ']t', 'doc': 'unimpaired' },
"       \
"       \ 'diagnostic' : { 'backward' : '[g', 'forward' : ']g', 'doc': 'coc-diagnostic' },
"       \ }
endif

if !exists("g:remotions_direction")
  " If set to one:
  "   The forward and the backward (';', ',') repetitions are made in the
  "   direction of the document
  " Otherwise (Vim default):
  "   The forward and the backward (';', ',') repetitions are made in the
  "   direction of the original motion (the standard behavior of ';', ',')
  let g:remotions_direction = 0
endif

if !exists("g:remotions_repeat_count")
  " If set to one the count of the original motion will also be repeated
  let g:remotions_repeat_count = 0
endif

" The key associate to the last motion
let g:remotions_family = ''

" The motion backward sequence associated to the last motion or '' if the last
" motion is among 'f', 'F', 't' or 'T'
let g:remotions_backward_plug = ''

" The motion forward sequence associated to the last motion or '' if the last
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

  let motion = {}
  if has_key(g:remotions_motions, g:remotions_family)
    " For the 'TtFf' key there is no guarantee that the motion exist in the
    " g:remotions_motions map
    let motion = g:remotions_motions[g:remotions_family]
  endif

  let repeat_count = g:remotions_repeat_count
  if has_key(motion, 'repeat_count')
    let repeat_count = motion.repeat_count
  endif

  let ret = ''
  if repeat_count && g:remotions_count > 1
    let ret = g:remotions_count
  endif

  if xor(g:remotions_inverted, a:forward)
    if g:remotions_forward_plug != ''
      let ret = ret . g:remotions_forward_plug 
    else
      let ret = "\<Cmd>execute 'normal! "
      if repeat_count && g:remotions_count > 1
        let ret = ret . g:remotions_count
      endif
      let ret = ret . ";'\<CR>"
    endif
  else
    if g:remotions_backward_plug != ''
      let ret = ret . g:remotions_backward_plug
    else
      let ret = "\<Cmd>execute 'normal! "
      if repeat_count && g:remotions_count > 1
        let ret = ret . g:remotions_count
      endif
      let ret = ret . ",'\<CR>"
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

function! s:TtFfMotion(key)
  " Method called when the single char motion are used:
  " - 'f' calls TtFfMotion('f')
  " The method set the variables to be able to replay the motion

  let motion = {}
  if has_key(g:remotions_motions, 'EeFf')
    " For backward compatibility reason the old document key was 'EeFf'
    let motion = g:remotions_motions['EeFf']
  endif
  if has_key(g:remotions_motions, 'TtFf')
    let motion = g:remotions_motions['TtFf']
  endif
  if v:count <= 1 && has_key(motion, 'repeat_if_count') && motion.repeat_if_count == 1
    " Skip the motion with the option 'repeat_if_count' if the count is <= 1
    return
  endif

  let direction = g:remotions_direction
  if has_key(motion, 'direction')
    let direction = motion.direction
  endif

  let g:remotions_family = 'TtFf'
  let g:remotions_backward_plug = '' 
  let g:remotions_forward_plug = ''

  let g:remotions_count = v:count

  let forward = a:key ==# 'f' || a:key ==# 't'
  let g:remotions_inverted = 0
  if !forward && direction
    let g:remotions_inverted = 1
  endif

  return a:key
endfunction

if maparg('f', 'n', 0, 1)->empty()
  nmap <expr> f <SID>TtFfMotion('f')
endif
if maparg('f', 'v', 0, 1)->empty()
  vmap <expr> f <SID>TtFfMotion('f')
endif

if maparg('F', 'n', 0, 1)->empty()
  nmap <expr> F <SID>TtFfMotion('F')
endif
if maparg('F', 'v', 0, 1)->empty()
  vmap <expr> F <SID>TtFfMotion('F')
endif

if maparg('t', 'n', 0, 1)->empty()
  nmap <expr> t <SID>TtFfMotion('t')
endif
if maparg('t', 'v', 0, 1)->empty()
  vmap <expr> t <SID>TtFfMotion('t')
endif

if maparg('T', 'n', 0, 1)->empty()
  nmap <expr> T <SID>TtFfMotion('T')
endif
if maparg('T', 'v', 0, 1)->empty()
  vmap <expr> T <SID>TtFfMotion('T')
endif

" nnoremap <expr> f <SID>TtFfMotion('f')
" nnoremap <expr> F <SID>TtFfMotion('F')
" nnoremap <expr> t <SID>TtFfMotion('t')
" nnoremap <expr> T <SID>TtFfMotion('T')

function! s:CustomMotion(forward, backward_plug, forward_plug, motion_plug, motion_family)
  " Method called when the original motion are used.
  " - ']m' calls CustomMotion(1, "\<Plug>forwardmethod", "\<Plug>backwardmethod")
  " The method set the variables to be able to replay the motion
  "
  if a:forward == 1
    let ret = a:forward_plug
  elseif a:forward == 0
    let ret = a:backward_plug
  elseif a:forward == 2
    let ret = a:motion_plug
  endif

  let motion = g:remotions_motions[a:motion_family]
  if v:count <= 1 && has_key(motion, 'repeat_if_count') && motion.repeat_if_count == 1
    " Skip the motion with the option 'repeat_if_count' if the count is <= 1
    return ret
  endif

  let direction = g:remotions_direction
  if has_key(motion, 'direction')
    let direction = motion.direction
  endif

  " Used to gather more information about the motion
  let g:remotions_family = a:motion_family

  if a:forward
    let g:remotions_backward_plug = a:backward_plug
    let g:remotions_forward_plug = a:forward_plug
  else
    let g:remotions_backward_plug = a:forward_plug
    let g:remotions_forward_plug = a:backward_plug
  endif

  let g:remotions_count = v:count

  let g:remotions_inverted = 0
  if !a:forward && direction
    let g:remotions_inverted = 1
  endif

  return ret
endfunction

function! s:HijackMotion(modes, motion, motion_family)
  " Replace the original motion mapping by a plugged version
  " - A plug motion is created with the original content
  " - The original mapping is deleted
  " - The plug motion is returned
  " Rational: The original motion mapping need to be redirected to an action
  " that store the context

  let mode_count = 0
  for mode in split(a:modes, '\zs')
    let mode_count = mode_count + 1

    let motion_mapping = maparg(a:motion, mode, 0, 1)
    let motion_key = '<Plug>(' . a:motion_family . ')'
    let motion_plug = "\<Plug>(" . a:motion_family . ')'

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

      " The original mapping is deleted if it is buffer mapping
      " in order to avoid the conflict with the new mapping
      " otherwise it is kept since the other buffer should find the original
      " mapping
      if motion_mapping.buffer
        call add(b:deleted_mappings, motion_mapping)
        if motion_mapping.mode == ' ' || motion_mapping.mode == ''
          let cmd = 'unmap '
          if motion_mapping.buffer
            let cmd = cmd . '<buffer> '
          endif
          execute cmd . a:motion
        else
          for mode in split(motion_mapping.mode, '\zs')
            let cmd = mode . 'unmap '
            if motion_mapping.buffer
              let cmd = cmd . '<buffer> '
            endif
            execute cmd . a:motion
          endfor
        endif
      endif

      " The plug is mapped to the original mapping rhs

      " Remark: Copy the original mapping to avoid modifying the backup used for the
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

function! s:HijackMotions(modes, backward, forward, motion, motion_plug, motion_family)
  " Introduce a plugged version of the backward and forward motions
  " Replace the backward and forward motion by
  " a backward and forward motion that use the CustomMotion method
  " that use the plugged version of the motion to execute the original motion

  if a:motion == ''
    let backward_plug = s:HijackMotion(a:modes, a:backward, "backward" . a:motion_family)
    let forward_plug = s:HijackMotion(a:modes, a:forward, "forward" . a:motion_family)

    let motion_plug = ''
  else
    let backward_plug = a:backward
    let forward_plug = a:forward

    let motion_plug = a:motion_plug
    if motion_plug == ''
      let motion_plug = s:HijackMotion(a:modes, a:motion, "motion" . a:motion_family)
    endif
  endif

  for mode in split(a:modes, '\zs')
    if a:motion == ''
      let mapping = {}
      let mapping.lhs = a:backward
      let mapping.mode = mode
      let mapping.buffer = 1
      call add(b:added_mappings, mapping)
      execute mode . 'map <buffer> <silent> <expr> ' . a:backward . " <SID>CustomMotion(0, '" . backward_plug . "', '" . forward_plug . "', '" . motion_plug . "', '" . a:motion_family . "')"

      let mapping = {}
      let mapping.lhs = a:forward
      let mapping.mode = mode
      let mapping.buffer = 1
      call add(b:added_mappings, mapping)
      execute mode . 'map <buffer> <silent> <expr> ' . a:forward . " <SID>CustomMotion(1, '" . backward_plug  . "', '" . forward_plug . "', '" . motion_plug . "', '" . a:motion_family . "')"
    else
      let mapping = {}
      let mapping.lhs = a:motion
      let mapping.mode = mode
      let mapping.buffer = 1
      call add(b:added_mappings, mapping)
      execute mode . 'map <buffer> <silent> <expr> ' . a:motion . " <SID>CustomMotion(2, '" . backward_plug  . "', '" . forward_plug . "', '" . motion_plug . "', '" . a:motion_family . "')"
    endif
  endfor
endfunction

function! RemotionsResetMappings()
  call s:Log('RemotionsResetMappings()')

  " Delete the mapping that have been added:
  if exists("b:added_mappings")
    for mapping in b:added_mappings
      for mode in split(mapping.mode, '\zs')
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

  call s:Log('RemotionsResetMappings() ->')
endfunction

function! s:SetMappings()
  call s:Log("SetMappings()")

  call RemotionsResetMappings()

  for motion_family in keys(g:remotions_motions)
    if motion_family ==# 'TtFf'
      continue
    endif
    let motion = ''
    if has_key(g:remotions_motions[motion_family], 'motion')
      let motion = g:remotions_motions[motion_family].motion
    endif
    let motion_plug = ''
    if has_key(g:remotions_motions[motion_family], 'motion_plug')
      let motion_plug = g:remotions_motions[motion_family].motion_plug
    endif
    call s:HijackMotions('nv', g:remotions_motions[motion_family].backward, g:remotions_motions[motion_family].forward, motion, motion_plug, motion_family)
  endfor

  call s:Log("SetMappings() ->")
endfunction

function s:BufNew()
  " Not working since:
  " - bufnr('%') != expand('<abuf>')
  " - can't switch buffer in this call back
endfunction

function s:BufEnter()
  if &filetype != ''
    return
  endif
  if exists('b:added_mappings')
    return
  endif
  call s:SetMappings()
endfunction

function! s:SetFileType()
  call s:Log("SetFileType()")

  call s:SetMappings()
  if !exists('b:undo_ftplugin')
    let b:undo_ftplugin = ''
  endif
  " Undo the mapping when the filetype is unset
  " Otherwise the RemotionsResetMapping that comes with SetMapping could
  " unset some of the filetype mappings
  let b:undo_ftplugin = 'call RemotionsResetMappings()|' . b:undo_ftplugin

  call s:Log("SetFileType() ->")
endfunction

augroup remotions
  " Make sure the mapping are reset one time per buffer
  " By creating only one callback
  autocmd!
  " autocmd BufNew * call <SID>BufNew()
  autocmd BufEnter * call <SID>BufEnter()
  autocmd FileType * call <SID>SetFileType()
augroup END
