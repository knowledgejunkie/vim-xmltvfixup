" Configure folding

setlocal foldmethod=expr
setlocal foldexpr=GetFold(v:lnum)
setlocal foldtext=FoldText()

setlocal foldenable
setlocal foldminlines=0
setlocal foldlevel=0

function! GetFold(lnum)
    " first look for (possibly commented) fixup entries to fold
    if getline(a:lnum) =~? '\v^#?[0-9]+\|'
        return '1'
    " next look for double-commented (##) lines to fold
    elseif getline(a:lnum) =~? '\v^##'
        return '1'
    " everything else is left unfolded
    else
        return '0'
    endif
endfunction

function! FoldText()
    let foldlinecount = foldclosedend(v:foldstart) - foldclosed(v:foldstart) + 1
    return '... ' . string(foldlinecount) . ' fixups hidden ...'
endfunction
