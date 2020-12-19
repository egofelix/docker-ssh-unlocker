#!/bin/bash

# Check if HOST_NAME was provided
if [[ -z ${HOST_NAME:-} ]]; then
  echo "Please provide the target hostname in HOST_NAME"
  exit
fi;

# Default Port
if [[ -z ${HOST_PORT:-} ]]; then
  HOST_PORT="22"
fi;

# Default User
if [[ -z ${HOST_USER:-} ]]; then
  HOST_USER="root"
fi;

# Check if SSH Public Key is provided
if [[ -z ${HOST_PUBKEY:-} ]]; then
  if [[ -f "/data/host.key" ]]; then
    HOST_PUBKEY=$(cat /data/host.key)
  fi;
fi
if [[ -z ${HOST_PUBKEY:-} ]]; then
  echo "Please provide the ssh public key of the host in HOST_SSH_PUB_KEY or /data/host.key"
  exit
fi;

# Check if private key is provided
if [[ ! -f "/data/private.key" ]]; then
  echo "Please provide private-key in /data/private.key"
fi

# Check if unlock-keyfile is provided
if [[ -z ${HOST_UNLOCK_KEY:-} ]]; then
  if [[ -f "/data/unlock.key" ]]; then
    HOST_UNLOCK_KEY=$(cat /data/unlock.key)
  fi;
fi
if [[ -z ${HOST_UNLOCK_KEY:-} ]]; then
  echo "Please provide the ssh unlock key in HOST_UNLOCK_KEY or /data/unlock.key"
  exit
fi;

# All checks done

# Generate known_hosts file
mkdir -p ~/.ssh/
echo "[${HOST_NAME}]:${HOST_PORT} ${HOST_PUBKEY}" > /tmp/known_hosts
PUBKEY=`ssh-keygen -y -f /data/private.key`

while true; do
  echo "Trying to unlock using key: ${PUBKEY}"
  echo -n "${HOST_UNLOCK_KEY}" | ssh -o "UserKnownHostsFile /tmp/known_hosts" -o "IdentityFile /tmp/id_rsa" -p ${HOST_PORT} ${HOST_USER}@${HOST_NAME} > /dev/null 2>&1
  sleep 30
done

exit 0
