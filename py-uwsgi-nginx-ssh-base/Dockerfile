FROM earthadvantage/py-uwsgi-nginx-base

RUN apt-get update && apt-get install -y openssh-server \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

COPY sshd_config /etc/ssh
RUN chmod 644 /etc/ssh/sshd_config \
    && mkdir /var/ssh && chown www-data /var/ssh
