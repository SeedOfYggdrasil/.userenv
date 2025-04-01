#!/bin/bash

load_gui_colors() {
    if [ -e "$HOME/.userenv/color" ] && [ -f "$HOME/.userenv/color" ]; then
        source "$HOME/.userenv/color" &>/dev/null
    fi
}

load_gui_error() {
    if [ -z ${bold_red} ]; then
        load_gui_colors
    elif [ -z ${nc} ]; then
        load_gui_colors
    fi

    local c1=${bold_red}
    local c0=${nc}

    echo -e "${c1}Error${c0}: Could not load desktop environment. Is LightDM installed?" && exit 1 &>/dev/null
}

load_gui() {
    if [ -z ${cyan} ]; then
        load_gui_colors
    elif [ -z ${nc} ]; then
        load_gui_colors
    fi

    local c1=${cyan}
    local c0=${nc}

    echo -e "${c1}Loading desktop environment. Please wait...${c0}"

    if "$(whoami)" == "root" ]; then
    	systemctl start lightdm || init 5 || load_gui_error && return 1
    else
        sudo systemctl start lightdm || sudo init 5 || load_gui_error && return 1
    fi
}

desktop() {
    load_gui
}

