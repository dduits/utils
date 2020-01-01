#!/bin/sh
#title          : sort-img-by-dimensions.sh
#description    : Sorts an image into either a mobile or a desktop folder based on the resolution.
#author         : dduits (https://github.com/dduits)
#license        : MIT, see the LICENSE file for more information.
#version        : 1.0
#usage          : find ~/Pictures/wallpapers -type f -exec sort-img-by-dimensions.sh {} ~/Pictures/wallpapers-sorted \;

file="$1"
output_path="$2"

# Require the file path.
if [ -z "$file" ]; then
    echo 'ERR: image file was not provided.'
    exit 1
fi

# Require the file to exit.
if [ ! -f "$file" ]; then
    echo "ERR: image file didn't exist: $file"
    exit 1
fi

# Require a output path.
if [ -z "$output_path" ]; then
    echo 'ERR: output path was not provided'
    exit 1
fi

# Require the output path to exit.
if [ ! -d "$output_path" ]; then
    echo "ERR: output path didn't exist: $output_path"
    exit 1
fi

# Make sure the file is an image.
if [ -z "$(file "$file" | grep image)" ]; then
    echo "INFO: not an image, skipping: $file"
    exit 0
fi

# Get the resolution.
image_resolution=$(identify -format "%[fx:w]x%[fx:h]" "$file" | head -1)
# Split the resolution string into two strings (width and height).
IFS='x' read -ra resolutions <<< "$image_resolution"

# Move the file to new folder for either mobile or desktop images.
if [ ${resolutions[0]} -gt ${resolutions[1]} ];then
    type="desktop"
    mkdir -p "$output_path/desktop"
    mv "$file" "$output_path/desktop"
else
    type="mobile"
    mkdir -p "$output_path/mobile"
    mv "$file" "$output_path/mobile"
fi

echo "INFO: $type image: $file"

exit 0