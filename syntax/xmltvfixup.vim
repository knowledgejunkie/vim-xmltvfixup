" Vim syntax file
" Language:	XMLTV Fixups
" Maintainer:	Nick Morrott <knowledgejunkie@gmail.com
" Last Change:	2014-09-06
" Version:      0.10

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'xmltvfixup'
endif


" :help group-names

" start with smallest matches
syntax match fixupText /\v.*$/ containedin=fixupLine contains=fixupTextSeparator
syntax match fixupType /\v^[0-9]+/ containedin=fixupLine nextgroup=fixupTypeSeparator
syntax match fixupTypeSeparator /\v\|/ containedin=fixupLine
syntax match fixupTextSeparator /\v\~/ containedin=fixupLine
syntax match fixupLine /\v^[0-9]+\|.*$/ contains=fixupText
syntax match fixupComment /\v^#.*/

highlight link fixupType Type
highlight link fixupTypeSeparator Constant
highlight link fixupTextSeparator Constant
highlight link fixupText Statement
highlight link fixupLine Keyword
highlight link fixupComment Comment

let b:current_syntax = "xmltvfixup"
if main_syntax == 'xmltvfixup'
  unlet main_syntax
endif

" Copyright (c) 2014, Nick Morrott
