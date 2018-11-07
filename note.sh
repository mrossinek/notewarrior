#!/bin/sh

# color constants
BOLD='\033[1;37m'
BRED='\033[1;31m'
BBLUE='\033[1;34m'
BYELLOW='\033[1;33m'
NC='\033[0m'  # no color

# source config
. ./config

# source functions
. ./helper.sh
. ./directory.sh
. ./file.sh
. ./view.sh
. ./system.sh

# usage info
usage()
{
        _usage "note <$commands>"
        echo "Use note <command> [help|usage] to find out more about a specific command"
        echo "Alternatively note usage all prints the help info for all commands"
        if [ "$2" = "all" ]; then
                IFS='|' read -ra cmds <<< "$commands"
                for cmd in "${cmds[@]}"; do
                        echo -e "${BBLUE}$cmd${NC}"
                        $cmd usage
                done
        fi
}


# main exectuion
# list of all valid commands
commands="init|deinit|add|edit|move|delete|list|info|show|open|undo"

# evaluate passed command arguments
eval "case \"$1\" in
        \"\"|h|help|usage)
                usage $@
                ;;
        $commands)
                $@
                ;;
        *)
                error \"$1 is an unknown command.\"
                usage $@
                ;;
esac"
