#!/bin/bash
# Copyright (c) 2012 Riverbed Technology, Inc. All rights reserved.
# INPUTS: OPT_CLUSTER_HOST, OPT_CLUSTER_PORT, ZEUS_ADMIN_PASSWORD
# Find the key, if it was installed by a preconfigure script

if [ ${UID} != "0" ]; then
echo "Setup needs to be run as root - exiting"
exit 1
fi

# Generate an admin password
for I in {1..8}; do
echo $RANDOM >> /tmp/passwd
done

MD5=$(md5sum /tmp/passwd)
ZEUS_ADMIN_PASSWORD=${MD5:1:8}

echo
echo
echo Use of this software is subject to the terms of the Riverbed End User
echo License Agreement
echo
echo Please review these terms, published at http://www.riverbed.com/license
echo before proceeding.
echo ------------------------------------------------------------------------
read -p "Enter 'accept' to accept this license, or press return to abort: " ACCEPT

if [[ "$ACCEPT" != "accept" ]]; then
echo You have chosen not to accept the End User License Agreement.  Please shut down and delete this machine.
exit 1
fi

echo

LICENSE_PATH="/tmp/fla_poc_key.txt"

# First try to join an existing cluster, but if that fails create a new cluster
if [ -n "$OPT_CLUSTER_HOST" ] ; then
if [ -n "$OPT_CLUSTER_PORT" ] ; then
OPT_CLUSTER_PORT=9090
fi

cat > /tmp/stm-configure-record <<EOF
accept-license=accept
start_at_boot=Y
net!warn=
zlb!admin_hostname=$OPT_CLUSTER_HOST
zlb!admin_password=$ZEUS_ADMIN_PASSWORD
zlb!admin_port=$OPT_CLUSTER_PORT
zlb!admin_username=admin
zxtm!cluster=s
zxtm!clustertipjoin=Y
zxtm!group=
zxtm!license_key=$LICENSE_PATH
zxtm!use_invalid_key_license=y
zxtm!unique_bind=N
zxtm!user=
zxtm!fingerprints_ok=y
EOF

/usr/local/zeus/zxtm/configure --noninteractive --replay-from=/tmp/stm-configure-record 2>&1 | tee /tmp/stm-configure.log

# If the cluster joining failed for any reason except that we couldn't contact
# the cluster_host, then we should give up and strand the instance
# This means that the first node in an auto-scaled array will create a new
# cluster, but subsequent nodes should join that cluster

CONFIG_SUCCESSFUL=${PIPESTATUS[0]}
grep "ERROR: Cannot connect to remote host" /tmp/stm-configure.log > /dev/null
CONNECT_FAILED=$?

if [ $CONFIG_SUCCESSFUL -eq 0 ] ; then
    exit 0
else
if [ $CONNECT_FAILED -ne 0 ] ; then
echo Failed to join cluster, exiting
exit 1
else
echo Could not contact cluster host $OPT_CLUSTER_HOST
fi
fi
fi

# If cluster_host was not specified, or we could not contact it (indicating that
# we are the first node in a new auto-scaling array) then set up as a new stand-alone
# cluster
echo Creating a new cluster
cat > /tmp/stm-configure-record <<EOF
accept-license=accept
admin!password=$ZEUS_ADMIN_PASSWORD
net!warn=
start_at_boot=Y
zxtm!cluster=C
zxtm!group=
zxtm!license_key=$LICENSE_PATH
zxtm!use_invalid_key_license=y
zxtm!unique_bind=N
zxtm!user=
EOF

/usr/local/zeus/zxtm/configure --noninteractive --replay-from=/tmp/stm-configure-record 2>&1 | tee /tmp/stm-configure.log

echo $ZEUS_ADMIN_PASSWORD > /root/admin_password
echo Your Stingray Traffic Manager administrator credentials have been set to username \"admin\" with password \"$ZEUS_ADMIN_PASSWORD\".
echo You should change this password in the STM Graphical User Interface as soon as possible.  This temporary password is stored in /root/admin_password for reference.
echo
echo

touch /root/.firstrun
