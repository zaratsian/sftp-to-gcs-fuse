# Get Metadata and set as ENV
export USERNAME=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/USERNAME" -H "Metadata-Flavor: Google")
export PASSWORD=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/PASSWORD" -H "Metadata-Flavor: Google")
export PUBLIC_KEY=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/PUBLIC_KEY" -H "Metadata-Flavor: Google")
export GITHUB_REPO=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/GITHUB_REPO" -H "Metadata-Flavor: Google")
export GCS_BUCKET_NAME=$(curl "http://metadata.google.internal/computeMetadata/v1/instance/attributes/GCS_BUCKET_NAME" -H "Metadata-Flavor: Google")

sudo apt update && \
    sudo apt install -y \
    git \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Install Docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER

# Clone Repo
git clone $GITHUB_REPO

# Build Contain
cd sftp-to-gcs-fuse
sudo docker build -t sftp .

# Run Container
sudo docker run --privileged -p 2222:22 \
--env BUCKET_NAME="$GCS_BUCKET_NAME" \
--env USERNAME="$USERNAME" \
--env PASSWORD="$PASSWORD" \
--env PUBLIC_KEY="$PUBLIC_KEY" \
sftp
