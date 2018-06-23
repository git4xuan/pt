#!/bin/env python
# -*- coding: utf-8 -*- 

import os
import sys

print("ptzip_local_ins_output")

def preInstall():
    os.system("bash ./ptzip/package_minimal.sh")
    os.system("apt-get install -y haproxy")

def ssClient():
    os.system("cp ./conf/ha-ss-rc.sh /usr/local/")
    os.system("cp ./conf/ha-ss-rc-2.sh /usr/local/")
    os.system("mv /etc/haproxy/haproxy.cfg{,.bak} && cp ./conf/haproxy.cfg /etc/haproxy/")
    os.system("systemctl restart haproxy")

if __name__ ==  "__main__":
    preInstall()
    ssClient()
