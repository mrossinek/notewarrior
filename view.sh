# note viewing
list()
{
        case "$#" in
                0)
                        tree -D $DIRECTORY 2> /dev/null
                        if [ "$?" -ne "0" ]; then
                                ls -l $DIRECTORY
                        fi
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note list"
                                echo "Lists contents of the notes directory"
                        else
                                error "too many arguments for note list"
                                list help
                        fi
                        ;;
                *)
                        error "too many arguments for note list"
                        list help
                        ;;
        esac
}

info()
{
        case "$#" in
                0)
                        error "too few arguments for note info"
                        info help
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note info <name of note>"
                                echo "Prints the metadata of an existing note"
                        elif [ ! -f $DIRECTORY/$1.md ]; then
                                error "$1.md does not exist!"
                        else
                                echo "Name:         $1.md"
                                echo "Last change:  `stat -c %z $DIRECTORY/$1.md`"
                                echo "Git history:"
                                PWD=`pwd`
                                cd $DIRECTORY
                                git log -p -- $1.md
                                cd $PWD
                        fi
                        ;;
                *)
                        error "too many arguments for note info"
                        info help
                        ;;
        esac
}

show()
{
        case "$#" in
                0)
                        error "too few arguments for note show"
                        show help
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note show <name of note>"
                                echo "Prints an existing note to stdout"
                        elif [ ! -f $DIRECTORY/$1.md ]; then
                                error "$1.md does not exist!"
                                read -p "Would you like to create it now? (Y/n)" choice
                                case "$choice" in
                                        (n*|N*)
                                                echo "Aborting..."
                                                ;;
                                        *)
                                                add $1
                                                ;;
                                esac

                        else
                                cat $DIRECTORY/$1.md
                        fi
                        ;;
                *)
                        error "too many arguments for note show"
                        show help
                        ;;
        esac
}

open()
{
        case "$#" in
                0)
                        error "too few arguments for note open"
                        open help
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note open <name of note> [html|pdf]"
                                echo "Opens the note in the specified format (html by default)"
                        else
                                open $1 html
                        fi
                        ;;
                2)
                        if [ ! -f $DIRECTORY/$1.md ]; then
                                error "$1.md does not exist!"
                                read -p "Would you like to create it now? (Y/n)" choice
                                case "$choice" in
                                        (n*|N*)
                                                echo "Aborting..."
                                                ;;
                                        *)
                                                add $1
                                                ;;
                                esac

                        else
                                case "$2" in
                                        html)
                                                pandoc $DIRECTORY/$1.md -s -o $DIRECTORY/$1.html
                                                $BROWSER $DIRECTORY/$1.html
                                                rm $DIRECTORY/$1.html
                                                ;;
                                        pdf)
                                                pandoc $DIRECTORY/$1.md -s -o $DIRECTORY/$1.pdf
                                                $PDFVIEWER $DIRECTORY/$1.pdf
                                                rm $DIRECTORY/$1.pdf
                                                ;;
                                        *)
                                                error "incompatible note opening format"
                                                echo "Aborting open..."
                                                ;;
                                esac
                        fi
                        ;;
                *)
                        error "too many arguments for note open"
                        open help
                        ;;
        esac
}


