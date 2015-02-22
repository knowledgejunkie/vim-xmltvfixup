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
