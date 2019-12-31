#!/bin/sh
#title     		: xcopy.sh
#description   	: Copies stdin to the clipboard.
#author			: dduits (https://github.com/dduits)
#license		: MIT, see the LICENSE file for more information.
#version        : 1.0
#usage		 	: echo "testing" | xcopy.sh

# Get from standard input.
[ $# -ge 1 -a -f "$1" ] && input="$1" || input="-"
input=$(cat $input)

trim=false

while getopts "t" opt; do
    case $opt in
    t) trim=true;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
    esac
done

# If user has provided the -t flag then remove a trailing break line (if present).
if [ "$trim" = true ]; then
    echo "$input" | grep '^' | head -c-1 - | xclip -selection c
else
    echo "$input" | xclip -selection c
fi

exit 0