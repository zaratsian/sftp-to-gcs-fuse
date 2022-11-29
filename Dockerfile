FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y gnupg lsb-release wget

RUN GCSFUSE_REPO=$(lsb_release -c -s) && \
    echo "deb http://packages.cloud.google.com/apt gcsfuse-$GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list && \
    wget -O - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && \
    apt-get install -y gcsfuse

RUN apt-get update && \
    apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

COPY files/sshd_config /etc/ssh/sshd_config
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /
RUN chmod 755 /etc/ssh/sshd_config
RUN chmod 755 /usr/local/bin/create-sftp-user
RUN chmod 755 /entrypoint

ARG BUCKET_NAME
ENV BUCKET_NAME=$BUCKET_NAME

#WORKDIR /app
#RUN mkdir /app/gcs
#RUN gcsfuse "stealth-air-datasets" /app/gcs

EXPOSE 22

ENTRYPOINT ["/entrypoint"]