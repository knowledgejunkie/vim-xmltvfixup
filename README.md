# Vim plugin for XMLTV/tv\_grab\_uk\_rt programme fixups

A Vim plugin providing functionality to make maintaining an XMLTV grabber
programme fixups file (e.g. prog\_titles\_to\_process for tv\_grab\_uk\_rt)
easier and less error-prone.

This plugin provides:

* Automatic filetype detection
* Syntax highlighting
* Automatic folding
* Fixup error detection

The fixup error detection support integrates with [Syntastic][syntastic],
a Vim plugin that uses external source code checkers (linters) to provide
editor notification of errors.


## Features

### Automatic filetype detection

File paths of \*/grab/uk\_rt/prog\_titles\_to\_process are automatically
set to the 'xmltvfixup' filetype. (This is the default path to the fixup
file in an XMLTV checkout.)

Other fixup files can be assigned the 'xmltvfixup' filetype automatically by adding
the following to your .vimrc:

    autocmd BufNewFile,BufRead */path/to/fixup/file set filetype=xmltvfixup

### Syntax highlighting

Elementary highlighting of the 'xmltvfixup' filetype is used to distinguish the
following elements in a fixups file:

* Fixup type(number)
* Fixup type separator (bar)
* Fixup text
* Fixup text separator (tilde)

### Automatic folding

All fixups of the same type are automatically folded when a fixups file is
opened. This can make navigation through a large fixups file much quicker.

### Fixup error detection

The provided linter script will check a fixups file for errors such as:

* Unknown fixup type
* Missing fixup text
* Wrong number of fixup fields in a fixup entry

The script will also try to suggest when a fixup might be better rewritten
as a different fixup type.


## Prerequisites

For full functionality, this plugin requires:

* [Syntastic][syntastic]
* A working Perl installation


## Installation (plugin)

Installing vim-xmltvfixup is straightforward. Use of a Vim plugin manager is
recommended (I currently use vim-plug).

### vim-plug

If you are using [vim-plug][vim-plug] you need to have the following 2 lines
in your `.vimrc`:

    Plug 'scrooloose/syntastic'
    Plug 'knowledgejunkie/vim-xmltvfixup'

To install the plugin from within Vim, run:

    :PlugInstall

To install the plugin from the command line, run:

    $ vim +PlugInstall +qall

### Vundle

For [Vundle][vundle] you need to make sure you have the following 2 lines in
your `.vimrc`:

    Bundle 'scrooloose/syntastic'
    Bundle 'knowledgejunkie/vim-xmltvfixup'

To install the plugin from within Vim, run:

    :PluginInstall

To install the plugin from the command line, run:

    $ vim +PluginInstall +qall

### Pathogen

For [Pathogen][pathogen], execute:

    cd ~/.vim/bundle
    git clone https://github.com/knowledgejunkie/vim-xmltvfixup
    vim +Helptags +q


## Installation (linter)

The linter script [xmltvfixuplint][xmltvfixuplint] is run automatically by
Syntastic. Typically this is whenever a fixup file is opened and/or saved.

The linter script runs directly from the plugin directory. No further
installation is necessary.


## Usage

Filetype detection, syntax highlighting and folding should "just work" once
the plugin is installed.

The fixup linter should work automatically if Syntastic is installed. Check
Syntastic's detailed help (`:h syntastic`) to see how it can be configured
to your specific requirements.

To use the linter as a standalone utility (must be in your $PATH):

    $ xmltvfixuplint prog_titles_to_process

Enjoy!


## TODO

* Improved highlighting
* Refactor linter, add more checks


## License

Copyright (c) 2014,2015 Nick Morrott. Distributed under the same terms as Vim itself. See `:help license`.

[vim-plug]: https://github.com/junegunn/vim-plug
[vundle]: https://github.com/gmarik/Vundle.vim
[pathogen]: https://github.com/tpope/vim-pathogen
[syntastic]: https://github.com/scrooloose/syntastic
[zsh]: http://www.zsh.org
[prezto]: https://github.com/sorin-ionescu/prezto
[xmltvfixuplint]: https://github.com/knowledgejunkie/vim-xmltvfixup/blob/master/syntax_checkers/xmltvfixup/xmltvfixuplint
