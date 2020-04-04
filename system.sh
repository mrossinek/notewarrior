# usage info
usage()
{
    _usage "note <${COMMANDS}>"
    echo "Use note <command> [help|usage] to find out more about a specific command."
    echo "Alternatively 'note usage commands' prints the help info for all commands"
    echo "and 'note usage config' prints the help info for possible configuratio options."
    IFS='|' read -ra cmds <<< "${COMMANDS}"
    misc=" commands config"
    if [[ ${cmds[*]}$misc =~ (^|[[:space:]])$2($|[[:space:]]) ]]; then
        if [ "$2" = "config" ]; then
            echo -e "${BBLUE}Configuration${NC}"
            echo -e "You can specify any of the following configuration options as simple bash variables."
            echo -e "Config files may be placed in $HOME/.noterc or $HOME/.config/notewarrior/config"
            echo -e "Alternatively you can provide a temporary config file with the -c <CONFIG> option."
            echo -e "${BBLUE}Variables${NC}"
            _config "DIRECTORY" "$HOME/.notes" "Path to the notes directory."
            _config "EXTENSION" "md" "File extension to use for notes."
            _config "ENABLE_GITWATCH" "true" "Whether to autostart gitwatch (true|false)."
            _config "OUTPUT_DIR" "=DIRECTORY" "Path where converted notes are stored in."
            _config "CSS_FILE" "style.css" "CSS filename for HTML generation.  Defaults to use vimwiki's default. This file needs to be present in OUTPUT_DIR."
        elif [ "$2" = "commands" ]; then
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


