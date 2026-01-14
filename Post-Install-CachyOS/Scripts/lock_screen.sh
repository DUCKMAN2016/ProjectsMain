#!/bin/bash
SDDM_TEST=`pgrep -xa sddm-helper`
[[ $SDDM_TEST == *"--autologin"* ]] && {
    sleep 5
    echo "$(date): Autologin detected, locking screen" >> /tmp/lock_log.txt
    loginctl lock-session
}
