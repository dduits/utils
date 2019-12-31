#!/bin/sh

folder_path=$1
destination_path=$2

folder_basename=$(basename "$folder_path")
folder_parent_path="$(readlink -f "$(basename "$(dirname "$folder_path")")")"

archive_file_name="$folder_basename.tar.bz2"
archive_path="$(readlink -f "$2")"

tar cjf "$archive_path"/"$archive_file_name" -C "$folder_parent_path" "$folder_basename"
