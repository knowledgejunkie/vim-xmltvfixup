" Vim syntax highlighting for XMLTV programme fixups
" Language:    XMLTV programme fixups
" FileType:    xmltvfixup
" Maintainer:  Nick Morrott <knowledgejunkie@gmail.com>
" Website:     https://github.com/knowledgejunkie/vim-xmltvfixup
" Copyright:   2016, Nick Morrott <knowledgejunkie@gmail.com>
" License:     Same as Vim
" Version:     0.03
" Last Change: 2016-06-30

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'xmltvfixup'
endif

" Fixup entries
syntax region xmltvfixupFixupType start="\v^[^#]" excludenl end="\v$" contains=xmltvfixupTypeID,xmltvfixupTypeSeparator,xmltvfixupUnsplitFixupFields
syntax match xmltvfixupTypeID "\v^[0-9]+" contained
syntax match xmltvfixupTypeSeparator "\v\|" contained

syntax region xmltvfixupUnsplitFixupFields start="\v(^[0-9]+\|)@<=\S" excludenl end="\v$" contained contains=xmltvfixupFixupField1,xmltvfixupFixupFieldx,xmltvfixupFixupFieldy
" The first match is special as it needs to match something, the following
" fields can be empty and alternate their highlights as necessary
" - adapted from https://groups.google.com/forum/#!topic/comp.editors/GWjYPgC35bA
syntax match xmltvfixupFixupField1 "\v[^~]+" contained contains=xmltvfixupFixupSeparator nextgroup=xmltvfixupFixupFieldx
syntax match xmltvfixupFixupFieldx "\v[~][^~]*" contained contains=xmltvfixupFixupSeparator nextgroup=xmltvfixupFixupFieldy
syntax match xmltvfixupFixupFieldy "\v[~][^~]*" contained contains=xmltvfixupFixupSeparator nextgroup=xmltvfixupFixupFieldx
syntax match xmltvfixupFixupSeparator "\v[~]" contained

highlight def link xmltvfixupTypeID Normal
highlight def link xmltvfixupTypeSeparator Identifier

highlight def link xmltvfixupFixupField1 Special
highlight def link xmltvfixupFixupFieldx Type
highlight def link xmltvfixupFixupFieldy Special
highlight def link xmltvfixupFixupSeparator Identifier

" Comments
syntax region xmltvfixupCommentLine start="\v^#" end="$" contains=xmltvfixupComment
syntax match xmltvfixupComment "\v^#.*" contained

highlight def link xmltvfixupComment Comment

let b:current_syntax = "xmltvfixup"
if main_syntax == 'xmltvfixup'
  unlet main_syntax
endif
