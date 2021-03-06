# file editing
add()
{
    case "$#" in
        0)
            error "too few arguments for note add"
            add help
            ;;
        1)
            name=$( basename "$1" ".${EXTENSION}" )
            if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                _usage "note add <name of new note>"
                echo "Adds a new note"
            elif [ -f "${DIRECTORY}/${name}.${EXTENSION}" ]; then
                error "${name}.${EXTENSION} already exists!"
            else
                echo "% ${name}" > "${DIRECTORY}/${name}.${EXTENSION}"
                if [ -n "${EDITOR}" ]; then
                    ${EDITOR} "${DIRECTORY}/${name}.${EXTENSION}"
                else
                    vim "${DIRECTORY}/${name}.${EXTENSION}"
                fi
                _git "add" "${name}.${EXTENSION}"
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
            name=$( basename "$1" ".${EXTENSION}" )
            if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                _usage "note edit <name of note>"
                echo "Edits an existing note"
            elif [ ! -f "${DIRECTORY}/${name}.${EXTENSION}" ]; then
                error "${name}.${EXTENSION} does not exist!"
                read -rp "Would you like to create it now? (Y/n)" choice
                case "${choice}" in
                    (n*|N*)
                        echo "Aborting..."
                        ;;
                    *)
                        add "${name}"
                        ;;
                esac

            else
                CHANGE=$(stat -c %z "${DIRECTORY}/${name}.${EXTENSION}")
                if [ -n "${EDITOR}" ]; then
                    ${EDITOR} "${DIRECTORY}/${name}.${EXTENSION}"
                else
                    vim "${DIRECTORY}/${name}.${EXTENSION}"
                fi
                if [ "$(stat -c %z "${DIRECTORY}/${name}.${EXTENSION}")" != "${CHANGE}" ]; then
                    _git "edit" "${name}.${EXTENSION}"
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
            name1=$( basename "$1" ".${EXTENSION}" )
            name2=$( basename "$2" ".${EXTENSION}" )
            if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                _usage "note move <old name of note> <new name of note>"
                echo "Renames an existing note"
            else
                error "too few arguments for note move"
                move help
            fi
            ;;
        2)
            if [ ! -f "${DIRECTORY}/${name1}.${EXTENSION}" ]; then
                error "${name1}.${EXTENSION} does not exist!"
            elif [ -f "${DIRECTORY}/${name2}.${EXTENSION}" ]; then
                error "${name2}.${EXTENSION} already exists!"
            else
                mv "${DIRECTORY}/${name1}.${EXTENSION}" "${DIRECTORY}/${name2}.${EXTENSION}"
                _git "move" "${name1}.${EXTENSION}" "${name2}.${EXTENSION}"
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
            name=$( basename "$1" ".${EXTENSION}" )
            if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                _usage "note delete <name of note>"
                echo "Deletes an existing note"
            elif [ ! -f "${DIRECTORY}/${name}.${EXTENSION}" ]; then
                error "${name}.${EXTENSION} does not exist!"
            else
                read -rp "Are you sure you want to delete the note ${name}.${EXTENSION}? (y/N)" choice
                case "${choice}" in
                    y*|Y*)
                        rm "${DIRECTORY}/${name}.${EXTENSION}"
                        _git "delete" "${name}.${EXTENSION}"
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


