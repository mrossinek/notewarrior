#!/bin/sh

BRED='\033[1;31m'
BYELLOW='\033[1;33m'
NC='\033[0m'  # no color

DIRECTORY="./tmp"
EDITOR="nvim"

error()
{
        >&2 echo -e "${BRED}Error${NC}: $1"
}

warning()
{
        >&2 echo -e "${BYELLOW}Warning${NC}: $1"
}


usage()
{
        echo "Usage: note [$commands]"
        echo "Use note [command] [help|usage] to find out more about a specific command"
        # IFS='|' read -ra cmds <<< "$commands"
        # for cmd in "${cmds[@]}"; do
        #         $cmd usage
        # done
}


init()
{
        case "$#" in
                0)
                        git init $DIRECTORY
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                echo "Usage: note init"
                                echo "Initializes the configured directory with git"
                        else
                                error "too many arguments for note init"
                                init help
                        fi
                        ;;
                *)
                        error "too many arguments for note init"
                       init help
                        ;;
        esac
}

deinit()
{
        case "$#" in
                0)
                        read -p "Are you sure you want to delete all user data in $DIRECTORY? (y/N)" choice
                        case "$choice" in
                                y*|Y*)
                                        rm -rf $DIRECTORY
                                        ;;
                                *)
                                        echo "Aborting deinit..."
                                        ;;
                        esac
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                echo "Usage: note deinit"
                                echo "Removes the configured directory and all its contents"
                        else
                                error "too many arguments for note deinit"
                                deinit help
                        fi
                        ;;
                *)
                        error "too many arguments for note deinit"
                        deinit help
                        ;;
        esac
}


add()
{
        case "$#" in
                0)
                        error "too few arguments for note add"
                        add help
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                echo "Usage: note add [name of new note]"
                                echo "Adds a new note"
                        elif [ -f $DIRECTORY/$1.md ]; then
                                error "$1.md already exists!"
                        else
                                echo "$1" > $DIRECTORY/$1.md
                                echo "$1" | sed 's/[^*]/=/g' >> $DIRECTORY/$1.md
                                $EDITOR $DIRECTORY/$1.md
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
                                echo "Usage: note edit [name of note]"
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
                                $EDITOR $DIRECTORY/$1.md
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
                                echo "Usage: note move [old name of note] [new name of note]"
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
                                echo "Usage: note delete [name of note]"
                                echo "Deletes an existing note"
                        elif [ ! -f $DIRECTORY/$1.md ]; then
                                error "$1.md does not exist!"
                        else
                        read -p "Are you sure you want to delete the note $1.md? (y/N)" choice
                        case "$choice" in
                                y*|Y*)
                                        rm $DIRECTORY/$1.md
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


list()
{
        case "$#" in
                0)
                        tree -D $DIRECTORY 2> /dev/null
                        if [ "$?" -ne "0" ]; then
                                ls -l $DIRECTORY
                        fi
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                echo "Usage: note list"
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


commands="init|deinit|add|edit|move|delete|list"

eval "case \"$1\" in
        \"\"|h|help|usage)
                usage
                ;;
        $commands)
                $@
                ;;
        *)
                error \"$1 is an unknown command.\"
                echo \"Aborting...\"
                ;;
esac"
