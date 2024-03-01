
let s:float_win = -1

function! s:CloseMyFloat()
  if s:float_win != -1
    execute s:float_win.'wincmd q'
    let s:float_win = -1
  endif
endfunction

function s:HoverFloat(text)
  call s:CloseMyFloat()
  let text_lines = a:text->split('\n')
  let float_buf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_text(float_buf, 0, 0, 0, 0, text_lines)
  let margin = 2
  let longest_line = text_lines
        \ ->map({k,v -> v->len()})
        \ ->reduce({acc, v -> max([acc, v])}, 0)
  let [_, row, col, _] = getpos('.')
  let width = min([longest_line+1-col, winwidth(0)-col-margin])
  let height = min([text_lines->len(), winheight(0)-margin])
  let config = { 'relative':'win', 'row': row, 'col': col,
               \ 'width': width, 'height': height, 'anchor':'NW' }
  let float = nvim_open_win(float_buf, v:false, config)
  let s:float_win = float->win_id2win()
  autocmd CursorMoved <buffer> ++once call s:CloseMyFloat()
endfunction

function! s:MyPreviewOrFloat(allow_float, name, cmd)
  if a:allow_float && has('nvim')
    let text = system(a:cmd->join(' '))
    call s:HoverFloat(text)
  else
    let cmdstr = a:cmd->join('\ ')
    echo a:cmd->join(' ')
    let options = 'buftype=nowrite\ bufhidden=wipe\ nobuflisted\ noswapfile\ nowrap\ nonumber\ readonly'
    execute 'pedit'.
          \ ' +setlocal\ '.options.
          \ '|file\ '.a:name.
          \ '|silent\ r\ !'.cmdstr
          \ ' '.tempname()
  endif
endfunction



command! -bang -nargs=* Hoogle call Hoogle(<bang>0, "<args>")

function! Hoogle(bang, flags)
  let cmd = ['stack', 'hoogle', '--'] + a:flags->split(' ')
  call s:MyPreviewOrFloat(a:bang, '[Hoogle]', cmd)
endfunction

compiler stack 
setlocal makeprg=stack\ build
setlocal keywordprg=:Hoogle!\ -i
