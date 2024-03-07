setlocal makeprg=pandoc\ %\ -t\ latex\ -o\ %:r.pdf
setlocal errorformat=\"%f\",\ line\ %l:\ %m
