#!/bin/bash

set -eu

uid=$(id -u)
username=$(id -un)

if (( uid >= 1000 )); then
  echo "XDG_DATA_HOME=/usr/local/home/${username}/.local/share"
  echo "XDG_STATE_HOME=/usr/local/home/${username}/.local/state"
  echo "XDG_CACHE_HOME=/usr/local/home/${username}/.cache"
  echo "XDG_CONFIG_HOME=/usr/local/home/${username}/.config"
  echo "KDEHOME=/usr/local/home/${username}/.kde"
fi
