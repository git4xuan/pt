#!/usr/env python
# 仅仅用来测试linode的方式
#update 动作
#


import os
import subprocess
import json


class Linodes:
    def __init__(self):
        self.source_id = self.getOldNodeId()
        self.target_id = self.getNewNodeId()


    def getOldNodeId(self):
        s, t = subprocess.getstatusoutput("linode-cli linodes list --json --pretty")
        source_id = -1
        if (s == 0):
            tDict = {}
            tList = []
            dt = json.loads(t)
            if (type(dt) == type(tDict)):
                source_id = dt["id"]
            elif (type(dt) == type(tList)):
                source_id = dt[0]["id"]
                ## 有bug，需要ip校验，先不管
            dt = json.loads(t)
            if (type(dt) == type(tDict)):
                source_id = dt["id"]
            elif (type(dt) == type(tList)):
                source_id = dt[0]["id"]
                ## 有bug，需要ip校验，先不管
            else:
                print("There is problem in linode-cli output")
        else:
            print("list error....")
        return source_id

    def createNewNodes(self): ## By clone
        if(self.source_id == -1):
            return -1
        else:
            s, t = subprocess.getstatusoutput("linode-cli linodes clone " + str(self.source_id) + " --json --pretty")
            return 0

    def bootNewNodes(self):
        if (self.target_id == -1):
            return -1
        else:
            s, t = subprocess.getstatusoutput("linode-cli linodes boot " + str(self.target_id) + " --json --pretty")
            return s

    def getNewNodeId(self):
        s, t = subprocess.getstatusoutput("linode-cli linodes list")
        source_id = -1
        if (s == 0):
            tDict = {}
            tList = []
            dt = json.loads(t)
            if (type(dt) == type(tDict)):
                print("There is no new nodes id..")
            elif (type(dt) == type(tList)):
                source_id = dt[1]["id"]
            else:
                print("There is problem in linode-cli output")
        return source_id

    def getNewNodeIP(self):
        pass

    def deleteOldNodes(self):
        pass

    def getDomainIP(self):
        pass

    def updateDomainIP(self):
        pass

    def checkIPAvailable(self):
        pass

    def ssClientRestart(self):
        pass

    def updateSSRServer(self):
        # exec all actions...
        pass

if __name__ == "__main__":




