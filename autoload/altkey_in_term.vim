let s:save_keys = []
let s:save_escs = {}
let s:keys = []
let s:mode = 'n'
let s:timer = 0

function! s:Mapset(m) abort
  if !empty(a:m)
    call mapset(a:m)
  endif
endfunction

function! altkey_in_term#Map(timer = 0) abort
  let do_save = empty(s:save_escs)
  for m in g:altkey_in_term_mode->split('.\zs')
    if do_save
      let s:save_escs[m] = maparg('<ESC>', m, 0, 1)
    endif
    execute $'{m}noremap <script> <Esc> <ScriptCmd>call altkey_in_term#Alt()<CR>'
  endfor
endfunction

function! altkey_in_term#Timeout(timer = 0) abort
  for k in s:keys
    silent! execute $'{s:mode}unmap {k}'
  endfor
  for s in s:save_keys
    call s:Mapset(s)
  endfor
  let s:save_keys = []
  if a:timer ==# 0
    call timer_stop(s:timer)
  else
    silent! execute $'{s:mode}unmap <ESC>'
    call s:Mapset(s:save_escs[s:mode])
    call feedkeys("\<Esc>", 'it')
    call timer_start(g:altkey_in_term_timeout, 'altkey_in_term#Map')
  endif
endfunction

function! altkey_in_term#Alt() abort
  let do_save = empty(s:save_keys)
  let s:mode = mode()->substitute('[vV]', 'x', '')
  let s:keys = g:altkey_in_term_keys->split('.\zs')
  for k in s:keys
    if do_save
      let s:save_keys += [maparg(k, s:mode, 0, 1)]
    endif
    execute $'{s:mode}map {k} <Cmd>call altkey_in_term#Timeout()<CR><A-{k}>'
  endfor
  let s:timer = timer_start(g:altkey_in_term_timeout, 'altkey_in_term#Timeout')
endfunction

