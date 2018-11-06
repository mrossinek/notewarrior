Notewarrior
===========

Notewarrior is a terminal based note management system.
It tries to follow the ideas behind taskwarrior by mimicking its behaviour in the
context of notes rather than tasks.
It is programmed in Bash since it is essentially just a wrapper program for many
different tasks related to the management of a central note directory.


List of Commands
----------------

* note init: initialize note dir
* note deinit: removes all user data (use with care!)
* note list: list notes (with filters)
* note show: print note
* note open: open converted note (pdf/html argument)
* note info: show metadata about note (incl. history)
* note add: adds a note
* note edit: edits a note
* note move: moves an existing note
* note delete: deletes an existing note (or multiple)
* note undo/redo: un/redo last change (based on git history)

General Implementation
----------------------

* Bash
* let Vim do the editing (maybe define some mappings here to go with the program)
* use markdown for the note files



