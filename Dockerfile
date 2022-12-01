FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y gnupg lsb-release wget

RUN GCSFUSE_REPO=$(lsb_release -c -s) && \
    echo "deb http://packages.cloud.google.com/apt gcsfuse-$GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list && \
    wget -O - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && \
    apt-get install -y gcsfuse openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

COPY assets/sshd_config /etc/ssh/sshd_config
COPY assets/entry /
RUN chmod 755 /etc/ssh/sshd_config
RUN chmod 755 /entry

EXPOSE 22

#CMD ["/bin/bash"]
ENTRYPOINT ["/entry"]