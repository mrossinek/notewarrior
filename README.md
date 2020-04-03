# Notewarrior

Notewarrior is a tool to help you manage your plain-text notes.
It has evolved a lot since it started out because I started using vimwiki more and more to actually organize and write my notes.
Thus, notewarrior has gotten to a point where it tries to get out of your way and only supplements the actual usage of vimwiki.
It does so by providing the following features:
- allows basic add/edit/delete/list/show/open functionality for your notes
- provides pandoc markdown integration for vimwiki by installing a custom `wiki2html_pandoc` binary
- automatically tracks your Notes folder with [gitwatch](https://github.com/gitwatch/gitwatch)
- using git it allows history rollback and undo/redo functionality

## Installation

You can install notewarrior by simply running:
```sh
git clone https://gitlab.com/mrossinek/notewarrior.git
cd notewarrior
make install
```

### Requirements
Please ensure that the following programs are installed:
- `inotifywait` (commonly provided via [inotify-tools](https://github.com/inotify-tools/inotify-tools))  [required by `gitwatch`]
- [pandoc](https://pandoc.org/)

#### Optionally
- [tree](http://mama.indstate.edu/users/ice/tree/)


## List of Commands
- `init`: initialize note directory
- `deinit`: removes all user data (use with care!)
- `list`: list notes (with filters)
- `show`: print note
- `open`: open converted note (pdf/html argument)
- `info`: show metadata about note (incl. history)
- `add`: adds a note
- `edit`: edits a note
- `move`: moves an existing note
- `delete`: deletes an existing note (or multiple)
- `undo/redo`: un/redo last change (based on git history)

## List of Configuration options
Configuration files may be placed in `~/.noterc` or `~/.config/notewarrior/config` or specified at runtime via the `-c <CONFIG>` command line option.

- `DIRECTORY`: path to the notes directory (default: `~/.notes`)
- `EXTENSION`: file extension for notes (default: `md`)
- `ENABLE_GITWATCH`: whether to autostart gitwatch (default: `true`) [`true` or `false`]
