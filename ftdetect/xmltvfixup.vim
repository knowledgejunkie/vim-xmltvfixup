" Vim filetype detection for XMLTV programme fixups
" Language:    XMLTV programme fixups
" FileType:    xmltvfixup
" Maintainer:  Nick Morrott <knowledgejunkie@gmail.com>
" Website:     https://github.com/knowledgejunkie/vim-xmltvfixup
" Copyright:   2016-19, Nick Morrott <knowledgejunkie@gmail.com>
" License:     Same as Vim
" Version:     0.05
" Last Change: 2019-04-28

" all detected augment.rules files get the xmltvfixup filetype
" but let's not futz with example rules file in the XMLTV source
autocmd BufRead,BufNewFile augment.rules
    \ if expand("%:p:h") =~# '/filter/augment' |
    \   set filetype=txt |
    \ else |
    \   set filetype=xmltvfixup |
    \ endif
