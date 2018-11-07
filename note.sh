#!/bin/sh

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

# source functions
. ./helper.sh
. ./directory.sh
. ./file.sh
. ./view.sh
. ./system.sh

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
                        usage
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
        . ./debug_config
elif [ ! -z ${CONFIG} ]; then
        . ./${CONFIG}
elif [ -f ~/.config/notewarrior/config ]; then
        . ~/.config/notewarrior/config
elif [ -f ~/.noterc ]; then
        . ~/.noterc
else
        . ./default_config
fi

# evaluate passed command arguments
eval "case \"$1\" in
        \"\"|h|help|usage)
                usage $@
                ;;
        $COMMANDS)
                $@
                ;;
        *)
                error \"$1 is an unknown command.\"
                usage $@
                ;;
esac"
