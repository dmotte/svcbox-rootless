#!/bin/bash

set -e

################### INCLUDE SCRIPTS FROM /opt/startup-early ####################

for i in /opt/startup-early/*.sh; do
    [ -f "$i" ] || continue
    # shellcheck source=/dev/null
    . "$i"
done

################################ SSH HOST KEYS #################################

# Create the temporary directory for host keys generation
mkdir -p ~/sshd/etc/ssh

# Get host keys from the volume
install -m600 -t ~/sshd/etc/ssh /ssh-host-keys/ssh_host_*_key 2>/dev/null || :
install -m644 -t ~/sshd/etc/ssh /ssh-host-keys/ssh_host_*_key.pub 2>/dev/null || :

# Generate the missing host keys
ssh-keygen -Af ~/sshd

# Move the host keys out of the temporary directory
mv -t ~/sshd ~/sshd/etc/ssh/*
rm -r ~/sshd/etc

# Copy the (previously missing) generated host keys to the volume
cp -nt/ssh-host-keys ~/sshd/ssh_host_*_key 2>/dev/null || :
cp -nt/ssh-host-keys ~/sshd/ssh_host_*_key.pub 2>/dev/null || :

############################### SSH CLIENT KEYS ################################

if [ ! -e ~/.ssh/authorized_keys ]; then
    install -dm700 ~/.ssh
    # shellcheck disable=SC3001
    install -m600 <(cat /ssh-client-keys/*.pub 2>/dev/null || :) \
        ~/.ssh/authorized_keys
fi

#################### INCLUDE SCRIPTS FROM /opt/startup-late ####################

for i in /opt/startup-late/*.sh; do
    [ -f "$i" ] || continue
    # shellcheck source=/dev/null
    . "$i"
done

############################## START SUPERVISORD ###############################

# Start supervisord with "exec" to let it become the PID 1 process. This ensures
# it receives all the stop signals correctly and reaps all the zombie processes
# inside the container
echo 'Starting supervisord'
exec /usr/bin/supervisord -nc ~/supervisor/supervisord.conf
