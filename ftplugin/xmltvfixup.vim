" Configure folding

setlocal foldmethod=expr
setlocal foldexpr=GetFold(v:lnum)
setlocal foldtext=FoldText()

setlocal foldenable
setlocal foldminlines=0
setlocal foldlevelstart=0
setlocal foldclose=all

function! GetFold(lnum)
    " start a new fold if we see a section separator
    if getline(a:lnum) =~? '\v^#{78}'
        return '>1'
    endif

    " foldlevel 1 if previous line is also foldlevel 1
    if a:lnum > 1 && foldlevel(a:lnum - 1) == 1
        return 1
    endif
endfunction

function! FoldText()
    let foldedFixups = s:getCountFoldedFixups(foldclosed(v:foldstart), foldclosedend(v:foldstart))
    let sectionText = s:getSectionText(foldclosed(v:foldstart), foldclosedend(v:foldstart))

    let strFolded = "    "
    if foldedFixups > 0
        let strFolded = printf('%4s', foldedFixups)
    endif

    return '... ' . strFolded . ' ' . sectionText
endfunction

function! s:getCountFoldedLines(foldstart, foldend)
    return a:foldend - a:foldstart + 1
endfunction

function! s:getCountFoldedFixups(foldstart, foldend)
    let lnum = a:foldstart
    let fixups = 0
    while lnum <= a:foldend
        let line = getline(lnum)
        if line =~? '\v#?[0-9]+\|'
            let fixups += 1
        endif
        let lnum += 1
    endwhile
    return fixups
endfunction

function! s:getSectionText(foldstart, foldend)
    let lnum = a:foldstart
    while lnum <= a:foldend
        let line = getline(lnum)
        if line =~? '\v^#\s[0-9A-Za-z]'
            return substitute(line, '^#\s\(.*\)$', '\1', "")
        endif
        let lnum += 1
    endwhile
    return "unknown"
endfunction
