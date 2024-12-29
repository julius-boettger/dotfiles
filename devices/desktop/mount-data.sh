#!/bin/sh

# luks encrypted data partition
partition="disk/by-uuid/4a4090eb-701d-4eb3-bb9f-d417091c872f"

# gui prompt passphrase
passphrase=$(zenity --entry --title="Mount encrypted data partition" --text="Enter passphrase:" --hide-text)
# exit if prompt was canceled
if [[ $? != 0 ]]; then exit; fi

# try to unlock partition
echo -n $passphrase | pkexec cryptsetup luksOpen /dev/$partition data
if [[ $? != 0 ]]; then
    dunstify "mounting failed" "at luks unlock of encrypted data partition"
    exit
fi

# try to mount partition
pkexec mount /dev/mapper/data /mnt/data
if [[ $? != 0 ]]; then
    dunstify "mounting failed" "at mount of encrypted data partition"
fi