#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

echo "Updating installed packages"
apt-get -qq update >/dev/null && apt-get -y -qq upgrade >/dev/null
echo "Installed packages updated"

set -x
cd /Build
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=/Build/depot_tools:$PATH
mkdir -p nwjs/src
mkdir src/content src/third_party src/v8
cd nwjs
gclient config --name=src https://github.com/nwjs/chromium.src.git@origin/nw17
mv ../.gclient .
git clone https://github.com/nwjs/nw.js src/content/nw
git clone https://github.com/nwjs/node src/third_party/node-nw
git clone https://github.com/nwjs/v8 src/v8

gclient sync --with_branch_heads --nohooks
./build/install-build-deps.sh




# echo "Starting transfer"
# aws configure set region $AWS_REGION
# aws configure set aws_access_key_id $AWS_ACCESS_KEY
# aws configure set aws_secret_access_key $AWS_SECRET_KEY
# aws s3 cp $PACKAGE_NAME $S3_STORE
# echo "Transfer completed"
