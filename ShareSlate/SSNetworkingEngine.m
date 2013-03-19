//
//  SSNetworkingEngine.m
//  ShareSlate
//
//  Created by Benjamin Pious on 3/1/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import "SSNetworkingEngine.h"

@implementation SSNetworkingEngine
-(id) initWithHostName: (NSString*) hostname port: (int) port
{
    if (self = [super init]) {
        
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        NSLog(@"%@, %d", hostname, port);
        CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)hostname, port, &readStream, &writeStream);
        inputStream = (NSInputStream *)readStream;
        outputStream = (NSOutputStream *)writeStream;
        [inputStream setDelegate:self];
        [outputStream setDelegate:self];
        
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [inputStream open];
        [outputStream open];
        
        notificationCenter = [NSNotificationCenter defaultCenter];
    }
    
    return self;
    
}


- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                uint8_t buffer[1024];
                int len;
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                            
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            //NSLog(@"server said: %@", output);
                            NSNotification* notification = [NSNotification notificationWithName:@"serverData" object:output];
                            [notificationCenter postNotification:notification];
                        }
                    }
                }
            }

			break;
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
            
		case NSStreamEventEndEncountered:
            NSLog(@"event end encountered");
			break;
            
		default:
			NSLog(@"Unknown event");
	}

    
}

-(void) sendMessage: (NSString*) message
{
    NSData *data = [[NSData alloc] initWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"%@", message);
	[outputStream write:[data bytes] maxLength:[data length]];
    [data release];

}


@end
