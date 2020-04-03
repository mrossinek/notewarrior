# note viewing
list()
{
    case "$#" in
        0)
            if ! tree -D "${DIRECTORY}" -P "*.${EXTENSION}" 2>/dev/null; then
                ls -l "${DIRECTORY}/*.${EXTENSION}"
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
            name=$( basename "$1" ".${EXTENSION}" )
            if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                _usage "note info <name of note>"
                echo "Prints the metadata of an existing note"
            elif [ ! -f "${DIRECTORY}/${name}.${EXTENSION}" ]; then
                error "$name.${EXTENSION} does not exist!"
            else
                echo "Name:         ${name}.${EXTENSION}"
                echo "Last change:  $(stat -c %z "${DIRECTORY}/${name}".${EXTENSION})"
                echo "Git history:"
                PWD=$(pwd)
                cd "${DIRECTORY}" || exit 1
                git log -p -- "${name}.${EXTENSION}"
                cd "${PWD}" || exit 1
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
            name=$( basename "$1" ".${EXTENSION}" )
            if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                _usage "note show <name of note>"
                echo "Prints an existing note to stdout"
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
                cat "${DIRECTORY}/${name}.${EXTENSION}"
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
                open "$1" html
            fi
            ;;
        2)
            name=$( basename "$1" ".${EXTENSION}" )
            if [ ! -f "${DIRECTORY}/${name}.${EXTENSION}" ]; then
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
                pandoc "${DIRECTORY}/${name}.${EXTENSION}" -s -o "${DIRECTORY}/${name}.$2"
                xdg-open "${DIRECTORY}/${name}.$2"
                rm "${DIRECTORY}/${name}.$2"
            fi
            ;;
        *)
            error "too many arguments for note open"
            open help
            ;;
    esac
}


