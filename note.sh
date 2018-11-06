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

edit()
{
        case "$#" in
                0)
                        echo "Usage: note edit [name of note]"
                        ;;
                1)
                        echo "Error: too few arguments for note edit"
                        ;;
                2)
                        if [ "$1" != "edit" ]; then
                                echo "Oops, something went wrong here."
                        elif [ ! -f $DIRECTORY/$2.md ]; then
                                echo "Error: $2.md does not exist!"
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
                        echo "Error: too many arguments for note edit"
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
                        echo "Error: too few arguments for note move"
                        ;;
                3)
                        if [ "$1" != "move" ]; then
                                echo "Oops, something went wrong here."
                        elif [ ! -f $DIRECTORY/$2.md ]; then
                                echo "Error: $2.md does not exist!"
                        elif [ -f $DIRECTORY/$3.md ]; then
                                echo "Error: $3.md already exists!"
                        else
                                mv $DIRECTORY/$2.md $DIRECTORY/$3.md
                        fi
                        ;;
                *)
                        echo "Error: too many arguments for note move"
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
                        echo "Error: too few arguments for note delete"
                        ;;
                2)
                        if [ "$1" != "delete" ]; then
                                echo "Oops, something went wrong here."
                        elif [ ! -f $DIRECTORY/$2.md ]; then
                                echo "Error: $2.md does not exist!"
                        else
                                rm $DIRECTORY/$2.md
                        fi
                        ;;
                *)
                        echo "Error: too many arguments for note delete"
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
        edit)
                edit $@
                ;;
        move)
                move $@
                ;;
        delete)
                delete $@
                ;;
        *)
                echo "Error: $1 is an unknown command."
                echo "Aborting..."
                ;;
esac
