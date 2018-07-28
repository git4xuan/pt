#!/usr/env python
# 仅仅用来测试linode的方式
#update 动作
#


import os
import subprocess
import json


class Linodes:
    def __init__(self):
        self.source_id = self.getOldNodeId()#order01
        self.target_id = -1 #order02


    def getOldNodeId(self):#order01
        s, tt = subprocess.getstatusoutput("linode-cli linodes list --json > /tmp/io1.txt")
        with open('/tmp/io1.txt', 'rt') as f:
            data = f.read()
            dt = json.loads(data)
        source_id = -1
        if (s == 0):
            tDict = {}
            tList = []
            #print(type(dt),dt)
            if (type(dt) == type(tDict)):
                source_id = dt["id"]
            elif (type(dt) == type(tList)):
                source_id = dt[0]["id"]
                ## 有bug，需要ip校验，先不管
                ## 有bug，需要ip校验，先不管
            else:
                print("There is problem in linode-cli old id ")
            print("In States0,OldIP, source_id = " + str(source_id))
        else:
            print("List error..." + str(s))
        return source_id

    def createNewNodes(self): ## By clone
        if(self.source_id == -1):
            return -1
        else:
            s, t = subprocess.getstatusoutput("linode-cli linodes clone " + str(self.source_id) + " --json --pretty" + ">/tmp/iocreate.txt")
            return s

    def bootNewNodes(self):
        if (self.target_id == -1):
            return -1
        else:
            s, t = subprocess.getstatusoutput("linode-cli linodes boot " + str(self.target_id) + " --json --pretty" + ">/tmp/io2.txt")
            return s

    def getNewNodeId(self):
        s, tt = subprocess.getstatusoutput("linode-cli linodes list --json > /tmp/io3.txt")
        with open('/tmp/io3.txt', 'rt') as f:
            data = f.read()
            dt = json.loads(data)
        order2_source_id = -1
        if (s == 0):
            tDict = {}
            tList = []
            if (type(dt) == type(tDict)):
                print("There is no new nodes id..")
            elif (type(dt) == type(tList)):
                order2_source_id = dt[1]["id"]
            else:
                print("There is problem in linode-cli output in NewNodeId")
            print("order2_source_id: " + str(order2_source_id))
        return order2_source_id

    def getNewNodeIP(self):
        s, tt = subprocess.getstatusoutput("linode-cli linodes list --json > /tmp/io4.txt")
        with open('/tmp/io4.txt', 'rt') as f:
            data = f.read()
            dt = json.loads(data)
        source_id = -1
        newNodeIP = " "
        if (s == 0):
            tDict = {}
            tList = []
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
            time.sleep(600)
            s, t = subprocess.getstatusoutput("linode-cli linodes delete " + str(self.source_id) + " --json --pretty")
            return s

    def getDomainIP(self):  # unused..
        pass

    def updateDomainIP(self):
        jcontent='content="'+ self.getNewNodeIP() + '"'
        jList = ['cli4','--put','"name"="c"','"type"="A"',jcontent,'/zones/:zvim.win/dns_records/:c.zvim.win']
        _cmd =' '.join(jList)
        s, t = subprocess.getstatusoutput(_cmd)
        return s


#        cmd = cli4 --put "name"="c" "type"="A" content= + self.target_id +  /zones/:zvim.win/dns_records/:c.zvim.win
#        cmd="""cli4 --post name="c" "type"="A" content="50.116.6.89" /zones/:zvim.win/dns_records """
# cli4 --delete  /zones/:zvim.win/dns_records/:c.zvim.win
# cli4 --put "name"="c" "type"="A" content="1.1.1.1" /zones/:zvim.win/dns_records/:c.zvim.win


    def checkSSRPortIsAvailable(self):# cron every 2 days.
        pass

    def updateSSRClient(self):
        s, t = subprocess.getstatusoutput("/bin/bash /usr/local/ha-ss-rc.sh")
        return s


    def updateSSRServer(self):
        bSignal = -1
        cSignal = self.createNewNodes()
        if(cSignal == -1):
            print("Error..For cSignal.")
        elif(cSignal == 0):
            print("creatNewNodes succeed.")
            self.target_id = self.getNewNodeId()
            bSignal = self.bootNewNodes()
            if(bSignal == 0):
                print("BootNewNodes succeed.")
        else:
            print("Unknown Error..For updateSSRServer")
        #return bSignal
        # if IP addr is available.
        print("update ssr.//bSignal is:"+ str(bSignal) +" cSignal is: "+ str(cSignal))
        return 0

if __name__ == "__main__":
        pt = Linodes()
        pt.updateSSRServer()
        nip=pt.getNewNodeIP()
        print(nip)
        nipState=pt.updateDomainIP()
        print("Update IP in cloudflare:" + nipState)
#        pt.deleteOldNodes()
        pt.updateSSRClient()
