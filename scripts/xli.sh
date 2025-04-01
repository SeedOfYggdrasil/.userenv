#!/bin/bash

# xli.sh
# ver. 2.1

xli_chk() {
    if [ ! -f "$1" ]; then
        echo "Invalid target."
        exit 1
    fi
}

xli_a() {
    head -n "$2" "$1" >> "$3"
}

xli_b() {
    sed -n "$2,$3p" "$1" >> "$4"
}

xli() {
    local f="$1"
    local s="$2"
    local e="$3"

    local i=1
    local n=${4:-"${f}(${i})"}

    if [ -f "$n" ]; then
        local i=$((i+1))
        local n="${f}(${i})"
    fi

    xli_chk "$f"
    xli_chk "$n" 

    if [ -z "$4" ]; then
        xli_a "$f" "$s" "$n"
    else
        xli_b "$f" "$s" "$e" "$n"
    fi
}
