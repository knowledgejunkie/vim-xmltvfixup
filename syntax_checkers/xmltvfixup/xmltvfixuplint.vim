" Vim Syntastic checker configuration for XMLTV programme fixups
" Language:    XMLTV programme fixups
" FileType:    xmltvfixup
" Maintainer:  Nick Morrott <knowledgejunkie@gmail.com>
" Website:     https://github.com/knowledgejunkie/vim-xmltvfixup
" Copyright:   2016, Nick Morrott <knowledgejunkie@gmail.com>
" License:     Same as Vim
" Version:     0.03
" Last Change: 2016-06-30

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
    let makeprg = self.makeprgBuild({})
    let errorformat = '%t:%f:%l:%m'

    return SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({ 'filetype': 'xmltvfixup', 'name': 'xmltvfixuplint', 'exec': s:checker })

let &cpo = s:save_cpo
unlet s:save_cpo
