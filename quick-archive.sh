#!/bin/sh
#title     		: quick-archive.sh
#description   	: Provides a quicker way to archiving folders. 
#author			: dduits (https://github.com/dduits)
#license		: MIT, see the LICENSE file for more information.
#version        : 1.0
#usage		 	: sh quick-archive.sh ~/Documents/school ~/Documents

folder=$1
destination=$2

# Make sure the folder was provided and exist.
if [ -z "$folder" ] || [ ! -d "$folder" ]; then
    echo "ERR: Folder was invalid."
    exit 1
fi

# Make sure the destination folder was provided and exist.
if [ -z "$destination" ] || [ ! -d "$destination" ]; then
    echo "ERR: Destination folder was invalid."
    exit 1
fi

# Get the name of the folder.
folder_basename=$(basename "$folder")
# Get the parent directory.
parent_dir=$(dirname "$folder")

# Archive name e.g. Documents.tar.bz2.
archive_filename="$folder_basename.tar.bz2"

# Create the archive.
tar cjf "$destination"/"$archive_filename" -C "$parent_dir" "$folder_basename"