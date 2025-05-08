let &l:path=expand("%:p:h")->substitute("\\","/","g").","
let b:load_path=get(b:, "load_path", "") . system("ruby -e 'puts $:'")
let &l:path.=b:load_path->substitute("\n",",","g")

set include=^\\s*require\\(_relative\\)\\?\\>

if has('nvim')
  lua vim.diagnostic.config { virtual_text = false, underline = false, signs = false }
endif
