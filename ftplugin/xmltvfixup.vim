" Vim filetype functions for XMLTV programme fixups
" Language:    XMLTV programme fixups
" FileType:    xmltvfixup
" Maintainer:  Nick Morrott <knowledgejunkie@gmail.com>
" Website:     https://github.com/knowledgejunkie/vim-xmltvfixup
" Copyright:   2016, Nick Morrott <knowledgejunkie@gmail.com>
" License:     Same as Vim
" Version:     0.03
" Last Change: 2016-06-30

" Initialisation {{{1

if exists("g:loaded_xmltvfixup") || &cp || v:version < 700
  finish
endif
let g:loaded_xmltvfixup = 1

" Uncomment the following line to disable default mappings
" let g:xmltvfixup_no_mappings = 1

" }}}1

" Script variables {{{1

let s:valid_fixup_types   = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
let s:fixup_types_to_sort = [1,2,3,4,5,6,7,8,11,12,13]

" }}}1

" Folding {{{1

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

" }}}1

" Utility functions {{{1

" Is requested fixup type valid?
function! s:IsFixupValid(type) abort
    let type = a:type
    if type >= 1 && type <= max(s:valid_fixup_types)
        return 1
    else
        return 0
    endif
endfunction

" Place cursor at bottom of given fixup type section
function! s:MoveToBottomOfFixupList(type) abort
    let type = a:type
    let bar_char = "|"
    let end_char = "#"

    if s:IsFixupValid(type)
        call cursor(1,1)

        let match_start_pattern = "^" . type . bar_char
        let match_end_pattern   = "^" . end_char

        let match_start = search(match_start_pattern, 'cW')
        if match_start >= 1
            normal! zo
            let match_end = search(match_end_pattern, 'W')
            if match_end >= 2 && match_end > match_start
                normal! k0
            else
                " did not find closing comment
            endif
        else
            " FIXME
            " insert new fixup type
        endif
    else
        echom "Unknown XMLTV Fixup type: " . type
    endif
endfunction

" Trim leading/trailing whitespace from given string
function! s:Trim(str)
    return substitute(a:str, '\v^\s*(.{-})\s*$', '\1', '')
endfunction

" Parse a multiline selection from a MythWeb programme details page
" into title, subtitle and description. The selection available in the
" "* register has lines terminated with the newline character which we can
" split on. There may also be a broadcast time line (before the description)
" which we remove.
"
" Note the we can quickly select the title and subtitle from the MythWeb
" Upcoming Recordings list. Usage of the details page is required to capture
" a programme's description. Thus, the minimum number of lines that we expect
" to see is 3 (title, time, desc), the most 4 (title, subtitle, time,desc).
function! s:ParseMythWebDetailSelection() abort
    let str = @*
    let title = ""
    let subtitle = ""
    let desc = ""

    let list = split(str, '\v\n')
    if len(list) < 3 || len(list) > 4
        throw "Not enough lines selected on MythWeb details page (need 3 or 4)"
    elseif len(list) == 3
        " let title = list[0]
        " strip trailing colon from title
        let title = substitute(list[0], '\v^(.{-1,}):$', '\1', '')
        " Sat, May 21, 08:30 PM to 09:55 PM (95 mins)
        if list[1] =~ '\v\d{2}:\d{2}.*\d{2}:\d{2}.*\(\d+\smins\)'
            " no subtitle, ignore a probable broadcast timings line
            let desc = list[2]
        else
            throw "Could not detect broadcast line in selection (line 2?)"
        endif
    elseif len(list) == 4
        " let title = list[0]
        " strip trailing colon from title
        let title = substitute(list[0], '\v^(.{-1,}):$', '\1', '')
        let subtitle = list[1]
        if list[2] =~ '\v\d{2}:\d{2}.*\d{2}:\d{2}.*\(\d+\smins\)'
            " already seen subtitle, ignore a probable broadcast timings line
            let desc = list[3]
        else
            throw "Could not detect broadcast line in selection (line 3?)"
        endif
    endif

    return [title, subtitle, desc]
endfunction

" }}}1

" Sort fixups {{{1

" Sort all fixup sections that are to be sorted (some are not e.g. type 9)
function! s:SortFixups() abort
    " save current position
    normal! mz
    normal! zR
    for type in s:fixup_types_to_sort
        call s:SortFixupsOfType(type)
    endfor
    " return cursor to original position
    normal! 'z
    normal! zM
endfunction

" Sort a given fixup type list
function! s:SortFixupsOfType(type) abort
    let type = a:type
    let bar_char = "|"
    let end_char = "#"

    if s:IsFixupValid(type)
        call cursor(1,1)

        let match_start_pattern = "^" . type . bar_char
        let match_end_pattern   = "^" . end_char

        let match_start = search(match_start_pattern, 'cW')
        if match_start >= 1
            execute "1," . match_start . " mark a"

            let match_end = search(match_end_pattern, 'W')
            if match_end >= 2 && match_end > match_start
                let match_end -= 1
                execute match_start . "," . match_end . " mark b"
                'a,'bsort
            endif
        endif
    else
        echom "Unknown XMLTV Fixup type: " . type
    endif
endfunction

" }}}1

" Insert new fixups {{{1

" Insert a new fixup of the given type
function! s:InsertNewFixup(type) abort
    let type = a:type
    " close all open folds
    normal! zM
    " get to bottom of fixup type list
    call s:MoveToBottomOfFixupList(type)
    " call correct function for new fixup type
    execute "call s:InsertType" . type . "Fixup()"
endfunction

function! s:InsertType1Fixup() abort
    call append(line('.'), "1|" . @*)
    normal! j0f|l
endfunction

function! s:InsertType2Fixup() abort
    call append(line('.'), "2|" . @*)
    normal! j0f|l
endfunction

function! s:InsertType3Fixup() abort
    call append(line('.'), "3|" . @*)
    normal! j0f|l
endfunction

function! s:InsertType4Fixup() abort
    call append(line('.'), "4|" . @*)
    normal! j0f|l
endfunction

function! s:InsertType5Fixup() abort
    let str = @*
    if str =~ '\v\s-\s'
        call append(line('.'), "5|" . str . "~" . substitute(str, '\v\s-\s', ": ", ""))
    else
        " throw "No match, aborting!"
        call append(line('.'), "5|" . str . "~" . str)
    endif
    normal! j0f~l
endfunction

function! s:InsertType6Fixup() abort
    call append(line('.'), "6|" . @* . "~Documentary")
    normal! j0fD
endfunction

function! s:InsertType7Fixup() abort
    let str = @*
    let list = split(str, '\v:\s')
    if len(list) == 1
        call append(line('.'), "7|" . list[0] . "~~")
        normal! j0f~l
        startinsert
    elseif len(list) == 2
        call append(line('.'), "7|" . list[0] . "~" . list[1] . "~" . substitute(list[1], '\v\s-\s', ': ', ""))
        normal! j0f~;l
    else
        call append(line('.'), "7|" . list[0] . "~" . join(list[1:], ': ') . "~" . substitute(join(list[1:], ': '), '\v\s-\s', ': ', ""))
        normal! j0f~;l
    endif
endfunction

function! s:InsertType8Fixup() abort
    let old_t = @*
    let has_hyphen = 0
    let has_colon  = 0

    if old_t =~ '\v\s-\s'
        let has_hyphen = 1
    endif
    if old_t =~ '\v:\s'
        let has_colon = 1
    endif

    if has_hyphen
        if has_colon
            let c_list = split(old_t, '\v:\s')
            let new_t = c_list[0]
            let new_s = substitute(c_list[1], '\v\s-\s', ': ', "")
            call append(line('.'), "8|" . old_t . "~~" . new_t . "~" . new_s)
            normal! j0f~;l
        else
            let list = split(old_t, '\v\s-\s')
            if len(list) == 2
                call append(line('.'), "8|" . old_t . "~~" . list[0] . "~" . list[1])
                normal! j0f~;l
            else
                call append(line('.'), "8|" . old_t . "~~" . list[0] . "~" . join(list[1:], ': '))
                normal! j0f~;l
            endif
        endif
    else
        if has_colon
            let list = split(old_t, '\v:\s')
            if len(list) == 2
                call append(line('.'), "8|" . old_t . "~~" . list[0] . "~" . list[1])
                normal! j0f~;l
            else
                call append(line('.'), "8|" . old_t . "~~" . list[0] . "~" . join(list[1:], ': '))
                normal! j0f~;l
            endif
        else
            call append(line('.'), "8|" . old_t . "~~" . old_t . "~")
            normal! j0f~;l
        endif
    endif
endfunction

function! s:InsertType9Fixup() abort
    let list = s:ParseMythWebDetailSelection()

    call append(line('.'), "9|" . list[0] . "~" . list[1] . "~" . list[2])
    normal! j0f~l
    startinsert
endfunction

function! s:InsertType10Fixup() abort
    let list = s:ParseMythWebDetailSelection()

    call append(line('.'), "10|" . list[0] . "~" . list[1] . "~~" . list[0] . "~" . list[2])
    normal! j0f~;l
    startinsert
endfunction

function! s:InsertType11Fixup() abort
    let str = @*
    let list = split(str, ':\s')
    if len(list) == 1
        call append(line('.'), "11|" . list[0] . "~")
        normal! j
        startinsert!
    elseif len(list) == 2
        call append(line('.'), "11|" . list[0] . "~" . list[1])
        normal! j0f~l
    else
        call append(line('.'), "11|" . join(list[0:1], ': ') . "~" . join(list[2:], ': '))
        normal! j0f~l
    endif
endfunction

function! s:InsertType12Fixup() abort
    call append(line('.'), "12|" . @* . "~Entertainment")
    normal! j0fE
endfunction

function! s:InsertType13Fixup() abort
    let str = @*
    let list = split(str, ':\s')
    if len(list) == 1
        call append(line('.'), "13|" . list[0] . "~")
        normal! j
        startinsert!
    elseif len(list) == 2
        call append(line('.'), "13|" . list[0] . "~" . list[1])
        normal! j0f~l
    else
        call append(line('.'), "13|" . join(list[0:1], ': ') . "~" . join(list[2:], ': '))
        normal! j0f~l
    endif
endfunction

function! s:InsertType14Fixup() abort
    call append(line('.'), "14|" . @* . "~")
    normal! j
    startinsert!
endfunction

" }}}1

" Custom completion {{{1

function! s:CompleteFixupTypes(ArgLead, CmdLine, CursorPos)
    return join(s:valid_fixup_types, "\n")
endfunction

" }}}1

" Mappings {{{1

" <Plug> maps and defalt keybindings (see tpope/surround.vim)
nnoremap <buffer> <silent> <Plug>SortXMLTVFixups        :call <SID>SortFixups()<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType1Fixup  :call <SID>InsertNewFixup(1)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType2Fixup  :call <SID>InsertNewFixup(2)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType3Fixup  :call <SID>InsertNewFixup(3)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType4Fixup  :call <SID>InsertNewFixup(4)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType5Fixup  :call <SID>InsertNewFixup(5)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType6Fixup  :call <SID>InsertNewFixup(6)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType7Fixup  :call <SID>InsertNewFixup(7)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType8Fixup  :call <SID>InsertNewFixup(8)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType9Fixup  :call <SID>InsertNewFixup(9)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType10Fixup :call <SID>InsertNewFixup(10)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType11Fixup :call <SID>InsertNewFixup(11)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType12Fixup :call <SID>InsertNewFixup(12)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType13Fixup :call <SID>InsertNewFixup(13)<CR>
nnoremap <buffer> <silent> <Plug>InsertXMLTVType14Fixup :call <SID>InsertNewFixup(14)<CR>

if !exists("g:xmltvfixup_no_mappings") || ! g:xmltvfixup_no_mappings
    nmap <buffer> <silent> <Leader>xS <Plug>SortXMLTVFixups
    nmap <buffer> <silent> <Leader>x1 <Plug>InsertXMLTVType1Fixup
    nmap <buffer> <silent> <Leader>x2 <Plug>InsertXMLTVType2Fixup
    nmap <buffer> <silent> <Leader>x3 <Plug>InsertXMLTVType3Fixup
    nmap <buffer> <silent> <Leader>x4 <Plug>InsertXMLTVType4Fixup
    nmap <buffer> <silent> <Leader>x5 <Plug>InsertXMLTVType5Fixup
    nmap <buffer> <silent> <Leader>x6 <Plug>InsertXMLTVType6Fixup
    nmap <buffer> <silent> <Leader>x7 <Plug>InsertXMLTVType7Fixup
    nmap <buffer> <silent> <Leader>x8 <Plug>InsertXMLTVType8Fixup
    nmap <buffer> <silent> <Leader>x9 <Plug>InsertXMLTVType9Fixup
    nmap <buffer> <silent> <Leader>xa <Plug>InsertXMLTVType10Fixup
    nmap <buffer> <silent> <Leader>xb <Plug>InsertXMLTVType11Fixup
    nmap <buffer> <silent> <Leader>xc <Plug>InsertXMLTVType12Fixup
    nmap <buffer> <silent> <Leader>xd <Plug>InsertXMLTVType13Fixup
    nmap <buffer> <silent> <Leader>xe <Plug>InsertXMLTVType14Fixup
endif

" }}}1

" Commands {{{1

command! -buffer -nargs=0 SortXMLTVFixups  call s:SortFixups()
command! -buffer -complete=custom,s:CompleteFixupTypes -nargs=1 InsertXMLTVFixup call s:InsertNewFixup(<args>)

" }}}1

" Autocommands {{{1

augroup xmltvfixup
    autocmd!
    autocmd FileType xmltvfixup set synmaxcol=0
    autocmd FileType xmltvfixup call s:setup_xmltvfixup()
augroup END

function! s:setup_xmltvfixup()
    " Enable syntax highlighting on very long lines
    " Automatically sort fixups when saving file
    autocmd BufWritePre <buffer> :silent! SortXMLTVFixups
endfunction

" }}}1
