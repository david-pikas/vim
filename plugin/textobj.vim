" Custom text objects
" see: https://github.com/kana/vim-textobj-user


function! textobj#select_i()
  call search('\\begin{[^}]}', 'bcW')

endfunction

call textobj#user#plugin('tex', {
\   'latex-tag': {
\     'pattern': ['\\begin{[^}]}', '\\end{[^}]}'],
\     'select-a': [],
\     'select-i': [],
\   },
\ })

function! textobj#tag_A()



endfunction

augroup tex_textobjs
  autocmd!
  autocmd FileType tex call textobj#user#map('tex', {
  \   'latex-tag': {
  \     'select-a': '<buffer> at',
  \     'select-i': '<buffer> it',
  \   },
  \ })
augroup END


" for selecting the entire file
" see: https://github.com/kana/vim-textobj-entire

function! textobj#select_a()

  keepjumps normal! gg0
  let start_pos = getpos('.')

  keepjumps normal! G$
  let end_pos = getpos('.')

  return ['V', start_pos, end_pos]
endfunction


function! textobj#select_i()

  keepjumps normal! gg0
  call search('^.', 'cW')
  let start_pos = getpos('.')

  keepjumps normal! G$
  call search('^.', 'bcW')
  normal! $
  let end_pos = getpos('.')

  return ['V', start_pos, end_pos]
endfunction

call textobj#user#plugin('entire', {
\      '-': {
\        'select-a': 'af',  'select-a-function': 'textobj#select_a',
\        'select-i': 'if',  'select-i-function': 'textobj#select_i'
\      }
\    })
