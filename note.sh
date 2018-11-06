#!/bin/sh

# color constants
BOLD='\033[1;37m'
BRED='\033[1;31m'
BBLUE='\033[1;34m'
BYELLOW='\033[1;33m'
NC='\033[0m'  # no color

# source config
. ./config


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


# directory management
init()
{
        case "$#" in
                0)
                        git init $DIRECTORY
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note init"
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
                        if [ ! -d $DIRECTORY ]; then
                                error "$DIRECTORY does not exist!"
                        else
                                read -p "Are you sure you want to delete all user data in $DIRECTORY? (y/N)" choice
                                case "$choice" in
                                        y*|Y*)
                                                rm -rf $DIRECTORY
                                                ;;
                                        *)
                                                echo "Aborting deinit..."
                                                ;;
                                esac
                        fi
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note deinit"
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


# file editing
add()
{
        case "$#" in
                0)
                        error "too few arguments for note add"
                        add help
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note add <name of new note>"
                                echo "Adds a new note"
                        elif [ -f $DIRECTORY/$1.md ]; then
                                error "$1.md already exists!"
                        else
                                echo "$1" > $DIRECTORY/$1.md
                                echo "$1" | sed 's/[^*]/=/g' >> $DIRECTORY/$1.md
                                $EDITOR $DIRECTORY/$1.md
                                _git "add" "$1.md"
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
                                _usage "note edit <name of note>"
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
                                CHANGE=`stat -c %z $DIRECTORY/$1.md`
                                $EDITOR $DIRECTORY/$1.md
                                if [[ `stat -c %z $DIRECTORY/$1.md` != "$CHANGE" ]]; then
                                        _git "edit" "$1.md"
                                fi
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
                                _usage "note move <old name of note> <new name of note>"
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
                                _git "move" "$1.md" "$2.md"
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
                                _usage "note delete <name of note>"
                                echo "Deletes an existing note"
                        elif [ ! -f $DIRECTORY/$1.md ]; then
                                error "$1.md does not exist!"
                        else
                        read -p "Are you sure you want to delete the note $1.md? (y/N)" choice
                        case "$choice" in
                                y*|Y*)
                                        rm $DIRECTORY/$1.md
                                        _git "delete" "$1.md"
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


# note viewing
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
                                _usage "note list"
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

info()
{
        case "$#" in
                0)
                        error "too few arguments for note info"
                        info help
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note info <name of note>"
                                echo "Prints the metadata of an existing note"
                        elif [ ! -f $DIRECTORY/$1.md ]; then
                                error "$1.md does not exist!"
                        else
                                echo "Name:         $1.md"
                                echo "Last change:  `stat -c %z $DIRECTORY/$1.md`"
                                echo "Git history:"
                                PWD=`pwd`
                                cd $DIRECTORY
                                git log -p -- $1.md
                                cd $PWD
                        fi
                        ;;
                *)
                        error "too many arguments for note info"
                        info help
                        ;;
        esac
}

show()
{
        case "$#" in
                0)
                        error "too few arguments for note show"
                        show help
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note show <name of note>"
                                echo "Prints an existing note to stdout"
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
                                cat $DIRECTORY/$1.md
                        fi
                        ;;
                *)
                        error "too many arguments for note show"
                        show help
                        ;;
        esac
}

open()
{
        case "$#" in
                0)
                        error "too few arguments for note open"
                        open help
                        ;;
                1)
                        if [[ "$1" =  "help" || "$1" = "usage" ]]; then
                                _usage "note open <name of note> [html|pdf]"
                                echo "Opens the note in the specified format (html by default)"
                        else
                                open $1 html
                        fi
                        ;;
                2)
                        if [ ! -f $DIRECTORY/$1.md ]; then
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
                                case "$2" in
                                        html)
                                                pandoc $DIRECTORY/$1.md -s -o $DIRECTORY/$1.html
                                                $BROWSER $DIRECTORY/$1.html
                                                rm $DIRECTORY/$1.html
                                                ;;
                                        pdf)
                                                pandoc $DIRECTORY/$1.md -s -o $DIRECTORY/$1.pdf
                                                $PDFVIEWER $DIRECTORY/$1.pdf
                                                rm $DIRECTORY/$1.pdf
                                                ;;
                                        *)
                                                error "incompatible note opening format"
                                                echo "Aborting open..."
                                                ;;
                                esac
                        fi
                        ;;
                *)
                        error "too many arguments for note open"
                        open help
                        ;;
        esac
}


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
