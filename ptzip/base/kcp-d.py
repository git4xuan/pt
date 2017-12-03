#!/bin/env python
# -*- coding: utf-8 -*- 

import os
import sys
import platform
#import re
# make sure go installed.
# kcptun installed.

cpu=platform.machine()
print("Start to install go with kcptun.Please wait..")
t=os.system("go get -u github.com/xtaci/kcptun/server")
    
if(t==0):
    print("kcptun installed.")
else:
    print("kcptun failed.")

# dante install
# we donnot check dependence...

ma_cpu=platform.processor()  # x86_64 aarch64
ma_arch=platform.architecture() # [0] 64bit
ma_pl=platform.platform()
ma_linux_ver="unknown"
flagU=platform.re.search("Ubuntu" , ma_pl)
flagD=platform.re.search("Debian" , ma_pl)
flagC=platform.re.search("Centos" , ma_pl)

if(flagU!=None):
    ma_linux_ver="Ubuntu"
if(flagD!=None):
    ma_linux_ver="Debian"
if(flagC!=None):
    ma_linux_ver="Centos"
else:
    print(ma_linux_ver)

print("ma_linux_ver is:" + ma_linux_ver)
print("=================================")


if(ma_linux_ver=="Ubuntu" or ma_linux_ver=="Debian"):
    ret=os.system("apt-get install -y dante-server")
    os.system("service danted restart")
else:
    # compile dante-server
    ret_comp=os.system("bash dante_comp_ins.sh")
    print("ret_compile is:" + str(ret_comp))
    if(os.path.isfile("/usr/sbin/sockd")):
        ret=0
    else:
        ret=1
        
if(ret==0):
    print("Dante-server install Success!!")
else:
    print("Dante-server install Failed!!")

## copy dante config file...

