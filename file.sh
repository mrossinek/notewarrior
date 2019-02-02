# file editing
add()
{
        case "$#" in
                0)
                        error "too few arguments for note add"
                        add help
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note add <name of new note>"
                                echo "Adds a new note"
                        elif [ -f $DIRECTORY/$1.md ]; then
                                error "$1.md already exists!"
                        else
                                echo "= $1 =" > $DIRECTORY/$1.md
                                if [ ! -z $EDITOR ]; then
                                        $EDITOR $DIRECTORY/$1.md
                                else
                                        vim $DIRECTORY/$1.md
                                fi
                                _git "add" "$1.md"
                        fi
                        ;;
                *)
                        error "too many arguments for note add"
                        add help
                        ;;
        esac
}

edit()
{
        case "$#" in
                0)
                        error "too few arguments for note edit"
                        edit help
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note edit <name of note>"
                                echo "Edits an existing note"
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
                                CHANGE=`stat -c %z $DIRECTORY/$1.md`
                                if [ ! -z $EDITOR ]; then
                                        $EDITOR $DIRECTORY/$1.md
                                else
                                        vim $DIRECTORY/$1.md
                                fi
                                if [[ `stat -c %z $DIRECTORY/$1.md` != "$CHANGE" ]]; then
                                        _git "edit" "$1.md"
                                fi
                        fi
                        ;;
                *)
                        error "too many arguments for note edit"
                        edit help
                        ;;
        esac
}

move()
{
        case "$#" in
                0)
                        error "too few arguments for note move"
                        move help
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note move <old name of note> <new name of note>"
                                echo "Renames an existing note"
                        else
                                error "too few arguments for note move"
                                move help
                        fi
                        ;;
                2)
                        if [ ! -f $DIRECTORY/$1.md ]; then
                                error "$1.md does not exist!"
                        elif [ -f $DIRECTORY/$2.md ]; then
                                error "$2.md already exists!"
                        else
                                mv $DIRECTORY/$1.md $DIRECTORY/$2.md
                                _git "move" "$1.md" "$2.md"
                        fi
                        ;;
                *)
                        error "too many arguments for note move"
                        move help
                        ;;
        esac
}

delete()
{
        case "$#" in
                0)
                        error "too few arguments for note delete"
                        delete help
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note delete <name of note>"
                                echo "Deletes an existing note"
                        elif [ ! -f $DIRECTORY/$1.md ]; then
                                error "$1.md does not exist!"
                        else
                        read -p "Are you sure you want to delete the note $1.md? (y/N)" choice
                        case "$choice" in
                                y*|Y*)
                                        rm $DIRECTORY/$1.md
                                        _git "delete" "$1.md"
                                        ;;
                                *)
                                        echo "Aborting delete..."
                                        ;;
                        esac
                        fi
                        ;;
                *)
                        error "too many arguments for note delete"
                        delete help
                        ;;
        esac
}


