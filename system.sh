#!/bin/sh

# system management
undo()
{
        case "$#" in
                0)
                        PWD=`pwd`
                        cd $DIRECTORY
                        git show HEAD
                        read -p "Are you sure you want to undo the above changes? (y/N)" choice
                        case "$choice" in
                                y*|Y*)
                                        git revert --no-edit HEAD
                                        ;;
                                *)
                                        echo "Aborting undo..."
                                        ;;
                        esac
                        cd $PWD
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note undo"
                                echo "Undoes the last change to the note system (as recorded by git)"
                        else
                                error "too many arguments for note undo"
                                undo help
                        fi
                        ;;
                *)
                        error "too many arguments for note undo"
                       undo help
                        ;;
        esac
}


