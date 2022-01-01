#!/bin/bash

umask 0002
chmod g+w /server-data
chmod g+w /server-files

runAsUser=linuxgsm
runAsGroup=linuxgsm

if [[ -v UID ]]; then
  if [[ $UID != $(id -u linuxgsm) ]]; then
    log "Changing uid of linuxgsm to $UID"
    usermod -u $UID linuxgsm
  fi
fi

if [[ -v GID ]]; then
  if [[ $GID != $(id -g linuxgsm) ]]; then
    log "Changing gid of linuxgsm to $GID"
    groupmod -o -g $GID linuxgsm
  fi
fi

if [[ $(stat -c "%u" /data) != $UID ]]; then
  log "Changing ownership of /server-data to $UID ..."
  chown -R ${runAsUser}:${runAsGroup} /server-data

  log "Changing ownership of /server-files to $UID ..."
  chown -R ${runAsUser}:${runAsGroup} /server-files
fi

exec gosu ${runAsUser}:${runAsGroup} entrypoint "$@"
