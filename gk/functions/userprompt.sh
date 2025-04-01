#!/bin/bash
# userprompt.sh | v.1.2 | 12.26.2024

userprompt_help() {
    echo
    echo "'USERPROMPT.sh'"
    echo "  USAGE"
    echo "        $ userprompt [opt] [str]"
    echo "  OPTIONS"
    echo "        [ -h | --help] : display usage information"
    echo "        [ + | add ]    : incrementally increase choice"
    echo "        [ str ]        : user prompt string"
    echo "  ADDITIONAL INFO"
    echo "        Unless '+' or 'add' is passed, the first argument"
    echo "        becomes the user prompt string, and the choice-"
    echo "        counter is reset to '1'. Passing '+' or 'add'"
    echo "        retains the user's choices from previous calls to"
    echo "        this function, allowing for complex scenarios."
    echo
}

userprompt() {
    local opt=$1
    local prompt="${2:-Continue?}"
    local var="choice_"
    local num=1

    if [[ "$opt" == "+" || "$opt" == "add" ]]; then
        true
    elif [[ "$opt" == "-h" || "$opt" == "--help" ]]; then
        userprompt_help
        return 0
    else
        unset $(compgen -v | grep "^${var}")
        prompt="$opt"
    fi

    while eval "[[ -n \${${var}${num}} ]]" 2>/dev/null; do
        ((num++))
    done

    local choice="${var}${num}"
    local user_input

    while true; do
        read -p "$prompt (Y/n): " user_input
        user_input=$(echo "$user_input" | tr '[:upper:]' '[:lower:]')

        case "$user_input" in
            y|yes)
                eval "${choice}=YES"
                export "${choice}"
                return 0
                ;;
            n|no)
                eval "${choice}=NO"
                export "${choice}"
                return 1
                ;;
            *)
                echo "Error: Invalid option '${user_input}'. Please enter 'Y' or 'N'."
                ;;
        esac
    done
}
