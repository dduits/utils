#!/bin/sh
#title     		: lrename.sh
#description   	: Renames a file or folder to be lowercase and have hyphen for spaces.
#author			: dduits (https://github.com/dduits)
#license		: MIT, see the LICENSE file for more information.
#version        : 1.0
#usage		 	: sh lrename.sh ~/Documents/File\ With\ Spaces.txt

file=$1
parent_dir="$(dirname "$file")"
lowercase_filename=$($(basename "$file") | tr '[:upper:]' '[:lower:]' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/ /-/g')
mv "$file" "$parent_dir/$lowercase_filename"