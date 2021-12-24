export RPD=~/projects/rust
__rust_codium() {
    codium . src/*.rs Cargo.toml
}

__rust_help="
Usage:
------
    new [bin/lib] [PROJECT_NAME]
      Creates a new bin/lib project with name PROJECT_NAME
    open [PROJECT_NAME]
      Opens project named PROJECT_NAME inside the rust projects directory set in \$RPD
    remove [PROJECT_NAME]
      Deletes a project in the rust projects directory set in \$RPD named PROJECT_NAME. 
      You will be asked to confirm PROJECT_NAME by typing it out again in full.
    rename [PROJECT_NAME] [NEW_NAME]
      Renames project named PROJECT_NAME as NEW_NAME so long as there is no existing project with the name NEW_NAME 
    list
      Runs 'ls -d */' in the rust project directory set in \$RPD
    help
      Prints this usage message

Return Codes:
-------------
    code | description
    -----|------------
    0    | Function completed successfully 
    1    | Incorrect command
    2    | For 'new' command, \$2 must be either 'lib' or 'bin'
    3    | For both 'new' \$3 and 'rename' \$3, project already exists with entered name 
    4    | For 'open' \$2, 'rename' \$2 and remove \$2, project does not exist with entered name.
    5    | Not yet implemented
    6    | failed to confirm deletion in 'remove'
    7    | 
"

rust() {
    # echo "Running 'rust'"
    case $1 in
        new) # rust new bin/lib [name]
            if test -d "$RPD/$3"; then
                echo "Project already exists!"
                return 3
            fi
            case $2 in
                bin)
                    cargo new --bin "$RPD/$3"
                    cd "$RPD/$3"
                    __rust_codium
                ;;
                lib)
                    cargo new --lib "$RPD/$3"
                    cd "$RPD/$3"
                    __rust_codium
                ;;
                *)
                    echo "Unknown project type '$2'. Should be either 'bin' or 'lib'."
                    return 2
                ;;
            esac
        ;;
        open) # rust open [name]
            if test ! -d "$RPD/$2"; then
                echo "Project '$2' does not exist."
                return 4
            fi
            cd "$RPD/$2"
            __rust_codium
        ;;
        remove) # rust remove [name] -> confirm [name]
            if test ! -d "$RPD/$2"; then
                echo "Project '$2' does not exist"
                return 4
            fi
            echo "Please type '$2' again to confirm deletion: "
            read confirmation
            if test $2 != $confirmation; then
                echo "'$confirmation' does not match '$2'."
                return 6
            fi
            rm -r "$RPD/$2"
        ;;
        rename) # rust rename [name] [new_name]
            if test ! -d "$RPD/$2"; then
                echo "Project '$2 does not exist."
                return 4
            fi
            if test -d "$RPD/$3"; then
                echo "A project with the name '$3' already exists."
                return 3
            fi
            mv "$RPS/$2" "$RPD/$3"
        ;;
        list) # rust list
            cd $RPD
            ls -D
            cd - >/dev/null
        ;;
        help) # rust help
            echo "$__rust_help"
        ;;
        *) #rust random
            echo "Unknown command, please run 'rust help' to learn how to use this function."
            return 1
        ;;
    esac
}