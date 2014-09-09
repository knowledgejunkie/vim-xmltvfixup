" Configure linter

setlocal makeprg=xmltvfixuplint\ %
setlocal errorformat=%t:%f:%l:%m

if exists('g:syntastic_extra_filetypes')
    call add(g:syntastic_extra_filetypes, 'xmltvfixup')
else
    let g:syntastic_extra_filetypes = ['xmltvfixup']
endif

let g:syntastic_xmltvfixup_exec='/usr/local/bin/xmltvfixuplint'
let g:syntastic_xmltvfixuplint_exec='/usr/local/bin/xmltvfixuplint'

" Configure folding

setlocal foldmethod=expr
setlocal foldexpr=GetFold(v:lnum)
setlocal foldtext=FoldText()

setlocal foldenable
setlocal foldminlines=0
setlocal foldlevel=0

function! GetFold(lnum)
    if getline(a:lnum) =~? '\v^#?[0-9]+\|'
        return '1'
    endif

    return '0'
endfunction

function! FoldText()
    let foldlinecount = foldclosedend(v:foldstart) - foldclosed(v:foldstart) + 1
    return '... ' . string(foldlinecount) . ' fixups hidden ...'
endfunction
