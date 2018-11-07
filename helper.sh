#!/bin/sh

# wrapper functions
error()
{
        >&2 echo -e "${BRED}Error${NC}: $1"
}

warning()
{
        >&2 echo -e "${BYELLOW}Warning${NC}: $1"
}

_usage()
{
        echo -e "${BYELLOW}Usage${NC}: $1"
}

_git()
{
        PWD=`pwd`
        cd $DIRECTORY

        case "$1" in
                add)
                        git add $2
                        git commit -m "Added $2"
                        ;;
                edit)
                        git add $2
                        git commit -m "Edited $2"
                        ;;
                move)
                        git rm $2
                        git add $3
                        git commit -m "Moved $2 to $3"
                        ;;
                delete)
                        git rm $2
                        git commit -m "Deleted $2"
                        ;;
                *)
                        error "Unknown internal git operation"
                        echo "Aborting..."
                        ;;
        esac

        cd $PWD
}


