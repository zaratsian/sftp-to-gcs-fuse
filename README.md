# sftp-gcs-fuse
SFTP Server for Google Cloud Storage based on GCSFuse

### Quickstart

1. Clone this repo

    ```bash
    git clone https://github.com/zaratsian/sftp-to-gcs-fuse.git
    ```

2. Copy the config.sample to a file called config

    ```bash
    cp config.sample config
    ```

3. Update the config file with your own values, such as your GCP project ID, your username, password, and/or public key, etc. 
4. Deploy SFTP Server

    ```bash
    ./gce-deploy.sh
    ```

5. From your client, connect to the SFTP Server

    ```bash
    sftp -P 2222 <sftp_server_ip_addr>
    ```

