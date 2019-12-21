#!/bin/sh
#title     		: mem-check.sh
#description   	: Checks if the available amount of memory has not 
#author			: dduits (https://github.com/dduits)
#license		: MIT, see the LICENSE file for more information.
#version        : 1.0
#usage		 	: sh mem-check.sh &>/dev/null &
#flags          : -v = verbose, prints verbose / debug information.
#                 -t = threshold, the minimum amount available memory in MB for a notify.
#                 -i = interval
#dependency     : Requires: getopts, free, awk, notify-send, paplay

# Minimum available memory limit in MB.
threshold=500

# Time in seconds the memory check will be performed again.
interval=5

# Will print out verbose memory checking information.
verbose=false

# Get flags.
while getopts "vt:i:" opt; do
    case $opt in
    v)
        verbose=true
        ;;
    t)
        threshold=$OPTARG
        ;;
    i)
        interval=$OPTARG
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

# Keeps track of whether the user has been notified.
hasNotified=false

# Repeat memory usage check indefinitely.
while :
do

    # Get the total amount available of memory (ram + swap).
    totalRam=$(free -m | awk '/^Mem:/{print $2}')
    totalSwap=$(free -m | awk '/^Swap:/{print $2}')
    totalMemSpace=$(($totalRam + $totalSwap))

    # Get the amount of used memory (used ram + used swap).
    usageRam=$(free -m | awk '/^Mem:/{print $3}')
    usageSwap=$(free -m | awk '/^Swap:/{print $3}')
    totalUsage=$(($usageRam + $usageSwap))

    # Calculate the amount of available memory.
    available=$(($totalMemSpace - $totalUsage))

    # Check if the available amount of memory is not lower then the threshold.
    if [ $available -lt $threshold ]; then
        # Don't notify the user if already notified.
        if [ "$hasNotified" != true ]; then
            notify-send -u critical "Only ${available} MB of memory / swap available."
            paplay /usr/share/sounds/LinuxMint/stereo/dialog-error.ogg
        fi
        hasNotified=true
    else
        # Reset the notify variable if the available amount of memory as decreased under the threshold.
        hasNotified=false
    fi

    # Only log verbose information if verbose flag was present.
    if [ "$verbose" = true ]; then
        echo "STATS:"
        echo "Total memory: ${totalMemSpace} MB, Total RAM: ${totalRam} MB, Total SWAP: ${totalSwap} MB"
        echo "Total usage: ${totalUsage} MB, RAM usage: ${usageRam} MB, SWAP usage: ${usageSwap} MB"
        echo "Available: $available MB, Threshold: $threshold MB, Interval: $interval SEC"
        echo
    fi

    # Sleep before repeating.
    sleep $interval

done