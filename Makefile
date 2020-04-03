all: note

clean:
	rm -f note

install: note
	sudo cp $^ /usr/local/bin/
	sudo cp _note /usr/share/zsh/site-functions/

uninstall:
	sudo rm /usr/local/bin/note
	sudo rm /usr/share/zsh/site-functions/_note

note: *.sh
	# recreate target
	rm -f $@
	touch $@
	# cat all files except the main part `note.sh`
	cat $(filter-out note.sh,$^) >> $@
	# append the main part `note.sh`
	cat note.sh >> $@
	# insert shell info at top
	sed -i '1s;^;#!/bin/sh\n\n;' $@
	# make executable
	chmod +x $@


.PHONY: all clean
