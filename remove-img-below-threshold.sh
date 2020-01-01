#!/bin/sh
# title: remove-img-below-threshold.sh
# description: Removes an image that is below a mega pixels threshold.
# author: dduits (https://github.com/dduits)
# license: MIT, see the LICENSE file for more information.
# version: 1.0
# usage: find -type f -exec remove-img-below-threshold.sh -t 2.0 -i {} \;

while getopts "t:i:" opt; do
    case $opt in
    t) threshold=$OPTARG;;
    i) 
        if [ -f "$OPTARG" ]; then
            image="$OPTARG"
        else
            echo "ERR: Image not found."
            exit 1
        fi
        ;;
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

# Require threshold to be set.
if [ -z "$threshold" ]; then
    echo "ERR: threshold was not provided."
    exit 1
fi

# Require image to be set.
if [ -z "$image" ]; then
    echo "ERR: No image provided."
    exit 1
fi

# Make sure the file is an image.
if [ -z "$(file "$image" | grep image)" ]; then
    echo "not an image, skipping: $image"
    exit 0
fi

# Calculate the amount of pixels from the mp pixel value.
threshold=$(echo "$threshold * 1000000 / 1" | bc)

# Get the resolution.
image_resolution=$(identify -format "%[fx:w]x%[fx:h]" "$image" | head -1)
# Split the resolution string into two strings (width and height).
IFS='x' read -ra ADDR <<< "$image_resolution"
# Calculate the total amount of pixels.
pixels=$(( ${ADDR[0]} * ${ADDR[1]} ))

# If the amount of pixels is lower then the defined threshold remove the image.
if [ $pixels -lt $threshold ]; then
    action="deleting: $image"
    rm "$image"
else
    action="skipping: $image"
fi

echo "resolution: $image_resolution, pixels: $pixels, $action"

exit 0