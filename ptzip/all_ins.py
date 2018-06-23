#!/bin/env python
# -*- coding: utf-8 -*- 

import os
import sys

process_number=0
ori=os.getcwd() ## loc exec
opath=sys.path[0] ## loc shell path

os.chdir(opath)

L=[]
L.append("python bbr_full.py")
L.append("bash ssr_install.sh")
L.append("bash ssh-newkey.sh")
L.append("bash package_minimal.sh")
L.append("bash package_extra.sh")
L.append("bash package_compile.sh")

for tmp in L:
    #print("List output_" + str(process_number) + ":  " + subprocess.check_output(tmp))
    print(os.system(tmp))
    process_number=process_number+1
    print(process_number)

# change loc


