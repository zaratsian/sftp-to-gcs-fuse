FROM ubuntu:20.04

ENV SFTPGROUP gcs-sftp-group
ENV USERNAME foo
ENV PASSWORD pass
ENV BUCKET_NAME my_gcs_bucket
ENV PUBLICKEY my_publickey

WORKDIR /app

COPY assets/sshd_config /etc/ssh/sshd_config
COPY assets/entry /app/entry

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata && \
    apt-get install -y gnupg lsb-release wget

RUN GCSFUSE_REPO=$(lsb_release -c -s) && \
    echo "deb http://packages.cloud.google.com/apt gcsfuse-$GCSFUSE_REPO main" | tee /etc/apt/sources.list.d/gcsfuse.list && \
    wget -O - https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && \
    apt-get install -y gcsfuse openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd

EXPOSE 22

ENTRYPOINT ["/app/entry"]
