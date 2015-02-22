# Vim plugin for XMLTV/tv\_grab\_uk\_rt programme fixups

A Vim plugin providing functionality to make maintaining an XMLTV grabber
programme fixups file (e.g. prog\_titles\_to\_process) easier and less
error-prone.

This plugin provides:

* Fileytpe detection
* Syntax highlighting
* Folding support
* Fixup linter

It works together with [Syntastic][syntastic], a Vim plugin that uses
external source code checkers to find and highlight errors.


## Features

### Fileytpe detection

File paths of \*/grab/uk\_rt/prog\_titles\_to\_process are automatically
set to the 'xmltvfixup' filetype.

Other files can be set to the 'xmltvfixup' filetype automatically by adding
the following to your .vimrc:

    autocmd BufNewFile,BufRead */path/to/fixup/file* set filetype=xmltvfixup

### Syntax highlighting

Elementary highlighting of the 'xmltvfixup' filetype shows the following
elements in a fixups file:

* Fixup type(number)
* Fixup type separator (bar)
* Fixup text
* Fixup text separator (tilde)

### Folding

All fixups are automatically folded when a fixups file is opened which
can make navigation quicker.

### Linter

The linter will check the fixups file for errors such as:

* Missing fixup text
* Invalid fixup type
* Wrong number of fixup fields in a fixup entry


## Prerequisites

For full functionality, this plugin requires:

* [Syntastic][syntastic]
* A working Perl installation


## Installation (plugin)

Installing vim-xmltvfixup is straightforward. Use of a Vim plugin manager is
recommended.

### vim-plug

If you are using [vim-plug][vim-plug] you need to have the following 2 lines
in your `.vimrc`:

    Plug 'scrooloose/syntastic'
    Plug 'knowledgejunkie/vim-xmltvfixup', { 'do': './install.sh' }

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

The linter script should be symlinked to a directory that is in your
shell's $PATH in order for Syntastic to be able to run it.

### vim-plug

If you are using vim-plug to manage your plugins and already have a ~/bin
directory ([Zsh][zsh] with [Prezto][prezto], for example), a symlink from the
vim-xmltvfixup repository will be made to ~/bin automatically as part of
the plugin installation process.

### Vundle/Pathogen/manual

Users of Vundle, Pathogen, or manual installations can create a symlink
to ~/bin by running the install.sh script. Alternatively, a link can be
created to any directory in your $PATH manually.


## Usage

Filetype detection, syntax highlighting and folding should "just work" once
the plugin is installed.

The fixup linter should work automatically if Syntastic is installed and the
linter script can be found in your $PATH. Check Syntastic's detailed help
(`:h syntastic`) to see how it can be configured to your requirements.

To use the linter as a standalone utility:

    $ xmltvfixuplint prog_titles_to_process

Enjoy!


## TODO

* Improved highlighting
* Linter working in Syntastic from within repository directory


## License

Copyright (c) Nick Morrott. Distributed under the same terms as Vim itself. See `:help license`.

[vim-plug]: https://github.com/junegunn/vim-plug
[vundle]: https://github.com/gmarik/Vundle.vim
[pathogen]: https://github.com/tpope/vim-pathogen
[syntastic]: https://github.com/scrooloose/syntastic
[zsh]: http://www.zsh.org
[prezto]: https://github.com/sorin-ionescu/prezto
[xmltvfixuplint]: https://github.com/knowledgejunkie/vim-xmltvfixup/blob/master/syntax_checkers/xmltvfixup/xmltvfixuplint
