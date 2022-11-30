export GCP_PROJECT_ID="stealth-air-23412"
export ARTIFACT_REPO_NAME="sftp-for-gcs"
export ARTIFACT_REPO_LOCATION="us-central1"
export APP_IMAGE="sftp-for-gcs"

# Create Artifact Repo
gcloud artifacts repositories create $ARTIFACT_REPO_NAME --repository-format=docker \
--location=$ARTIFACT_REPO_LOCATION --description="SFTP for GCS Repository"

# Cloud Build
gcloud builds submit --config=cloudbuild.yaml \
  --substitutions=_LOCATION=$ARTIFACT_REPO_LOCATION,_REPOSITORY=$ARTIFACT_REPO_NAME,_IMAGE=$APP_IMAGE .

