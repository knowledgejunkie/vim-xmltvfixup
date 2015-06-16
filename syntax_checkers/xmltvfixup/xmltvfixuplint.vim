if exists("g:loaded_syntastic_xmltvfixup_xmltvfixuplint_checker")
    finish
endif
let g:loaded_syntastic_xmltvfixup_xmltvfixuplint_checker = 1

if exists('g:syntastic_extra_filetypes')
    call add(g:syntastic_extra_filetypes, 'xmltvfixup')
else
    let g:syntastic_extra_filetypes = ['xmltvfixup']
endif

" let g:syntastic_debug = 1

let s:save_cpo = &cpo
set cpo&vim

let s:checker = expand('<sfile>:p:h') . '/xmltvfixuplint'

function! SyntaxCheckers_xmltvfixup_xmltvfixuplint_GetLocList() dict
    let makeprg = self.makeprgBuild({ 'exe' : s:checker })
    let errorformat = '%t:%f:%l:%m'

    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({ 'filetype': 'xmltvfixup', 'name': 'xmltvfixuplint' })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set et sts=4 sw=4:
