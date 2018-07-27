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
            dt = json.loads(str(t))
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
            print("list error..." + str(s))
            print("t is: " + t)
        return source_id

    def createNewNodes(self): ## By clone
        if(self.source_id == -1):
            return -1
        else:
            s, t = subprocess.getstatusoutput("linode-cli linodes clone " + str(self.source_id) + " --json --pretty")
            return s

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
        s, t = subprocess.getstatusoutput("linode-cli linodes list")
        source_id = -1
        newNodeIP = " "
        if (s == 0):
            tDict = {}
            tList = []
            dt = json.loads(t)
            if (type(dt) == type(tDict)):
                print("There is no new nodes id..")
            elif (type(dt) == type(tList)):
                newNodeIP = dt[1]["ipv4"][0]
            else:
                print("There is problem in linode-cli output")
        return newNodeIP

    def deleteOldNodes(self):
        if (self.source_id == -1):
            return -1
        else:
            s, t = subprocess.getstatusoutput("linode-cli linodes delete " + str(self.source_id) + " --json --pretty")
            return s

    def getDomainIP(self):  # unused..


        pass

    def updateDomainIP(self):
        pass

    def checkSSRPortIsAvailable(self):
        pass

    def updateSSRClient(self):
        s, t = subprocess.getstatusoutput("bash /usr/local/ha-ss-rc.sh")
        return s


    def updateSSRServer(self):
        bSignal = -1
        cSignal = self.createNewNodes()
        if(cSignal == -1):
            print("Error..")
        elif(cSignal == 0):
            print("creatNewNodes succeed.")
            bSignal = self.bootNewNodes()
        else:
            print("Unknown Error..")
        #return bSignal
        # if IP addr is available.
        print("update ssr."+ str(bSignal) + str(cSignal))
        return 0

if __name__ == "__main__":
        pt = Linodes()
        print("As we can get more details")

        pt.updateSSRServer()
