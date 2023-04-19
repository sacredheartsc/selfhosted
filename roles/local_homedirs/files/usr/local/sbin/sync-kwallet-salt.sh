#!/bin/bash

PAM_UID=$(id -u "$PAM_USER")

LOCAL_SALT="/usr/local/home/${PAM_USER}/.local/share/kwalletd/kdewallet.salt"
NFS_SALT="/home/${PAM_USER}/.local/share/kwalletd/kdewallet.salt"

if (( PAM_UID >= 1000 )) && [ -f "$NFS_SALT" ]; then
  install -o "$PAM_USER" -g "$PAM_USER" -m 0755 -d "/usr/local/home/${PAM_USER}/.local"
  install -o "$PAM_USER" -g "$PAM_USER" -m 0755 -d "/usr/local/home/${PAM_USER}/.local/share"
  install -o "$PAM_USER" -g "$PAM_USER" -m 0755 -d "/usr/local/home/${PAM_USER}/.local/share/kwalletd"
  install -o "$PAM_USER" -g "$PAM_USER" -m 0600 "$NFS_SALT" "$LOCAL_SALT"
fi
