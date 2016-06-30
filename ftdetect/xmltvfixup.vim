" Vim filetype detection for XMLTV programme fixups
" Language:    XMLTV programme fixups
" FileType:    xmltvfixup
" Maintainer:  Nick Morrott <knowledgejunkie@gmail.com>
" Website:     https://github.com/knowledgejunkie/vim-xmltvfixup
" Copyright:   2016, Nick Morrott <knowledgejunkie@gmail.com>
" License:     Same as Vim
" Version:     0.03
" Last Change: 2016-06-30

autocmd BufNewFile,BufRead prog_titles_to_process set filetype=xmltvfixup
autocmd BufNewFile,BufRead augment.rules set filetype=xmltvfixup
