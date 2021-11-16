#!/bin/bash
# This script is meant to be run in the User Data of the Boundary Instance while it's booting.
echo "Determining public IP address"
PUBLIC_IPV4=$(ec2metadata --public-ipv4)


cat << EOCSU >/etc/systemd/system/boundary.service
Description="HashiCorp Boundary"
Documentation=https://www.boundaryproject.io/
Requires=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/bin/boundary dev \
    -api-listen-address=0.0.0.0 \
    -proxy-listen-address=0.0.0.0 \
    -worker-public-address=${PUBLIC_IPV4} \
    -password=dodtlv2021
LimitMEMLOCK=infinity
Capabilities=CAP_IPC_LOCK+ep
CapabilityBoundingSet=CAP_SYSLOG CAP_IPC_LOCK

[Install]
WantedBy=multi-user.target
EOCSU

systemctl daemon-reload
systemctl start boundary
