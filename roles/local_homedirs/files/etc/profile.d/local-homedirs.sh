# This file contains various environment variables and hacks to accomodate
# applications that don't play well with NFS-mounted home directories.

if (( UID >= 1000 )); then
  export PYTHONUSERBASE="/usr/local/home/${USER}/.local"
  export npm_config_cache="/usr/local/home/${USER}/.npm"
  export CARGO_HOME="/usr/local/home/${USER}/.cargo"
  export GOPATH="/usr/local/home/${USER}/go"

  # firefox
  mkdir -p "/usr/local/home/${USER}/.mozilla"
  ln -sfn "/usr/local/home/${USER}/.mozilla" "${HOME}/.mozilla"

  # flatpak
  ln -sfn "/opt/flatpak/${USER}" "${HOME}/.var"

  # kwallet
  if [ -f "${HOME}/.local/share/kwalletd/kdewallet.salt" ]; then
    mkdir -p "/usr/local/home/${USER}/.local/share/kwalletd"
    ln -sfn "${HOME}/.local/share/kwalletd/kdewallet.salt" "/usr/local/home/${USER}/.local/share/kwalletd/kdewallet.salt"
  fi
fi
