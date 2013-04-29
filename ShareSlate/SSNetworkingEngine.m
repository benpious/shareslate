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
        
        if ([hostname isEqual:@""]) {
            hostname = @"localhost";
            //hostname = @"128.237.191.52";
        }
        
        if (port == 0) {
            port = 1700;
        }
        
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
                            
                        //NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        NSError* error;
                        NSDictionary* output = [NSJSONSerialization JSONObjectWithData: [NSData dataWithBytes:buffer length:len]  options:NSJSONReadingMutableContainers error:&error];
                        
                        if (nil != output) {
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

-(void) sendMessage: (NSDictionary*) message
{
    //NSData *data = [[NSData alloc] initWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
    NSError* error;
    /*
    if ([message objectForKey:@"type"]  != nil) {
        NSLog(@"%@",[message objectForKey:@"type"] );
    }
     */
    NSData* data = [NSJSONSerialization dataWithJSONObject:message options:0 error: &error];
    //if (data == nil) {
    //    NSLog(@"data == nil");
    //}
    //NSLog(@"about to send");
    
	[outputStream write:[data bytes] maxLength:[data length]];
    //[NSJSONSerialization writeJSONObject:message toStream:outputStream options:0 error:&error];

}


@end
