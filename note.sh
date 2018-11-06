#!/bin/sh

DIRECTORY="./tmp"
EDITOR="nvim"

init()
{
        git init $DIRECTORY
}

deinit()
{
        read -p "Are you sure you want to delete all user data in $DIRECTORY? (y/N)" choice
        case "$choice" in
                (y*|Y*)
                        rm -rf $DIRECTORY
                        ;;
                *)
                        echo "Aborting deinit..."
                        ;;
        esac
}

usage()
{
        echo "Usage: note [command]"
}

add()
{
        case "$#" in
                0)
                        echo "Usage: note add [name of new note]"
                        ;;
                1)
                        echo "Error: too few arguments for note add"
                        ;;
                2)
                        if [ "$1" != "add" ]; then
                                echo "Oops, something went wrong here."
                        elif [ -f $DIRECTORY/$2.md ]; then
                                echo "Error: $2.md already exists!"
                        else
                                echo "$2" > $DIRECTORY/$2.md
                                echo "$2" | sed 's/[^*]/=/g' >> $DIRECTORY/$2.md
                                $EDITOR $DIRECTORY/$2.md
                        fi
                        ;;
                *)
                        echo "Error: too many arguments for note add"
                        ;;
        esac
}

case "$1" in
        ""|h|help|usage)
                usage
                ;;
        init)
                init
                ;;
        deinit)
                deinit
                ;;
        add)
                add $@
                ;;
        *)
                echo "Error: $1 is an unknown command."
                echo "Aborting..."
                ;;
esac
