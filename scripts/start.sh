#!/bin/bash

umask 0002
chmod g+w /server-data
chmod g+w /server-files

runAsUser=linuxgsm
runAsGroup=linuxgsm

if [[ -v UID ]]; then
  if [[ $UID != $(id -u linuxgsm) ]]; then
    usermod -u $UID linuxgsm
  fi
fi

if [[ -v GID ]]; then
  if [[ $GID != $(id -g linuxgsm) ]]; then
    groupmod -o -g $GID linuxgsm
  fi
fi

if [[ $(stat -c "%u" /server-data) != $UID ]]; then
  chown -R ${runAsUser}:${runAsGroup} /server-data
fi

if [[ $(stat -c "%u" /server-files) != $UID ]]; then
  chown -R ${runAsUser}:${runAsGroup} /server-files
fi

if [[ $(stat -c "%u" /home/linuxgsm/Zomboid) != $UID ]]; then
  chown -R ${runAsUser}:${runAsGroup} /home/linuxgsm/Zomboid
fi

if [[ $(stat -c "%u" /home/linuxgsm/serverfiles) != $UID ]]; then
  chown -R ${runAsUser}:${runAsGroup} /home/linuxgsm/serverfiles
fi

exec gosu ${runAsUser}:${runAsGroup} /entrypoint.sh "$@"
