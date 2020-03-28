#!/bin/bash
FULLKEY=""
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50
do
  VARNAME="PRIVKEY${i}"

  if [ -z "${!VARNAME}" ]
  then
    break
  fi

  FULLKEY="${FULLKEY}\n${!VARNAME}"
done

if [ -z "${FULLKEY}" ]
then
    echo "Did you forget to fill PRIVKEY environments?"
    sleep 10
    exit 1
fi

if [ -z "${HOST_KEY}" ]
then
    echo "Did you forget to fill HOST_KEY environments?"
    sleep 10
    exit 2
fi

if [ -z "${HOST_PORT}" ]
then
    echo "Did you forget to fill HOST_PORT environments?"
    sleep 10
    exit 3
fi

if [ -z "${HOST_USER}" ]
then
    echo "Did you forget to fill HOST_USER environments?"
    sleep 10
    exit 4
fi

if [ -z "${HOST_PASS}" ]
then
    echo "Did you forget to fill HOST_PASS environments?"
    sleep 10
    exit 5
fi


echo -e ${FULLKEY} | base64 -d > /tmp/id_rsa && chmod 0600 /tmp/id_rsa
echo "[${HOST_NAME}]:${HOST_PORT} $HOST_KEY" > /tmp/known_hosts
PUBKEY=`ssh-keygen -y -f /tmp/id_rsa`

while true; do
  echo "Trying to unlock using key: ${PUBKEY}"
  echo -n "${HOST_PASS}" | ssh -o "UserKnownHostsFile /tmp/known_hosts" -o "IdentityFile /tmp/id_rsa" -p ${HOST_PORT} ${HOST_USER}@${HOST_NAME} > /dev/null 2>&1
  sleep 30
done

exit 0
