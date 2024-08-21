FROM docker.io/library/debian:12

EXPOSE 2222

RUN apt-get update && \
    apt-get install -y supervisor openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    rm -f /etc/ssh/ssh_host_*_key /etc/ssh/ssh_host_*_key.pub && \
    sed -Ei /etc/ssh/sshd_config \
        -e 's/^#?PermitRootLogin[ \t].*$/PermitRootLogin no/' \
        -e 's/^#?HostbasedAuthentication[ \t].*$/HostbasedAuthentication no/' \
        -e 's/^#?PermitEmptyPasswords[ \t].*$/PermitEmptyPasswords no/' \
        -e 's/^#?PasswordAuthentication[ \t].*$/PasswordAuthentication no/'

COPY --chown=root:root --chmod=755 startup.sh /

COPY --chown=root:root --chmod=644 supervisord-global.conf \
    /etc/supervisor/supervisord.conf

ENV LC_ALL=C.UTF-8
RUN echo '#!/bin/bash\n\nexport LC_ALL=C.UTF-8' \
    > /etc/profile.d/set-c-utf8-locale.sh

RUN useradd -Ums/bin/bash mainuser && \
    install -d -omainuser -gmainuser -m700 \
        /opt/startup-early /opt/startup-late \
        /ssh-host-keys /ssh-client-keys \
        /home/mainuser/supervisor /home/mainuser/supervisor/conf.d \
        /home/mainuser/supervisor/log /home/mainuser/sshd

USER mainuser

COPY --chown=mainuser:mainuser --chmod=644 supervisord-mainuser.conf \
    /home/mainuser/supervisor/supervisord.conf

RUN sed -E /etc/ssh/sshd_config \
        -e 's/^#?Port[ \t].*$/Port 2222/' \
        -e 's|^#?HostKey[ \t]+/etc/ssh/(.+)$|HostKey /home/mainuser/sshd/\1|' \
        -e 's|^#?PidFile[ \t].*$|PidFile /home/mainuser/sshd/sshd.pid|' \
        > /home/mainuser/sshd/sshd_config

ENTRYPOINT ["/startup.sh"]
