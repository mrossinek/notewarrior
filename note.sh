#!/bin/sh

DIRECTORY="./tmp/"

init()
{
        CURDIR=`pwd`
        mkdir -p $DIRECTORY
        cd $DIRECTORY
        git init
        cd $CURDIR
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

