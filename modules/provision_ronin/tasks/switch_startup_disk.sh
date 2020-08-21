#!/usr/bin/env bash

if [[ $EUID != 0 ]] ; then
    echo "installr: Please run this as root, or via sudo."
    exit 1
fi

if [[ -z "${PT_volume}" ]]; then
    echo "Missing volume name"
    exit 1
fi

TARGET_VOL="${PT_volume}"

# Lookup disk info on target volume
if TARGET_VOL_DU=$(diskutil info -plist "${TARGET_VOL}"); then
    TARGET_VOL_MP=$(/usr/libexec/PlistBuddy -c "print MountPoint" /dev/stdin <<< "${TARGET_VOL_DU}")
else
    echo "Failed to find disk info on ${TARGET_VOL}"
    exit 1
fi

# Set startup disk or fail
systemsetup -setstartupdisk "${TARGET_VOL_MP}" || exit 1

exit 0
