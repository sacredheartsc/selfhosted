#!/bin/bash

PAM_UID=$(id -u "$PAM_USER")

if (( PAM_UID >= 1000 )); then
  install -o "$PAM_USER" -g "$PAM_USER" -m 0700 -d "/usr/local/home/$PAM_USER"

  # Flatpak shadows /usr with its own runtime, so we need a path that flatpak
  # doesn't touch. /opt seems appropriate.
  install -o "$PAM_USER" -g "$PAM_USER" -m 0700 -d "/opt/flatpak/$PAM_USER"
fi
