#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

echo "Updating installed packages"
apt-get -qq update >/dev/null && apt-get -y -qq upgrade >/dev/null
echo "Installed packages updated"

set -x
cd /Build
git clone -q https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=/Build/depot_tools:$PATH
mkdir -p nwjs/src/content nwjs/src/third_party nwjs/src/v8

cd nwjs
gclient config --name=src https://github.com/nwjs/chromium.src.git@origin/nw77
mv ../.gclient .
git clone -q https://github.com/nwjs/nw.js src/content/nw
git clone -q https://github.com/nwjs/node src/third_party/node-nw
git clone -q https://github.com/nwjs/v8 src/v8

echo "Sync takes very long time. Be patient"
gclient sync --with_branch_heads &> /dev/null
echo "Installing build deps"
./build/install-build-deps.sh

cd src
gn gen out/nw --args='is_debug=false is_component_ffmpeg=true target_cpu="x86"'

GYP_CHROMIUM_NO_ACTION=0 ./build/gyp_chromium -I \
third_party/node-nw/common.gypi -D building_nw=1 \
-D clang=1 third_party/node-nw/node.gyp

echo "Build nwjs"
ninja -C out/nw nwjs

echo "Build Node"
ninja -C out/Release node

echo "Copy the build Node library to the nwjs binary folder"
ninja -C out/nw copy_node



# echo "Starting transfer"
# aws configure set region $AWS_REGION
# aws configure set aws_access_key_id $AWS_ACCESS_KEY
# aws configure set aws_secret_access_key $AWS_SECRET_KEY
# aws s3 cp $PACKAGE_NAME $S3_STORE
# echo "Transfer completed"
