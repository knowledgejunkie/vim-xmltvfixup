if exists("g:loaded_syntastic_xmltvfixup_xmltvfixuplint_checker")
    finish
endif
let g:loaded_syntastic_xmltvfixup_xmltvfixuplint_checker = 1

if exists('g:syntastic_extra_filetypes')
    call add(g:syntastic_extra_filetypes, 'xmltvfixup')
else
    let g:syntastic_extra_filetypes = ['xmltvfixup']
endif

let g:syntastic_debug = 1

let s:save_cpo = &cpo
set cpo&vim

" function! SyntaxCheckers_xmltvfixup_xmltvfixuplint_IsAvailable() dict
"     return executable(self.getExec())
" endfunction

let s:parser_name   = 'xmltvfixuplint'
let s:parse_command = shellescape(expand('<sfile>:p:h') . '/' . s:parser_name)

function! SyntaxCheckers_xmltvfixup_xmltvfixuplint_GetLocList() dict
"     let makeprg = self.makeprgBuild({})
    let makeprg     = s:parse_command . ' ' . shellescape(expand('%'))
    let errorformat = '%t:%f:%l:%m'

    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({ 'filetype': 'xmltvfixup', 'name': 'xmltvfixuplint' })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set et sts=4 sw=4:
