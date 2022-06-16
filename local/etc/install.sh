#!/bin/sh
function ask() {
    read -p "$1 (y/N): " -r -n1
    echo
    case $(echo $REPLY | tr '[A-Z]' '[a-z]') in
        y|yes) return 0;;
        *)     return 1;;
    esac

}

function copyconf() {
    RSYNC="rsync -ai --info=NAME --chown root:root --chmod=0644"
    if [[ -z "$2" ]]; then
        sudo $RSYNC "$MY_PATH/$1" "/etc/$1"
    else
        sudo $RSYNC "$MY_PATH/$1" $2
    fi
}

MY_PATH=$(dirname "$0")

copyconf vconsole.conf
copyconf ruwin_alt_sh_caps2ctrl-UTF-8.map.gz "/usr/share/kbd/keymaps/i386/qwerty/"

ask "Do you use keychron keyboard?" &&
    copyconf modprobe.d/keychron.conf
ask "Disable btusb autosuspend?" &&
    copyconf modprobe.d/btusb.conf
ask "Disable usb autosuspend?" &&
    copyconf modprobe.d/usbcore.conf
ask "Do you use ntfs3 module?" &&
    copyconf modules-load.d/ntfs3.conf &&
    copyconf udev/rules.d/80-ntfs3.rules
ask "Do you use ddcutil (to adjust screen brightness)?" &&
    copyconf modules-load.d/i2c.conf &&
    copyconf udev/rules.d/45-ddcutil-i2c.rules

