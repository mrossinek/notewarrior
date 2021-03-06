# wrapper functions
error()
{
    >&2 echo -e "${BRED}Error${NC}: $1"
}

warning()
{
    >&2 echo -e "${BYELLOW}Warning${NC}: $1"
}

_usage()
{
    echo -e "${BYELLOW}Usage${NC}: $1"
}

_config()
{
    echo -e "${BYELLOW}$1${NC} [Default: $2]"
    echo -e "$3"
}

_git()
{
    PWD=$(pwd)
    cd "${DIRECTORY}" || exit 1

    case "$1" in
        add)
            git add "$2"
            git commit -m "Added $2"
            ;;
        edit)
            git add "$2"
            git commit -m "Edited $2"
            ;;
        move)
            git rm "$2"
            git add "$3"
            git commit -m "Moved $2 to $3"
            ;;
        delete)
            git rm "$2"
            git commit -m "Deleted $2"
            ;;
        *)
            error "Unknown internal git operation"
            echo "Aborting..."
            ;;
    esac

    if [ "$(git status -s | wc -l)" != "0" ]; then
        warning "There are unstaged changes in your repo!"
        read -rp "Would you like to work on this? [Yes/no] " choice
        case "${choice}" in
            (n*|N*)
                cd "${PWD}" || exit 1
                ;;
            *)
                warning "You will be dropped into a subshell inside your notes directory!"
                echo -e "You can leave by typing '${BRED}exit${NC}'"
                cd "${DIRECTORY}" || exit 1
                exec "${SHELL}"
                ;;
        esac
    else
        cd "${PWD}" || exit 1
    fi
}


