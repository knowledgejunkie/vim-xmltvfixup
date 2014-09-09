if exists("g:loaded_syntastic_xmltvfixup_xmltvfixuplint_checker")
    finish
endif
let g:loaded_syntastic_xmltvfixup_xmltvfixuplint_checker = 1

let g:syntastic_debug = 17

let s:save_cpo = &cpo
set cpo&vim

"let s:checker = expand('<sfile>:p:h') . syntastic#util#Slash() . 'xmltvfixuplint'

function! SyntaxCheckers_xmltvfixup_xmltvfixuplint_GetLocList() dict
    "let makeprg = self.makeprgBuild({'args_before': s:checker})
    "let makeprg = self.makeprgBuild({'exe': xmltvfixuplint})
    let makeprg = '/usr/local/bin/xmltvfixuplint'
    let errorformat = '%t:%f:%l:%m'

    let loclist = SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })

    call self.setWantSort(1)

    return loclist
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
            \ 'filetype': 'xmltvfixup',
            \ 'name': 'xmltvfixuplint',
            \ 'exec': 'xmltvfixuplint' })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set et sts=4 sw=4:
