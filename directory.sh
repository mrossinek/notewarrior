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


