#!/bin/sh

DIRECTORY="./tmp/"

init()
{
        git init $DIRECTORY
}

deinit()
{
        read -p "Are you sure you want to delete all user data in $DIRECTORY? (y/N)" choice
        case "$choice" in
                (y*|Y*) rm -rf $DIRECTORY
                ;;
                *) echo "Aborting deinit..."
                ;;
        esac
}

usage()
{
 echo "Usage: note [command]"
}

case "$1" in
        ""|h|help|usage) usage
        ;;
        init) init
        ;;
        deinit) deinit
        ;;
        *) echo "Error: $1 is an unknown command.\nAborting..."
        ;;
esac
