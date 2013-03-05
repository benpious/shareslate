from twisted.internet.protocol import Factory, Protocol
from twisted.internet import reactor

class PassMessage(Protocol):
    def connectionMade(self):
        print "connected"
        self.factory.clients.append(self)
        for currMessage in self.factory.messageData:
            self.message(currMessage)
    
    def connectionLost(self, reason):
        self.factory.clients.remove(self)
    
    def dataReceived(self, data):
        self.factory.messageData.append(data)
        for c in self.factory.clients:
            if c != self:
                c.message(data)
    
    def message(self, message):
        self.transport.write(message)

factory = Factory()

reactor.listenTCP(1700, factory)
factory.protocol = PassMessage
factory.clients = []
factory.messageData = []
reactor.run()
