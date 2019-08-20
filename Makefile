all: note

clean:
	rm -f note

install: note
	sudo cp $< /usr/local/bin/
	sudo cp _note /usr/share/zsh/site-functions/

uninstall:
	sudo rm /usr/local/bin/note
	sudo rm /usr/share/zsh/site-functions/_note

note: note.sh helper.sh system.sh directory.sh file.sh view.sh
	# recreate target
	rm -f $@
	touch $@
	# cat all files but first prerequisite
	cat $(filter-out $<,$^) >> $@
	# append required part of first prerequesite
	tail -n +10 $< >> $@
	# insert shell info at top
	sed -i '1s;^;#!/bin/sh\n\n;' $@
	# make executable
	chmod +x $@


.PHONY: all clean
