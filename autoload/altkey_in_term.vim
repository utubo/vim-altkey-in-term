let s:save_keys = []
let s:timer = 0

function! altkey_in_term#Timeout(timer) abort
  let keys = g:altkey_in_term_keys->split('.\zs')
  for m in g:altkey_in_term_mode->split('.\zs')
    for k in keys
      silent! execute $'{m}unmap {k}'
    endfor
  endfor
  for m in s:save_keys
    if !empty(m)
      call mapset(m)
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
  let keys = g:altkey_in_term_keys->split('.\zs')
  for m in g:altkey_in_term_mode->split('.\zs')
    for k in keys
      if do_save
        let s:save_keys += [maparg(k, m, 0, 1)]
      endif
      execute $'{m}map {k} <Cmd>call altkey_in_term#Timeout(0)<CR><A-{k}>'
    endfor
  endfor
  let s:timer = timer_start(g:altkey_in_term_timeout, 'altkey_in_term#Timeout')
endfunction

