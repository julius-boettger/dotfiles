#!/bin/sh

# luks encrypted data partition
partition="disk/by-uuid/4a4090eb-701d-4eb3-bb9f-d417091c872f"

# gui prompt passphrase
passphrase=$(zenity --entry --title="Mount encrypted data partition" --text="Enter passphrase:" --hide-text)
# exit if prompt was canceled
if [[ $? != 0 ]]; then exit; fi

# gui prompt password
password=$(zenity --password)
# exit if prompt was canceled
if [[ $? != 0 ]]; then exit; fi
# test if password is correct
echo -n $password | sudo -S true
if [[ $? != 0 ]]; then
    dunstify "mount failed" "password incorrect"
    exit
fi
# sudo should now just work for some time,
# as it was executed succesfully once

# try to unlock partition
echo -n $passphrase | sudo cryptsetup luksOpen /dev/$partition data
if [[ $? != 0 ]]; then
    dunstify "mount failed" "passphrase of encrypted data partition incorrect"
    exit
fi

# try to mount partition
sudo mount /dev/mapper/data /mnt/data
if [[ $? != 0 ]]; then
    dunstify "mount failed" "at actual mount of unlocked partition"
fi

dunstify "mount successful" "of encrypted data partition"