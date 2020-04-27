all: note

clean:
	rm -f note

install: note wiki2html_pandoc
	sudo install -b $^ /usr/local/bin/
	sudo install -b _note /usr/share/zsh/site-functions/
	sudo install -b ext/markdown2ctags/markdown2ctags.py /usr/local/bin/markdown2ctags
	sudo install -b ext/gitwatch/gitwatch.sh /usr/local/bin/gitwatch
	mkdir -p "${HOME}/.config/systemd/user"
	cp ext/gitwatch/gitwatch@.service ${HOME}/.config/systemd/user/

uninstall:
	sudo rm /usr/local/bin/note
	sudo rm /usr/local/bin/wiki2html_pandoc
	sudo rm /usr/share/zsh/site-functions/_note
	sudo rm /usr/local/bin/markdown2ctags
	echo 'Leaving gitwatch installed'

note: *.sh
	# recreate target
	rm -f $@
	# insert shell info at top
	echo "#!/bin/bash\n" > $@
	# cat all files except the main part `note.sh`
	cat $(filter-out note.sh,$^) >> $@
	# append the main part `note.sh`
	cat note.sh >> $@
	# make executable
	chmod +x $@


.PHONY: all clean
