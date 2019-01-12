all: note

clean:
	rm -f note

install: note
	sudo cp $< /usr/bin/

uninstall:
	sudo rm /usr/bin/note

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
