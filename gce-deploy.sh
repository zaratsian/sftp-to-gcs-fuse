# Load Config
. config

export GCE_INSTANCE_NAME_WITH_TIMESTAMP="${GCE_INSTANCE_NAME}-$(date -u +%s)"

# Deploy GCE VM Instance
gcloud compute instances create $GCE_INSTANCE_NAME_WITH_TIMESTAMP \
    --project=$GCP_PROJECT_ID \
    --zone=$GCE_ZONE \
    --machine-type=e2-medium \
    --network-interface=network-tier=PREMIUM,subnet=default \
    --scopes=https://www.googleapis.com/auth/cloud-platform \
    --create-disk=auto-delete=yes,boot=yes,device-name=$GCE_INSTANCE_NAME_WITH_TIMESTAMP,image=projects/debian-cloud/global/images/debian-11-bullseye-v20221102,mode=rw,size=10,type=projects/$GCP_PROJECT_ID/zones/$GCE_ZONE/diskTypes/pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --reservation-affinity=any \
    --tags=sftp-for-gcs \
    --metadata-from-file=startup-script=gce-startup-script.sh \
    --metadata=USERNAME=$USERNAME,PASSWORD=$PASSWORD,GCS_BUCKET_NAME=$GCS_BUCKET_NAME,GITHUB_REPO=$GITHUB_REPO

# Set Firewall to allow port 2222
gcloud compute --project=$GCP_PROJECT_ID \
firewall-rules create sftp-for-gcs-firewall \
--direction=INGRESS \
--priority=1000 \
--network=default \
--action=ALLOW \
--rules=tcp:2222 \
--source-ranges=0.0.0.0/0
