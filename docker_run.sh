docker run -it --privileged -p 2222:22 \
--env BUCKET_NAME="stealth-air-datasets" \
--env USERNAME="foo" \
--env PASSWORD="pass" \
--env PUBLIC_KEY="xyz" \
fuse