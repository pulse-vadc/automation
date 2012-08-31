#!/bin/bash

# Copyright (c) 2011, Riverbed Technology, Inc. All rights reserved.

# Inputs...
# REPO_URL: The URL of the repository from which to download the Stingray binary
# distribution.
# STINGRAY_PKG_NAME: The name of the binary package to download.
# UID=`/usr/bin/id | cut -f2 -d"=" | cut -f1 -d"("`
if [ ${UID} != "0" ]; then
    echo "Setup needs to be run as root - exiting"
    exit 1
fi

REPO_URL=<your repository url>
STINGRAY_PKG_NAME="zeustm_81_linux"
STINGRAY_PKG_DIRNAME="ZeusTM_81_Linux-x86_64"
STINGRAY_LICENSE="license_key.txt"

if [ STINGRAY_PKG_NAME = “” ] ; then
    STINGRAY_PKG_NAME=”Zeus_81_Linux”
fi

cd /tmp
# Download the needed license file
echo "wget -o dl_lic.log ${REPO_URL}${STINGRAY_LICENSE}"
wget -o dl_lic.log ${REPO_URL}${STINGRAY_LICENSE}

# Download and unpack the attached Traffic Manager package
ARCH=`uname -m`
if [ x$ARCH = "xx86_64" ] ; then
    wget -o dl.log ${REPO_URL}${STINGRAY_PKG_NAME}-x86_64.tgz
    tar zxvf ${STINGRAY_PKG_NAME}-x86_64.tgz
    cd ${STINGRAY_PKG_DIRNAME}
else
    wget -o dl.log ${REPO_URL}-x86.tgz
    tar zxvf ${STINGRAY_PKG_NAME}-x86.tgz
    cd ${STINGRAY_PKG_DIRNAME}
fi

# Install the software, but don't configure it.
cat > ztm-install-record <<EOF
accept-license=accept
zeushome=/usr/local/zeus
zxtm!perform_initial_config=N
EOF
./zinstall --replay-from=ztm-install-record
