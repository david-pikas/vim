" linting config 

" let g:ale_completion_enabled = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0

" nnoremap <leader>d <Plug>(ale_go_to_definition)
" nnoremap <silent> [w :ALEPrevious<CR>
" nnoremap <silent> ]w :ALENext<CR>
" nnoremap <leader>? <Plug>(ale_detail)
" nnoremap <leader>= <Plug>(ale_fix)

" Note: for texlab to work, you need to moddify the ALE
" linter to provide a default root directory
" https://github.com/dense-analysis/ale/pull/2501/files

" call ale#linter#Define('haskell', {
"   \   'name': 'haskell-language-server',
"   \   'lsp': 'stdio',
"   \   'executable': 'haskell-language-server-wrapper',
"   \   'command': 'haskell-language-server-wrapper --lsp',
"   \   'project_root': function('ale_linters#haskell#hie#GetProjectRoot'),
"   \})
"
"   \ , 'c': ['cc', 'clangtidy']

let g:ale_linters = { 'haskell':  []
                  \ , 'markdown': []
                  \ , 'javascript': []
                  \ , 'json': []
                  \ , 'typescript': []
                  \ , 'latex': []
                  \ , 'tex': []
                  \ , 'perl': ['perl']
                  \ , 'python': ['mypy']
                  \ , 'rust': []
                  \ , 'c': []
                  \ , 'cpp': ['cppcheck']
                  \ , 'erlang': []
                  \ , 'ruby': []
                  \ , 'viml': []
                  \ }

