" auto detect spell language
let s:vim_lang = {'swedish':'sv', 'english':'en'}
let &l:include = '\v\\%(%(input|include|subfile)\{|documentclass\[)\zs\f+\ze%(\}|\]\{subfiles\})'
function! BabelSpellLang()
  let s:babel=''
  redir => s:babel
    try
      silent isearch /^\s*\\usepackage\s*\[[^\]]\+\]{babel}/
    catch /Couldn't find pattern/
      return
    endtry
  redir END
  let s:babel_lang = matchstr(s:babel, 'usepackage\s*\[\zs[^\]]\+\ze\]')
  let s:babel_lang = split(s:babel_lang, '\s*,\s*')
  let s:babel_lang = filter(s:babel_lang, "has_key(s:vim_lang, v:val)")
  let s:spelllang = map(s:babel_lang, "get(s:vim_lang, v:val, '')")
  let &l:spelllang = join(s:spelllang, ',')
endfunc

" auto detect language
silent call BabelSpellLang()

" pdflatex as make
setlocal makeprg=rubber\ --pdf\ %
setlocal errorformat=%f:%l:\ %m


