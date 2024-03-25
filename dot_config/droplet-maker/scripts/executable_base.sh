#!/bin/bash

set -x

# Create pgujjula and allow login by ssh
useradd pgujjula
mkdir ~pgujjula/.ssh
mv ~root/.ssh/authorized_keys ~pgujjula/.ssh/authorized_keys
chmod 700 ~pgujjula/.ssh
chmod 600 ~pgujjula/.ssh/authorized_keys
chown pgujjula ~pgujjula/.ssh
chown pgujjula ~pgujjula/.ssh/authorized_keys
chgrp pgujjula ~pgujjula/.ssh
chgrp pgujjula ~pgujjula/.ssh/authorized_keys

# Give sudo permissions to pgujjula
usermod -aG wheel pgujjula

# Allow sudo without password
sed -e 's/^%wheel/#%wheel/g' -e 's/^# %wheel/%wheel/g' \
  -i /etc/sudoers

# Disable log in to root
sed -i -e 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
