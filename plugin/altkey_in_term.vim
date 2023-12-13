if exists('g:loaded_altkey_in_term')
  finish
endif
let g:loaded_altkey_in_term = 1
let s:save_cpo = &cpo
set cpo&vim

if !exists('g:altkey_in_term_keys')
  let g:altkey_in_term_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
endif
if !exists('g:altkey_in_term_mode')
  let g:altkey_in_term_mode = 'ncxi'
endif
if !exists('g:altkey_in_term_timeout')
  let g:altkey_in_term_timeout = 10
endif

if !exists('g:altkey_in_term_lazy')
  call timer_start(g:altkey_in_term_timeout, 'altkey_in_term#Map')
else
  call altkey_in_term#Map()
endif

let &cpo = s:save_cpo
unlet s:save_cpo

