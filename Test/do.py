#!/usr/env python
# 仅仅用来测试linode的方式
#update 动作
#


import os
import subprocess
import json


class Linodes(self,domain=None):
    def getOldNodeId(self):
        pass
    def getDomainIP(self):
        pass
    def getNewNodeIP(self):
        pass
    def deleteOldNodes(self):
        pass
    def createNewNodes(self):
        ##By clone
        pass
    def changeDomainIP(self):
        pass
    def checkIPAvailable(self):
        pass
    def ssClientRestart(self):
        pass


if __name__ == "__main__":
    s1,t1 = subprocess.getstatusoutput("linode-cli linodes list")
    if(s1 == 0):
        tDict = {}
        tList = []
        dt1 = json.loads(t1)
        if(type(dt1) == type(tDict)):
            source_id = dt1["id"]
        elif(type(dt1) == type(tList)):
            source_id = dt1[0]["id"]
            ## 有bug，需要ip校验，先不管
        else:
            print("There is problem in linode-cli output")

        s2,t2 = subprocess.getstatusoutput("linode-cli linodes clone " + str(source_id))
        if(s2 == 0):
            dt2 = json.loads(t2)
            ## we need to new_ip as return data
            print("linodes clone will start...")
            s3, t3 = subprocess.getstatusoutput("linode-cli linodes list")
            dt3 = json.loads(t3)
            dest_id = dt3[1]["id"]
            _ , _ = subprocess.getstatusoutput("linode-cli linodes boot " + str(dest_id))
            dest_ip = dt3[1]["ip"]
            print("dest_ip is:" + dest_ip)
        else:
            print("linodes clone failed..")









        #s3,t3 = subprocess.getstatusoutput("cli4 update")