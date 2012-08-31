#!/bin/bash
# Copyright (c) 2011, Riverbed Technology, Inc. All rights reserved.

# Apply default tunings for EC2 - only needed when starting from a blank config

#GlobalSettings.removeFlipperFrontendCheckAddresses %gateway%
#GlobalSettings.setFlipperHeartbeatMethod unicast
#GlobalSettings.setFlipperAutofailback false
#GlobalSettings.setFlipperMonitorInterval 2000
#GlobalSettings.setFlipperMonitorTimeout 15

/usr/local/zeus/zxtm/bin/zcli <<EOF
GlobalSettings.setJavaEnabled 0
EOF
