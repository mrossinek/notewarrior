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

init()
{
        case "$#" in
                0)
                        git init $DIRECTORY
                        ;;
                *)
                        error "too many arguments for note init"
                        ;;
        esac
}

deinit()
{
        case "$#" in
                0)
                        read -p "Are you sure you want to delete all user data in $DIRECTORY? (y/N)" choice
                        case "$choice" in
                                (y*|Y*)
                                        rm -rf $DIRECTORY
                                        ;;
                                *)
                                        echo "Aborting deinit..."
                                        ;;
                        esac
                        ;;
                *)
                        error "too many arguments for note deinit"
                        ;;
        esac
}

usage()
{
        echo "Usage: note [$commands]"
}

add()
{
        case "$#" in
                0)
                        echo "Usage: note add [name of new note]"
                        ;;
                1)
                        error "too few arguments for note add"
                        ;;
                2)
                        if [ "$1" != "add" ]; then
                                echo "Oops, something went wrong here."
                        elif [ -f $DIRECTORY/$2.md ]; then
                                error "$2.md already exists!"
                        else
                                echo "$2" > $DIRECTORY/$2.md
                                echo "$2" | sed 's/[^*]/=/g' >> $DIRECTORY/$2.md
                                $EDITOR $DIRECTORY/$2.md
                        fi
                        ;;
                *)
                        error "too many arguments for note add"
                        ;;
        esac
}

edit()
{
        case "$#" in
                0)
                        echo "Usage: note edit [name of note]"
                        ;;
                1)
                        error "too few arguments for note edit"
                        ;;
                2)
                        if [ "$1" != "edit" ]; then
                                echo "Oops, something went wrong here."
                        elif [ ! -f $DIRECTORY/$2.md ]; then
                                error "$2.md does not exist!"
                                read -p "Would you like to create it now? (Y/n)" choice
                                case "$choice" in
                                        (n*|N*)
                                                echo "Aborting..."
                                                ;;
                                        *)
                                                add add $2
                                                ;;
                                esac

                        else
                                $EDITOR $DIRECTORY/$2.md
                        fi
                        ;;
                *)
                        error "too many arguments for note edit"
                        ;;
        esac
}

move()
{
        case "$#" in
                0)
                        echo "Usage: note move [old name] [new name]"
                        ;;
                1|2)
                        error "too few arguments for note move"
                        ;;
                3)
                        if [ "$1" != "move" ]; then
                                echo "Oops, something went wrong here."
                        elif [ ! -f $DIRECTORY/$2.md ]; then
                                error "$2.md does not exist!"
                        elif [ -f $DIRECTORY/$3.md ]; then
                                error "$3.md already exists!"
                        else
                                mv $DIRECTORY/$2.md $DIRECTORY/$3.md
                        fi
                        ;;
                *)
                        error "too many arguments for note move"
                        ;;
        esac
}


delete()
{
        case "$#" in
                0)
                        echo "Usage: note delete [name of note]"
                        ;;
                1)
                        error "too few arguments for note delete"
                        ;;
                2)
                        if [ "$1" != "delete" ]; then
                                echo "Oops, something went wrong here."
                        elif [ ! -f $DIRECTORY/$2.md ]; then
                                error "$2.md does not exist!"
                        else
                                rm $DIRECTORY/$2.md
                        fi
                        ;;
                *)
                        error "too many arguments for note delete"
                        ;;
        esac
}


list()
{
        case "$#" in
                0)
                        tree -D $DIRECTORY
                        if [ "$?" -ne "0" ]; then
                                ls -l $DIRECTORY
                        fi
                        ;;
                *)
                        error "too many arguments for note list"
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
