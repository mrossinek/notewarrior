# usage info
usage()
{
    _usage "note <${COMMANDS}>"
    echo "Use note <command> [help|usage] to find out more about a specific command."
    echo "Alternatively note usage all prints the help info for all commands."
    IFS='|' read -ra cmds <<< "${COMMANDS}"
    all=" all"
    if [[ ${cmds[*]}$all =~ (^|[[:space:]])$2($|[[:space:]]) ]]; then
        if [ "$2" = "all" ]; then
            for cmd in "${cmds[@]}"; do
                echo -e "${BBLUE}$cmd${NC}"
                "${cmd}" usage
            done
        else
            echo -e "${BBLUE}$2${NC}"
            "$2" usage
        fi
    fi
}


# system management
undo()
{
    case "$#" in
        0)
            PWD=$(pwd)
            cd "${DIRECTORY}" || exit 1
            git show HEAD
            read -rp "Are you sure you want to undo the above changes? (y/N)" choice
            case "${choice}" in
                y*|Y*)
                    git revert --no-edit HEAD
                    ;;
                *)
                    echo "Aborting undo..."
                    ;;
            esac
            cd "${PWD}" || exit 1
            ;;
        1)
            if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                _usage "note undo"
                echo "Undoes the last change to the note system (as recorded by git)"
            else
                error "too many arguments for note undo"
                undo help
            fi
            ;;
        *)
            error "too many arguments for note undo"
            undo help
            ;;
    esac
}


