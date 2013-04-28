//
//  SSNetworkingEngine.h
//  ShareSlate
//
//  Created by Benjamin Pious on 3/1/13.
//  Copyright (c) 2013 Benjamin Pious. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SSNetworkingEngine : NSObject<NSStreamDelegate>
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSNotificationCenter* notificationCenter;
    
}
-(id) initWithHostName: (NSString*) hostname port: (int) port;
-(void) sendMessage: (NSDictionary*) message;


@end
