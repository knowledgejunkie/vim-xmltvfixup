" Vim filetype detection for XMLTV programme fixups
" Language:    XMLTV programme fixups
" FileType:    xmltvfixup
" Maintainer:  Nick Morrott <knowledgejunkie@gmail.com>
" Website:     https://github.com/knowledgejunkie/vim-xmltvfixup
" Copyright:   2016, Nick Morrott <knowledgejunkie@gmail.com>
" License:     Same as Vim
" Version:     0.04
" Last Change: 2016-07-14

autocmd BufRead,BufNewFile prog_titles_to_process set filetype=xmltvfixup
autocmd BufRead,BufNewFile augment.rules set filetype=xmltvfixup
