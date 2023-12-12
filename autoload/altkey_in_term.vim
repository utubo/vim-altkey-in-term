let s:save_keys = []
let g:altkey_in_term_flg = 0

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
  if g:altkey_in_term_flg
    call feedkeys("\<Esc>", 'nit')
  endif
  if exists('#User#AltkeyInTerm')
    doautocmd User AltkeyInTerm
  endif
endfunction

function! altkey_in_term#Alt() abort
  let g:altkey_in_term_flg = 1
  let keys = g:altkey_in_term_keys->split('.\zs')
  let do_save = empty(s:save_keys)
  for m in g:altkey_in_term_mode->split('.\zs')
    for k in keys
      if do_save
        let s:save_keys += [maparg(k, m, 0, 1)]
      endif
      execute $'{m}map {k} <Cmd>let g:altkey_in_term_flg = 0<CR><A-{k}>'
    endfor
  endfor
  call timer_start(g:altkey_in_term_timeout, 'altkey_in_term#Timeout')
endfunction

