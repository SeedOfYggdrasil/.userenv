#!/bin/bash

load_gui() {

    if "$(whoami)" == "root" ]; then
    	systemctl start lightdm || init 5 || echo "Could not load Desktop (lightdm)!" && return 1
    else
        sudo systemctl start lightdm || sudo init 5 || echo "Could not load Desktop (lightdm)!" && return 1
    fi
}

desktop() {
    load_gui
}

