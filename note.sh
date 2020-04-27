# shellcheck disable=SC1090,SC2034
# CONSTANTS
DEBUG=false
# color constants
BOLD='\033[1;37m'
BRED='\033[1;31m'
BBLUE='\033[1;34m'
BYELLOW='\033[1;33m'
NC='\033[0m'  # no color
# list of all valid commands
COMMANDS="init|deinit|add|edit|move|delete|list|info|show|open|undo"

# main exectuion
# parse command line options
while getopts ":c:d" opt; do
    case "$opt" in
        c)
            CONFIG="$OPTARG"
            shift 2
            ;;
        d)
            DEBUG=true
            shift 1
            ;;
        \?)
            error "Invalid command line option"
            usage "$@"
            exit 1
            ;;
        :)
            error "Option -$OPTARG requires an argument."
            exit 1
            ;;
    esac
done

# source config
if $DEBUG ; then
    DIRECTORY=/tmp/notewarrior-debug
elif [ -n "${CONFIG}" ]; then
    . "./${CONFIG}"
elif [ -f ~/.config/notewarrior/config ]; then
    . ~/.config/notewarrior/config
elif [ -f ~/.noterc ]; then
    . ~/.noterc
fi

# use defaults if nothing was set yet
if [ ! "${DIRECTORY}" ]; then
    DIRECTORY=~/.notes
fi
if [ ! "${ENABLE_GITWATCH}" ]; then
    ENABLE_GITWATCH=true
fi
if [ ! "${EXTENSION}" ]; then
    EXTENSION=md
fi
if [ ! -v "${OUTPUT_DIR}" ]; then
    OUTPUT_DIR="${DIRECTORY}"
fi
if [ ! "${CSS_FILE}" ]; then
    CSS_FILE=style.css
fi

# evaluate passed command arguments
eval "case \"$1\" in
\"\"|h|help|usage)
usage $*
;;
$COMMANDS)
    $*
    ;;
*)
    error \"$1 is an unknown command.\"
    usage $*
    ;;
esac"
