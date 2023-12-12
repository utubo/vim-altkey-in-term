let s:save_keys = []
let s:keys = []
let s:mode = 'n'
let s:timer = 0

function! altkey_in_term#Timeout(timer) abort
  for k in s:keys
    silent! execute $'{s:mode}unmap {k}'
  endfor
  for s in s:save_keys
    if !empty(s)
      call mapset(s)
    endif
  endfor
  let s:save_keys = []
  if a:timer ==# 0
    call timer_stop(s:timer)
  else
    call feedkeys("\<Esc>", 'nit')
    if exists('#User#AltkeyInTermEsc')
      doautocmd User AltkeyInTermEsc
    endif
  endif
endfunction

function! altkey_in_term#Alt() abort
  let do_save = empty(s:save_keys)
  let s:mode = mode()->substitute('v', 'x', '')
  let s:keys = g:altkey_in_term_keys->split('.\zs')
  for k in s:keys
    if do_save
      let s:save_keys += [maparg(k, s:mode, 0, 1)]
    endif
    execute $'{s:mode}map {k} <Cmd>call altkey_in_term#Timeout(0)<CR><A-{k}>'
  endfor
  let s:timer = timer_start(g:altkey_in_term_timeout, 'altkey_in_term#Timeout')
endfunction

