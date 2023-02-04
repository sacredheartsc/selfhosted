#!/bin/bash

exec 1> >(logger -s -t $(basename "$0")) 2>&1

usage() {
  echo "$0 -c CERT_PATH -k KEY_PATH [-o OWNER] [-m MODE] [POST_COMMAND ...]"
  exit 1
}

OWNER=root:root
MODE=400

while getopts ':c:k:m:o:' opt; do
  case $opt in
    c) CERT_PATH=$OPTARG ;;
    k) KEY_PATH=$OPTARG ;;
    m) MODE=$OPTARG ;;
    o) OWNER=$OPTARG ;;
    *) usage ;;
  esac
done

shift $((OPTIND-1))

if [ -z "$CERT_PATH" -o -z "$KEY_PATH" ]; then
  usage
fi

OWNER_USER=${OWNER%:*}
OWNER_GROUP=${OWNER#*:}
OWNER_GROUP=${OWNER_GROUP:-$OWNER_USER}

install -v -m "$MODE" -o "${OWNER_USER}" -g "${OWNER_GROUP}" "${RENEWED_LINEAGE}/fullchain.pem" "$CERT_PATH"
install -v -m "$MODE" -o "${OWNER_USER}" -g "${OWNER_GROUP}" "${RENEWED_LINEAGE}/privkey.pem"   "$KEY_PATH"

# run post-command
if (($#)); then
  echo "running post-command: $*"
  "$@"
fi
