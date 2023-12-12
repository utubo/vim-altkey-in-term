if exists('g:loaded_altkey_in_term')
  finish
endif
let g:loaded_altkey_in_term = 1
let s:save_cpo = &cpo
set cpo&vim

if !exists('g:altkey_in_term_keys')
  let g:altkey_in_term_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
endif
if !exists('g:altkey_in_term_timeout')
  let g:altkey_in_term_timeout = 10
endif
nnoremap <script> <Esc> <ScriptCmd>call altkey_in_term#Alt()<CR>
cnoremap <script> <Esc> <ScriptCmd>call altkey_in_term#Alt()<CR>
xnoremap <script> <Esc> <ScriptCmd>call altkey_in_term#Alt()<CR>

let &cpo = s:save_cpo
unlet s:save_cpo

