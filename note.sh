#!/bin/sh

# CONSTANTS
# color constants
BOLD='\033[1;37m'
BRED='\033[1;31m'
BBLUE='\033[1;34m'
BYELLOW='\033[1;33m'
NC='\033[0m'  # no color
# list of all valid commands
COMMANDS="init|deinit|add|edit|move|delete|list|info|show|open|undo"

# source config
. ./config

# source functions
. ./helper.sh
. ./directory.sh
. ./file.sh
. ./view.sh
. ./system.sh

# main exectuion

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
