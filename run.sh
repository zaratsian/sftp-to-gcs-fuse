docker run -it --privileged -p 2222:22 \
--env BUCKET_NAME="stealth-air-datasets" \
fuse foo:pass:::upload