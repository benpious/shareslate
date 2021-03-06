from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor
import json      # for data storing and request/response sending
import datetime  # for getting a timestamp

class Save:
    name = ""
    desc = ""
    start = 0
    end = 0

class Packet:
    type = ""
    name = ""
    desc = ""
    data = []
    timeStamp = ""
    success = False

def separateJSON(inString):
    curlyDepth = 0
    outString = ""
    for c in inString:
        outString += c
        if(c == "{"):
            curlyDepth += 1
        elif(c == "}"):
            curlyDepth -= 1

        if(curlyDepth == 0):
            outString += "\n"
    
    outString = outString[:-1]
    return outString

class PassMessage(Protocol):
    def connectionMade(self):
        print "connected"
        self.factory.clients.append(self)
        for currMessage in self.factory.shapeArr:
            self.message(currMessage)
    
    def connectionLost(self, reason):
        self.factory.clients.remove(self)
    
    def dataReceived(self, data):
        print "received data = <<<\"" + data + "\">>>"
        sepdData = separateJSON(data)
        jsonList = sepdData.split("\n")
        for reqStr in jsonList:
            self.processRequest(reqStr)

    def processRequest(self, reqStr):
        print "processing req = <<<\"" + reqStr + "\">>>"
        request = json.loads(reqStr)
        response = {}
        response["type"] = request["type"]

        if(request["type"] == "add"):
            self.factory.shapeArr.extend(request["data"])
            response["data"] = request["data"]
            response["success"] = True
            for c in self.factory.clients:
                if c != self:
                    c.message(json.dumps(response))

        elif(request["type"] == "save"):
            curSave = Save()
            curSave.name = request["name"]
            curSave.desc = request["desc"]
            curSave.start = self.factory.curStart
            curSave.end = len(self.factory.shapeArr)
            self.factory.saveDict[request["name"]] = curSave

            response["name"] = request["name"]
            response["desc"] = request["desc"]
            response["timeStamp"] = str(datetime.datetime.now())
            response["success"] = True
            for c in self.factory.clients:
                c.message(json.dumps(response))

        elif(request["type"] == "getVersion"):
            if(request["name"] not in self.factory.saveDict):
                response["success"] = False
                self.message(json.dumps(response))
            else:
                reqSave = self.factory.saveDict[request["name"]]
                response["name"] = request["name"]
                response["desc"] = reqSave.desc
                response["data"] = self.factory.shapeArr[reqSave.start:reqSave.end]
                response["success"] = True
                self.message(json.dumps(response))

        elif(request["type"] == "propogate"):
            if(request["name"] not in self.factory.saveDict):
                response["success"] = False
                self.message(json.dumps(response))
            else:
                reqSave = self.factory.saveDict[request["name"]]
                response["name"] = request["name"]
                response["desc"] = reqSave.desc
                response["data"] = self.factory.shapeArr[reqSave.start:reqSave.end]
                response["success"] = True
                for c in self.factory.clients:
                    c.message(json.dumps(response))

                self.factory.curStart = len(self.factory.shapeArr)
                self.factory.shapeArr.extend(response["data"])

        elif(request["type"] == "remove"):
            response["index"] = request["index"]
            for c in self.factory.clients:
                c.message(json.dumps(response))

    def message(self, message):
        self.transport.write(message)

factory = Factory()

reactor.listenTCP(1700, factory)
factory.protocol = PassMessage
factory.clients = []

factory.curStart = 0
factory.saveDict = {} # maps from save name to Save object
factory.shapeArr = []

reactor.run()
