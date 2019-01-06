let directory = tempname()
execute 'silent !mkdir -p '.directory
redraw!

if !exists('g:default_shebang')
    let g:default_shebang= '/usr/bin/bash'
endif
if !exists('g:run_on_write')
    let g:run_on_write = 0
endif
" if !exists('g:

function s:noop()

endfunction

function! PromptScript() range
    let saved_firstline = a:firstline
    let saved_lastline = a:lastline
    let original_buffer = bufnr('%')
    let b:ScriptFn = function('s:noop')

    execute 'split /tmp/command-runner/'.original_buffer.'-script'
    1,$d
    call setline(1, '#! '.g:default_shebang)
    call setline(2, '')
    2
    let script_buffer = bufnr('%')
    write|edit
    
    function! RunScript() closure
        let script_file = directory.'/'.original_buffer.'-script'
        execute 'silent !chmod +x '.script_file
        execute 'buffer '.original_buffer
        execute 'silent '.saved_firstline.','.saved_lastline.' !'.script_file
        execute 'buffer '.script_buffer
        redraw!
    endfunction
    
    let b:ScriptFn = funcref('RunScript')
    silent command! -buffer Runscript call call(b:ScriptFn, [])
    nnoremap <silent><buffer> <leader>s :w<CR>:Runscript<CR>
    if g:run_on_write != 0
        autocmd BufWritePost <buffer> Runscript
    endif
endfunction

silent command! -range=% Promptscript <line1>,<line2>call PromptScript()
nnoremap <silent> <leader>s :Promptscript<CR>
